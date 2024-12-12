<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="controller.DB_Connection" %>
<%@ page import="java.security.MessageDigest" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>User Authentication</title>
    <style>
        /* Add your CSS here for styling, if needed */
    </style>
</head>

<body>

    <%
        String movieTitle = request.getParameter("movieTitle");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        boolean isValidUser = false;
        Connection conn = null;

        if (email != null && password != null) {
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            

            try {
                // Establish database connection
                DB_Connection obj_Db_Connection = new DB_Connection();
                conn = obj_Db_Connection.get_Connection();

                // Fetch the hashed password from the database
                String query = "SELECT PasswordHash FROM Users WHERE Email = ?";
                pstmt = conn.prepareStatement(query);
                pstmt.setString(1, email);
                rs = pstmt.executeQuery();

                if (rs.next()) {
                    String storedHash = rs.getString("PasswordHash");

                    // Hash the entered password
                    MessageDigest md = MessageDigest.getInstance("SHA-256");
                    byte[] hashedBytes = md.digest(password.getBytes());
                    StringBuilder enteredHash = new StringBuilder();

                    for (byte b : hashedBytes) {
                        enteredHash.append(String.format("%02x", b));
                    }

                    // Compare the stored hash with the entered password hash
                    if (storedHash.equals(enteredHash.toString())) {
                        isValidUser = true;
                    }
                }
            } catch (Exception e) {
                out.println("<p>Error: " + e.getMessage() + "</p>");
            } finally {
                // Close resources
                try {
                    if (rs != null) rs.close();
                    if (pstmt != null) pstmt.close();
                    if (conn != null) conn.close();
                } catch (SQLException e) {
                    out.println("<p>Error closing resources: " + e.getMessage() + "</p>");
                }
            }
        }

        if (isValidUser) {
    %>
        <script>
            // Show a success alert and redirect
            
            alert("Logged in Successfully!");
            window.location.href = "userProfile.jsp?movieTitle=<%= movieTitle %>&email=<%= email %>";
        </script>
    <%
        } else {
    %>
        <script>
            // Show an error alert and redirect back to login
            alert("Invalid Email or Password. Please try again!");
            window.location.href = "userLogin.jsp";
        </script>
    <%
        }
    %>
	<%			
			
			ResultSet rs=null;
			PreparedStatement stmt=null;
			try {
                // Establish database connection
                if (conn != null) {
                    // Query to fetch unique movies
                    

    		String query = "SELECT DISTINCT m.MovieID, m.MovieTitle, m.Language, m.Genre,  " +
                   "m.Duration, m.ImageSrc, m.Description, " +
                   "t.TheaterID, t.TheaterName, t.Location, t.SeatingCapacity " +
                   "FROM Movies m " +
                   "JOIN Theaters t ON t.Manager_Email = m.Manager_Email and m.MovieTitle=?";
    		stmt = conn.prepareStatement(query);
    		stmt.setString(1,movieTitle);
    		
    		
    		 rs = stmt.executeQuery();

    		while (rs.next()) {
      		  // Movie details
        	int movieId = rs.getInt("MovieID");
        	String movieName = rs.getString("MovieTitle");
        	String language = rs.getString("Language");
        	String genre = rs.getString("Genre");
        	
        	String duration = rs.getString("Duration");
        	String posterURL = rs.getString("ImageSrc");
        	String description = rs.getString("Description");

        	// Theater details
        	int theaterId = rs.getInt("TheaterID");
        	String theaterName = rs.getString("TheaterName");
        	String location = rs.getString("Location");
        	int capacity = rs.getInt("SeatingCapacity");
        	
%>                       
						 <div class="movie-card">
                            <a href="userLogin.jsp?movieTitle=<%= movieName %>">
                                <img src="<%= posterURL %>" alt="<%= movieName %>">
                            </a>
                            <h4><%= movieName %></h4>
                            <h2>Language: <%= language %></h2>
                            <h2>TheaterName: <%= theaterName %></h2>
                            <h2>Location: <%= location %></h2>
                        </div>
<%
                    }
                } else {
                    out.println("Failed to connect to the database.");
                }
            } catch (Exception e) {
                e.printStackTrace();
                out.println("Error: " + e.getMessage());
            } finally {
                try {
                    if (rs != null) rs.close();
                    if (stmt != null) stmt.close();
                    if (conn != null) conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        %>
</body>

</html>
