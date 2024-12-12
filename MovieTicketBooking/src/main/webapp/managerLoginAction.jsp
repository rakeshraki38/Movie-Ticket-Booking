<%@page import="controller.DB_Connection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.*, javax.servlet.http.*"%>
<!DOCTYPE html>
<html>
<head>
    <title>Processing Login</title>
   
</head>
<body>
 <%
		//Database connection parameters
		DB_Connection obj_DB_Connection=new DB_Connection();
 		Connection conn=obj_DB_Connection.get_Connection();
		
 		// Retrieve form data
 		String email = request.getParameter("email");
 		String managerPassword = request.getParameter("password");

 		boolean isValidUser = false; // Flag to track login success
        if (email != null && managerPassword != null) {
            
            PreparedStatement pstmt = null;
            ResultSet rs = null;

            try {

                // SQL query to verify manager credentials
                String sql = "SELECT * FROM managers WHERE Email = ? AND password = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, email);
                pstmt.setString(2, managerPassword);
				
                
                // Execute query
                rs = pstmt.executeQuery();

                if (rs.next()) {
                    isValidUser = true;
                }

            } catch (Exception e) {
                out.println("Error: " + e.getMessage());
            } finally {
                // Close resources
                try {
                    if (rs != null) rs.close();
                    if (pstmt != null) pstmt.close();
                    if (conn != null) conn.close();
                } catch (SQLException e) {
                    out.println("Error closing resources: " + e.getMessage());
                }
            }
        }
 		if(isValidUser){
 	 		HttpSession session1=request.getSession();
 	 		session1.setAttribute("email", email);
 	 		
 	 		if (email == null) {
%>
 	 			<script>
 	            // Show an alert popup
 	            alert(" You will be redirected to the login page (session has expired).");

 	            // Redirect to adminLogin.jsp after closing the popup
 	            window.location.href = "ManagerLogin.jsp";
 	        </script>
<%
 	        
 	 	    }
 	
%>
 		<script>
 		window.location.href = "managerProfile.jsp";
 		</script>
<%
 		}else{
 						
%>
 		<script>
 	// Show an alert popup
        alert("Login Failed: Invalid ManagerName or Password. Try Again!!");

 		window.location.href = "ManagerLogin.jsp";
 		</script>
 <%
 		}
 %>
 		


	
</body>
</html>

