<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>All Users</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css">
</head>
<body>
<%@ include file="../components/admin-navbar.html" %>
<%@ page import="java.sql.*, java.util.*, admin.*, pg.*, services.*" %>

<div class="container">
    <h1 class="text-center">All Users</h1>
    <p class="text-center">This is where you can view all users and their details.</p>
    
    <!-- Search Bar -->
    <form method="get">
        <div class="row mb-4">
            <div class="col-md-10">
                <input type="text" name="searchQuery" class="form-control" placeholder="Search by name or email" value="<%= request.getParameter("searchQuery") != null ? request.getParameter("searchQuery") : "" %>">
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
                        <th scope="col">Country Code</th>
                        <th scope="col">Phone Number</th>
                        <th scope="col">Email</th>
                        <th scope="col">Registered On</th>
                        <th scope="col">Role</th>
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
                            String sql = "SELECT * FROM users";
                            if (searchQuery != null && !searchQuery.isEmpty()) {
                                sql += " WHERE name ILIKE ? OR email ILIKE ?";
                            }
                            
                            PreparedStatement statement = connection.prepareStatement(sql);
                            
                            if (searchQuery != null && !searchQuery.isEmpty()) {
                                statement.setString(1, "%" + searchQuery + "%");
                                statement.setString(2, "%" + searchQuery + "%");
                            }
                            
                            ResultSet resultSet = statement.executeQuery();
                            
                            while (resultSet.next()) {
                                int id = resultSet.getInt("id");
                                String name = resultSet.getString("name");
                                String countryCode = resultSet.getString("country_code");
                                int phoneNum = resultSet.getInt("phone_number");
                                String email = resultSet.getString("email");
                                String created_at = resultSet.getString("created_at");
                                String role = resultSet.getString("role");
                    %>
                    <tr>
                        <th scope="row"><%= id %></th>
                        <td><%= name %></td>
                        <td><%= countryCode %></td>
                        <td><%= phoneNum %></td>
                        <td><%= email %></td>
                        <td><%= created_at %></td>
                        <td><%= role %></td>
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
<%@ include file="../components/admin-footer.html" %>
</body>
</html>
