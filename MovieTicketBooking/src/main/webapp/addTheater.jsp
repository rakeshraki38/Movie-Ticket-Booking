<%@page import="controller.DB_Connection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Theater</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f4;
        }
        .container {
            max-width: 600px;
            margin: 50px auto;
            padding: 20px;
            background: white;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            border-radius: 8px;
        }
        h1 {
            text-align: center;
            color: #ff4c68;
        }
        form {
            display: flex;
            flex-direction: column;
        }
        label {
            margin: 10px 0 5px;
            font-weight: bold;
        }
        input[type="text"], input[type="number"] {
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        button {
            margin-top: 20px;
            padding: 10px;
            background-color: #ff4c68;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        button:hover {
            background-color: #e63950;
        }
        .success, .error {
            text-align: center;
            margin-top: 10px;
            padding: 10px;
            border-radius: 4px;
        }
        .success {
            background-color: #d4edda;
            color: #155724;
        }
        .error {
            background-color: #f8d7da;
            color: #721c24;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Add Theater</h1>
        <form method="post" action="addTheater.jsp">
            <label for="theaterName">Theater Name:</label>
            <input type="text" id="theaterName" name="theaterName" required>

            <label for="location">Location:</label>
            <input type="text" id="location" name="location" required>

            <label for="totalScreens">Total Screens:</label>
            <input type="number" id="totalScreens" name="totalScreens" required>

            <button type="submit">Add Theater</button>
        </form>

        <%
        	String email1 = (String) session.getAttribute("email");
    		String email=email1;
            // Handle form submission
            String theaterName = request.getParameter("theaterName");
            String location = request.getParameter("location");
            String totalScreens = request.getParameter("totalScreens");

            if (theaterName != null && location != null && totalScreens != null) {
                try {
                    int TotalScreens = Integer.parseInt(totalScreens);

                    // Database connection
                    DB_Connection obj_Db_Connection=new DB_Connection();
                    Connection conn=obj_Db_Connection.get_Connection();

                    // Insert query
                    String query = "INSERT INTO Theaters (TheaterName, Location, totalScreens, manager_email) VALUES (?, ?, ?, ?)";
                    PreparedStatement stmt = conn.prepareStatement(query);
                    stmt.setString(1, theaterName);
                    stmt.setString(2, location);
                    stmt.setInt(3, TotalScreens);
                    stmt.setString(4,email);

                    int rowsInserted = stmt.executeUpdate();

                    if (rowsInserted > 0) {
                    %>
                    
                    <script>
                    // Show an alert popup
                    alert("Theater added successfully!");

                     window.location.href = "managerProfile.jsp";
               		 </script>
                   <%
                    }

                    stmt.close();
                    conn.close();
                } catch (Exception e) {
                    out.println("<div class='error'>Error: " + e.getMessage() + "</div>");
                }
            }
        %>
    </div>
</body>
</html>
