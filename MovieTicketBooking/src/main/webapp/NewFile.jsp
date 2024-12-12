<%@page import="controller.DB_Connection"%>

<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>

<%@ page import="java.util.*" %>
<%@ page import="java.time.*" %>
<%@ page import="java.time.format.TextStyle" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.time.LocalDate, java.time.format.DateTimeFormatter" %>


<%@ page import="java.sql.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Profile</title>
    <style>
    body {
        font-family: Arial, sans-serif;
        background-color: #f4f4f4;
        margin: 0;
        padding: 0;
    }

    .header {
        background-color: #ff4c68;
        color: white;
        padding: 20px;
        text-align: center;
        position: relative;
    }

    .header h1 {
        margin: 0;
        font-size: 24px;
        font-weight: bold;
    }

    .header .logout-button {
        background-color: #e63950;
        color: white;
        border: none;
        padding: 10px 20px;
        font-size: 16px;
        border-radius: 5px;
        cursor: pointer;
        position: absolute;
        right: 20px;
        top: 20px;
        transition: background-color 0.3s ease, transform 0.2s ease;
    }

    .header .logout-button:hover {
        background-color: #d62828;
        transform: scale(1.1);
    }

    .container {
        display: flex;
        flex-wrap: wrap;
        justify-content: center;
        gap: 20px;
        padding: 20px;
    }

    .movie-card {
        background-color: white;
        border-radius: 8px;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        overflow: hidden;
        width: 250px;
        text-align: center;
        transition: transform 0.3s ease, box-shadow 0.3s ease;
    }

    .movie-card:hover {
        transform: scale(1.05);
        box-shadow: 0 6px 12px rgba(0, 0, 0, 0.2);
    }

    .movie-card img {
        width: 100%;
        height: 300px;
        object-fit: cover;
        cursor: pointer;
    }

    .movie-card h3 {
        font-size: 20px;
        color: #333;
        margin: 10px 0;
        font-weight: bold;
    }

    .movie-card h4 {
        font-size: 16px;
        color: #555;
        margin: 5px 0;
    }

    .movie-details-card ul {
        padding: 0;
        list-style: none;
        display: flex;
        flex-wrap: wrap;
        justify-content: center;
        gap: 10px;
        margin: 10px 0;
    }

    .movie-details-card ul li {
        margin: 0;
    }

    .movie-details-card ul li a {
        text-decoration: none;
        color: white;
        background-color: #007bff;
        padding: 10px 15px;
        border-radius: 8px;
        font-size: 14px;
        font-weight: bold;
        display: inline-block;
        transition: background-color 0.3s ease, transform 0.2s ease, box-shadow 0.3s ease;
        text-align: center;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    }

    .movie-details-card ul li a:hover {
        background-color: #0056b3;
        transform: scale(1.05);
        box-shadow: 0 6px 12px rgba(0, 0, 0, 0.2);
    }
    .day-button {
            background-color: #f4f4f4;
            color: #333;
            border: 1px solid #ddd;
            padding: 10px 20px;
            margin: 5px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            transition: background-color 0.3s ease, transform 0.2s ease;
        }

        .day-button:hover {
            background-color: #e0e0e0;
            transform: scale(1.05);
        }
		
       

</style>

