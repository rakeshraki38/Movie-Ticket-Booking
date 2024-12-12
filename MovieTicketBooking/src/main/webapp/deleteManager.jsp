<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="controller.DB_Connection"%>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
    <title>Delete Manager</title>
</head>
<body>
    <%
        String managerEmail = request.getParameter("email"); // Retrieve the manager email from the request
        Connection conn = null;
        PreparedStatement deleteMoviesStmt = null;
        PreparedStatement deleteTheatersStmt = null;
        PreparedStatement deleteManagerStmt = null;
        Statement stmt = null;
        ResultSet rs = null;
        String message = "";

        try {
            // Establish database connection
            DB_Connection obj_Db_Connection = new DB_Connection();
            conn = obj_Db_Connection.get_Connection();

            if (conn != null) {
                // Start a transaction
                conn.setAutoCommit(false);

                // Delete movies associated with theaters managed by the manager
                String deleteMoviesQuery = "DELETE FROM Movies WHERE TheaterName IN (SELECT TheaterName FROM Theaters WHERE manager_email = ?)";
                deleteMoviesStmt = conn.prepareStatement(deleteMoviesQuery);
                deleteMoviesStmt.setString(1, managerEmail);
                deleteMoviesStmt.executeUpdate();

                // Delete theaters managed by the manager
                String deleteTheatersQuery = "DELETE FROM Theaters WHERE manager_email = ?";
                deleteTheatersStmt = conn.prepareStatement(deleteTheatersQuery);
                deleteTheatersStmt.setString(1, managerEmail);
                deleteTheatersStmt.executeUpdate();
				
                
             	
                // Delete the manager
                String deleteManagerQuery = "DELETE FROM Managers WHERE Email = ?";
                deleteManagerStmt = conn.prepareStatement(deleteManagerQuery);
                deleteManagerStmt.setString(1, managerEmail);
                int rowsDeleted = deleteManagerStmt.executeUpdate();

                if (rowsDeleted > 0) {
                	// Renumber MovieID in the Movies table
                    stmt = conn.createStatement();
                    stmt.execute("SET @new_id = 0");
                    stmt.execute("UPDATE Movies SET MovieID = (@new_id := @new_id + 1)");

                    // Renumber TheaterID in the Theaters table
                    stmt.execute("SET @new_id = 0");
                    stmt.execute("UPDATE Theaters SET TheaterID = (@new_id := @new_id + 1)");
                    
                    
                    // Renumber ManagerID in the Managers table
                    stmt = conn.createStatement();
                    stmt.execute("SET @new_id = 0");
                    stmt.execute("UPDATE Managers SET ManagerID = (@new_id := @new_id + 1)");

                    // Commit the transaction
                    conn.commit();
                    message = "Manager and associated data have been successfully deleted.";
                } else {
                    conn.rollback(); // Rollback if manager deletion fails
                    message = "Failed to delete the manager. Please try again.";
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
                if (deleteTheatersStmt != null) deleteTheatersStmt.close();
                if (deleteManagerStmt != null) deleteManagerStmt.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                message = "Error closing resources: " + e.getMessage();
            }
        }
    %>

    <!-- Redirect to Profile.jsp -->
    <script>
        alert('<%= message.replace("'", "\\'") %>');
        window.location.href = 'Profile.jsp';
    </script>
</body>
</html>
