<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, pg.*, services.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add Service</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
</head>
<body>
<%@ include file="components/navbar.html" %>

<%
    // Ensure the user is an admin
    if (session.getAttribute("adminRole") == null || !session.getAttribute("adminRole").equals("Admin")) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Process form submission for adding a new service
    String message = "";
    String serviceTitle = request.getParameter("serviceTitle");
    String serviceDescription = request.getParameter("serviceDescription");
    String servicePrice = request.getParameter("servicePrice");

    if (serviceTitle != null && serviceDescription != null && servicePrice != null) {
        try {
            Config neon = new Config();
            String url = neon.getConnectionUrl();
            String username = neon.getUser();
            String password = neon.getPassword();

            Class.forName("org.postgresql.Driver");
            Connection connection = DriverManager.getConnection(url, username, password);

            String sql = "INSERT INTO services (servicetitle, servicedescription, price) VALUES (?, ?, ?)";
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setString(1, serviceTitle);
            statement.setString(2, serviceDescription);
            statement.setDouble(3, Double.parseDouble(servicePrice));

            int rowsAffected = statement.executeUpdate();
            if (rowsAffected > 0) {
                message = "<div class='alert alert-success'>Service added successfully.</div>";
            } else {
                message = "<div class='alert alert-danger'>Failed to add service. Please try again.</div>";
            }

            statement.close();
            connection.close();
        } catch (Exception e) {
            message = "<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>";
        }
    }
%>


<%@ include file="components/footer.html" %>
</body>
</html>
