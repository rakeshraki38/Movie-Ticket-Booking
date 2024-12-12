<%@ page import="controller.DB_Connection" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Manager</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f9f9f9;
            margin: 0;
            padding: 20px;
        }
        .form-container {
            background-color: #ffffff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            max-width: 500px;
            margin: auto;
        }
        h1 {
            text-align: center;
            color: #333;
        }
        label {
            display: block;
            margin-bottom: 8px;
            color: #555;
        }
        input[type="text"],
        input[type="password"],
        input[type="email"] {
            width: 100%;
            padding: 10px;
            margin-bottom: 15px;
            border: 1px solid #ccc;
            border-radius: 4px;
            font-size: 14px;
        }
        button {
            width: 100%;
            padding: 10px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
        }
        button:hover {
            background-color: #45a049;
        }
    </style>
</head>
<body>
    <%
        String managerIdStr = request.getParameter("id");
        String managerName = "", email = "", phoneNumber = "", password = "";

        if (managerIdStr != null) {
            int managerId = Integer.parseInt(managerIdStr);
            Connection connection = null;
            PreparedStatement ps = null;
            ResultSet rs = null;

            try {
                DB_Connection obj_DB_Connection = new DB_Connection();
                connection = obj_DB_Connection.get_Connection();
                ps = connection.prepareStatement("SELECT ManagerName, Email, PhoneNumber, Password FROM Managers WHERE ManagerID = ?");
                ps.setInt(1, managerId);
                rs = ps.executeQuery();

                if (rs.next()) {
                    managerName = rs.getString("ManagerName");
                    email = rs.getString("Email");
                    phoneNumber = rs.getString("PhoneNumber");
                    password = rs.getString("Password"); // Fetch current password
                } else {
                    out.print("<p>Manager not found.</p>");
                }
            } catch (Exception e) {
                e.printStackTrace();
                out.print("<p>Error: " + e.getMessage() + "</p>");
            } finally {
                try {
                    if (rs != null) rs.close();
                    if (ps != null) ps.close();
                    if (connection != null) connection.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    %>

    <div class="form-container">
        <form method="post" action="updateManager.jsp?id=<%= managerIdStr %>">
            <h1>Edit Manager</h1>
            <label for="managerName">Manager Name:</label>
            <input type="text" id="managerName" name="managerName" value="<%= managerName %>" required><br><br>

            <label for="password">Password:</label>
            <input type="password" id="password" name="password" value="<%= password %>" required><br><br>

            <label for="email">Email:</label>
            <input type="email" id="email" name="email" value="<%= email %>" required><br><br>

            <label for="phoneNumber">Phone Number:</label>
            <input type="text" id="phoneNumber" name="phoneNumber" value="<%= phoneNumber %>" required><br><br>

            <button type="submit">Update Manager</button>
        </form>
    </div>
</body>
</html>
