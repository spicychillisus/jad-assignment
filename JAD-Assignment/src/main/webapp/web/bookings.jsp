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
    session.removeAttribute("discountCode");
	session.removeAttribute("discountValue");
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

            Class.forName("org.postgresql.Driver");
            Connection connection = DriverManager.getConnection(url, username, password);

            // Modify the query to include the 'status' field and handle nulls by setting default 'Pending'
            String sql = "SELECT id, service_type, customer_name, email, phone, date, time, COALESCE(status, 'Pending') AS status FROM bookings WHERE email = ?";
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setString(1, userEmail);
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

                <th>Payment Status</th>


                <th>Status</th>
                <th>Actions</th>


            </tr>
        </thead>
        <tbody>
    <%
                do {

                    int bookingId = resultSet.getInt("id");
                    String status = resultSet.getString("status"); // Status will be "Pending" if null

    %>
            <tr>
                <td><%= resultSet.getString("service_type") %></td>
                <td><%= resultSet.getString("customer_name") %></td>
                <td><%= resultSet.getString("email") %></td>
                <td><%= resultSet.getString("phone") %></td>
                <td><%= resultSet.getDate("date") %></td>
                <td><%= resultSet.getTime("time") %></td>

                <td>
                	<div class="btn btn-outline-success user-select-none">
                		<span>Paid</span>
                	</div>
                </td>


                <td>
                    <%= status %>  <!-- Display the current status (or 'Pending' if null) -->
                </td>
                <td>
                    <a href="updateBooking.jsp?id=<%= bookingId %>" class="btn btn-warning btn-sm">Update</a>
                    <a href="cancelBooking.jsp?id=<%= bookingId %>" class="btn btn-danger btn-sm">Cancel</a>
                </td>

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
