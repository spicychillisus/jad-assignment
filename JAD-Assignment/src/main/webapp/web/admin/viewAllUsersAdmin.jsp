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
        <h1 class="text-center">All Users</h1>
        <p class="text-center">This is where you can view all users and their details.</p>
        <div class="row">
            <div class="col">
                <table class="table table-striped">
                    <thead>
                    	<tr>
                            <th scope="col">id</th>
                            <th scope="col">Name</th>
                            <th scope="col">Country Code</th>
                            <th scope="col">Phone Number</th>
                            <th scope="col">Email</th>
                            <th scope="col">Registered On</th>
                            <th scope="col">Role</th>
                        </tr>
                    </thead>
                    <%
						Config neon = new Config();
						String url = neon.getConnectionUrl();
						String username = neon.getUser();
						String password = neon.getPassword();
						
						try {
						    Class.forName("org.postgresql.Driver");
						    Connection connection = DriverManager.getConnection(url, username, password);
						
						    // Fetch services from the database
						    String sql = "SELECT * FROM users";
						    PreparedStatement statement = connection.prepareStatement(sql);
						    ResultSet resultSet = statement.executeQuery();
						
						    while (resultSet.next()) {
						        int serviceId = resultSet.getInt("id");
						        String name = resultSet.getString("name");
						        String countryCode = resultSet.getString("country_code");
						        int phoneNum = resultSet.getInt("phone_number");
						        String email = resultSet.getString("email");
						        String created_at = resultSet.getString("created_at");
						        String role = resultSet.getString("role");
					%>
					
                        
                    <tbody>
                        <tr>
                            <th scope="row">1</th>
                            <td><%= name %></td>
                            <td><%= countryCode %></td>
                            <td><%= phoneNum %></td>
                            <td><%= email %></td>
                            <td><%= created_at %></td>
                            <td><%= role %></td>
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