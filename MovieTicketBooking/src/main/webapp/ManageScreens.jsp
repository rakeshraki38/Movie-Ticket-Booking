<%@page import="controller.DB_Connection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Screens</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
        }
        table {
            width: 80%;
            border-collapse: collapse;
            margin: 20px 0;
        }
        th, td {
            border: 1px solid #ccc;
            padding: 10px;
            text-align: left;
        }
        th {
            background-color: #f4f4f4;
        }
        .form-container {
            margin-bottom: 20px;
        }
        .form-container input, select {
            padding: 8px;
            margin-right: 10px;
        }
        .form-container button {
            padding: 8px 15px;
        }
        body {
    font-family: Arial, sans-serif;
    margin: 20px;
    background-color: #f9f9f9;
}

h1 {
    color: #333;
    text-align: center;
    margin-bottom: 30px;
}

.table-container {
    width: 80%;
    margin: 20px auto;
    border-collapse: collapse;
}

table {
    width: 100%;
    border-collapse: collapse;
    margin: 20px 0;
}

th, td {
    border: 1px solid #ccc;
    padding: 10px;
    text-align: left;
}

th {
    background-color: #f4f4f4;
    font-weight: bold;
}

.form-container {
    width: 50%;
    margin: 0 auto;
    background-color: #fff;
    padding: 20px;
    border-radius: 8px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}

.form-container label {
    display: block;
    margin-bottom: 10px;
    font-weight: bold;
    color: #555;
}

.form-container input {
    width: 100%;
    padding: 12px;
    margin: 8px 0 15px 0;
    border: 1px solid #ddd;
    border-radius: 4px;
    font-size: 16px;
    box-sizing: border-box;
}

.form-container input[type="number"] {
    -moz-appearance: textfield;
    -webkit-appearance: none;
    appearance: none;
}

.form-container input[type="number"]::-webkit-outer-spin-button,
.form-container input[type="number"]::-webkit-inner-spin-button {
    -webkit-appearance: none;
    margin: 0;
}

.form-container button {
    background-color: #4CAF50;
    color: white;
    padding: 12px 20px;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    font-size: 16px;
    width: 100%;
}

.form-container button:hover {
    background-color: #45a049;
}

.form-container .error {
    color: red;
    font-size: 14px;
    margin-top: 10px;
}

.form-container .success {
    color: green;
    font-size: 14px;
    margin-top: 10px;
}
        
    </style>
</head>
<body>

<h1>Manage Screens</h1>

<div class="form-container">
    <form method="post" action="ManageScreens.jsp">
    	<%
    String theaterName = request.getParameter("theaterName");
    String location = request.getParameter("location");
   
    String email = (String) session.getAttribute("email"); // Manager name from session
   
 int theaterID = 0;
    
    if (theaterName != null && location != null && email != null) {
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        try {
            // Initialize database connection
            DB_Connection obj_DB_Connection = new DB_Connection();
            conn = obj_DB_Connection.get_Connection();

            // Define the SQL query to fetch the TheaterID
            String SQL = "SELECT TheaterID FROM Theaters WHERE TheaterName = ? AND Location = ? AND manager_email = ?";
            PreparedStatement pstmt = conn.prepareStatement(SQL);

            // Set parameters in the query
            pstmt.setString(1, theaterName);
            pstmt.setString(2, location);
            pstmt.setString(3, email);

            // Execute the query
            ResultSet rs1 = pstmt.executeQuery();

            // Retrieve the TheaterID if the result exists
            if (rs1.next()) {
                theaterID = rs1.getInt("TheaterID");
               // out.println("Theater ID: " + theaterID); // Debugging output, remove in production
            } else {
                out.println("No theater found matching the criteria.");
            }
            // Close resources
            rs1.close();
            pstmt.close();
        } catch (Exception e) {
            out.println("Error: " + e.getMessage());
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    out.println("Error closing connection: " + e.getMessage());
                }
            }
        }
    } else {
        out.println("Error: Missing required parameters.");
    }
%>
        <input type="hidden" name="theaterId" value="<%=theaterID %>" id="theaterId" required>
		
        <label for="screenName">Screen Name:</label>
        <input type="text" name="screenName" id="screenName" required>

        <label for="seatCapacity">Seat Capacity:</label>
        <input type="number" name="seatCapacity" id="seatCapacity" required>

        <button type="submit">Add Screen</button>
    </form>
</div>

<%
    if (request.getMethod().equalsIgnoreCase("POST")) {
        int theaterId = Integer.parseInt(request.getParameter("theaterId"));
        String screenName = request.getParameter("screenName");
        int seatCapacity = Integer.parseInt(request.getParameter("seatCapacity"));

        Connection conn = null;
        try {
            // Initialize database connection
            DB_Connection obj_DB_Connection = new DB_Connection();
            conn = obj_DB_Connection.get_Connection();

            // Step 1: Fetch the current number of screens added for the theater
            String countScreensSQL = "SELECT COUNT(*) AS CurrentScreens FROM Screens WHERE TheaterID = ?";
            PreparedStatement countStmt = conn.prepareStatement(countScreensSQL);
            countStmt.setInt(1, theaterId); // Assuming `theaterId` is fetched from the form
            ResultSet countRs = countStmt.executeQuery();

            int currentScreens = 0;
            if (countRs.next()) {
                currentScreens = countRs.getInt("CurrentScreens");
            }

            countRs.close();
            countStmt.close();

            // Step 2: Fetch the total allowed screens for the theater
            String totalScreensSQL = "SELECT totalScreens FROM Theaters WHERE TheaterID = ?";
            PreparedStatement totalStmt = conn.prepareStatement(totalScreensSQL);
            totalStmt.setInt(1, theaterId);
            ResultSet totalRs = totalStmt.executeQuery();

            int totalScreens = 0;
            if (totalRs.next()) {
                totalScreens = totalRs.getInt("totalScreens");
            }

            totalRs.close();
            totalStmt.close();
            
            //out.print(theaterId);
            //out.println(screenName);
            //out.print(seatCapacity);
            //out.println(totalScreens);
            //out.println(currentScreens);

            // Step 3: Check if a new screen can be added
            if (currentScreens < totalScreens) {
                // Proceed with insertion
                String insertSQL = "INSERT INTO Screens (TheaterID, ScreenName, SeatCapacity) VALUES (?, ?, ?)";
                PreparedStatement insertStmt = conn.prepareStatement(insertSQL);
                insertStmt.setInt(1, theaterId);
                insertStmt.setString(2, screenName);
                insertStmt.setInt(3, seatCapacity);

                int rowsInserted = insertStmt.executeUpdate();
                if (rowsInserted > 0) {
                	// Renumber MovieID in the Movies table
                    Statement stmt = conn.createStatement();
                    stmt.execute("SET @new_id = 0");
                    stmt.execute("UPDATE Screens SET ScreenID = (@new_id := @new_id + 1)");

                	out.println("<script> alert('Screen added successfully!'); window.location.href = 'managerProfile.jsp'; </script>");

                } else {
                    out.println("Failed to add the screen.");
                }

                insertStmt.close();
            } else {
            	out.println("<script> alert('Cannot add more screens. Maximum allowed screens for this theater have been reached.!'); window.location.href = 'managerProfile.jsp'; </script>");

            }
        } catch (Exception e) {
            out.println("Error: " + e.getMessage());
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    out.println("Error closing connection: " + e.getMessage());
                }
            }
        }
    }
%>

</body>
</html>
