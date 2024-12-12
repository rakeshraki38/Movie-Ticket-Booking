<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="controller.DB_Connection" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Active Bookings</title>
    <style>
        body {
            font-family: Arial, sans-serif;
        }
        h1 {
            text-align: center;
            background-color: #333333; /* Updated header color */
            color: #f9f9f9; /* Updated text color */
            padding: 20px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        table, th, td {
            border: 1px solid black;
        }
        th, td {
            padding: 10px;
            text-align: left;
        }
        th {
            background-color: #f2f2f2;
        }
        .button-container {
            position: absolute;
            top: 40px;
            right: 20px;
        }
        #logoutBtn {
            padding: 10px;
            background-color: #f44336;
            color: white;
            border: none;
            cursor: pointer;
            margin-right: 10px;
        }
        #logoutBtn:hover {
            background-color: #d32f2f;
        }
        #printBtn {
            padding: 10px;
            background-color: #FF0000;
            color: white;
            border: none;
            cursor: pointer;
        }
        #printBtn:hover {
            background-color: #d32f2f;
        }
        .action-btn {
            padding: 5px 10px;
            background-color: #2196F3;
            color: white;
            border: none;
            cursor: pointer;
        }
        .action-btn:hover {
            background-color: #0b7dda;
        }
    </style>
</head>
<body>
    <h1>Active Bookings</h1>
     <%
     	String email = request.getParameter("email");
     	Connection conn = null;
     	PreparedStatement pstmt = null;
     	ResultSet rs = null;
     	String password = request.getParameter("password");
    
        // Get current date and time
        SimpleDateFormat dateFormat = new SimpleDateFormat("dd-MM-yyyy");
        SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
        String currentDate = dateFormat.format(new java.util.Date()); // Get current date in dd-MM-yyyy format
        String currentTime = timeFormat.format(new java.util.Date()); // Get current time in HH:mm format
    %>

    <!-- Logout and Print Buttons -->
    <div class="button-container">
        <form action="userRegisterAction.jsp?email=<%= email %>&password=<%= password %>" method="POST" style="display:inline;">
            <button id="printBtn" onclick="window.print()">Print All Bookings</button>
            <button type="submit" id="logoutBtn">Logout</button>
        </form>
        
    </div>


    <%
        try {
            conn = new DB_Connection().get_Connection(); // Assuming you have a DB_Connection class for DB connection

            // SQL query to fetch data based on the user email, BookedDate, and Showtime conditions
            String query = "SELECT m.MovieTitle, m.Description, m.Genre, m.TheaterName, m.Location, " +
                           "b.ScreenName, b.Showtime, b.BookedDate, b.SeatNumbers, u.Username, u.Phone " +
                           "FROM movies m " +
                           "JOIN bookings b ON b.MovieID = m.MovieID " +
                           "JOIN users u ON b.UserID = u.UserID " +
                           "WHERE u.Email = ? " +
                           "AND STR_TO_DATE(b.BookedDate, '%d-%m-%Y') >= CURDATE() " +
                           "AND (STR_TO_DATE(b.BookedDate, '%d-%m-%Y') > CURDATE() OR " +
                           "STR_TO_DATE(b.Showtime, '%H:%i') > CURTIME())";

            pstmt = conn.prepareStatement(query);
            pstmt.setString(1, email); // Set the user email in the query

            rs = pstmt.executeQuery(); // Execute the query

            // Check if results exist
            if (rs.next()) {
                out.println("<table>");
                out.println("<tr><th>Movie Title</th><th>Genre</th><th>Theater Name</th><th>Location</th>" +
                            "<th>Screen Name</th><th>Showtime</th><th>Booked Date</th><th>Seat Numbers</th><th>Username</th><th>Phone</th><th>Actions</th></tr>");

                do {
                    out.println("<tr>");
                    out.println("<td>" + rs.getString("MovieTitle") + "</td>");
                    out.println("<td>" + rs.getString("Genre") + "</td>");
                    out.println("<td>" + rs.getString("TheaterName") + "</td>");
                    out.println("<td>" + rs.getString("Location") + "</td>");
                    out.println("<td>" + rs.getString("ScreenName") + "</td>");
                    out.println("<td>" + rs.getString("Showtime") + "</td>");
                    out.println("<td>" + rs.getString("BookedDate") + "</td>");
                    out.println("<td>" + rs.getString("SeatNumbers") + "</td>");
                    out.println("<td>" + rs.getString("Username") + "</td>");
                    out.println("<td>" + rs.getString("Phone") + "</td>");
                    out.println("<td><button class='action-btn' onclick='printBooking(" + 
                                 "\"" + rs.getString("MovieTitle") + "\", \"" + rs.getString("Description") + "\", \"" + rs.getString("Genre") + "\", \"" + rs.getString("TheaterName") + "\", \"" + rs.getString("Location") + "\", \"" + rs.getString("ScreenName") + "\", \"" + rs.getString("Showtime") + "\", \"" + rs.getString("BookedDate") + "\", \"" + rs.getString("SeatNumbers") + "\", \"" + rs.getString("Username") + "\", \"" + rs.getString("Phone") + "\")'>Print</button></td>");
                    out.println("</tr>");
                } while (rs.next());

                out.println("</table>");
            } else {
                out.println("<p>No active bookings found for the given email.</p>");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            out.println("<p>Error: " + e.getMessage() + "</p>");
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    %>

    <script>
        function printBooking(movieTitle, description, genre, theaterName, location, screenName, showtime, bookedDate, seatNumbers, username, phone) {
            var printWindow = window.open('', '', 'height=600,width=800');
            printWindow.document.write('<html><head><title>' + movieTitle + '</title></head><body>');
            printWindow.document.write('<h1>' + movieTitle + ' - Booking Details</h1>');
            printWindow.document.write('<p><b>Movie Title:</b> ' + movieTitle + '</p>');
            //printWindow.document.write('<p><b>Description:</b> ' + description + '</p>');
            printWindow.document.write('<p><b>Genre:</b> ' + genre + '</p>');
            printWindow.document.write('<p><b>Theater Name:</b> ' + theaterName + '</p>');
            printWindow.document.write('<p><b>Location:</b> ' + location + '</p>');
            printWindow.document.write('<p><b>Screen Name:</b> ' + screenName + '</p>');
            printWindow.document.write('<p><b>Showtime:</b> ' + showtime + '</p>');
            printWindow.document.write('<p><b>Booked Date:</b> ' + bookedDate + '</p>');
            printWindow.document.write('<p><b>Seat Numbers:</b> ' + seatNumbers + '</p>');
            printWindow.document.write('<p><b>Username:</b> ' + username + '</p>');
            printWindow.document.write('<p><b>Phone:</b> ' + phone + '</p>');
            printWindow.document.write('<p><button onclick="window.print()">Print</button></p>');
            printWindow.document.write('</body></html>');
            printWindow.document.close();
        }
    </script>
</body>
</html>
