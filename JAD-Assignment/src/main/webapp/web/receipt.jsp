<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.text.DecimalFormat" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Booking Receipt</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <script>
        function printReceipt() {
            window.print();
        }
    </script>
</head>
<body>

<%@ include file="components/navbar.html" %>

<div class="container mt-5">
    <h1>Your Cleaning Service Booking Receipt</h1>
    <p>Thank you for booking with us. Below are your booking details:</p>

    <div class="card p-4">
        <h3>Booking Details</h3>
        <p><strong>Service Type:</strong> <%= request.getParameter("serviceType") %></p>
        <p><strong>Name:</strong> <%= request.getParameter("name") %></p>
        <p><strong>Email:</strong> <%= request.getParameter("email") %></p>
        <p><strong>Price (Excluding GST):</strong> $<%= request.getParameter("price") %></p>

        <p><strong>GST (8%):</strong> $<%= 
            new DecimalFormat("#.##").format(Double.parseDouble(request.getParameter("price")) * 0.08) 
        %></p>
        
        <%
            // Round the total price (including GST) to 2 decimal places
            double totalPrice = Double.parseDouble(request.getParameter("totalPrice"));
            totalPrice = Math.round(totalPrice * 100.0) / 100.0;
        %>
        <p><strong>Total Price (Including GST):</strong> $<%= totalPrice %></p>

        <h3>Booking Information</h3>
        <p><strong>Date:</strong> <%= request.getParameter("date") %></p>
        <p><strong>Time:</strong> <%= request.getParameter("time") %></p>
        <p><strong>Location:</strong> <%= request.getParameter("location") %></p>
    </div>

    <button class="btn btn-success mt-4" onclick="printReceipt()">Print Receipt</button>

</div>

<%@ include file="components/footer.html" %>

</body>
</html>
