<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Welcome to CleanEase</title>
	<link rel="stylesheet" href="./css/home.css">

</head>
<body>
    <%@ include file="components/navbar.html" %>
	<%
	if (session != null) {
		session.removeAttribute("discountCode");
	}
	%>
    <!-- Header Section -->
    <header>
        <h1>Welcome to CleanEase</h1>
        <p>Your trusted partner for home cleaning services</p>
        <%
            String userName = (String) session.getAttribute("userName");
            if (userName != null) {
        %>
            <p>Hello, <%= userName %>! Thank you for logging in.</p>
        <% } else { %>
            <p>Welcome, guest! Feel free to explore our services.</p>
        <% } %>
    </header>

    <main>
    
<!-- Services Section -->
<section id="services">
    <h2>Our Cleaning Services by Category</h2>
    <p>Explore our wide range of cleaning services to meet your needs.</p>
    <div class="service-category">
        <div class="service-card">
            <i class="fas fa-home"></i> 
            <h3>Residential Cleaning</h3>
            <p>Basic and deep cleaning options for your home.</p>
        </div>
        <div class="service-card">
            <i class="fas fa-briefcase"></i>
            <h3>Office Cleaning</h3>
            <p>Daily or weekly cleaning services to keep your workspace tidy.</p>
        </div>
        <div class="service-card">
            <i class="fas fa-cogs"></i> 
            <h3>Specialty Cleaning</h3>
            <p>Move-in/move-out cleaning, post-renovation, and more.</p>
        </div>
    </div>
</section>

<!-- How It Works Section -->
<section id="how-it-works">
    <h2>How It Works</h2>
    <ol>
        <li>Book a service online or contact us directly.</li>
        <li>Our team confirms your appointment and arrives on time.</li>
        <li>Enjoy a cleaner and healthier environment!</li>
    </ol>
</section>

        <!-- Call to Action -->
        <section id="cta">
            <h2>Ready to Book Your Cleaning Service?</h2>
            <p>Experience the CleanEase difference today!</p>
            <a href="/JAD-Assignment/services">Explore Services</a>
        </section>
        
        
        <!-- Testimonials Section -->
        <section id="testimonials">
            <h2>What Our Customers Say</h2>
            <div class="testimonial">
                <p>"CleanEase made moving out so much easier! Their deep cleaning service is top-notch."</p>
                <p><strong>- Jane Doe</strong></p>
            </div>
            <div class="testimonial">
                <p>"The team is professional and reliable. My office has never looked better."</p>
                <p><strong>- John Smith</strong></p>
            </div>
        </section>


    </main>


    <%@ include file="components/footer.html" %>
</body>
</html>