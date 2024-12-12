<%@page import="controller.DB_Connection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.DecimalFormat" %>

<!DOCTYPE html>
<html>
<head>
    <title>Seat Layout</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            text-align: center;
            padding: 20px;
            background-color: #f9f9f9;
            color: #333;
        }

        .screen-container {
            text-align: center;
            margin-bottom: 20px;
        }

        .screen {
            width: 40%;
            margin: 0 auto 20px;
            padding: 10px;
            background-color: #444;
            color: white;
            font-weight: bold;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        .seat-grid {
            display: grid;
            gap: 10px;
            justify-content: center;
            padding: 20px;
        }

        .seat {
            width: 65px;
            height: 65px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 5px;
            background-color: #e0e0e0;
            border: 1px solid #ccc;
            cursor: pointer;
            border-radius: 4px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            transition: transform 0.2s ease, background-color 0.3s ease;
        }

        .seat:hover {
            transform: scale(1.1);
            background-color: #d3d3d3;
        }

        .seat.royal {
            background-color: #f4c6d1;
            border: 1px solid #d48ba5;
        }

        .seat.executive {
            background-color: #c6e1ff;
            border: 1px solid #8ab6d6;
        }

        .seat.booked {
            background-color: #ffcdd2;
            cursor: not-allowed;
            border: 1px solid #e57373;
        }

        .seat.selected {
            background-color: #4caf50; /* Selected seat color */
            border: 1px solid #388e3c;
            color: white;
            font-weight: bold;
        }

        #total-amount {
            margin-top: 20px;
            font-family: Arial, sans-serif;
            font-size: 1.2em;
            color: #555;
        }

        button {
            margin-top: 20px;
            padding: 10px 20px;
            font-size: 1em;
            color: white;
            background-color: #4caf50;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        button:hover {
            background-color: #388e3c;
        }

        .logout {
            display: inline-block;
            background-color: black;
            color: white;
            padding: 10px 20px;
            text-decoration: none;
            font-size: 16px;
            font-weight: bold;
            border-radius: 5px;
            text-align: center;
            position: absolute;
            right: 20px;
            top: 20px;
            transition: background-color 0.3s ease;
        }

        .logout:hover {
            background-color: #444;
            color: white;
        }
    .seat.booked {
    background-color: #ffe082; /* Soft gold background */
    cursor: not-allowed;
    border: 1px solid #ffa000; /* Warm brown border */
}


        
    </style>
    <script>
    let selectedSeats = [];
    let totalAmount = 0.0;
    const royalSeatPrice = 250.00; // Example price for Royal seats
    const executiveSeatPrice = 150.00; // Example price for Executive seats

    function selectSeat(seatElement) {
        // Get the seat text (e.g., "R1C2" or "E2C3")
        const seat = seatElement.innerText;
        const seatType = seat.startsWith('R') ? 'royal' : 'executive';

        // Check if the seat is already selected
        if (selectedSeats.includes(seat)) {
            // If already selected, remove it and adjust the total amount
            selectedSeats = selectedSeats.filter(selected => selected !== seat);
            totalAmount -= (seatType === 'royal') ? royalSeatPrice : executiveSeatPrice;
            seatElement.classList.remove('selected');
        } else {
            // If not selected, add it and adjust the total amount
            selectedSeats.push(seat);
            totalAmount += (seatType === 'royal') ? royalSeatPrice : executiveSeatPrice;
            seatElement.classList.add('selected');
        }

        // Update the total amount displayed
        document.getElementById('amount').innerText = totalAmount.toFixed(2);

        // Update the hidden input values for SeatNumbers and TotalAmount
        document.getElementById('selectedSeats').value = selectedSeats.join(',');
        document.getElementById('totalAmount').value = totalAmount.toFixed(2);
    }

    function bookTickets() {
        if (selectedSeats.length > 0) {
            alert('Seats booked: ' + selectedSeats.join(', ') + '\nTotal Amount: ₹' + totalAmount.toFixed(2));
            // Submit the form
            document.forms[0].submit();
        } else {
            alert('Please select seats before booking.');
        }
    }

