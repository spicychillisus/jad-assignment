<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Contact Us</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
</head>
<body>
<%@ include file="components/navbar.html" %>

<div class="container mt-5">
    <h1 class="text-center">Contact Us</h1>
    <p class="text-center mb-4">We'd love to hear from you! Fill out the form below or reach out through our contact details. Our team will get back to you shortly.</p>

    <div class="row">
        <!-- Contact Form -->
        <div class="col-md-6">
            <form method="post" action="auth/verifyContactUs.jsp">
                <div class="mb-3">
                    <label for="name" class="form-label">Your Name</label>
                    <input type="text" class="form-control" id="name" name="name" required>
                </div>
                <div class="mb-3">
                    <label for="email" class="form-label">Your Email</label>
                    <input type="email" class="form-control" id="email" name="email" required>
                </div>
                <div class="mb-3">
                    <label for="subject" class="form-label">Subject</label>
                    <input type="text" class="form-control" id="subject" name="subject" required>
                </div>
                <div class="mb-3">
                    <label for="message" class="form-label">Your Message</label>
                    <textarea class="form-control" id="message" name="message" rows="5" required></textarea>
                </div>
                <button type="submit" class="btn btn-primary w-100">Send Message</button>
            </form>
        </div>

        <!-- Contact Details -->
        <div class="col-md-6">
            <h3>Contact Details</h3>
            <p>
                <i class="fas fa-phone-alt"></i> +65 6775 1133<br>
                <i class="fas fa-envelope"></i> admin@cleanease.com<br>
                <i class="fas fa-map-marker-alt"></i> 10 Buangkok View, Buangkok Green Medical Park, Singapore 539747
            </p>
            <h3>Follow Us</h3>
            <div class="d-flex">
                <a href="#" class="me-3"><i class="fab fa-facebook fa-2x"></i></a>
                <a href="#" class="me-3"><i class="fab fa-twitter fa-2x"></i></a>
                <a href="#"><i class="fab fa-instagram fa-2x"></i></a>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
