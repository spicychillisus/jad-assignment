<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>View All Services</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css">
</head>
<body>
<%@ include file="../components/admin-navbar.html" %>
<%@ page import="java.sql.*, java.util.*, admin.*, pg.*, services.*" %>
<div class="container">
    <h1 class="text-center">All Services</h1>
    <p class="text-center">You have the power to either edit the service or delete it. You could even add a new one. Your choice.</p>
    <a href="addServiceForm.jsp" class="mt-4"><button class="btn btn-success">Add New Service</button></a>
    
    <!-- Search Bar -->
    <form method="get" action="">
        <div class="row mt-4 mb-4">
            <div class="col-md-10">
                <input type="text" name="searchQuery" class="form-control" placeholder="Search by name or description" value="<%= request.getParameter("searchQuery") != null ? request.getParameter("searchQuery") : "" %>">
            </div>
            <div class="col-md-2">
                <button type="submit" class="btn btn-primary w-100">Search</button>
            </div>
        </div>
    </form>
    
    <div class="row">
        <div class="col">
            <table class="table table-striped">
                <thead>
                    <tr>
                        <th scope="col">ID</th>
                        <th scope="col">Name</th>
                        <th scope="col">Description</th>
                        <th scope="col">Price</th>
                        <th scope="col">Actions</th>
                    </tr>
                </thead>
                <tbody>
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
                            
                            // Get the search query parameter
                            String searchQuery = request.getParameter("searchQuery");
                            String sql = "SELECT * FROM services";
                            if (searchQuery != null && !searchQuery.isEmpty()) {
                                sql += " WHERE servicetitle ILIKE ? OR servicedescription ILIKE ?";
                            }
                            
                            PreparedStatement statement = connection.prepareStatement(sql);
                            if (searchQuery != null && !searchQuery.isEmpty()) {
                                statement.setString(1, "%" + searchQuery + "%");
                                statement.setString(2, "%" + searchQuery + "%");
                            }
                            
                            ResultSet resultSet = statement.executeQuery();
                            
                            while (resultSet.next()) {
                                int id = resultSet.getInt("id");
                                String serviceTitle = resultSet.getString("servicetitle");
                                String serviceDescription = resultSet.getString("servicedescription");
                                double price = resultSet.getDouble("price");
                    %>
                    <tr>
                        <th scope="row"><%= id %></th>
                        <td><%= serviceTitle %></td>
                        <td><%= serviceDescription %></td>
                        <td><%= price %></td>
                        <td>
                            <a href="editService.jsp?serviceId=<%=id%>" class="btn btn-primary">Edit</a>
                        </td>
                        <td><a href="deleteService.jsp?serviceId=<%=id%>" class="btn btn-danger">Delete</a></td>
                    </tr>
                    <%    
                            }
                            
                            statement.close();
                            connection.close();
                        } catch (Exception e) {
                            out.println("<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>");
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>
</div>
</body>
</html>
