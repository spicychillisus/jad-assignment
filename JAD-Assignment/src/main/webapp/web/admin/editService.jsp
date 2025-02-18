<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, pg.*, services.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Service</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
</head>
<body>
<%@ include file="../components/navbar.html" %>

<%
    // Ensure the user is an admin
    if (session.getAttribute("adminRole") == null || !session.getAttribute("adminRole").equals("Admin")) {
        response.sendRedirect("../login.jsp");
        return;
    }

    // Fetch service ID from URL parameter
    String serviceId = request.getParameter("serviceId");
    if (serviceId == null || serviceId.isEmpty()) {
        out.println("<div class='alert alert-danger'>Service not found!</div>");
        return;
    }

    String message = "";
    Service service = null; // Declare service outside try block

    // Fetch service data from the database
    try {
        Config neon = new Config();
        String url = neon.getConnectionUrl();
        String username = neon.getUser();
        String password = neon.getPassword();

        Class.forName("org.postgresql.Driver");
        Connection connection = DriverManager.getConnection(url, username, password);

        String sql = "SELECT * FROM services WHERE serviceid = ?";
        PreparedStatement statement = connection.prepareStatement(sql);
        statement.setInt(1, Integer.parseInt(serviceId));

        ResultSet resultSet = statement.executeQuery();

        if (resultSet.next()) {
            service = new Service(
                resultSet.getInt("serviceid"), // Ensure this matches your DB column name
                resultSet.getString("servicetitle"),
                resultSet.getString("servicedescription"),
                resultSet.getDouble("price"),
                resultSet.getString("category"),
                resultSet.getDouble("rating"),
                resultSet.getInt("demand")
            );
        } else {
            message = "<div class='alert alert-danger'>Service not found!</div>";
        }

        statement.close();
        connection.close();
    } catch (Exception e) {
        message = "<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>";
    }

    // Process the form submission to update service
    if (service != null && request.getMethod().equalsIgnoreCase("POST")) {
        String serviceTitle = request.getParameter("serviceTitle");
        String serviceDescription = request.getParameter("serviceDescription");
        String servicePrice = request.getParameter("servicePrice");

        try {
            Config neon = new Config();
            String url = neon.getConnectionUrl();
            String username = neon.getUser();
            String password = neon.getPassword();

            Class.forName("org.postgresql.Driver");
            Connection connection = DriverManager.getConnection(url, username, password);

            String updateSql = "UPDATE services SET servicetitle = ?, servicedescription = ?, price = ? WHERE serviceid = ?";
            PreparedStatement updateStatement = connection.prepareStatement(updateSql);
            updateStatement.setString(1, serviceTitle);
            updateStatement.setString(2, serviceDescription);
            updateStatement.setDouble(3, Double.parseDouble(servicePrice));
            updateStatement.setInt(4, service.getServiceid());

            int rowsAffected = updateStatement.executeUpdate();
            if (rowsAffected > 0) {
                message = "<div class='alert alert-success'>Service updated successfully.</div>";
                // Re-fetch the updated service data
                service.setServicetitle(serviceTitle);
                service.setServicedescription(serviceDescription);
                service.setPrice(Double.parseDouble(servicePrice));
            } else {
                message = "<div class='alert alert-danger'>Failed to update service.</div>";
            }

            updateStatement.close();
            connection.close();
        } catch (Exception e) {
            message = "<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>";
        }
    }
%>

<div class="container mt-5">
    <h1>Edit Service</h1>
    <%= message %>

    <% if (service != null) { %>
        <form action="editService.jsp?serviceId=<%= serviceId %>" method="POST">
            <input type="hidden" name="serviceId" value="<%= service.getServiceid() %>">
            
            <div class="mb-3">
                <label for="serviceTitle" class="form-label">Service Title</label>
                <input type="text" class="form-control" id="serviceTitle" name="serviceTitle" value="<%= service.getServicetitle() %>" required>
            </div>
            <div class="mb-3">
                <label for="serviceDescription" class="form-label">Service Description</label>
                <textarea class="form-control" id="serviceDescription" name="serviceDescription" required><%= service.getServicedescription() %></textarea>
            </div>
            <div class="mb-3">
                <label for="servicePrice" class="form-label">Price</label>
                <input type="number" class="form-control" id="servicePrice" name="servicePrice" value="<%= service.getPrice() %>" required>
            </div>
            <button type="submit" class="btn btn-success">Save Changes</button>
        </form>
    <% } else { %>
        <div class="alert alert-danger">Service not found.</div>
    <% } %>
</div>

<%@ include file="../components/footer.html" %>
</body>
</html>