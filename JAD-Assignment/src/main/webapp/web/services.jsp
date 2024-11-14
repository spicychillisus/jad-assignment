<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Cleaning Services</title>
<link rel="stylesheet" href="css/services.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
</head>
<body>
<%@ include file = "components/navbar.html" %>
<%@page import ="java.sql.*, java.*"%>


<div class="content-container">
    <h1>Our Cleaning Services</h1>
    <p>Choose from our range of cleaning services, designed to keep your spaces spotless and comfortable.</p>

    <!-- Home Cleaning Service -->
    <div class="service-card">
        <h2 class="service-title">Home Cleaning</h2>
        <p class="service-description">Our home cleaning service covers all areas of your house, including dusting, vacuuming, and thorough cleaning of kitchens and bathrooms.</p>
        <a href="bookService.jsp?service=homeCleaning" class="book-button">Book Now</a>
    </div>

    <!-- Office Cleaning Service -->
    <div class="service-card">
        <h2 class="service-title">Office Cleaning</h2>
        <p class="service-description">Our office cleaning service ensures a clean and productive work environment, with services tailored to suit your business hours and requirements.</p>
        <a href="bookService.jsp?service=officeCleaning" class="book-button">Book Now</a>
    </div>

    <!-- Carpet Cleaning Service -->
    <div class="service-card">
        <h2 class="service-title">Carpet Cleaning</h2>
        <p class="service-description">Get your carpets deep cleaned with our specialized carpet cleaning service. We remove stains, allergens, and dirt, making your carpets look and feel new.</p>
        <a href="bookService.jsp?service=carpetCleaning" class="book-button">Book Now</a>
    </div>

    <!-- Upholstery Cleaning Service -->
    <div class="service-card">
        <h2 class="service-title">Upholstery Cleaning</h2>
        <p class="service-description">Our upholstery cleaning service revives your furniture, removing stains and dirt from sofas, chairs, and more.</p>
        <a href="bookService.jsp?service=upholsteryCleaning" class="book-button">Book Now</a>
    </div>
</div>

</body>
</html>