</head>
<body>
    <div class="header">
        <h1>Welcome, 
         
            <% 
                String email = request.getParameter("email");
                Connection conn = null;
                String username = null;
                try {
                    DB_Connection obj_Db_Connection = new DB_Connection();
                    conn = obj_Db_Connection.get_Connection();

                    String query = "SELECT Username FROM Users WHERE Email = ?";
                    PreparedStatement ps = conn.prepareStatement(query);
                    ps.setString(1, email);
                    ResultSet rst = ps.executeQuery();

                    if (rst.next()) {
                        username = rst.getString("Username");
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    try {
                        if (conn != null) conn.close();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }
                out.print(username != null ? username : "Guest");
            %>
        </h1>
        <form action="Dash.jsp" method="POST">
            <button type="submit" class="logout-button">Logout</button>
        </form>
    </div>
			
	<div class="container">
    <div style="text-align: center; margin-top: 20px;">
        <form method="POST" action="">
            <input type="hidden" name="selectedDate" id="selectedDateInput">
            <%
                LocalDate today = LocalDate.now();
                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd-MM-yyyy");
            
            
                for (int i = 0; i < 7; i++) {
                    LocalDate currentDay = today.plusDays(i);
                    String dayName = currentDay.getDayOfWeek().getDisplayName(TextStyle.SHORT, Locale.ENGLISH);
                    int dayOfMonth = currentDay.getDayOfMonth();
                    String monthName = currentDay.getMonth().getDisplayName(TextStyle.SHORT, Locale.ENGLISH);
                    String currentDayStr = currentDay.format(formatter); // Format to dd-MM-yyyy
            %>
            <button type="button" class="day-button" id="day<%= i %>" 
                    onclick="selectDate('<%= currentDayStr %>', this)">
                <%= dayName %> <%= dayOfMonth %> <%= monthName %>
            </button>
            <% } %>
        </form>
    </div>
</div>

<script>
    function selectDate(date, button) {
        // Mark the selected button
        document.querySelectorAll('.day-button').forEach(btn => btn.classList.remove('selected'));
        button.classList.add('selected');

        // Update the hidden input value
        document.getElementById('selectedDateInput').value = date;

        // Submit the form
        button.closest('form').submit();
    }
</script>
	
		
    <div class="container">
        <%
        int count = 0;
        String movieTitle = request.getParameter("movieTitle");
        conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        PreparedStatement stmtTheater = null;
        ResultSet rsTheater = null;

        try {
            DB_Connection obj_Db_Connection = new DB_Connection();
            conn = obj_Db_Connection.get_Connection();

            if (conn != null) {
                String query = "SELECT DISTINCT m.MovieID, m.MovieTitle, m.Duration, m.ImageSrc, m.Language," +
                               "m.TheaterName, m.Location, m.manager_email " +
                               "FROM movies m " +
                               "JOIN shows s ON m.MovieID = s.MovieID " +
                               "WHERE m.MovieTitle = ?";
                stmt = conn.prepareStatement(query);
                stmt.setString(1, movieTitle);
                rs = stmt.executeQuery();

                while (rs.next()) {
                    int movieId = rs.getInt("MovieID");
                    String movieName = rs.getString("MovieTitle");
                    String language = rs.getString("Language");
                    String duration = rs.getString("Duration");
                    String posterURL = rs.getString("ImageSrc");
                    String theaterName = rs.getString("TheaterName");
                    String location = rs.getString("Location");
                    String managerEmail = rs.getString("manager_email");

                    String theaterQuery = "SELECT TheaterID FROM theaters WHERE TheaterName = ? AND location = ? and manager_email=?";
                    stmtTheater = conn.prepareStatement(theaterQuery);
                    stmtTheater.setString(1, theaterName);
                    stmtTheater.setString(2, location);
                    stmtTheater.setString(3, managerEmail);
                    rsTheater = stmtTheater.executeQuery();

                    int theaterID = 0;
                    if (rsTheater.next()) {
                        theaterID = rsTheater.getInt("TheaterID");
                    }

                    String ScreenName = null;
                    String showTime = null;
                    PreparedStatement pstmt = conn.prepareStatement("SELECT ScreenName, ShowTime FROM shows WHERE MovieID = ? AND TheaterID = ?");
                    pstmt.setInt(1, movieId);
                    pstmt.setInt(2, theaterID);
                    ResultSet rs1 = pstmt.executeQuery();

                    List<String> showTimes = new ArrayList<>();
                    while (rs1.next()) {
                        ScreenName = rs1.getString("ScreenName");
                        showTime = rs1.getString("ShowTime");
                        showTimes.add(showTime);
                    }

                    if (count < 1) {
                        %>
                        <div class="movie-card">
                            <img src="<%= posterURL %>" alt="<%= movieName %>">
                            <h3><%= movieName %></h3>
                        </div>
                        <%
                        count++;
                    }
                    %>
                    
                           
                    <div class="movie-card">
                    <div class="movie-details-card">
                    	                    <%
    // Get the selected date from the request or default to the current date
    String selectedDate = request.getParameter("selectedDate");

    if (selectedDate == null || selectedDate.isEmpty()) {
        selectedDate = LocalDate.now().toString(); // Default to today's date in YYYY-MM-DD format
        //DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd-MM-yyyy");
        selectedDate = LocalDate.parse(selectedDate).format(formatter);

    } 
    %>
                        <h4>Language: <%= language %></h4>
                        <h4>Theater: <%= theaterName %></h4>
                        <h4>Location: <%= location %></h4>
                         <h4>Date: <%= selectedDate %></h4>
                        
                        
   <h4>Showtimes:</h4>


<ul>
    <%
        SimpleDateFormat inputFormat = new SimpleDateFormat("HH:mm"); // Input: 24-hour format
        SimpleDateFormat outputFormat = new SimpleDateFormat("hh:mm a"); // Output: 12-hour format with AM/PM
        int index = 0; // Unique index for IDs

        for (String time : showTimes) {
            try {
                Date date = inputFormat.parse(time); // Parse the 24-hour format time
                String formattedTime = outputFormat.format(date); // Format to 12-hour format
    %>
        <li>
            <a href="seatSelection.jsp?movieID=<%= movieId %>&movieName=<%= movieName%>&theaterName=<%= theaterName %>&location=<%= location %>&theaterID=<%= theaterID %>&ScreenName=<%= ScreenName %>&email=<%= email %>&showTime=<%= formattedTime %>&selectedDate=<%= selectedDate %>"
               id="showTimeLink_<%= index %>">
                <%= formattedTime %>
            </a>
        </li>
    <%
                index++; // Increment the index
            } catch (Exception e) {
                e.printStackTrace();
                out.println("<p>Error formatting time: " + e.getMessage() + "</p>");
            }
        }
    %>
</ul>
                    </div>
                    </div>
                    <%
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<p>Error: " + e.getMessage() + "</p>");
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        %>
    </div>
</body>
</html>
