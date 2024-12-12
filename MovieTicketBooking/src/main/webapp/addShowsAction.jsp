<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="controller.DB_Connection" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.util.Date" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add Show</title>
</head>
<body>
<%
String movieTitle = request.getParameter("movieTitle");
String show_time = request.getParameter("show_time");
String theaterName = request.getParameter("theaterName");
String location = request.getParameter("location");

int movieID = Integer.parseInt(request.getParameter("movieID"));
int theaterID = Integer.parseInt(request.getParameter("theaterID"));

int screenID = 0;
String screenName = null;

try {
    String screenParam = request.getParameter("screen");
    if (screenParam != null && screenParam.contains(" | ")) {
        String[] selectedValues = screenParam.split(" \\| ");
        if (selectedValues.length == 2) {
            try {
                screenID = Integer.parseInt(selectedValues[0].trim());
                screenName = selectedValues[1].trim();
                out.print("<br>Screen ID: " + screenID + "<br>");
                out.print("Screen Name: " + screenName + "<br>");
            } catch (NumberFormatException e) {
                out.print("<p style='color:red;'>Error: Invalid Screen ID format.</p>");
            }
        } else {
            out.print("<p style='color:red;'>Error: Unexpected format for Screen parameter. Expected format: 'ScreenID | ScreenName'.</p>");
        }
    } else {
        out.print("<p style='color:red;'>Error: Invalid or missing Screen parameter.</p>");
    }
} catch (Exception e) {
    out.print("<p style='color:red;'>An unexpected error occurred: " + e.getMessage() + "</p>");
    e.printStackTrace();
}

if (show_time != null && !show_time.isEmpty() && screenID != 0 && movieID != 0 && theaterID != 0) {
	Calendar endTime = Calendar.getInstance();
    try {
        DB_Connection obj_Db_Connection = new DB_Connection();
        Connection conn = obj_Db_Connection.get_Connection();

        // Get movie duration
        String durationQuery = "SELECT Duration FROM Movies WHERE MovieID = ?";
        PreparedStatement durationStmt = conn.prepareStatement(durationQuery);
        durationStmt.setInt(1, movieID);
        ResultSet durationRs = durationStmt.executeQuery();
        int duration = 0;
        if (durationRs.next()) {
            duration = durationRs.getInt("Duration");
        }
        durationRs.close();
        durationStmt.close();

        // Validate show time against existing show times for the selected screen
        String showQuery = "SELECT ShowTime FROM Shows WHERE ScreenID = ? AND TheaterID = ?";
        PreparedStatement showStmt = conn.prepareStatement(showQuery);
        showStmt.setInt(1, screenID);
        showStmt.setInt(2, theaterID);
        ResultSet showRs = showStmt.executeQuery();

        SimpleDateFormat sdf = new SimpleDateFormat("HH:mm");
        Date newShowTime = sdf.parse(show_time);
        boolean isConflict = false;

        while (showRs.next()) {
            Date existingShowTime = sdf.parse(showRs.getString("ShowTime"));
            
            endTime.setTime(existingShowTime);
            endTime.add(Calendar.MINUTE, duration);

            if (newShowTime.before(endTime.getTime())) {
            	
                isConflict = true;
                break;
            }
        }

        if (isConflict) {
        	
        	
        %>
            <script type="text/javascript">
                alert('Error: Selected show time conflicts with an existing show. You can try scheduling the show after the duration of existing shows.');
                window.location.href = 'managerProfile.jsp';
            </script>
            <%
		} else {
            // Insert new show record
            String insertQuery = "INSERT INTO Shows (ScreenID, MovieID, TheaterID, ScreenName, ShowTime) VALUES (?,?,?,?,?)";
            PreparedStatement insertStmt = conn.prepareStatement(insertQuery);
            insertStmt.setInt(1, screenID);
            insertStmt.setInt(2, movieID);
            insertStmt.setInt(3, theaterID);
            insertStmt.setString(4, screenName);
            insertStmt.setString(5, show_time);

            int rowsAffected = insertStmt.executeUpdate();
            if (rowsAffected > 0) {
                out.print("<script type='text/javascript'>alert('Show added successfully!'); window.location.href = 'managerProfile.jsp';</script>");
            } else {
                out.print("<div style='color:red;'>Failed to add the Show. Please try again.</div>");
            }
            insertStmt.close();
        }

        showRs.close();
        showStmt.close();
        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
        out.print("<p style='color:red;'>Error occurred while validating and adding the show.</p>");
    }
} else {
    out.print("<div style='color:red;'>Please fill in all required fields correctly.</div>");
}
%>
</body>
</html>
