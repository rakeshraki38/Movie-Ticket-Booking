<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@page import="controller.DB_Connection"%>
<%@ page import="java.security.MessageDigest" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login</title>
    <style>
        /* General body styling */
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }

        /* Form container styling */
        .form-container {
            background-color: #fff;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            width: 400px;
        }

        .form-container h2 {
            text-align: center;
            margin-bottom: 20px;
            color: #333;
        }

        .form-container label {
            font-weight: bold;
            color: #555;
            display: block;
            margin-bottom: 5px;
        }

        .form-container input {
            width: 100%;
            padding: 10px;
            margin-bottom: 15px;
            border: 1px solid #ccc;
            border-radius: 5px;
            transition: border-color 0.3s;
        }

        .form-container input:focus {
            border-color: #ff4c68;
            outline: none;
            box-shadow: 0 0 5px rgba(255, 76, 104, 0.5);
        }

        .form-container button {
            width: 100%;
            padding: 10px;
            background-color: #ff4c68;
            border: none;
            color: white;
            font-size: 16px;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        .form-container button:hover {
            background-color: #e63950;
        }

        .form-container p {
            text-align: center;
            margin-top: 15px;
            font-size: 14px;
            color: #666;
        }

        .form-container a {
            color: #ff4c68;
            text-decoration: none;
        }

        .form-container a:hover {
            text-decoration: underline;
        }

        /* Responsive design */
        @media (max-width: 480px) {
            .form-container {
                width: 90%;
                padding: 20px;
            }
        }
    </style>
</head>
<body>
	<%
	String movieTitle=request.getParameter("movieTitle");
	
	%>
    <div class="form-container">
        <h2>Login</h2>
        <form action="userRegisterAction.jsp" method="POST">
       	    <label for="email">Email:</label>
            <input type="email" name="email" required>

            <label for="password">Password:</label>
            <input type="password" name="password" required>

            <button type="submit">Login</button>
        </form>

        <p>Don't have an account? <a href="register.jsp">Create one</a>.</p>

        <%
	
            if (request.getMethod().equalsIgnoreCase("POST")) {
              String email = request.getParameter("email");
              
              String password = request.getParameter("password");
                
                // Hash the input password
                String hashedPassword = null;
                try {
                    MessageDigest md = MessageDigest.getInstance("SHA-256");
                    byte[] hash = md.digest(password.getBytes());
                    StringBuilder sb = new StringBuilder();
                    for (byte b : hash) {
                        sb.append(String.format("%02x", b));
                    }
                    hashedPassword = sb.toString();
                } catch (Exception e) {
                    e.printStackTrace();
                }

                Connection conn = null;
                PreparedStatement stmt = null;
                try {
                    // Establish database connection
                      DB_Connection obj_Db_Connection=new DB_Connection();
                      conn=obj_Db_Connection.get_Connection();
                        
                    // Check if credentials match
                    String query = "SELECT * FROM Users WHERE Email = ? AND PasswordHash = ?";
                    stmt = conn.prepareStatement(query);
                    stmt.setString(1, email);
                    stmt.setString(2, hashedPassword);
                    ResultSet rs = stmt.executeQuery();

                    if (rs.next()) {
                        out.println("<p>Login successful! Welcome, " + email + ".</p>");
                        session.setAttribute("userEmail", email); // Set session
                    } else {
                        out.println("<p>Invalid email or password. Please try again.</p>");
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    out.println("<p>Something went wrong: " + e.getMessage() + "</p>");
                } finally {
                    if (stmt != null) stmt.close();
                    if (conn != null) conn.close();
                }
            }
        %>
    </div>
</body>
</html>
