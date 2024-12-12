<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="controller.DB_Connection"%>
<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>User Profile</title>
<style>
    /* Resetting some basic styles */
    body {
        font-family: Arial, sans-serif;
        margin: 0;
        padding: 0;
        background-color: #f4f4f4;
    }

    /* Center the content */
    .container {
        width: 80%;
        margin: 20px auto;
        background-color: white;
        padding: 20px;
        border-radius: 8px;
        box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.1);
    }

    /* Header styles */
    .header {
        background-color: #4CAF50;
        color: white;
        padding: 15px;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    .header h2 {
        margin: 0;
        font-size: 24px;
    }

    /* Table styles */
    table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 20px;
    }

    th, td {
        padding: 12px;
        text-align: left;
        border: 1px solid #ddd;
    }

    th {
        background-color: #4CAF50;
        color: white;
    }

    /* Button styles */
    .btn {
        background-color: #4CAF50;
        color: white;
        padding: 10px 20px;
        text-decoration: none;
        border-radius: 5px;
        display: inline-block;
    }

    .btn:hover {
        background-color: #45a049;
    }

    .action-btn {
        background-color: #f44336; /* Red for delete */
        color: white;
        padding: 5px 10px;
        text-decoration: none;
        border-radius: 5px;
    }

    .action-btn:hover {
        background-color: #d32f2f;
    }

    .edit-btn {
        background-color: #ff9800; /* Orange for edit */
        color: white;
        padding: 5px 10px;
        text-decoration: none;
        border-radius: 5px;
    }

    .edit-btn:hover {
        background-color: #f57c00;
    }

    /* Add a footer for better structure */
    .footer {
        text-align: center;
        margin-top: 20px;
        color: #777;
        font-size: 14px;
    }
</style>
</head>
<body>

<%
    // Set session timeout to 10 minutes (6000 seconds)
      // 6000 seconds = 10 minutes

    String adminname= (String) session.getAttribute("adminname");
	//String adminname=adminname1;
%>

<%-- Header Section --%>

<center>
<% if (adminname == null) { %>

    <div class="container">
        <h2>Your session has expired due to inactivity. Please log in again.</h2>
        <p><a href="adminLogin.jsp" class="btn">Go to Login</a></p>
        
    </div>

<% } else { %>

    <div class="header">
        <h2>Welcome Admin, <%= adminname %>!</h2>
        <div>
            <a href="addManager.jsp" class="btn">Add Manager</a>
            <a href="Dash.jsp" class="btn">Logout</a>
        </div>
    </div>

    <div class="container">
        <h3>Managers List</h3>
        <%
            // Database connection setup
            Connection conn = null;
            Statement stmt = null;
            ResultSet rs = null;
            try {
                DB_Connection obj_Db_Connection = new DB_Connection();
                conn = obj_Db_Connection.get_Connection();

                if (conn != null) {
                    // SQL query to retrieve all managers' details
                    String sql = "SELECT ManagerID, ManagerName, Email, PhoneNumber FROM Managers";
                    stmt = conn.createStatement();
                    rs = stmt.executeQuery(sql);

                    // Display manager details in a table
                    if (rs.next()) {
        %>
                        <table>
                            <tr>
                                <th>Manager Name</th>
                                <th>Email</th>
                                <th>Phone Number</th>
                                <th>Actions</th>
                            </tr>
        <%
                        // Loop through the result set and display data
                        do {
        %>
                            <tr>
                                <td><%= rs.getString("ManagerName") %></td>
                                <td><%= rs.getString("Email") %></td>
                                <td><%= rs.getString("PhoneNumber") %></td>
                                <td>
                                    <!-- Edit and Delete buttons -->
                                    <a href="editManager.jsp?id=<%= rs.getInt("ManagerID") %>" class="edit-btn">Edit</a>
                        
                                    <a href="deleteManager.jsp?id=<%= rs.getInt("ManagerID") %>&email=<%= rs.getString("Email") %>" class="action-btn" onclick="return confirm('Are you sure you want to delete this manager?');">Delete</a>
                                    
                                </td>
                            </tr>
        <%
                        } while (rs.next());
        %>
                        </table>
        <%
                    } else {
                        out.print("<p>No managers found.</p>");
                    }
                } else {
                    out.print("<p>Database connection failed.</p>");
                }
            } catch (Exception e) {
                out.print("<p>Error: " + e.getMessage() + "</p>");
            } finally {
                try {
                    if (rs != null) rs.close();
                    if (stmt != null) stmt.close();
                    if (conn != null) conn.close();
                } catch (SQLException e) {
                    out.print("<p>Error closing resources: " + e.getMessage() + "</p>");
                }
            }
        %>
    </div>

<% 
    }
    // Invalidating session after use
    //session.removeAttribute("adminname");
    //session.invalidate();
%>

</center>

<!-- Footer Section -->
<div class="footer">
    <p>&copy; 2024 Your Company. All Rights Reserved.</p>
</div>

</body>
</html>
