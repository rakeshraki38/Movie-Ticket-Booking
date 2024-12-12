<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="controller.DB_Connection"%>
<%@ page import="java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
    <title>Update Movie</title>
</head>
<body>
    <%
        // Retrieve form data
        String movieTitle = request.getParameter("movieTitle");
        String genre = request.getParameter("genre");
        int duration = Integer.parseInt(request.getParameter("duration"));
        String language = request.getParameter("language");
        String director = request.getParameter("director");
        String description = request.getParameter("description");

        // Database connection setup
        DB_Connection obj_DB_Connection = new DB_Connection();
        Connection conn = obj_DB_Connection.get_Connection();

        // Update movie details in the database
        String updateQuery = "UPDATE Movies SET Genre = ?, Duration = ?, Language = ?, Director = ?, Description = ? WHERE MovieTitle = ?";
        PreparedStatement stmt = conn.prepareStatement(updateQuery);
        stmt.setString(1, genre);
        stmt.setInt(2, duration);
        stmt.setString(3, language);
        stmt.setString(4, director);
        stmt.setString(5, description);
        stmt.setString(6, movieTitle);

        int rowsAffected = stmt.executeUpdate();
        stmt.close();
        
        // Provide feedback to the manager
        if (rowsAffected > 0) {
            out.println("<script>alert('Movie details updated successfully.'); window.location.href='managerProfile.jsp';</script>");
        } else {
            out.println("<script>alert('Failed to update movie.'); window.location.href='editMovie.jsp';</script>");
        }

        conn.close();
    %>
</body>
</html>
