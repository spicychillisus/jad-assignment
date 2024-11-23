<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard - Edit Services</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
</head>
<body>
<%@ include file="../components/admin-navbar.html" %>
<%@ page import="java.sql.*, java.util.*, admin.*, pg.*, services.*" %>

<%
    // Ensure the user is an admin
    if (session.getAttribute("adminRole") == null || !session.getAttribute("adminRole").equals("Admin")) {
        response.sendRedirect("../login.jsp");
        return; // Stop further processing if not logged in as admin
    }
%>

<div class="container mt-5">
    <h1 class="text-center">Admin Dashboard</h1>
    <p class="text-center">
        This is where you monitor what services there are, and view user's feedback.
    </p>
    <div class="row">
        <h3 class="text-center">Based on CleanEase's statistics, there are:</h3>
        <%
                    
	                 // Ensure the user is an admin
	                    if (session.getAttribute("adminRole") == null || !session.getAttribute("adminRole").equals("Admin")) {
	                        response.sendRedirect("../login.jsp");
	                        return; // Stop further processing if not logged in as admin
	                    }
						Config neon = new Config();
						String url = neon.getConnectionUrl();
						String username = neon.getUser();
						String password = neon.getPassword();
						
						Connection con = null;
					    Statement stmt = null;
					    ResultSet rs = null;
						
						try {
					        // Create a connection to the database
					        Class.forName("org.postgresql.Driver");
					        con = DriverManager.getConnection(url, username, password);
					        stmt = con.createStatement();

					        // Count services
					        rs = stmt.executeQuery("SELECT COUNT(*) FROM services");
					        rs.next();
					        int serviceCount = rs.getInt(1);

					        // Count bookings
					        rs = stmt.executeQuery("SELECT COUNT(*) FROM bookings");
					        rs.next();
					        int bookingCount = rs.getInt(1);

					        // Count users
					        rs = stmt.executeQuery("SELECT COUNT(*) FROM users");
					        rs.next();
					        int userCount = rs.getInt(1);

					        // Count feedback
					        rs = stmt.executeQuery("SELECT COUNT(*) FROM feedback");
					        rs.next();
					        int feedbackCount = rs.getInt(1);
					%>  
					
        <!-- services -->
    	<div class="col">
            <div class="card">
                <div class="card-body text-center">
                    <h5 class="card-title">
                        <%= serviceCount %>
                    </h5>
                    <p>Services</p>
                    <a href="viewAllServicesAdmin.jsp">
                        <button class="btn btn-primary mt-2">View All</button>
                    </a>
                </div>
            </div>
    	</div>
        <!-- bookings -->
        <div class="col">
            <div class="card">
                <div class="card-body text-center">
                    <h5 class="card-title">
                        <%= bookingCount %>
                    </h5>
                    <p>Bookings</p>
                    <a href="viewAllBookings.jsp">
                        <button class="btn btn-primary mt-2">View All</button>
                    </a>
                </div>
                
            </div>
    	</div>
        <!-- users -->
        <div class="col">
            <div class="card">
                <div class="card-body text-center">
                    <h5 class="card-title">
                        <%= userCount %>
                    </h5>
                    <p>Users</p>
                    <a href="viewAllUsersAdmin.jsp">
                        <button class="btn btn-primary mt-2">View All</button>
                    </a>
                    
                </div>
            </div>
    	</div>
        <div class="col">
            <div class="card">
                <div class="card-body text-center">
                    <h5 class="card-title">
                        <%= feedbackCount %>
                    </h5>
                    <p>feedbacks</p>
                    <a href="viewAllFeedback.jsp">
                        <button class="btn btn-primary mt-2">View All</button>
                    </a>
                </div>
            </div>
    	</div>
    	<%      
					
					    } catch (SQLException e) {
					        e.printStackTrace();
					    }
						
						 	
					%>
    </div>
</div>


<%@ include file="../components/admin-footer.html" %>
</body>
</html>
