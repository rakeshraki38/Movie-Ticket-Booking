<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Login Result</title>
    <style>
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

        .result-container {
            background-color: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            width: 350px;
            text-align: center;
        }

        h2 {
            color: #333;
        }

        p {
            color: #666;
            font-size: 16px;
        }

        .btn {
            display: inline-block;
            margin-top: 10px;
            padding: 10px 20px;
            background-color: #4CAF50;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            font-size: 16px;
        }

        .btn:hover {
            background-color: #45a049;
        }

        .error {
            color: #ff4c4c;
            font-weight: bold;
        }
    </style>
    
</head>
<body>

    <div class="result-container">
        <%
            String adminname = request.getParameter("adminname");
            String password = request.getParameter("password");
            
            // Hardcoded credentials for demonstration purposes
            String correctAdminname = "admin123";
            String correctPassword = "password123";

            if (adminname != null & password != null) {
                if (adminname.equals(correctAdminname) && password.equals(correctPassword)) {
                    // Create a session and store the adminname
			
    		// Check if a session already exists, otherwise create a new one
    		//HttpSession session = request.getSession(true);

    		// Set an attribute in the session
    		session.setAttribute("adminname", adminname);

    		// You can also set session timeout if needed
    		session.setMaxInactiveInterval(500); // Time in seconds 


        %>
        <script>
            // Show an alert popup
            alert("Login Successfull!!!");

            // Redirect to adminLogin.jsp after closing the popup
            window.location.href = "Profile.jsp";
        </script>
        <%
        	
                } else {
        %>
        <script>
            // Show an alert popup
            alert("Login Failed: Invalid admin name or password. You will be redirected to the login page.");

            // Redirect to adminLogin.jsp after closing the popup
            window.location.href = "adminLogin.jsp";
        </script>
        <%
                }
            } else {
        %>
                <h2 class="error">Invalid credentials</h2>
                <p class="error">Please provide both Adminname and password.</p>
                <p><a href="adminLogin.jsp" class="btn">Go to Login</a></p>
        <%
            }
        %>
    </div>

</body>
</html>
