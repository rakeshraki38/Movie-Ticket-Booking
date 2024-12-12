<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="controller.DB_Connection"%>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
    <title>Update Theater</title>
</head>
<body>
    <%	
        String originalTheaterName = request.getParameter("originalTheaterName");
    	String originallocation=request.getParameter("originallocation");
    
        String newTheaterName = request.getParameter("theaterName");
        String newLocation = request.getParameter("location");
        String email = (String) session.getAttribute("email");

        Connection conn = null;
        PreparedStatement pstmt = null;
        String message = "";

        try {
            // Establish database connection
            DB_Connection obj_Db_Connection = new DB_Connection();
            conn = obj_Db_Connection.get_Connection();

            if (conn != null) {
                // Update theater details in the Theaters table
                String updateTheaterQuery = "UPDATE Theaters SET TheaterName = ?, Location = ? WHERE TheaterName = ? AND manager_email = ? and location=?";
                pstmt = conn.prepareStatement(updateTheaterQuery);
                pstmt.setString(1, newTheaterName);
                pstmt.setString(2, newLocation);
                pstmt.setString(3, originalTheaterName);
                pstmt.setString(4, email);
                pstmt.setString(5, originallocation);

                int theaterRowsAffected = pstmt.executeUpdate();

                if (theaterRowsAffected > 0) {
                    // Update theater name in the Movies table
                    String updateMoviesQuery = "UPDATE Movies SET TheaterName = ?, location = ? WHERE TheaterName = ? AND manager_email = ? and location=?";
                    pstmt = conn.prepareStatement(updateMoviesQuery);
                    pstmt.setString(1, newTheaterName);
                    pstmt.setString(2, newLocation);
                    pstmt.setString(3, originalTheaterName);
                    pstmt.setString(4, email);
                    pstmt.setString(5, originallocation);
                    
                    int movieRowsAffected = pstmt.executeUpdate();

                    if (movieRowsAffected > 0) {
                        message = "Theater and related movies updated successfully!";
                    } else {
                        message = "Theater updated, but no movies were linked to this theater.";
                    }
                } else {
                    message = "Failed to update theater. Please try again.";
                }
            } else {
                message = "Database connection failed.";
            }
        } catch (Exception e) {
            message = "Error updating theater: " + e.getMessage();
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                message = "Error closing resources: " + e.getMessage();
            }
        }
    %>

    <!-- Display success or error message -->
    <script>
        alert('<%= message.replace("'", "\\'") %>');
        window.location.href = 'managerProfile.jsp';
    </script>
</body>
</html>
