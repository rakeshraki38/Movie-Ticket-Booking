<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="controller.DB_Connection"%>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BookYourShow</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f4;
        }

        header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 20px;
            background-color: #ff4c68;
            color: white;
            position: relative;
            margin-bottom: 20px; /* Adds space below the header */
        }

        header h1 {
            flex: 1;
            text-align: center;
            margin: 0;
        }

        .dot-menu {
            position: relative;
            cursor: pointer;
            font-size: 24px;
            margin-left: auto;
        }

        .dot-menu span {
            display: block;
            height: 5px;
            width: 5px;
            background-color: white;
            border-radius: 50%;
            margin: 3px 0;
        }

        .dropdown {
            display: none;
            position: absolute;
            top: 40px;
            right: 20px;
            background-color: white;
            color: #ff4c68;
            border: 1px solid #ff4c68;
            border-radius: 5px;
            box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.1);
            z-index: 9999;
            text-align: left;
        }

        .dropdown a {
            display: block;
            padding: 10px 15px;
            text-decoration: none;
            color: #ff4c68;
            font-size: 16px;
        }

        .dropdown a:hover {
            background-color: #ff4c68;
            color: white;
        }

       .container {
    	display: flex;
    	flex-wrap: wrap;
    	justify-content: flex-start;
    	gap: 10px;
    	margin: 0 10px 20px;
		}

		.movie-card {
    	display: flex;
    	flex-direction: column;
    	align-items: center;
    	flex-basis: calc(16.5% - 10px); /* Adjusted width */
    	background-color: white;
    	box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
    	border-radius: 8px;
    	text-align: center;
		}

        .movie-card img {
            width: 100%;
            height: 290px;
            object-fit: cover;
            cursor: pointer;
        }

        .movie-card h3 {
            margin: 5px 0;
            font-size: 16px;
            color: #333;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .movie-card p {
            margin: 5px 0;
            color: #777;
        }

        .movie-card button {
            background-color: #ff4c68;
            color: white;
            border: none;
            padding: 10px 20px;
            font-size: 16px;
            border-radius: 5px;
            cursor: pointer;
            margin-bottom: 10px;
        }

        .movie-card button:hover {
            background-color: #e63950;
        }

        footer {
            text-align: center;
            padding: 5px;
            background-color: #333;
            color: white;
            position: fixed;
            bottom: 0;
            width: 100%;
            font-size: 14px;
        }
    </style>
</head>
<body>
    <header>
        <h1>Book Your Show</h1>
        <div class="dot-menu" id="dot-menu">
            <!-- Three Dots Icon -->
            <span></span>
            <span></span>
            <span></span>

            <!-- Dropdown Menu -->
            <div class="dropdown" id="dropdown-menu">
                <a href="adminLogin.jsp">Admin</a>
                <a href="ManagerLogin.jsp">Manager</a>
                <a href="userRegister.jsp">User</a>
                <a href="Dash.jsp">Logout</a>
            </div>
        </div>
    </header>

    <div class="container">
        <%
            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;

            try {
                // Establish database connection
                DB_Connection obj_Db_Connection = new DB_Connection();
                conn = obj_Db_Connection.get_Connection();

                if (conn != null) {
                    // Query to fetch unique movies
                    String query = "SELECT DISTINCT MovieID, MovieTitle, LANGUAGE, ImageSrc FROM Movies " +
                                   "WHERE MovieID IN (SELECT MIN(MovieID) FROM movies GROUP BY MovieTitle)";
                    stmt = conn.prepareStatement(query);
                    rs = stmt.executeQuery();

                    while (rs.next()) {
                        int movieId = rs.getInt("MovieID");
                        String movieName = rs.getString("MovieTitle");
                        String language = rs.getString("Language");
                        String posterURL = rs.getString("ImageSrc");
        %>
                        <div class="movie-card">
               	                <a href="userLogin.jsp?movieTitle=<%= movieName %>&movieID=<%= movieId%>">
                                <img src="<%= posterURL %>" alt="<%= movieName %>">
                            </a>
                            <h3><%= movieName %></h3>
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
    </div>

    <footer>
        <p>&copy; 2024 BookYourShow. All Rights Reserved.</p>
    </footer>

    <script>
        document.getElementById("dot-menu").addEventListener("click", function() {
            var dropdown = document.getElementById("dropdown-menu");
            dropdown.style.display = (dropdown.style.display === "block") ? "none" : "block";
        });

        window.addEventListener("click", function(event) {
            var dropdown = document.getElementById("dropdown-menu");
            var menu = document.getElementById("dot-menu");
            if (!menu.contains(event.target)) {
                dropdown.style.display = "none";
            }
        });
    </script>
</body>
</html>  