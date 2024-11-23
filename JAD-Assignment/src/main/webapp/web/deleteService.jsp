<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, pg.*, services.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Delete Service</title>
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

    // Get serviceId from URL and delete the service
    String serviceId = request.getParameter("serviceId");
    if (serviceId != null && !serviceId.isEmpty()) {
        try {
            Config neon = new Config();
            String url = neon.getConnectionUrl();
            String username = neon.getUser();
            String password = neon.getPassword();

            Class.forName("org.postgresql.Driver");
            Connection connection = DriverManager.getConnection(url, username, password);

            String sql = "DELETE FROM services WHERE id = ?";
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setInt(1, Integer.parseInt(serviceId));

            int rowsAffected = statement.executeUpdate();
            if (rowsAffected > 0) {
                out.println("<div class='alert alert-success'>Service deleted successfully.</div>");
            } else {
                out.println("<div class='alert alert-danger'>Failed to delete service.</div>");
            }

            statement.close();
            connection.close();
        } catch (Exception e) {
            out.println("<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>");
        }
    }
%>

<%@ include file="components/footer.html" %>
</body>
</html>
