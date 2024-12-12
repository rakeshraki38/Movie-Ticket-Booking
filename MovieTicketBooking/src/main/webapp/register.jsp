<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.security.MessageDigest" %>
<%@ page import="controller.DB_Connection" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register</title>
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

        /* Success message styling */
        .success-message {
            background-color: #e0f7e0;
            padding: 15px;
            border-radius: 8px;
            text-align: center;
            margin-top: 20px;
            color: #4caf50;
        }

        .btn-group {
            margin-top: 20px;
            text-align: center;
        }

        .btn-group a {
            display: inline-block;
            padding: 10px 20px;
            margin: 5px;
            background-color: #ff4c68;
            color: white;
            text-decoration: none;
            border-radius: 5px;
        }

        .btn-group a:hover {
            background-color: #e63950;
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
    <div class="form-container">
        <h2>Register</h2>

        <% 
            boolean isRegistered = false; // flag to track successful registration
            if (request.getMethod().equalsIgnoreCase("POST")) {
                String username = request.getParameter("username");
                String email = request.getParameter("email");
                String password = request.getParameter("password");
                String phone = request.getParameter("phone");

                // Validate password: at least 8 chars, 1 uppercase, and 1 digit
                if (!password.matches("^(?=.*[A-Z])(?=.*\\d).{8,}$")) {
                    out.println("<p>Password must be at least 8 characters long, with 1 uppercase letter and 1 number.</p>");
                } else {
                    Connection conn = null;
                    PreparedStatement stmt = null;

                    try {
                        // Establish database connection
                        DB_Connection obj_Db_Connection = new DB_Connection();
                        conn = obj_Db_Connection.get_Connection();

                        // Check if email already exists
                        String checkQuery = "SELECT Email FROM Users WHERE Email = ?";
                        stmt = conn.prepareStatement(checkQuery);
                        stmt.setString(1, email);
                        ResultSet rs = stmt.executeQuery();

                        if (rs.next()) {
                            out.println("<p>Email already exists. Please <a href='userLogin.jsp'>Login</a>.</p>");
                        } else {
                            // Hash password using SHA-256
                            MessageDigest md = MessageDigest.getInstance("SHA-256");
                            byte[] hash = md.digest(password.getBytes());
                            StringBuilder hashedPassword = new StringBuilder();
                            for (byte b : hash) {
                                hashedPassword.append(String.format("%02x", b));
                            }

                            // Insert new user into database
                            String insertQuery = "INSERT INTO Users (Username, Email, PasswordHash, Phone) VALUES (?, ?, ?, ?)";
                            stmt = conn.prepareStatement(insertQuery);
                            stmt.setString(1, username);
                            stmt.setString(2, email);
                            stmt.setString(3, hashedPassword.toString());
                            stmt.setString(4, phone);
                            stmt.executeUpdate();

                            // Set the flag indicating successful registration
                            isRegistered = true;
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                        out.println("<p>Error: " + e.getMessage() + "</p>");
                    } finally {
                        if (stmt != null) try { stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                        if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
                    }
                }
            }

            // Show success message and buttons if registration is successful
            if (isRegistered) { %>
                <div class="success-message">
                    <h3>Account created successfully!</h3>
                    <p>Your account has been successfully created.</p>
                </div>
                <div class="btn-group">
                    <a href="userLogin.jsp">Login</a>
                    <a href="Dash.jsp">Home</a>
                </div>
            <% } else { %>
                <!-- Registration Form -->
                <form action="register.jsp" method="POST">
                    <label>Username:</label>
                    <input type="text" name="username" required>

                    <label>Email:</label>
                    <input type="email" name="email" required>

                    <label>Password:</label>
                    <input type="password" name="password" required>

                    <label>Phone Number:</label>
                    <input type="text" name="phone" pattern="\d{10}" title="Enter a valid 10-digit phone number" required>

                    <button type="submit">Register</button>
                </form>
            <% } %>

    </div>
</body>
</html>
