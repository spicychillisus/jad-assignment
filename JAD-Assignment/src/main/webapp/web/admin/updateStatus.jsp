<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, pg.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Update Booking Status</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
</head>
<body>

<%@ include file="../components/admin-navbar.html" %>

<%
    String bookingId = request.getParameter("id");
    if (bookingId == null || bookingId.isEmpty()) {
        response.sendRedirect("viewAllBookings.jsp");
        return;
    }

    String message = "";
    Config neon = new Config();
    String url = neon.getConnectionUrl();
    String username = neon.getUser();
    String password = neon.getPassword();

    try {
        Class.forName("org.postgresql.Driver");
        Connection connection = DriverManager.getConnection(url, username, password);

        if ("POST".equals(request.getMethod())) {
            // Get new status from form
            String newStatus = request.getParameter("status");

            // Update the booking status in the database
            String sql = "UPDATE bookings SET status = ? WHERE id = ?";
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setString(1, newStatus);
            statement.setInt(2, Integer.parseInt(bookingId));
            int rowsUpdated = statement.executeUpdate();

            if (rowsUpdated > 0) {
                message = "<div class='alert alert-success'>Status updated successfully!</div>";
            } else {
                message = "<div class='alert alert-danger'>Failed to update status.</div>";
            }

            statement.close();
            connection.close();
        }

    } catch (Exception e) {
        message = "<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>";
    }
%>

<div class="container mt-5">
    <h1>Update Booking Status</h1>
    <%= message %>
    <form method="POST">
        <div class="mb-3">
            <label for="status" class="form-label">Status</label>
            <select class="form-select" id="status" name="status" required>
                <option value="In Progress">In Progress</option>
                <option value="Completed">Completed</option>
            </select>
        </div>
        <button type="submit" class="btn btn-primary">Update Status</button>
    </form>
</div>

<%@ include file="../components/footer.html" %>
</body>
</html>