<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.*, pg.*" %>
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
            <input type="text" id="serviceType" name="serviceType" class="form-control" value="<%= request.getParameter("service") != null ? request.getParameter("service") : "" %>" readonly>
        </div>

        <div class="mb-3">
            <label for="name" class="form-label">Your Name</label>
            <!-- Pre-fill name if the session contains a value -->
            <input type="text" id="name" name="name" class="form-control" value="<%= session.getAttribute("userName") != null ? session.getAttribute("userName") : "" %>" required>
        </div>

        <div class="mb-3">
            <label for="email" class="form-label">Email Address</label>
            <!-- Pre-fill email if the session contains a value -->
            <input type="email" id="email" name="email" class="form-control" value="<%= session.getAttribute("userEmail") != null ? session.getAttribute("userEmail") : "" %>" required>
        </div>

        <div class="mb-3">
            <label for="phone" class="form-label">Phone Number</label>
            <!-- Pre-fill phone if the session contains a value -->
            <input type="tel" id="phone" name="phone" class="form-control" value="<%= session.getAttribute("userPhone") != null ? session.getAttribute("userPhone") : "" %>" required>
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
        // Using the Config class to get the PostgreSQL database connection
        Config neon = new Config();
        String url = neon.getConnectionUrl();
        String username = neon.getUser();
        String password = neon.getPassword();

        if (request.getMethod().equalsIgnoreCase("POST")) {
            String serviceType = request.getParameter("serviceType");
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String dateStr = request.getParameter("date");
            String timeStr = request.getParameter("time");

            try {
                // Convert String date to java.sql.Date
                java.sql.Date date = java.sql.Date.valueOf(dateStr);

                // Convert String time to java.sql.Time
                java.sql.Time time = java.sql.Time.valueOf(timeStr + ":00"); // Ensure it's in HH:mm:ss format

                // Ensure using the correct PostgreSQL JDBC driver
                Class.forName("org.postgresql.Driver");
                Connection connection = DriverManager.getConnection(url, username, password);

                // Insert SQL query for booking service
                String sql = "INSERT INTO bookings (service_type, customer_name, email, phone, date, time) VALUES (?, ?, ?, ?, ?, ?)";
                PreparedStatement statement = connection.prepareStatement(sql);
                statement.setString(1, serviceType);
                statement.setString(2, name);
                statement.setString(3, email);
                statement.setString(4, phone);
                statement.setDate(5, date); // Set the date using java.sql.Date
                statement.setTime(6, time); // Set the time using java.sql.Time

                int rowsInserted = statement.executeUpdate();
                if (rowsInserted > 0) {
                    out.println("<div class='alert alert-success mt-4'>Thank you, your booking has been submitted successfully!</div>");
                } else {
                    out.println("<div class='alert alert-danger mt-4'>Sorry, there was an error processing your booking.</div>");
                }

                // Closing resources
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
