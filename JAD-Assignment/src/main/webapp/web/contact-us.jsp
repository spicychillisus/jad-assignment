<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Contact Us</title>
    <link rel="stylesheet" href="./css/contact.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <%@ page import ="java.sql.*, java.util.*, members.*, pg.*"%>
    
</head>
<body>
<%@ include file="components/navbar.html" %>
<%@page import="java.sql.*, java.util.*, javax.sql.*, java.io.*" %>

<div class="container mt-5">
    <h1 class="text-center">Contact Us</h1>
    <p class="text-center mb-4">We'd love to hear from you! Fill out the form below or reach out through our contact details. Our team will get back to you shortly.</p>
    
    <div id="successMessage" class="alert alert-success d-none" role="alert">
        Thank you for your feedback! Your response has been recorded successfully.
    </div>
    
    <div id="errorMessage" class="alert alert-danger d-none" role="alert">
        Sorry, there was an issue submitting your feedback. Please try again later.
    </div>

    <div class="row">
        <!-- Contact Form -->
        <div class="col-md-6">
            <%
                String userName = (String) session.getAttribute("userName");
                String userEmail = (String) session.getAttribute("userEmail");
                String message = "";  // For error/success messages
                if (request.getMethod().equalsIgnoreCase("POST")) {
                    try {
                        String name = request.getParameter("name");
                        String email = request.getParameter("email");
                        String subject = request.getParameter("subject");
                        String feedbackMessage = request.getParameter("message");
                        int rating = Integer.parseInt(request.getParameter("rating"));

                        // Database connection details (use your connection URL, username, password)
                        Config neon = new Config();
                        String url = neon.getConnectionUrl();
                        String dbUser = neon.getUser();
                        String dbPassword = neon.getPassword();

                        Class.forName("org.postgresql.Driver");
                        Connection conn = DriverManager.getConnection(url, dbUser, dbPassword);

                        // SQL query to insert feedback
                        String sql = "INSERT INTO feedback (name, email, subject, message, rating) VALUES (?, ?, ?, ?, ?)";
                        PreparedStatement pstmt = conn.prepareStatement(sql);
                        pstmt.setString(1, name);
                        pstmt.setString(2, email);
                        pstmt.setString(3, subject);
                        pstmt.setString(4, feedbackMessage);
                        pstmt.setInt(5, rating);

                        // Execute the query
                        int result = pstmt.executeUpdate();
                        if (result > 0) {
                            message = "<div class='alert alert-success'>Thank you for your feedback!</div>";
                        } else {
                            message = "<div class='alert alert-danger'>Sorry, there was an issue submitting your feedback. Please try again later.</div>";
                        }

                        conn.close();
                    } catch (Exception e) {
                        e.printStackTrace();
                        message = "<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>";
                    }
                }
            %>
            <%= message %>
            <form id="contactForm" method="POST">
                <div class="mb-3">
                    <label for="name" class="form-label">Your Name</label>
                    <input type="text" class="form-control" id="name" name="name" value="<%= userName != null ? userName : "" %>" required>
                </div>
                <div class="mb-3">
                    <label for="email" class="form-label">Your Email</label>
                    <input type="email" class="form-control" id="email" name="email" value="<%= userEmail != null ? userEmail : "" %>" required>
                </div>
                <div class="mb-3">
                    <label for="subject" class="form-label">Subject</label>
                    <input type="text" class="form-control" id="subject" name="subject" required>
                </div>
                <div class="mb-3">
                    <label for="message" class="form-label">Your Message</label>
                    <textarea class="form-control" id="message" name="message" rows="5" required></textarea>
                </div>
                <div class="mb-3">
                    <label class="form-label">Rate Our Service</label>
                    <div class="star-rating">
                        <input type="radio" id="star5" name="rating" value="5"><label for="star5">&#9733;</label>
                        <input type="radio" id="star4" name="rating" value="4"><label for="star4">&#9733;</label>
                        <input type="radio" id="star3" name="rating" value="3"><label for="star3">&#9733;</label>
                        <input type="radio" id="star2" name="rating" value="2"><label for="star2">&#9733;</label>
                        <input type="radio" id="star1" name="rating" value="1"><label for="star1">&#9733;</label>
                    </div>
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
                <i class="fas fa-map-marker-alt"></i> 500 Dover Rd, Singapore 139651
            </p>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<%@ include file="components/footer.html" %>
</body>
</html>
