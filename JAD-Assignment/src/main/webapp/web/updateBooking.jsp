<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, pg.*" %>
<%@ include file="components/navbar.html" %>

<style>
  /* Form Styling */
  .container {
    max-width: 600px;
    margin-top: 50px;
  }

  .form-container {
    background: #f8f9fa;
    padding: 30px;
    border-radius: 8px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
  }

  .form-container .form-label {
    font-weight: bold;
    font-size: 16px;
    color: #495057;
  }

  .form-control {
    font-size: 14px;
    padding: 10px;
  }

  .btn-primary {
    background-color: #007bff;
    border-color: #007bff;
    padding: 12px 25px;
    font-size: 16px;
    font-weight: bold;
    width: 100%;
  }

  .btn-primary:hover {
    background-color: #0056b3;
    border-color: #004085;
  }

  .btn-secondary {
    background-color: #6c757d;
    border-color: #6c757d;
    padding: 12px 25px;
    font-size: 16px;
    font-weight: bold;
    width: 100%;
  }

  .btn-secondary:hover {
    background-color: #5a6268;
    border-color: #4e555b;
  }

  p.success {
    background: #d4edda;
    color: #155724;
    border: 1px solid #c3e6cb;
  }

  p.error {
    background: #f8d7da;
    color: #721c24;
    border: 1px solid #f5c6cb;
  }

</style>

<%
    int bookingId = Integer.parseInt(request.getParameter("id"));
    Config neon = new Config();
    String url = neon.getConnectionUrl();
    String username = neon.getUser();
    String password = neon.getPassword();

    try {
        Class.forName("org.postgresql.Driver");
        Connection connection = DriverManager.getConnection(url, username, password);

        String sql = "SELECT * FROM bookings WHERE id = ?";
        PreparedStatement statement = connection.prepareStatement(sql);
        statement.setInt(1, bookingId);
        ResultSet resultSet = statement.executeQuery();

        if (resultSet.next()) {
%>

<div class="container">
  <div class="form-container">
    <h2 class="text-center mb-4">Edit Booking</h2>

    <form action="saveUpdatedBooking.jsp" method="post">
        <input type="hidden" name="id" value="<%= bookingId %>">

        <div class="mb-3">
            <label for="phone" class="form-label">Phone</label>
            <input type="text" name="phone" id="phone" class="form-control" value="<%= resultSet.getString("phone") %>">
        </div>

        <div class="mb-3">
            <label for="date" class="form-label">Date</label>
            <input type="date" name="date" id="date" class="form-control" value="<%= resultSet.getDate("date") %>">
        </div>

        <div class="mb-3">
            <label for="time" class="form-label">Time</label>
            <input type="time" name="time" id="time" class="form-control" value="<%= resultSet.getTime("time") %>">
        </div>

        <div class="d-flex justify-content-between">
            <button type="submit" class="btn btn-primary">Save</button>
            <a href="bookingList.jsp" class="btn btn-secondary">Cancel</a>
        </div>
    </form>
  </div>
</div>

<%
        } else {
            out.println("<p class='error'>Booking not found.</p>");
        }

        resultSet.close();
        statement.close();
        connection.close();
    } catch (Exception e) {
        out.println("<p class='error'>Error: " + e.getMessage() + "</p>");
    }
%>

<%@ include file="components/footer.html" %>
