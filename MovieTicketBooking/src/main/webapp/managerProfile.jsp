<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="controller.DB_Connection"%>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
    <title>Dashboard</title>
    <style>
        /* Basic styles for the header and buttons */
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
        }
        header {
            background-color: #333;
            color: white;
            padding: 15px;
            text-align: center;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        header h1 {
            margin: 0;
        }
        nav {
            display: flex;
            gap: 10px;
        }
        nav button {
            background-color: #555;
            color: white;
            border: none;
            padding: 10px 20px;
            cursor: pointer;
            border-radius: 5px;
            font-size: 16px;
        }
        nav button:hover {
            background-color: #777;
        }
        main {
            padding: 20px;
            text-align: center;
        }
        table {
            width: 80%;
            margin-top: 20px;
            border-collapse: collapse;
            margin: 20px auto;
        }
        table, th, td {
            border: 1px solid #ddd;
        }
        th, td {
            padding: 10px;
            text-align: left;
        }
        th {
            background-color: #333;
            color: white;
        }
        .action-buttons {
            display: flex;
            gap: 10px;
        }
        .action-buttons button {
            background-color: #ff4c68;
            color: white;
            border: none;
            padding: 5px 10px;
            cursor: pointer;
            border-radius: 5px;
        }
        .action-buttons button:hover {
            background-color: #e63950;
        }
        .section-title {
            text-align: center;
            margin-top: 40px;
            font-size: 24px;
            color: #333;
        }
    </style>
</head>
<body>
    <!-- Header Section -->
    <header>
        <%
        String email = (String) session.getAttribute("email");
        %>
        <%
        String managerName = "Manager not found";
        try {
            // Database connection setup
            Connection conn = null;
        	ResultSet rsm = null;
        	        	
            DB_Connection obj_Db_Connection = new DB_Connection();
            conn = obj_Db_Connection.get_Connection();
            PreparedStatement Stmt = null;
            if (conn != null) {
                // Retrieve movies added by the manager
                String managerQuery = "SELECT ManagerName FROM Managers WHERE Email = ?";
                Stmt = conn.prepareStatement(managerQuery);
                Stmt.setString(1, email);
                rsm = Stmt.executeQuery();
                if (rsm.next()) {
                    managerName = rsm.getString("ManagerName");
                }
            } else {
                out.println("<p>Database connection failed.</p>");
            }
        } catch (SQLException e) {
            out.println("<p>Error retrieving movies: " + e.getMessage() + "</p>");
        }
        %>
        
        <h2>Welcome to your profile!<%= managerName %></h2>
        
        <nav>
            <form action="addTheater.jsp" method="get" style="display:inline;">
                <button type="submit">Add Theaters</button>
            </form>
            <form action="addMovies.jsp" method="get" style="display:inline;">
                <button type="submit">Add Movies</button>
            <!-- 
            	<form action="addShows.jsp" method="post" style="display:inline;">
                <button type="submit">Add shows</button>
            </form>
             -->
            </form>
            
            <form action="Dash.jsp" method="post" style="display:inline;">
                <button type="submit">Logout</button>
            </form>
        </nav>
    </header>

    <!-- Main Content Section -->
    <main>
        <!-- Movie Section -->
        <div class="section-title">
            <h3>Movies Added by You</h3>
        </div>
        
        <%

        ResultSet rsMovies = null;
        PreparedStatement movieStmt = null;
        Connection conn = null;
        try {
            // Database connection setup
            DB_Connection obj_Db_Connection = new DB_Connection();
            conn = obj_Db_Connection.get_Connection();
            
            if (conn != null) {
                // Retrieve movies added by the manager
                String movieQuery = "SELECT MovieTitle, Genre, Duration, Language, Director, Description, TheaterName, location FROM Movies WHERE manager_email = ?";
                movieStmt = conn.prepareStatement(movieQuery);
                movieStmt.setString(1, email);
                rsMovies = movieStmt.executeQuery();
            } else {
                out.println("<p>Database connection failed.</p>");
            }
        } catch (SQLException e) {
            out.println("<p>Error retrieving movies: " + e.getMessage() + "</p>");
        }
        %>

        <table>
            <thead>
                <tr>
                    <th>Title</th>
                    <th>Genre</th>
                    <th>Duration</th>                    
                    <th>Theater</th>
                    <th>Location</th>
                    <th>Language</th>
                    <th>Director</th>
                    <th>Description</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                try {
                    while (rsMovies != null && rsMovies.next()) {
                        String movieTitle = rsMovies.getString("MovieTitle");
                        String genre = rsMovies.getString("Genre");
                        int duration = rsMovies.getInt("Duration");
                        
                        String theaterName = rsMovies.getString("TheaterName");
                        String location = rsMovies.getString("location");
                        String language = rsMovies.getString("Language");
                        String director = rsMovies.getString("Director");
                        String description = rsMovies.getString("Description");
                %>
                <tr>
                    <td><%= movieTitle %></td>
                    <td><%= genre %></td>
                    <td><%= duration %> mins</td>
                    
                    <td><%= theaterName %></td>
                    <td><%= location %></td>
                    <td><%= language %></td>
                    <td><%= director %></td>
                    <td><%= description %></td>
                    <td>
                    	 <div class="action-buttons">
                    	 <form action="addShows.jsp" method="post">
    					 <!-- Hidden inputs to pass multiple values -->
    					<input type="hidden" name="movieTitle" value="<%= movieTitle %>">
    					<input type="hidden" name="genre" value="<%= genre %>">
    					
    					<input type="hidden" name="theaterName" value="<%= theaterName %>">
    					<input type="hidden" name="location" value="<%= location %>">
    					<input type="hidden" name="language" value="<%= language %>">
    					<input type="hidden" name="director" value="<%= director %>">
    					<input type="hidden" name="description" value="<%= description %>">

    					<button type="submit">Add Show</button>
						</form>
                            
                        
                            <form action="editMovie.jsp" method="get">
                                <input type="hidden" name="movieTitle" value="<%= movieTitle %>">
                                <input type="hidden" name="theaterName" value="<%= theaterName %>">
    							<input type="hidden" name="location" value="<%= location %>">
                                <button type="submit">Edit</button>
                            </form>
                            <form action="deleteMovie.jsp" method="post">
                                <input type="hidden" name="movieTitle" value="<%= movieTitle %>">
                                <input type="hidden" name="theaterName" value="<%= theaterName %>">
    							<input type="hidden" name="location" value="<%= location %>">
                                <button type="submit" onclick="return confirm('Are you sure you want to delete this manager?')">Delete</button>
                            </form>
                        </div>
                    </td>
                </tr>
                <%
                    }
                } catch (SQLException e) {
                    out.println("<p>Error displaying movies: " + e.getMessage() + "</p>");
                }
                %>
                
            </tbody>
        </table>
		
		
        <%
        // Close resources for movies
        if (rsMovies != null) rsMovies.close();
        if (movieStmt != null) movieStmt.close();
        %>

        <!-- Theater Section -->
        <div class="section-title">
            <h3>Theaters Managed by You</h3>
        </div>
        
        <%
        ResultSet rsTheaters = null;
        PreparedStatement theaterStmt = null;
        try {
            if (conn != null) {
                // Retrieve theaters associated with the manager
                String theaterQuery = "SELECT TheaterName, Location, totalScreens FROM Theaters WHERE manager_email = ?";
                theaterStmt = conn.prepareStatement(theaterQuery);
                theaterStmt.setString(1, email);
                rsTheaters = theaterStmt.executeQuery();
            } else {
                out.println("<p>Database connection failed.</p>");
            }
        } catch (SQLException e) {
            out.println("<p>Error retrieving theaters: " + e.getMessage() + "</p>");
        }
        %>

        <table>
            <thead>
                <tr>
                    <th>Theater Name</th>
                    <th>Location</th>
                    <th>Total Screens</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                try {
                    while (rsTheaters != null && rsTheaters.next()) {
                        String theaterName = rsTheaters.getString("TheaterName");
                        String location = rsTheaters.getString("Location");
                        String totalScreens=rsTheaters.getString("totalScreens");
                %>
                <tr>
                    <td><%= theaterName %></td>
                    <td><%= location %></td>
                    <td><%= totalScreens %></td>
                    <td>
                        <div class="action-buttons">
                        	<form action="ManageScreens.jsp" method="get">
                                <input type="hidden" name="theaterName" value="<%= theaterName %>">
                                <input type="hidden" name="location" value="<%= location %>">
                                <input type="hidden" name="totalscreens" value="<%= totalScreens %>">
                                <button type="submit">Add Screens</button>
                            </form>
                            
                            <form action="editTheater.jsp" method="get">
                                <input type="hidden" name="theaterName" value="<%= theaterName %>">
                                <input type="hidden" name="location" value="<%= location %>">
                                <input type="hidden" name="totalscreens" value="<%= totalScreens %>">
                                <button type="submit">Edit</button>
                            </form>
                            <form action="deleteTheater.jsp" method="post">
                                <input type="hidden" name="theaterName" value="<%= theaterName %>">
                                <input type="hidden" name="location" value="<%= location %>">
                                <button type="submit" onclick="return confirm('Are you sure you want to delete this manager?')">Delete</button>
                            </form>
                        </div>
                    </td>
                </tr>
                <%
                    }
                } catch (SQLException e) {
                    out.println("<p>Error displaying theaters: " + e.getMessage() + "</p>");
                }
                %>
            </tbody>
        </table>

        <%
        // Close resources for theaters
        if (rsTheaters != null) rsTheaters.close();
        if (theaterStmt != null) theaterStmt.close();
        %>

        <% 
        // Close the database connection
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                out.println("<p>Error closing connection: " + e.getMessage() + "</p>");
            }
        }
        %>

    </main>
</body>
</html>  