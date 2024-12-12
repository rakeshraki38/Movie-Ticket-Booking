<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="controller.DB_Connection"%>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
    <title>Delete Theater</title>
</head>
<body>
    <%
        String theaterName = request.getParameter("theaterName"); // Retrieve the theater name from the request
        String location = request.getParameter("location");
        String email = (String) session.getAttribute("email");

        Connection conn = null;
        PreparedStatement deleteMoviesStmt = null;
        PreparedStatement deleteTheaterStmt = null;
        PreparedStatement deleteScreensStmt = null;
        Statement stmt = null;
        ResultSet rs = null;
        int theaterID=0;
        String message = "";

        try {
            // Establish database connection
            DB_Connection obj_Db_Connection = new DB_Connection();
            conn = obj_Db_Connection.get_Connection();
            
            String sql="select TheaterID from theaters where TheaterName=?";
            PreparedStatement pstmt=conn.prepareStatement(sql);
            pstmt.setString(1, theaterName);
            ResultSet rs1=pstmt.executeQuery();
            if(rs1.next()){
            	rs1.getInt("TheaterID");;
            }

            if (conn != null) {
                // Start a transaction
                conn.setAutoCommit(false);

                // Delete movies associated with the theater
                String deleteMoviesQuery = "DELETE FROM Movies WHERE TheaterName = ? and location=?";
                deleteMoviesStmt = conn.prepareStatement(deleteMoviesQuery);
                deleteMoviesStmt.setString(1, theaterName);
                deleteMoviesStmt.setString(2, location);
                deleteMoviesStmt.executeUpdate();
				
                // Delete Screens associated with the theater
                //String deleteScreensQuery = "DELETE FROM Screens WHERE TheaterID = ?";
                //deleteScreensStmt = conn.prepareStatement(deleteScreensQuery);
                
                //deleteScreensStmt.setInt(1, theaterID);
                //deleteMoviesStmt.setString(2, location);
                //deleteScreensStmt.executeUpdate();
                
                // Delete the theater itself
                String deleteTheaterQuery = "DELETE FROM Theaters WHERE TheaterName = ? AND manager_email = ? and location=?";
                deleteTheaterStmt = conn.prepareStatement(deleteTheaterQuery);
                deleteTheaterStmt.setString(1, theaterName);
                deleteTheaterStmt.setString(2, email);
                deleteTheaterStmt.setString(3, location);
                int theaterRowsDeleted = deleteTheaterStmt.executeUpdate();

                if (theaterRowsDeleted > 0) {
                    // Renumber TheaterID
                    stmt = conn.createStatement();
                    stmt.execute("SET @new_id = 0");
                    stmt.execute("UPDATE Theaters SET TheaterID = (@new_id := @new_id + 1)");

                    // Get the new AUTO_INCREMENT value for Theaters
                    rs = stmt.executeQuery("SELECT IFNULL(MAX(TheaterID), 0) + 1 AS NextID FROM Theaters");
                    int nextTheaterID = 1;
                    if (rs.next()) {
                        nextTheaterID = rs.getInt("NextID");
                    }

                    // Reset AUTO_INCREMENT value for Theaters
                    stmt.execute("ALTER TABLE Theaters AUTO_INCREMENT = " + nextTheaterID);

                    // Renumber MovieID for remaining movies
                    stmt.execute("SET @new_id = 0");
                    stmt.execute("UPDATE Movies SET MovieID = (@new_id := @new_id + 1)");
					
                    //renumber ScreenID value for SCreens
                    stmt.execute("SET @new_id = 0");
                    stmt.execute("UPDATE Screens SET ScreenID = (@new_id := @new_id + 1)");
					
                    
                    // Get the new AUTO_INCREMENT value for Movies
                    rs = stmt.executeQuery("SELECT IFNULL(MAX(MovieID), 0) + 1 AS NextID FROM Movies");
                    int nextMovieID = 1;
                    if (rs.next()) {
                        nextMovieID = rs.getInt("NextID");
                    }

                    // Reset AUTO_INCREMENT value for Movies
                    stmt.execute("ALTER TABLE Movies AUTO_INCREMENT = " + nextMovieID);

                    conn.commit(); // Commit the transaction
                    message = "Theater '" + theaterName + "' and its associated movies, Screens have been successfully deleted.";
                } else {
                    conn.rollback(); // Rollback if theater deletion fails
                    message = "Failed to delete theater '" + theaterName + "'. Please try again.";
                }
            } else {
                message = "Database connection failed.";
            }
        } catch (Exception e) {
            if (conn != null) {
                try {
                    conn.rollback(); // Rollback on error
                } catch (SQLException ex) {
                    message = "Error during rollback: " + ex.getMessage();
                }
            }
            message = "Error: " + e.getMessage();
        } finally {
            try {
                if (rs != null) rs.close();
                if (deleteMoviesStmt != null) deleteMoviesStmt.close();
                if (deleteTheaterStmt != null) deleteTheaterStmt.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                message = "Error closing resources: " + e.getMessage();
            }
        }
    %>

    <!-- Redirect to managerProfile.jsp -->
    <script>
        alert('<%= message.replace("'", "\\'") %>');
        window.location.href = 'managerProfile.jsp';
    </script>
</body>
</html>
