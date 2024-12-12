<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@page import="controller.DB_Connection"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Booking Confirmation</title>
    <style>
        .ticket-container {
            width: 50%;
            margin: 50px auto;
            padding: 20px;
            border: 1px solid #ddd;
            border-radius: 8px;
            background-color: #f9f9f9;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        .ticket-header {
            text-align: center;
            margin-bottom: 20px;
        }
        .ticket-details {
            font-size: 16px;
            line-height: 1.6;
        }
        .ticket-details span {
            font-weight: bold;
        }
        .ticket-actions {
            text-align: center;
            margin-top: 20px;
        }
        .btn {
            padding: 10px 20px;
            border: none;
            background-color: #4caf50;
            color: white;
            font-size: 16px;
            border-radius: 5px;
            cursor: pointer;
        }
        .btn:hover {
            background-color: #45a049;
        }
    </style>
</head><body>
    <% 
        // Retrieving data from the request
        String userID = request.getParameter("userID");
        String screenID = request.getParameter("screenID");
        String theaterID = request.getParameter("theaterID");
        String movieID = request.getParameter("movieID");
        String showID = request.getParameter("showID");
        String screenName = request.getParameter("ScreenName");
        String showTime = request.getParameter("showTime");
        String bookedDate = request.getParameter("showDate");
        String seatNumbers = request.getParameter("selectedSeats"); // Comma-separated seat numbers
		String totalAmount=request.getParameter("totalAmount");
		// DATABASE CONNECTION AND insertion
        Connection con = null;
        PreparedStatement pstmt = null;

 try {
            // Establishing the DATABASE CONNECTION
            DB_Connection obj_DB_Connection = new DB_Connection();
            con = obj_DB_Connection.get_Connection();

            if (con == null) {
                throw new Exception("Failed to establish a database connection.");
            }

            // Inserting booking DATA INTO the Bookings TABLE
            String SQL = "INSERT INTO Bookings (UserID, ScreenID, TheaterID, MovieID, ShowID, ScreenName, ShowTime, BookedDate, SeatNumbers) "
                       + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
            pstmt = con.prepareStatement(SQL);

            pstmt.setInt(1, Integer.parseInt(userID));
            pstmt.setInt(2, Integer.parseInt(screenID));
            pstmt.setInt(3, Integer.parseInt(theaterID));
            pstmt.setInt(4, Integer.parseInt(movieID));
            pstmt.setInt(5, Integer.parseInt(showID));
            pstmt.setString(6, screenName);
            pstmt.setString(7, showTime);
            pstmt.setString(8, bookedDate);
            pstmt.setString(9, seatNumbers);

           int rowsInserted = pstmt.executeUpdate();

            if (rowsInserted > 0) {
                %>
                <div class="ticket-container">
                    <div class="ticket-header">
                        <h2>Booking Confirmation</h2>
                        <p>Thank you for your booking! Below are your ticket details:</p>
                    </div>
                    <div class="ticket-details">
                    	
                        <p><span>Theater Name:</span> <%= request.getParameter("theaterName") %></p>
                        <p><span>Screen Name:</span> <%= request.getParameter("ScreenName") %></p>
                        <p><span>Show Time:</span> <%= request.getParameter("showTime") %></p>
                        <p><span>Theater Location:</span> <%= request.getParameter("location") %></p>
                        <p><span>Movie Name:</span> <%= request.getParameter("movieName") %></p>
                        <p><span>Seat Numbers:</span> <%= seatNumbers%></p>
                        <p><span>Booked Date:</span> <%= bookedDate %></p>
                        <p><span>Total Amount:</span> <%= totalAmount %></p>
                        
                        
                    </div>
                    <div class="ticket-actions">
        				<!-- Print Button -->
        				<button class="btn" onclick="window.print()">Print Ticket</button>
        				<!-- OK Button -->
        				<button class="btn" onclick="window.location.href='Dash.jsp'">OK</button>
    				</div>
                </div>
                <%
            } else {
                out.println("<p>Failed to book. Please try again.</p>");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            out.println("<p>Error: " + e.getMessage() + "</p>");
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }


       

       
    %>
</body>
</html>
