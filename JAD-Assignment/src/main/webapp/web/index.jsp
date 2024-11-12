<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Welcome to CleanEase</title>
    <link rel="stylesheet" href="./css/home.css"> 
</head>
<body>
	<%@ include file = "components/navbar.html" %>
    <!-- Header Section -->
    <header>
        <h1>Welcome to CleanEase</h1>
        <p>Your trusted partner for home cleaning services</p>
    </header>


    <!-- Main Content Section -->
    <main>
        <section id="services">
            <h2>Our Cleaning Services by Category</h2>
            <p>Explore our wide range of cleaning services.</p>
            <div class="service-category">
                <h3>Residential Cleaning</h3>
                <p>Basic and deep cleaning options for your home.</p>
            </div>
            <div class="service-category">
                <h3>Office Cleaning</h3>
                <p>Daily or weekly cleaning services to keep your workspace tidy.</p>
            </div>
            <div class="service-category">
                <h3>Specialty Cleaning</h3>
                <p>Move-in/move-out cleaning, post-renovation, and more.</p>
            </div>
        </section>
    </main>

    <!-- Footer Section -->
    <footer>
        <p>&copy; 2024 CleanEase Inc. All rights reserved.</p>
        <p><a href="contact.jsp">Contact Us</a> | <a href="feedback.jsp">Customer Feedback</a></p>
    </footer>
</body>
</html>
