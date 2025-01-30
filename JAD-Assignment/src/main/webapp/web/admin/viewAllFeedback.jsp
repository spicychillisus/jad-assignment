<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>View All Feedback</title>
</head>
<body>
<%@ include file="../components/admin-navbar.html" %>
<%@ page import="java.sql.*, java.util.*, admin.*, pg.*, services.*" %>
<div class="container">
        <h1 class="text-center">All Feedback</h1>
        <p class="text-center">See what they say about us</p>
        <div class="row">
            <div class="col">
                <table class="table table-striped">
                    <thead>
                    	<tr>
                            <th scope="col">id</th>
                            <th scope="col">Name</th>
                            <th scope="col">Email</th>
                            <th scope="col">Subject</th>
                            <th scope="col">Message</th>
                            <th scope="col">Rating</th>
                        </tr>
                    </thead>
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
						
						ArrayList<Service> services = new ArrayList<>();
						
						try {
						    Class.forName("org.postgresql.Driver");
						    Connection connection = DriverManager.getConnection(url, username, password);
						
						    // Fetch services from the database
						    String sql = "SELECT * FROM feedback ";
						    PreparedStatement statement = connection.prepareStatement(sql);
						    ResultSet resultSet = statement.executeQuery();
						
						    while (resultSet.next()) {
						        int id = resultSet.getInt("id");
						        String name = resultSet.getString("name");
						        String email = resultSet.getString("email");
						        String subject = resultSet.getString("subject");
						        String message = resultSet.getString("message");
						        int rating = resultSet.getInt("rating");
					%>
					
                        
                    <tbody>
                        <tr>
                            <th scope="row"><%= id %></th>
                            <td><%= name %></td>
                            <td><%= email %></td>
                            <td><%= subject %></td>
                            <td><%= message %></td>
                            <td><%= rating %></td>
                        </tr>
                    </tbody>
                    <%	    
						    }
						
						    statement.close();
						    connection.close();
						} catch (Exception e) {
						    out.println("<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>");
						}
					%>
                </table>
            </div>
        </div>
    </div>
</body>
</html>