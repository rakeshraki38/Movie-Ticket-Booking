<%@ page import="controller.DB_Connection"%>
<%@ page import="java.util.regex.*" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Add Manager</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 50px;
        }
        form {
            max-width: 400px;
            margin: auto;
            padding: 20px;
            border: 1px solid #ccc;
            border-radius: 5px;
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
        }
        input {
            width: 100%;
            padding: 10px;
            margin: 10px 0;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        button {
            padding: 10px 15px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        button:hover {
            background-color: #45a049;
        }
        .error {
            color: red;
            font-size: 12px;
        }
        .success {
            color: green;
            font-size: 16px;
        }
    </style>
    <script>
        // Client-side validation for password and email
        function validateForm() {
            var managerName = document.getElementById("managerName").value;
            var password = document.getElementById("password").value;
            var email = document.getElementById("email").value;
            var phoneNumber = document.getElementById("phoneNumber").value;

            var passwordPattern = /^(?=.*[A-Z])(?=.*\d).{8,}$/;
            var emailPattern = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
            var phonePattern = /^\d{10}$/; // For a 10-digit phone number

            // Check if all fields are filled
            if (managerName.trim() === "" || password.trim() === "" || email.trim() === "" || phoneNumber.trim() === "") {
                alert("All fields are required.");
                return false;
            }

            // Validate password
            if (!passwordPattern.test(password)) {
                alert("Password must be at least 8 characters long, contain one uppercase letter, and one number.");
                return false;
            }

            // Validate email
            if (!emailPattern.test(email)) {
                alert("Please enter a valid email address.");
                return false;
            }

            // Validate phone number
            if (!phonePattern.test(phoneNumber)) {
                alert("Please enter a valid 10-digit phone number.");
                return false;
            }

            return true;
        }
    </script>
</head>
<body>
    <% 
        // Server-side validation
        String errorMessage = null;
        String successMessage = null;
		
        
        // Check if form was submitted
        if (request.getMethod().equalsIgnoreCase("POST")) {
            String managerName = request.getParameter("managerName");
            String password = request.getParameter("password");
            String email = request.getParameter("email");
            String phoneNumber = request.getParameter("phoneNumber");

            // Validate managerName
            if (managerName == null || managerName.trim().isEmpty()) {
                errorMessage = "Manager name cannot be empty.";
            } 
            // Validate password using regex
            else if (password == null || !Pattern.matches("^(?=.*[A-Z])(?=.*\\d).{8,}$", password)) {
                errorMessage = "Password must be at least 8 characters long, contain one uppercase letter, and one number.";
            } 
            // Validate email
            else if (email == null || !Pattern.matches("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", email)) {
                errorMessage = "Please enter a valid email address.";
            }
            // Validate phone number
            else if (phoneNumber == null || !Pattern.matches("^\\d{10}$", phoneNumber)) {
                errorMessage = "Please enter a valid 10-digit phone number.";
            } else {
                // Save to database if validation passes
                try {
                    DB_Connection obj_DB_Connection = new DB_Connection();
                    Connection connection = obj_DB_Connection.get_Connection();
                    PreparedStatement ps = null;

                    ps = connection.prepareStatement("INSERT INTO Managers (ManagerName, Password, Email, PhoneNumber) VALUES (?, ?, ?, ?)");
                    ps.setString(1, managerName);
                    ps.setString(2, password);
                    ps.setString(3, email);
                    ps.setString(4, phoneNumber);

                    int rows = ps.executeUpdate();
                    if (rows > 0) {
                    	// Renumber TheaterID in the Theaters table
                    	Statement stmt = connection.createStatement();
                        stmt.execute("SET @new_id = 0");
                        stmt.execute("UPDATE Theaters SET TheaterID = (@new_id := @new_id + 1)");
                        
                        successMessage = "Manager added successfully!";
                    } else {
                        errorMessage = "Failed to add manager.";
                    }

                    ps.close();
                    connection.close();
                } catch (Exception e) {
                    e.printStackTrace();
                    errorMessage = "An error occurred: " + e.getMessage();
                }
            }
        }
    %>

    <% if (errorMessage != null) { %>
        <p class="error"><%= errorMessage %></p>
    <% } %>

    <% if (successMessage != null) { %>
        <script>
            alert("<%= successMessage %>");
            // Redirect after success
            window.location.href = "Profile.jsp";
        </script>
    <% } %>
    <%
    	String adminname= (String) session.getAttribute("adminname");
		//out.print(adminname);
    %>

    <form method="post" onsubmit="return validateForm()">
    
        <h1 align="center">Add Manager</h1>

        <label for="managerName">Manager Name:</label>
        <input type="text" id="managerName" name="managerName" placeholder="Enter manager name" required>

        <label for="password">Password:</label>
        <input type="password" id="password" name="password" placeholder="Enter password" 
               title="Password must be at least 8 characters long, contain one uppercase letter, and one number." required>

        <label for="email">Email:</label>
        <input type="email" id="email" name="email" placeholder="Enter email" required>

        <label for="phoneNumber">Phone Number:</label>
        <input type="text" id="phoneNumber" name="phoneNumber" placeholder="Enter 10-digit phone number" required>

        <button type="submit">Add Manager</button>
    </form>
</body>
</html>
