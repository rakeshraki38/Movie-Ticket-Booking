<%@page import="controller.DB_Connection"%>
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
        <h2>Add a New Movie</h2>

        <!-- Movie Form -->
        <%
        	String email = (String) session.getAttribute("email");
        	//String name=request.getParameter("theater");
        	//String location=request.getParameter("location");
        %>
        <form action="addMoviesAction.jsp" method="post">
 
            <label for="movieTitle">Movie Title:</label>
            <input type="text" id="movieTitle" name="MovieTitle" required>

            <label for="genre">Genre:</label>
            <input type="text" id="genre" name="Genre" required>

            <label for="duration">Duration:</label>
            <div style="display: flex; gap: 10px;">
                <select id="hours" name="durationHours">
                    <% for (int i = 0; i <= 12; i++) { %>
                        <option value="<%= i %>"><%= i %> hr</option>
                    <% } %>
                </select>
                <select id="minutes" name="durationMinutes">
                    <% for (int i = 0; i < 60; i++) { %>
                        <option value="<%= i %>"><%= i %> min</option>
                    <% } %>
                </select>
            </div>

            <label for="imageSrc">Movie Poster (URL):</label>
            <input type="text" id="imageSrc" name="ImageSrc" placeholder="Enter image URL" required>

            <label for="language">Language:</label>
            <select name="Language" id="language" required>
                <option value="">-- Select Language --</option>
                <option value="Kannada">Kannada</option>
                <option value="Telugu">Telugu</option>
                <option value="English">English</option>
            </select>

            <label for="director">Director:</label>
            <input type="text" id="director" name="Director" required>
            
            
             <label for="theater">Select Theater:</label>
<select name="theater" id="theater" required>
    <option value="">-- Select a Theater --</option>
    <% 
        if (email != null) {
            try {
                DB_Connection obj_Db_Connection = new DB_Connection();
                Connection conn = obj_Db_Connection.get_Connection();
                String query = "SELECT TheaterName, Location FROM Theaters WHERE manager_email = ?";
                PreparedStatement stmt = conn.prepareStatement(query);
                stmt.setString(1, email);

                ResultSet rs = stmt.executeQuery();

                while (rs.next()) {
                    String theaterName = rs.getString("TheaterName");
                    String location = rs.getString("Location"); // Corrected the column name to "Location"
                    // Use a delimiter to concatenate the values
                    String value = theaterName + " | " + location;
    %>
                    <!-- Display both theaterName and location in the dropdown -->
                    <option value="<%= value %>"><%= theaterName + " - " + location %></option>
    <%
                }
                rs.close();
                stmt.close();
                conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    %>
</select>

                     
            <label for="description">Description:</label>
            <textarea id="description" name="Description" required></textarea>

            <button type="submit">Add Movie</button>
        </form>
    

    </div>
</body>
</html>
