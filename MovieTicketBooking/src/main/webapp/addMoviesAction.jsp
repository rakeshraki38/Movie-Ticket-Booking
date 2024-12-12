<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="controller.DB_Connection"%>
<%@page import="java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

<%
	String email=(String)session.getAttribute("email");
    // Handle form submission for Movie
    String movieTitle = request.getParameter("MovieTitle");
    String genre = request.getParameter("Genre");
	
    // Retrieve and validate duration
    String durationHoursStr = request.getParameter("durationHours");
    String durationMinutesStr = request.getParameter("durationMinutes");

    // Ensure that duration values are valid numbers and calculate total duration in minutes
    int durationHours = (durationHoursStr != null && !durationHoursStr.isEmpty()) ? Integer.parseInt(durationHoursStr) : 0;
    int durationMinutes = (durationMinutesStr != null && !durationMinutesStr.isEmpty()) ? Integer.parseInt(durationMinutesStr) : 0;
    int totalDurationInMinutes = (durationHours * 60) + durationMinutes;
    
    String ImageSrc = request.getParameter("ImageSrc");
    
   
    //out.println("<div class='error'>Please provide a valid movie poster URL.</div>");
    String language = request.getParameter("Language");
    String director = request.getParameter("Director");
    //String theaterName = request.getParameter("theater"); // Theater name to be inserted
    String description = request.getParameter("Description");
    //String theaterLocation=request.getParameter("location");
   
    String theaterName=null;
    String location=null;
   	String theaterParam = request.getParameter("theater");
	if (theaterParam != null && theaterParam.contains(" | ")) {
    String[] selectedValues = theaterParam.split(" \\| ");
    if (selectedValues.length > 1) {
        theaterName = selectedValues[0];
        location = selectedValues[1];
        
    } else {
        // Handle the case where the split does not result in the expected number of parts
        out.print("Error: Unexpected format for theater parameter.");
    }
	} else {
    // Handle the case where the parameter is null or does not contain the delimiter
    out.print("Error: Invalid or missing theater parameter.");
}
   
// Validate input before inserting to the database
if (movieTitle != null && !movieTitle.isEmpty() && genre != null && !genre.isEmpty() && totalDurationInMinutes > 0 && !theaterName.isEmpty()) {
	try {
	    // Database connection
	    DB_Connection obj_Db_Connection = new DB_Connection();
	    Connection conn = obj_Db_Connection.get_Connection();

	    // SQL Query for inserting movie details
	    String query = "INSERT INTO Movies (MovieTitle, Genre, Duration, ImageSrc, Language, Director, Description, manager_email, TheaterName, location) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
	    PreparedStatement stmt = conn.prepareStatement(query);

	    // Set parameters
	    stmt.setString(1, movieTitle);        // Movie Title
	    stmt.setString(2, genre);             // Genre
	    stmt.setInt(3, totalDurationInMinutes); // Duration in minutes
	    stmt.setString(4, ImageSrc);          // Movie Poster (URL)
	    stmt.setString(5, language);          // Language
	    stmt.setString(6, director);          // Director
	    stmt.setString(7, description);       // Description
	    stmt.setString(8, email);    // Manager email from session
	    stmt.setString(9, theaterName);              // Theater Name
	    stmt.setString(10, location);         // Theater Location

	    // Execute the update
	    int rowsAffected = stmt.executeUpdate();

	    if (rowsAffected > 0) {
	    	// Renumber MovieID in the Movies table
			Statement stmt1=null;
            stmt1 = conn.createStatement();
            stmt1.execute("SET @new_id = 0");
            stmt1.execute("UPDATE Movies SET MovieID = (@new_id := @new_id + 1)");

%>
		<script type="text/javascript">
		alert('Movie added successfully!');
		window.location.href = "managerProfile.jsp";
		</script>
<%
	    } else {
	        out.println("<div class='error'>Failed to add the movie. Please try again.</div>");
	    }

	    // Close the statement and connection
	    stmt.close();
	    conn.close();

	} catch (SQLException e) {
	    e.printStackTrace();
	    out.println("<div class='error'>Error while adding the movie: " + e.getMessage() + "</div>");
	}

} else {
    out.println("<div class='error'>Please fill in all required fields correctly.</div>");
}


%>
</body>
</html>