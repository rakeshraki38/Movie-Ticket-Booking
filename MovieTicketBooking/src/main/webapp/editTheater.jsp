<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="controller.DB_Connection"%>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
    <title>Edit Theater</title>
    <style>
        /* General body styling */
        body {
            font-family: Arial, sans-serif;
            background-color: #f0f4f8;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }

        /* Container for form */
        .form-container {
            background-color: #ffffff;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            width: 400px;
        }

        /* Form title */
        h1 {
            text-align: center;
            color: #333;
            margin-bottom: 20px;
        }

        /* Form labels */
        label {
            display: block;
            margin-bottom: 8px;
            color: #555;
            font-weight: bold;
        }

        /* Input fields */
        input[type="text"] {
            width: 100%;
            padding: 10px;
            margin-bottom: 15px;
            border: 1px solid #ccc;
            border-radius: 4px;
            font-size: 14px;
            background-color: #f9f9f9;
            transition: border-color 0.3s ease;
        }

        /* Input focus effect */
        input[type="text"]:focus {
            border-color: #4CAF50;
            outline: none;
        }

        /* Submit button */
        button {
            width: 100%;
            padding: 12px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 4px;
            font-size: 16px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        /* Button hover effect */
        button:hover {
            background-color: #45a049;
        }

        /* Alert message styling */
        .alert {
            text-align: center;
            color: red;
            margin-bottom: 15px;
        }
    </style>
</head>
<body>
    <%
        // Fetch theater name from request
        String theaterName = request.getParameter("theaterName");
        String location = request.getParameter("location");
        String email = (String) session.getAttribute("email"); // Manager name from session

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        

    %>

    <div class="form-container">
        <h1>Edit Theater</h1>
        <form action="updateTheater.jsp" method="post">
            <input type="hidden" name="originalTheaterName" value="<%= theaterName %>">
			 <input type="hidden" name="originallocation" value="<%= location %>">
            <label for="theaterName">Theater Name:</label>
            <input type="text" id="theaterName" name="theaterName" value="<%= theaterName %>" required>

            <label for="location">Location:</label>
            <input type="text" id="location" name="location" value="<%= location %>" required>

            <button type="submit">Update Theater</button>
        </form>
    </div>
</body>
</html>
