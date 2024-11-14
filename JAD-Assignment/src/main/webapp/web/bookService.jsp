<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Book Cleaning Service</title>
    <link rel="stylesheet" href="css/services.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
</head>
<body>

<%@ include file="components/navbar.html" %>

<div class="container mt-5">
    <h1>Book a Cleaning Service</h1>
    <p>Fill out the form below to book a service</p>

    <!-- Booking Form -->
    <form action="bookService.jsp" method="post" class="mt-3">
        <div class="mb-3">
            <label for="serviceType" class="form-label">Service Type</label>
            <input type="text" id="serviceType" name="serviceType" class="form-control" value="<%= request.getParameter("service") %>" readonly>
        </div>

        <div class="mb-3">
            <label for="name" class="form-label">Your Name</label>
            <input type="text" id="name" name="name" class="form-control" required>
        </div>

        <div class="mb-3">
            <label for="email" class="form-label">Email Address</label>
            <input type="email" id="email" name="email" class="form-control" required>
        </div>

        <div class="mb-3">
            <label for="phone" class="form-label">Phone Number</label>
            <input type="tel" id="phone" name="phone" class="form-control" required>
        </div>

        <div class="mb-3">
            <label for="date" class="form-label">Preferred Date</label>
            <input type="date" id="date" name="date" class="form-control" required>
        </div>

        <div class="mb-3">
            <label for="time" class="form-label">Preferred Time</label>
            <input type="time" id="time" name="time" class="form-control" required>
        </div>

        <button type="submit" class="btn btn-primary">Submit Booking</button>
    </form>

    <!-- Confirmation message -->
    <%
        // Database connection details
        String dbURL = "jdbc:mysql://localhost:3306/yourDatabaseName";
        String dbUser = "yourUsername";
        String dbPassword = "yourPassword";

        if (request.getMethod().equalsIgnoreCase("POST")) {
            String serviceType = request.getParameter("serviceType");
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String date = request.getParameter("date");
            String time = request.getParameter("time");

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection connection = DriverManager.getConnection(dbURL, dbUser, dbPassword);

                String sql = "INSERT INTO bookings (service_type, customer_name, email, phone, date, time) VALUES (?, ?, ?, ?, ?, ?)";
                PreparedStatement statement = connection.prepareStatement(sql);
                statement.setString(1, serviceType);
                statement.setString(2, name);
                statement.setString(3, email);
                statement.setString(4, phone);
                statement.setString(5, date);
                statement.setString(6, time);

                int rowsInserted = statement.executeUpdate();
                if (rowsInserted > 0) {
                    out.println("<div class='alert alert-success mt-4'>Thank you, your booking has been submitted successfully!</div>");
                } else {
                    out.println("<div class='alert alert-danger mt-4'>Sorry, there was an error processing your booking.</div>");
                }

                statement.close();
                connection.close();
            } catch (Exception e) {
                out.println("<div class='alert alert-danger mt-4'>Error: " + e.getMessage() + "</div>");
            }
        }
    %>
</div>

</body>
</html>
