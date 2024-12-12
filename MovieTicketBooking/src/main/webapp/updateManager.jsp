<%@ page import="controller.DB_Connection" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Update Manager</title>
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
        if (managerIdStr == null || managerIdStr.isEmpty()) {
            out.print("<p>Invalid Manager ID.</p>");
            return;
        }

        int managerId = Integer.parseInt(managerIdStr);
        String updatedName = request.getParameter("managerName");
        String updatedPassword = request.getParameter("password");
        String updatedEmail = request.getParameter("email");
        String updatedPhoneNumber = request.getParameter("phoneNumber");

        Connection connection = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            DB_Connection obj_DB_Connection = new DB_Connection();
            connection = obj_DB_Connection.get_Connection();
            connection.setAutoCommit(false); // Start transaction

            // Get current email before update to check for changes
            ps = connection.prepareStatement("SELECT Email FROM Managers WHERE ManagerID = ?");
            ps.setInt(1, managerId);
            rs = ps.executeQuery();
            String currentEmail = null;

            if (rs.next()) {
                currentEmail = rs.getString("Email");
            } else {
                out.print("<p>Manager not found.</p>");
                return;
            }

            // Step 1: Update manager information
            ps = connection.prepareStatement("UPDATE Managers SET ManagerName = ?, Password = ?, Email = ?, PhoneNumber = ? WHERE ManagerID = ?");
            ps.setString(1, updatedName);
            ps.setString(2, updatedPassword);
            ps.setString(3, updatedEmail);
            ps.setString(4, updatedPhoneNumber);
            ps.setInt(5, managerId);

            int rowsUpdated = ps.executeUpdate();

            if (rowsUpdated > 0) {
                // Step 2: Check if the email has changed and update related tables
                if (currentEmail != null && !updatedEmail.equals(currentEmail)) {
                    // Update email in the Movies table
                    ps = connection.prepareStatement("UPDATE Movies SET manager_email = ? WHERE manager_email = ?");
                    ps.setString(1, updatedEmail);
                    ps.setString(2, currentEmail);
                    ps.executeUpdate();

                    // Update email in the Theaters table
                    ps = connection.prepareStatement("UPDATE Theaters SET manager_email = ? WHERE manager_email = ?");
                    ps.setString(1, updatedEmail);
                    ps.setString(2, currentEmail);
                    ps.executeUpdate();
                }

                connection.commit(); // Commit the transaction if everything is successful
                %>
                <script>
                alert('Manager Updated Successfully...');
                window.location.href = 'Profile.jsp';
                </script>
                <%
            } else {
                connection.rollback(); // Rollback if update fails
                out.print("<p>Failed to update manager.</p>");
            }
        } catch (Exception e) {
            try {
                if (connection != null) {
                    connection.rollback(); // Rollback on error
                }
            } catch (SQLException se) {
                se.printStackTrace();
            }
            out.print("<p>Error: " + e.getMessage() + "</p>");
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (connection != null) {
                    connection.setAutoCommit(true); // Reset autocommit to true
                    connection.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    %>
</body>
</html>
