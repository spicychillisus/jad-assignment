<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Cleaning Services</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
<link rel="stylesheet" href="./css/services.css">
</head>
<body>
<%@ include file="components/navbar.html" %>
<%@ page import="java.sql.*, java.*" %>

    <div class="content-container">
        <h1>Our Cleaning Services</h1>
        <p class="text-center">Choose from our range of cleaning services, designed to keep your spaces spotless and comfortable.</p>

        <!-- Service Cards Container -->
        <div class="service-card-container">
            <div class="service-card homeCleaning">
                <i class="fas fa-home"></i>
                <h2>Home Cleaning</h2>
                <p>Our home cleaning service covers all areas of your house, including dusting, vacuuming, and thorough cleaning of kitchens and bathrooms.</p>
                <p class="price">$99.99</p>
                <a href="bookService.jsp?service=homeCleaning" class="book-button">Book Now</a>
            </div>

            <div class="service-card officeCleaning">
                <i class="fas fa-building"></i>
                <h2>Office Cleaning</h2>
                <p>Our office cleaning service ensures a clean and productive work environment, with services tailored to suit your business hours and requirements.</p>
                <p class="price">$149.99</p>
                <a href="bookService.jsp?service=officeCleaning" class="book-button">Book Now</a>
            </div>

            <!-- Updated Toilet Cleaning Card -->
            <div class="service-card toiletCleaning">
                <i class="fas fa-toilet"></i> <!-- Changed icon to toilet -->
                <h2>Toilet Cleaning</h2>
                <p>Our toilet cleaning service ensures cleanliness and hygiene, leaving your toilets fresh and sparkling clean.</p>
                <p class="price">$79.99</p>
                <a href="bookService.jsp?service=toiletCleaning" class="book-button">Book Now</a>
            </div>

            <div class="service-card upholsteryCleaning">
                <i class="fas fa-couch"></i>
                <h2>Upholstery Cleaning</h2>
                <p>Our upholstery cleaning service revives your furniture, removing stains and dirt from sofas, chairs, and more.</p>
                <p class="price">$89.99</p>
                <a href="bookService.jsp?service=upholsteryCleaning" class="book-button">Book Now</a>
            </div>
        </div>
    </div>

    <%@ include file="components/footer.html" %>
</body>
</html>
