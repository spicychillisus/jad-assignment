<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
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
	<!-- Form to add a new service -->
    <h3>Add New Service</h3>
    <form action="addService.jsp" method="POST">
        <div class="mb-3">
            <label for="serviceTitle" class="form-label">Service Title</label>
            <input type="text" class="form-control" id="serviceTitle" name="serviceTitle" required>
        </div>
        <div class="mb-3">
            <label for="serviceDescription" class="form-label">Service Description</label>
            <textarea class="form-control" id="serviceDescription" name="serviceDescription" required></textarea>
        </div>
        <div class="mb-3">
            <label for="servicePrice" class="form-label">Price</label>
            <input type="number" class="form-control" id="servicePrice" name="servicePrice" required>
        </div>
        <button type="submit" class="btn btn-primary">Add Service</button>
    </form>
</div>
</body>
</html>