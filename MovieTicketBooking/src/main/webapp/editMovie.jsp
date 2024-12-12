<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="controller.DB_Connection"%>
<%@ page import="java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Movie</title>
    <style>
        /* General body styling */
        body {
            font-family: Arial, sans-serif;
            background-color: #f0f4f8;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }

        /* Form container */
        .form-container {
            background-color: #ffffff;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            max-width: 500px;
            width: 100%;
        }

        /* Page title */
        h2 {
            text-align: center;
            color: #333;
            margin-bottom: 20px;
        }

        /* Form labels */
        label {
            display: block;
            margin-bottom: 8px;
            color: #555;
            font-weight: bold;
        }

        /* Input fields, textarea, and select dropdown */
        input[type="text"],
        input[type="number"],
        textarea,
        select {
            width: 100%;
            padding: 12px;
            margin-bottom: 15px;
            border: 1px solid #ccc;
            border-radius: 4px;
            font-size: 14px;
            background-color: #f9f9f9;
            transition: border-color 0.3s ease;
        }

        /* Input focus effect */
        input[type="text"]:focus,
        input[type="number"]:focus,
        textarea:focus,
        select:focus {
            border-color: #4CAF50;
            outline: none;
        }

        /* Textarea styling */
        textarea {
            resize: vertical;
            min-height: 80px;
        }

        /* Submit button */
        button {
            width: 100%;
            padding: 12px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 4px;
            font-size: 16px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        /* Button hover effect */
        button:hover {
            background-color: #45a049;
        }
    </style>
</head>
<body>
    <%
        String movieTitle = request.getParameter("movieTitle");
    	String theaterName1 = request.getParameter("theaterName");
    	String location1 = request.getParameter("location");
        // Database connection setup
        DB_Connection obj_DB_Connection = new DB_Connection();
        Connection conn = obj_DB_Connection.get_Connection();

        // Get movie details from the database
        String query = "SELECT * FROM Movies WHERE MovieTitle = ? AND TheaterName = ? AND Location = ?";
        PreparedStatement stmt = conn.prepareStatement(query);
        stmt.setString(1, movieTitle);
        stmt.setString(2, theaterName1);
        stmt.setString(3, location1);
        ResultSet rs = stmt.executeQuery();

        String genre = "";
        int duration = 0;
        String language = "";
        String director = "";
        String description = "";
        String theater = "";

        if (rs.next()) {
            genre = rs.getString("Genre");
            duration = rs.getInt("Duration");
            language = rs.getString("Language");
            director = rs.getString("Director");
            description = rs.getString("Description");
            theater = rs.getString("TheaterName");
        }
        rs.close();
        stmt.close();
    %>

    <div class="form-container">
        <h2>Edit Movie: <%= movieTitle %></h2>
        <form action="updateMovie.jsp" method="post">
            <input type="hidden" name="movieTitle" value="<%= movieTitle %>">

            <label>Genre:</label>
            <input type="text" name="genre" value="<%= genre %>" required>

            <label>Duration (in minutes):</label>
            <input type="number" name="duration" value="<%= duration %>" required>

            <label>Language:</label>
            <select name="Language" id="language" required>
                <option value="">-- Select Language --</option>
                <option value="Kannada" <%= "Kannada".equals(language) ? "selected" : "" %>>Kannada</option>
                <option value="Telugu" <%= "Telugu".equals(language) ? "selected" : "" %>>Telugu</option>
                <option value="English" <%= "English".equals(language) ? "selected" : "" %>>English</option>
            </select>

            <label>Theater:</label>
            <select name="theater" id="theater" required>
                <option value="">-- Select a Theater --</option>
                <%
                    String email1 = (String) session.getAttribute("email");
                    String email = email1;
                    if (email != null) {
                        // Query to get theaters added by the current manager
                        String query1 = "SELECT TheaterName FROM Theaters WHERE manager_email = ?";
                        PreparedStatement stmt1 = conn.prepareStatement(query1);
                        stmt1.setString(1, email);
                        ResultSet rs1 = stmt1.executeQuery();

                        // Loop through the result set and display each theater as an option
                        while (rs1.next()) {
                            String theaterName = rs1.getString("TheaterName");
                %>
                            <option value="<%= theaterName %>" <%= theaterName.equals(theater) ? "selected" : "" %>>
                                <%= theaterName %>
                            </option>
                <%
                        }
                        // Close resources
                        rs1.close();
                        stmt1.close();
                    }
                    conn.close();
                %>
            </select>

            <label>Director:</label>
            <input type="text" name="director" value="<%= director %>" required>

            <label>Description:</label>
            <textarea name="description" required><%= description %></textarea>

            <button type="submit">Save Changes</button>
        </form>
    </div>
</body>
</html>
