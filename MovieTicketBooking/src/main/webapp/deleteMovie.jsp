<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="controller.DB_Connection"%>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
    <title>Delete Movie</title>
</head>
<body>
    <%
        String movieTitle = request.getParameter("movieTitle"); // Retrieve movie title from the request
        String theaterName1 = request.getParameter("theaterName");
    	String location1 = request.getParameter("location");
    	
        Connection conn = null;
        PreparedStatement pstmt = null;
        Statement stmt = null;
        String message = "";     
        
        try {
            // Database connection
            DB_Connection obj_Db_Connection = new DB_Connection();
            conn = obj_Db_Connection.get_Connection();

            if (conn != null) {
                // SQL query to delete the movie
                String sql = "DELETE FROM Movies WHERE MovieTitle = ? AND TheaterName = ? AND Location = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, movieTitle);
                pstmt.setString(2, theaterName1);
                pstmt.setString(3, location1);

                int rowsAffected = pstmt.executeUpdate();

                if (rowsAffected > 0) {
                    // Renumber MovieID
                    stmt = conn.createStatement();
                    stmt.execute("SET @new_id = 0");
                    stmt.execute("UPDATE Movies SET MovieID = (@new_id := @new_id + 1)");

                    // Fetch the maximum MovieID
                    ResultSet rs = stmt.executeQuery("SELECT IFNULL(MAX(MovieID), 0) + 1 AS NextID FROM Movies");
                    int nextAutoIncrement = 1; // Default to 1 if the table is empty
                    if (rs.next()) {
                        nextAutoIncrement = rs.getInt("NextID");
                    }
                    rs.close();

                    // Reset AUTO_INCREMENT value
                    String resetAutoIncrement = "ALTER TABLE Movies AUTO_INCREMENT = " + nextAutoIncrement;
                    stmt.execute(resetAutoIncrement);

                    message = "Movie '" + movieTitle + "' has been successfully deleted.";
                } else {
                    message = "No movie found with the title '" + movieTitle + "'.";
                }
            } else {
                message = "Database connection failed.";
            }
        } catch (Exception e) {
            message = "Error: " + e.getMessage();
        } finally {
            try {
                if (stmt != null) stmt.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                message = "Error closing resources: " + e.getMessage();
            }
        }

        // Escape the message for use in JavaScript
        String escapedMessage = message.replace("'", "\\'");
    %>

    <!-- Inject JavaScript for alert and redirection -->
    <script>
        alert('<%= escapedMessage %>');
        window.location.href = 'managerProfile.jsp';
    </script>
</body>
</html>
