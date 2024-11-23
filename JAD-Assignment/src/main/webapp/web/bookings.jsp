<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, pg.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Your Bookings</title>
    <link rel="stylesheet" href="css/services.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
</head>
<body>

<%@ include file="components/navbar.html" %>

<div class="container mt-5">
    <h1>Your Bookings</h1>
    <p>Below are the details of your upcoming service bookings:</p>

    <%
        // Get the user email from the session or redirect to login page if not found
        String userEmail = (String) session.getAttribute("userEmail");
        if (userEmail == null || userEmail.isEmpty()) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Using the Config class to get the PostgreSQL database connection
        Config neon = new Config();
        String url = neon.getConnectionUrl();
        String username = neon.getUser();
        String password = neon.getPassword();

        try {
            // Connect to the database
            Class.forName("org.postgresql.Driver");
            Connection connection = DriverManager.getConnection(url, username, password);

            // Query to get all bookings for the user
            String sql = "SELECT service_type, customer_name, email, phone, date, time FROM bookings WHERE email = ?";
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setString(1, userEmail);  // Use the session user email to filter bookings
            ResultSet resultSet = statement.executeQuery();

            // Display the bookings in a table
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

            // Close resources
            resultSet.close();
            statement.close();
            connection.close();
        } catch (Exception e) {
            out.println("<div class='alert alert-danger mt-4'>Error: " + e.getMessage() + "</div>");
        }
    %>

</div>

	<%@ include file="components/footer.html" %>
</body>
</html>
