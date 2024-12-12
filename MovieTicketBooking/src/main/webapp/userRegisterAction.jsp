<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="controller.DB_Connection" %>
<%@ page import="java.security.MessageDigest" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>User Authentication</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            background-color: #f4f4f4;
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 30px;
            background-color: #2C3E50;
            color: white;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
        }

        .header .welcome {
            font-size: 20px;
            font-weight: bold;
        }

        .header .logout-btn {
            background-color: #E74C3C;
            color: white;
            border: none;
            padding: 10px 20px;
            margin-left: 20px;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .header .logout-btn:hover {
            background-color: #C0392B;
        }

        .user-details {
            margin: 30px auto;
            padding: 20px;
            background-color: white;
            max-width: 600px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            border-radius: 8px;
        }

        .user-details label {
            font-weight: bold;
            margin-bottom: 5px;
            display: block;
        }

        .user-details input {
            width: 100%;
            padding: 12px;
            margin: 8px 0;
            font-size: 16px;
            border: 1px solid #ccc;
            border-radius: 5px;
            box-sizing: border-box;
        }

        .user-details input:disabled {
            background-color: #f2f2f2;
        }

        .button-container {
            display: flex;
            justify-content: space-between;
            margin-top: 20px;
        }

        .edit-btn, .save-btn {
            padding: 10px 20px;
            background-color: #2C3E50;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .edit-btn:hover, .save-btn:hover {
            background-color: #34495E;
        }

        .save-btn {
            display: none;
        }

        .dropdown {
            position: relative;
            display: inline-block;
        }

        .dropdown-btn {
            background-color: #E74C3C;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
        }

        .dropdown-btn:hover {
            background-color: #34495E;
        }

        .dropdown-content {
            display: none;
            position: absolute;
            background-color: white;
            min-width: 150px;
            box-shadow: 0px 8px 16px rgba(0, 0, 0, 0.2);
            z-index: 1;
            border-radius: 5px;
            overflow: hidden;
        }

        .dropdown-content a {
            color: #2C3E50;
            padding: 10px 15px;
            text-decoration: none;
            display: block;
            transition: background-color 0.3s ease;
        }

        .dropdown-content a:hover {
            background-color: #f2f2f2;
        }

        .dropdown:hover .dropdown-content {
            display: block;
        }
    </style>
</head>

<body>
<%
    String email = request.getParameter("email");
    String password = request.getParameter("password");
    String phone = null;
    String storedHash = null;
    boolean isValidUser = false;
    String userName = "";
    
    PreparedStatement pstmt=null;
    Connection conn=null;
    ResultSet rs=null;

    if (email != null && password != null) {
        try  {
        	conn = new DB_Connection().get_Connection();
        	pstmt = conn.prepareStatement("SELECT * FROM Users WHERE Email = ?");
            pstmt.setString(1, email);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                storedHash = rs.getString("PasswordHash");
                userName = rs.getString("UserName");
                phone = rs.getString("Phone");

                MessageDigest md = MessageDigest.getInstance("SHA-256");
                byte[] hashedBytes = md.digest(password.getBytes("UTF-8"));
                StringBuilder enteredHash = new StringBuilder();

                for (byte b : hashedBytes) {
                    enteredHash.append(String.format("%02x", b));
                }

                if (storedHash.equals(enteredHash.toString())) {
                    isValidUser = true;
                    session.setAttribute("userEmail", email);
                    session.setAttribute("userName", userName);
                }
            }
        } catch (Exception e) {
            out.println("<p>Error: " + e.getMessage() + "</p>");
        }
        finally {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        }
    }
%>

<% if (isValidUser) { %>
<div class="header">
    <div class="welcome">Welcome, <%= session.getAttribute("userName") %>!</div>
    <div>
        <div class="dropdown">
            <button class="dropdown-btn">Bookings &#9662;</button>
            <div class="dropdown-content">
            <a href="activeSections.jsp?email=<%= email%>&password=<%= password%>">Active</a>
            <a href="ExpiredSections.jsp?email=<%= email%>&password=<%= password%>">Expired</a>
        </div>
        </div>
        <button class="logout-btn" onclick="logout()">Logout</button>
    </div>
</div>

<div class="user-details">
    <form method="POST" action="userUpdate.jsp">
        <label for="username">User Name</label>
        <input type="text" id="username" name="username" value="<%= userName %>" disabled />

        <label for="email">Email</label>
        <input type="email" id="email" name="email" value="<%= email %>" disabled />
        <input type="hidden" name="hiddenEmail" value="<%= email %>" />

        <label for="phone">Phone</label>
        <input type="text" id="phone" name="phone" value="<%= phone %>" disabled />

        <label for="password">Password</label>
        <input type="text" id="password" name="password" value="<%= password %>" disabled />

        <div class="button-container">
            <button type="button" class="edit-btn" onclick="enableEdit()">Edit</button>
            <button type="submit" class="save-btn">Update</button>
        </div>
    </form>
</div>

<script>
    function logout() {
        <% session.invalidate(); %>
        window.location.href = "Dash.jsp";
    }

    function enableEdit() {
        document.getElementById("username").disabled = false;
        document.getElementById("phone").disabled = false;
        document.getElementById("password").disabled = false;

        document.querySelector(".edit-btn").style.display = "none";
        document.querySelector(".save-btn").style.display = "inline-block";
    }
</script>
<% } else { %>
<script>
    alert("Invalid login credentials. Please try again!");
    window.location.href = "userRegister.jsp";
</script>
<% } %>


</body>
</html>