</script>
</head>
<body>
<form action="bookTickets.jsp" method="POST">
    <h1>Seat Layout</h1>
    <a href="Dash.jsp" class="logout">Logout</a>

    <div class="screen-container">
        <div class="screen">SCREEN (All eyes this way, please!)</div>
    </div>

    <% 
    	
    	//String email= request.getParameter("email");
    	
        String movieId = request.getParameter("movieID");
        String theaterID = request.getParameter("theaterID");
        String showTime = request.getParameter("showTime");
        String ScreenName = request.getParameter("ScreenName");
     	   
        String movieName=request.getParameter("movieName");
        String theaterName = request.getParameter("theaterName");
        String location = request.getParameter("location");
        
        
        int ScreenID = 0;
        int ShowID = 0;
        int UserID = 0;
        String email = request.getParameter("email");
        String selectedDay = request.getParameter("selectedDate");

        Connection con = null;
        int rows = 0;
        int cols = 10; // Assuming 10 columns by default
        int SeatCapacity = 0;

        PreparedStatement pstmt1 = null;
        ResultSet rs2 = null;

        try {
            DB_Connection obj_DB_Connection = new DB_Connection();
            con = obj_DB_Connection.get_Connection();

            if (con == null) {
                throw new SQLException("Failed to establish a database connection.");
            }

            // Retrieving the SeatCapacity from the Screens table
            String sql1 = "SELECT ScreenID, SeatCapacity FROM Screens WHERE ScreenName = ? AND TheaterID = ?";
            pstmt1 = con.prepareStatement(sql1);
            pstmt1.setString(1, ScreenName);
            pstmt1.setString(2, theaterID);
            rs2 = pstmt1.executeQuery();

            if (rs2.next()) {
                SeatCapacity = rs2.getInt("SeatCapacity");
                ScreenID = rs2.getInt("ScreenID");
            }

            rows = (int) Math.ceil((double) SeatCapacity / cols);

            // Retrieving the ShowID from the Shows table
            String sql2 = "SELECT ShowID FROM Shows WHERE ScreenName = ? AND TheaterID = ? AND MovieID = ? AND ScreenID = ?";
            pstmt1 = con.prepareStatement(sql2);
            pstmt1.setString(1, ScreenName);
            pstmt1.setString(2, theaterID);
            pstmt1.setString(3, movieId);
            pstmt1.setInt(4, ScreenID);
            rs2 = pstmt1.executeQuery();

            if (rs2.next()) {
                ShowID = rs2.getInt("ShowID");
            }

            // Retrieving the UserID from the Users table
            String sql3 = "SELECT UserID FROM Users WHERE Email = ?";
            pstmt1 = con.prepareStatement(sql3);
            pstmt1.setString(1, email);
            rs2 = pstmt1.executeQuery();

            if (rs2.next()) {
                UserID = rs2.getInt("UserID");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            out.println("<p>Error: " + e.getMessage() + "</p>");
        } finally {
            try {
                if (rs2 != null) rs2.close();
                if (pstmt1 != null) pstmt1.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    %>
    
    <%
    // List to hold the booked seat numbers
    List<String> bookedSeats = new ArrayList<>();
    try {
        DB_Connection obj_DB_Connection = new DB_Connection();
        con = obj_DB_Connection.get_Connection();

        if (con == null) {
            throw new SQLException("Failed to establish a database connection.");
        }

        // Query to fetch booked seats for the given ShowID, ShowTime, and BookedDate
        String sqlBookedSeats = "SELECT SeatNumbers FROM Bookings WHERE ShowID = ? AND ShowTime = ? AND BookedDate = ?";
        pstmt1 = con.prepareStatement(sqlBookedSeats);
        pstmt1.setInt(1, ShowID); // ShowID retrieved earlier in the code
        pstmt1.setString(2, showTime); // ShowTime provided in the request
        pstmt1.setString(3, selectedDay); // Selected date from the form
        rs2 = pstmt1.executeQuery();

        while (rs2.next()) {
            // Split the SeatNumbers (comma-separated) and add each seat to the list
            String seatNumbers = rs2.getString("SeatNumbers");
            if (seatNumbers != null && !seatNumbers.isEmpty()) {
                String[] seats = seatNumbers.split(",");
                for (String seat : seats) {
                    bookedSeats.add(seat.trim());
                }
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
        out.println("<p>Error fetching booked seats: " + e.getMessage() + "</p>");
    } finally {
        try {
            if (rs2 != null) rs2.close();
            if (pstmt1 != null) pstmt1.close();
            if (con != null) con.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>


    <!-- Debugging: Print the booked seats -->
<%
   // out.println("<p>Booked Seats: " + bookedSeats + "</p>");
%>

	<div class="seat-grid" style="grid-template-columns: repeat(<%= cols %>, 65px);">
    <% 
        for (int row = 1; row <= rows; row++) {
            String seatType = (row == rows) ? "royal" : "executive"; // Last row is Royal
            for (int col = 1; col <= cols; col++) {
                if ((row - 1) * cols + col <= SeatCapacity) {
                    String seatID = (row == rows ? "R" : "E") + row + "C" + col;
                    String seatClass = seatType;

                    // Check if the seat is in the bookedSeats list
                    if (bookedSeats.contains(seatID)) {
                        seatClass += " booked"; // Mark seat as booked
                    }
    %>
    <div class="seat <%= seatClass %>" <% if (!bookedSeats.contains(seatID)) { %>onclick="selectSeat(this)"<% } %>>
        <%= seatID %>
    </div>
    <% 
                }
            }
        }
    %>
		</div>

    <div id="total-amount">
        <h3>Royal (R): ₹250.00 Executive (E): ₹150.00</h3>
        <h3>Total Amount: ₹<span id="amount">0.00</span></h3>
        <button type="button" onclick="bookTickets()">Book Tickets</button>
    </div>
    

    <!-- Hidden inputs to pass data to bookings.jsp -->
    <input type="hidden" name="movieID" value="<%= movieId %>">
    <input type="hidden" name="theaterID" value="<%= theaterID %>">
    
    <input type="hidden" name="movieName" value="<%= movieName %>">
    <input type="hidden" name="theaterName" value="<%= theaterName %>">
    <input type="hidden" name="location" value="<%= location %>">
    
    <input type="hidden" name="ScreenName" value="<%= ScreenName %>">
    <input type="hidden" name="showTime" value="<%= showTime %>">
    <input type="hidden" name="selectedDate" value="<%= selectedDay %>">
    <input type="hidden" name="email" value="<%= email %>">
    
    <!-- Hidden inputs for additional details -->
    <input type="hidden" name="showDate" id="showDate" value="<%= selectedDay %>">
    <input type="hidden" name="userID" id="userID" value="<%= UserID %>">
    <input type="hidden" name="screenID" id="screenID" value="<%= ScreenID %>">
    <input type="hidden" name="showID" id="showID" value="<%= ShowID %>">
    <input type="hidden" name="totalAmount" id="totalAmount" value="0.00">
    <input type="hidden" name="selectedSeats" id="selectedSeats" value="">
</form>

</body>
</html>
