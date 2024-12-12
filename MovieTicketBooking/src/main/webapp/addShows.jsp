<%@ page import="controller.DB_Connection" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>



<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Movie</title>
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
        h2 {
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
        input[type="text"], input[type="number"], textarea, select {
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
        <h2>Add New Show</h2>

        <%	
            String email = (String) session.getAttribute("email");
            String movieTitle = request.getParameter("movieTitle");
            String theaterName = request.getParameter("theaterName");
            String location = request.getParameter("location");
            
            int movieID = 0;
            int theaterID = 0;
        %>
        
        <form action="addShowsAction.jsp" method="post">
            <%
                // Retrieve movieID based on the provided details
                if (email != null) {
                    try {
                        DB_Connection obj_Db_Connection = new DB_Connection();
                        Connection conn = obj_Db_Connection.get_Connection();
                        String query = "SELECT MovieID FROM Movies WHERE manager_email = ? AND MovieTitle = ? AND TheaterName = ? AND Location = ?";
                        PreparedStatement stmt = conn.prepareStatement(query);
                        stmt.setString(1, email);
                        stmt.setString(2, movieTitle);
                        stmt.setString(3, theaterName);
                        stmt.setString(4, location);
                        ResultSet rs = stmt.executeQuery();

                        if (rs.next()) {
                            movieID = rs.getInt("MovieID");
                        }
                        rs.close();
                        stmt.close();
                        conn.close();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }
            %>

            <%
                // Retrieve theaterID based on the provided details
                if (email != null) {
                    try {
                        DB_Connection obj_Db_Connection = new DB_Connection();
                        Connection conn = obj_Db_Connection.get_Connection();
                        String query = "SELECT TheaterID FROM Theaters WHERE manager_email = ? AND TheaterName = ? AND Location = ?";
                        PreparedStatement stmt = conn.prepareStatement(query);
                        stmt.setString(1, email);
                        stmt.setString(2, theaterName);
                        stmt.setString(3, location);
                        ResultSet rs = stmt.executeQuery();

                        if (rs.next()) {
                            theaterID = rs.getInt("TheaterID");
                        }
                        rs.close();
                        stmt.close();
                        conn.close();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }
            %>

            <!-- Hidden fields to pass information to the action page -->
            <input type="hidden" name="movieID" value="<%= movieID %>">
            <input type="hidden" name="theaterID" value="<%= theaterID %>">
            <input type="hidden" name="movieTitle" value="<%= movieTitle %>">
            <input type="hidden" name="theaterName" value="<%= theaterName %>">
            <input type="hidden" name="location" value="<%= location %>">

            <!-- Show Time -->
            <label for="show_time">Show Time (HH:mm):</label>
            <input type="time" name="show_time" required />
            
            <!-- Screen Number -->
            <label for="screen">Select Screen:</label>
            <select name="screen" id="screen" required>
                <option value="">-- Select a Screen --</option>
                <%
                    if (email != null && theaterID != 0) {
                        try {
                            DB_Connection obj_Db_Connection = new DB_Connection();
                            Connection conn = obj_Db_Connection.get_Connection();
                            String query = "SELECT ScreenID, ScreenName FROM Screens WHERE TheaterID = ?";
                            PreparedStatement stmt = conn.prepareStatement(query);
                            stmt.setInt(1, theaterID);
                            ResultSet rs = stmt.executeQuery();

                            while (rs.next()) {
                                int screenID = rs.getInt("ScreenID");
                                String screenName = rs.getString("ScreenName");
                                String value = screenID + " | " + screenName;
                %>
                                <option value="<%= value %>"><%= screenID + " - " + screenName %></option>
                <%
                            }
                            rs.close();
                            stmt.close();
                            conn.close();
                        } catch (SQLException e) {
                            e.printStackTrace();
                        }
                    } else {
                        out.print("No data available or invalid theater ID.");
                    }
                %>
            </select>

            <!-- Submit Button -->
            <button type="submit">Add Show</button>
        </form>
    </div>

   
</body>
</html>
