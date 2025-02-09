<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, pg.*" %>
<%
    int bookingId = Integer.parseInt(request.getParameter("id"));
    Config neon = new Config();
    String url = neon.getConnectionUrl();
    String username = neon.getUser();
    String password = neon.getPassword();

    try {
        Class.forName("org.postgresql.Driver");
        Connection connection = DriverManager.getConnection(url, username, password);

        String sql = "DELETE FROM bookings WHERE id = ?";
        PreparedStatement statement = connection.prepareStatement(sql);
        statement.setInt(1, bookingId);

        int rowsAffected = statement.executeUpdate();
        if (rowsAffected > 0) {
            response.sendRedirect("bookings.jsp");
        } else {
            out.println("<p>Error cancelling booking.</p>");
        }

        statement.close();
        connection.close();
    } catch (Exception e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
    }
%>
