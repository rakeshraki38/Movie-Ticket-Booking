<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="controller.DB_Connection" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Expired Bookings</title>
    <style>
        body {
            font-family: Arial, sans-serif;
        }
        h1 {
            text-align: center;
            background-color: #333333; /* Header color */
            color: #f9f9f9; /* Text color */
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
    </style>
</head>
<body>
    <h1>Expired Bookings</h1>
     <%
     	String email = request.getParameter("email");
     	Connection conn = null;
     	PreparedStatement pstmt = null;
     	ResultSet rs = null;
     	String password = request.getParameter("password");
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

            // SQL query to fetch data based on past bookings
            String query = "SELECT m.MovieTitle, m.Genre, m.TheaterName, m.Location, " +
                           "b.ScreenName, b.Showtime, b.BookedDate, b.SeatNumbers, u.Username, u.Phone " +
                           "FROM movies m " +
                           "JOIN bookings b ON b.MovieID = m.MovieID " +
                           "JOIN users u ON b.UserID = u.UserID " +
                           "WHERE u.Email = ? " +
                           "AND STR_TO_DATE(b.BookedDate, '%d-%m-%Y') < CURDATE() " +
                           "OR (STR_TO_DATE(b.BookedDate, '%d-%m-%Y') = CURDATE() AND " +
                           "STR_TO_DATE(b.Showtime, '%H:%i') <= CURTIME())";

            pstmt = conn.prepareStatement(query);
            pstmt.setString(1, email); // Set the user email in the query

            rs = pstmt.executeQuery(); // Execute the query

            // Check if results exist
            if (rs.next()) {
                out.println("<table>");
                out.println("<tr><th>Movie Title</th><th>Genre</th><th>Theater Name</th><th>Location</th>" +
                            "<th>Screen Name</th><th>Showtime</th><th>Booked Date</th><th>Seat Numbers</th><th>Username</th><th>Phone</th></tr>");

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
                    out.println("</tr>");
                } while (rs.next());

                out.println("</table>");
            } else {
                out.println("<p>No expired bookings found for the given email.</p>");
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
</body>
</html>
