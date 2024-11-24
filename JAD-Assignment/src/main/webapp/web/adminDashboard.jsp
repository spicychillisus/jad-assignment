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
<%@ page import="java.sql.*, admin.*, pg.*" %>

<%
    // Ensure the user is an admin
    if (session.getAttribute("adminRole") == null || !session.getAttribute("adminRole").equals("Admin")) {
        response.sendRedirect("login.jsp");
        return; // Stop further processing if not logged in as admin
    }
%>

<div class="container mt-5">
    <h1>Admin Dashboard</h1>
    <hr>

    <!-- Section to display all bookings -->
    <h3>All Bookings</h3>
    <%
        try {
            // Initialize Config and database connection details for bookings
            Config neon = new Config();
            String url = neon.getConnectionUrl();
            String username = neon.getUser();
            String password = neon.getPassword();

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
            connection.close();
        } catch (Exception e) {
            out.println("<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>");
        }
    %>
    <hr>

    <!-- Section to display all feedbacks -->
    <h3>All Feedbacks</h3>
    <%
        try {
            // Reinitialize Config and database connection details for feedback
            Config neon = new Config();
            String url = neon.getConnectionUrl();
            String username = neon.getUser();
            String password = neon.getPassword();

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
