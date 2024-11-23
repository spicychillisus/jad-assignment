<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard - Edit Services</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
</head>
<body>
<%@ include file="components/admin-navbar.html" %>
<%@ page import="java.sql.*, java.util.*, admin.*, pg.*, services.*" %>

<%
    // Ensure the user is an admin
    if (session.getAttribute("adminRole") == null || !session.getAttribute("adminRole").equals("Admin")) {
        response.sendRedirect("login.jsp");
        return; // Stop further processing if not logged in as admin
    }
%>

<div class="container mt-5">
    <h1 class="text-center">Admin Dashboard</h1>
    <p>
    This is where you monitor what services there are, and view user's feedback.
    </p>

    <div class="row">
    	<div class="col">
    	
    	</div>
    	<div class="col">
    	
    	</div>
    </div>

    <hr>

    <!-- Section to display existing services -->
    <h3>Existing Services</h3>
    <%
        // Fetch the list of services (if available)
        Config neon = new Config();
        String url = neon.getConnectionUrl();
        String username = neon.getUser();
        String password = neon.getPassword();

        try {
            Class.forName("org.postgresql.Driver");
            Connection connection = DriverManager.getConnection(url, username, password);

            // Fetch services from the database
            String sql = "SELECT * FROM services";
            PreparedStatement statement = connection.prepareStatement(sql);
            ResultSet resultSet = statement.executeQuery();

            while (resultSet.next()) {
                int serviceId = resultSet.getInt("id");
                String serviceTitle = resultSet.getString("servicetitle");
                String serviceDescription = resultSet.getString("servicedescription");
                double servicePrice = resultSet.getDouble("price");

                out.println("<div class='service-item mb-4'>");
                out.println("<h4>" + serviceTitle + "</h4>");
                out.println("<p>" + serviceDescription + "</p>");
                out.println("<p><strong>Price: $" + servicePrice + "</strong></p>");
                out.println("<a href='editService.jsp?serviceId=" + serviceId + "' class='btn btn-primary'>Edit Service</a>");
                out.println("<a href='deleteService.jsp?serviceId=" + serviceId + "' class='btn btn-danger'>Delete Service</a>");
                out.println("</div>");
            }

            statement.close();
            connection.close();
        } catch (Exception e) {
            out.println("<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>");
        }
    %>

    <hr>

    <!-- Section to display all bookings -->
    <h3>All Bookings</h3>
    <%
        try {
            Class.forName("org.postgresql.Driver");
            Connection connection = DriverManager.getConnection(url, username, password);

            String sql = "SELECT service_type, customer_name, email, phone, date, time FROM bookings ORDER BY date, time";
            PreparedStatement statement = connection.prepareStatement(sql);
            ResultSet resultSet = statement.executeQuery();

            if (resultSet.next()) {
    %>
    <table class="table mt-4">
        <thead>
            <tr>
                <th>Service Type</th>
                <th>Customer Name</th>
                <th>Email</th>
                <th>Phone</th>
                <th>Date</th>
                <th>Time</th>
            </tr>
        </thead>
        <tbody>
    <%
                do {
    %>
            <tr>
                <td><%= resultSet.getString("service_type") %></td>
                <td><%= resultSet.getString("customer_name") %></td>
                <td><%= resultSet.getString("email") %></td>
                <td><%= resultSet.getString("phone") %></td>
                <td><%= resultSet.getDate("date") %></td>
                <td><%= resultSet.getTime("time") %></td>
            </tr>
    <%
                } while (resultSet.next());
    %>
        </tbody>
    </table>
    <%
            } else {
                out.println("<p>No bookings found.</p>");
            }

            resultSet.close();
            statement.close();
        } catch (Exception e) {
            out.println("<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>");
        }
    %>

    <hr>

    <!-- Section to display all feedbacks -->
    <h3>All Feedbacks</h3>
    <%
        try {
            Class.forName("org.postgresql.Driver");
            Connection connection = DriverManager.getConnection(url, username, password);

            String sql = "SELECT id, name, email, subject, message, rating, created_at FROM feedback ORDER BY created_at DESC";
            PreparedStatement statement = connection.prepareStatement(sql);
            ResultSet resultSet = statement.executeQuery();

            if (resultSet.next()) {
    %>
    <table class="table mt-4">
        <thead>
            <tr>
                <th>ID</th>
                <th>Name</th>
                <th>Email</th>
                <th>Subject</th>
                <th>Message</th>
                <th>Rating</th>
                <th>Created At</th>
            </tr>
        </thead>
        <tbody>
    <%
                do {
    %>
            <tr>
                <td><%= resultSet.getInt("id") %></td>
                <td><%= resultSet.getString("name") %></td>
                <td><%= resultSet.getString("email") %></td>
                <td><%= resultSet.getString("subject") %></td>
                <td><%= resultSet.getString("message") %></td>
                <td><%= resultSet.getInt("rating") %></td>
                <td><%= resultSet.getTimestamp("created_at") %></td>
            </tr>
    <%
                } while (resultSet.next());
    %>
        </tbody>
    </table>
    <%
            } else {
                out.println("<p>No feedbacks found.</p>");
            }

            resultSet.close();
            statement.close();
            connection.close();
        } catch (Exception e) {
            out.println("<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>");
        }
    %>

</div>

<%@ include file="components/footer.html" %>
</body>
</html>
