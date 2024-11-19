<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Cleaning Services</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
<style>
    body {
        height: 100%;
        margin: 0;
        padding: 0;
        background-color: #e6f7e6;
    }

    .service-card {
        background: #ffffff;
        border: 1px solid #ddd;
        border-radius: 8px;
        padding: 20px;
        margin: 20px 0;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        text-align: center;
        transition: transform 0.3s ease, box-shadow 0.3s ease, background-color 0.3s ease;
        position: relative; /* Ensure background stays intact during hover */
    }

    .service-card:hover {
        transform: translateY(-10px);
        box-shadow: 0 8px 15px rgba(0, 0, 0, 0.2);
        background-color: #ffffff; /* Reapply background to ensure it doesn't disappear */
    }

    .service-card i {
        font-size: 3rem;
        color: #007bff;
        margin-bottom: 10px;
        transition: color 0.3s ease;
    }

    .service-card:hover i {
        color: #0056b3;
    }

    .book-button {
        display: inline-block;
        padding: 10px 20px;
        font-size: 1rem;
        color: #fff;
        background-color: #007bff;
        border: none;
        border-radius: 4px;
        text-decoration: none;
        transition: background-color 0.3s ease, transform 0.2s ease;
    }

    .book-button:hover {
        background-color: #0056b3;
        transform: translateY(-3px);
    }

    @media (max-width: 768px) {
        .service-card {
            margin: 20px 5px;
            padding: 15px;
        }
    }
</style>

</head>
<body>
<%@ include file="components/navbar.html" %>
<%@ page import="java.sql.*, java.*" %>

<div class="content-container" style="padding: 20px; text-align: center;">
    <h1>Our Cleaning Services</h1>
    <p>
        Choose from our range of cleaning services, designed to keep your spaces spotless and comfortable.
    </p>

    <!-- Service Cards -->
    <div class="service-card">
        <i class="fas fa-home"></i>
        <h2>Home Cleaning</h2>
        <p>Our home cleaning service covers all areas of your house, including dusting, vacuuming, and thorough cleaning of kitchens and bathrooms.</p>
        <p style="color: #28a745; font-size: 1.2rem; font-weight: bold;">$99.99</p>
        <a href="bookService.jsp?service=homeCleaning" class="book-button">Book Now</a>
    </div>

    <div class="service-card">
        <i class="fas fa-building"></i>
        <h2>Office Cleaning</h2>
        <p>Our office cleaning service ensures a clean and productive work environment, with services tailored to suit your business hours and requirements.</p>
        <p style="color: #28a745; font-size: 1.2rem; font-weight: bold;">$149.99</p>
        <a href="bookService.jsp?service=officeCleaning" class="book-button">Book Now</a>
    </div>

    <div class="service-card">
        <i class="fas fa-carpet"></i>
        <h2>Carpet Cleaning</h2>
        <p>Get your carpets deep cleaned with our specialized carpet cleaning service. We remove stains, allergens, and dirt, making your carpets look and feel new.</p>
        <p style="color: #28a745; font-size: 1.2rem; font-weight: bold;">$129.99</p>
        <a href="bookService.jsp?service=carpetCleaning" class="book-button">Book Now</a>
    </div>

    <div class="service-card">
        <i class="fas fa-couch"></i>
        <h2>Upholstery Cleaning</h2>
        <p>Our upholstery cleaning service revives your furniture, removing stains and dirt from sofas, chairs, and more.</p>
        <p style="color: #28a745; font-size: 1.2rem; font-weight: bold;">$89.99</p>
        <a href="bookService.jsp?service=upholsteryCleaning" class="book-button">Book Now</a>
    </div>
</div>
    <%@ include file="components/footer.html" %>
</body>
</html>
