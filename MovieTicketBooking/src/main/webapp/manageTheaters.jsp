<%@page import="controller.DB_Connection"%>
<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Profile</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
        }

        .header {
            background-color: #ff4c68;
            color: white;
            padding: 20px;
            text-align: center;
        }

        .header h1 {
            margin: 0;
        }

        .header .welcome-message {
            font-size: 20px;
        }

        .header .logout-button {
            background-color: #e63950;
            color: white;
            border: none;
            padding: 10px 20px;
            font-size: 16px;
            cursor: pointer;
            border-radius: 5px;
            margin-top: 10px;
        }

        .header .logout-button:hover {
            background-color: #d62828;
        }

        .movies-list {
            margin: 30px;
        }

        .movies-list h4 {
            font-size: 24px;
            margin-bottom: 20px;
        }

        .movie-item {
            background-color: white;
            padding: 15px;
            margin-bottom: 10px;
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }

        .movie-item p {
            font-size: 18px;
            margin: 5px 0;
        }
    </style>
</head>
<body>
	
    <!-- Header with Welcome message and Logout Button -->
    <div class="header">
    	<%
    	
		String email = request.getParameter("email");
		String movieTitle=request.getParameter("movieTitle");
		
		Connection conn = null;
    	
     	String username=null;
     	
    	try{
	 	DB_Connection obj_Db_Connection=new DB_Connection();
     	conn=obj_Db_Connection.get_Connection();
		
     	String strquery="select Username from Users where Email=?";
     	PreparedStatement ps=conn.prepareStatement(strquery);
     	ps.setString(1,email);
     	ResultSet rst=ps.executeQuery();
     	
     	if(rst.next()){
     		username=rst.getString("Username");
     	}  
    	else {
        out.println("<p>Database connection failed.</p>");
    	}
		} catch (SQLException e) {
    	out.println("<p>Error retrieving movies: " + e.getMessage() + "</p>");
		}
%>
	
        <h1>Welcome,<%= username %> </h1>

        <p class="welcome-message"></p>
        <form action="Dash.jsp" method="POST">
        <button type="submit" class="logout-button" style="position: absolute;
    			right: 0px;top: 20px;">Logout</button>
        </form>
    </div>
    	<%			
			ResultSet rs=null;
			PreparedStatement stmt=null;
			try {
                // Establish database connection
                if (conn != null) {
                    // Query to fetch unique movies
                    

    		String query = "SELECT DISTINCT MovieID, MovieTitle, Duration, ImageSrc, Language,"+
    		"TheaterName, location from movies where MovieTitle=?";
                  
    		stmt = conn.prepareStatement(query);
    		stmt.setString(1,movieTitle);
    		
    		
    		 rs = stmt.executeQuery();

    		while (rs.next()) {
      		  // Movie details
        	int movieId = rs.getInt("MovieID");
        	String movieName = rs.getString("MovieTitle");
        	String language = rs.getString("Language");
        	//String genre = rs.getString("Genre");
        	
        	String duration = rs.getString("Duration");
        	String posterURL = rs.getString("ImageSrc");
        	//String description = rs.getString("Description");

        	// Theater details
        	//int theaterId = rs.getInt("TheaterID");
        	String theaterName = rs.getString("TheaterName");
        	String location = rs.getString("Location");
        	//int capacity = rs.getInt("SeatingCapacity");
        	
%>                       
						 <div class="movie-card">
                            <a href="userLogin.jsp?movieTitle=<%= movieName %>">
                                <img src="<%= posterURL %>" alt="<%= movieName %>">
                            </a>
                            <h1><%= movieName %></h1>
                            <h4>Language: <%= language %></h4>
                            <h4>TheaterName: <%= theaterName %></h4>
                            <h4>Location: <%= location %></h4>
                        </div>
<%
                    }
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
