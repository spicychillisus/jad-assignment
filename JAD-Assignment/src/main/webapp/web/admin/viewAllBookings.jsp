<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%@ include file="../components/admin-navbar.html" %>
<%@ page import="java.sql.*, java.util.*, admin.*, pg.*, services.*" %>

<div class="container">
        <h1 class="text-center">All Bookings</h1>
        <p class="text-center">All the bookings everyone has made, all can be seen here.</p>
        <div class="row">
            <div class="col">
                <table class="table table-striped">
                    <thead>
                    	<tr>
                            <th scope="col">id</th>
                            <th scope="col">Service</th>
                            <th scope="col">User</th>
                            <th scope="col">Email</th>
                            <th scope="col">Phone Number</th>
                            <th scope="col">Booked On</th>
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
						
						try {
						    Class.forName("org.postgresql.Driver");
						    Connection connection = DriverManager.getConnection(url, username, password);
						
						    // Fetch services from the database
						    String sql = "SELECT * FROM bookings";
						    PreparedStatement statement = connection.prepareStatement(sql);
						    ResultSet resultSet = statement.executeQuery();
						    %>
						    <%
						 
						    while (resultSet.next()) {
						        int id = resultSet.getInt("id");
						        String service_type = resultSet.getString("service_type");
						        String customer_name = resultSet.getString("customer_name");
						        String email = resultSet.getString("email");
						        int phone = resultSet.getInt("phone");
						        String date = resultSet.getString("date");
					%>
					
                        
                    <tbody>
                        <tr>
                            <th scope="row"><%= id %></th>
                            <td><%= service_type %></td>
                            <td><%= customer_name %></td>
                            <td><%= phone %></td>
                            <td><%= email %></td>
                            <td><%= phone %></td>
                            <td><%= date %></td>
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
<%@ include file="../components/admin-footer.html" %>
</body>
</html>