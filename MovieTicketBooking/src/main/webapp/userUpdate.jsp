<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ page import="java.sql.*" %>
<%@page import="controller.DB_Connection"%>
<%@ page import="java.security.MessageDigest" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Update Profile</title>
</head>
<body>
<%
    String email = request.getParameter("hiddenEmail");
    String newUsername = request.getParameter("username");
    String newPhone = request.getParameter("phone");
    String newPassword = request.getParameter("password");

    if (newUsername != null && newPhone != null && newPassword != null && email != null) {
        try (
            Connection conn = new DB_Connection().get_Connection();
            PreparedStatement pstmt = conn.prepareStatement("UPDATE Users SET Username = ?, Phone = ?, PasswordHash = ? WHERE Email = ?")
        ) {
            // Hash the new password
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hashedBytes = md.digest(newPassword.getBytes("UTF-8"));
            StringBuilder enteredHash = new StringBuilder();
            for (byte b : hashedBytes) {
                enteredHash.append(String.format("%02x", b));
            }

            // Update the database with the new details
            pstmt.setString(1, newUsername);
            pstmt.setString(2, newPhone);
            pstmt.setString(3, enteredHash.toString());
            pstmt.setString(4, email);
            int rowsUpdated = pstmt.executeUpdate();

            if (rowsUpdated > 0) {
                // Update session attributes
                session.setAttribute("userName", newUsername);
                out.println("<script>alert('Profile updated successfully!');</script>");
                out.println("<form id='redirectForm' action='userRegisterAction.jsp' method='post'>");
                out.println("<input type='hidden' name='email' value='" + email + "'>");
                out.println("<input type='hidden' name='password' value='" + newPassword + "'>");
                out.println("</form>");
                out.println("<script>document.getElementById('redirectForm').submit();</script>");
            } else {
                out.println("<script>alert('Failed to update profile. Please try again.');</script>");
                out.println("<form id='redirectForm' action='userRegisterAction.jsp' method='post'>");
                out.println("<input type='hidden' name='email' value='" + email + "'>");
                out.println("<input type='hidden' name='password' value='" + newPassword + "'>");
                out.println("</form>");
                out.println("<script>document.getElementById('redirectForm').submit();</script>");
            }
        } catch (Exception e) {
            out.println("<p>Error: " + e.getMessage() + "</p>");
        }
    } else {
%>
<script>
    alert("Invalid Email or Password. Please try again!");
    window.location.href = "userRegister.jsp";
</script>
<%
    }
%>
</body>
</html>
