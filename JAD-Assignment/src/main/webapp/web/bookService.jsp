<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, pg.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Book Cleaning Service</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
	<link rel="stylesheet" href="./css/bookService.css">
</head>
<body>

<%@ include file="components/navbar.html" %>

<%
    // Check if the user is logged in
    if (session.getAttribute("userName") == null) {
        // Redirect to login page if not logged in
        response.sendRedirect("login.jsp");
        return; 
    }

<<<<<<< HEAD
	Connection conn = null;
	String svcPaymentPrice = request.getParameter("price");
	double servicePaymentPrice = Double.parseDouble(svcPaymentPrice);
	String cleaningService = request.getParameter("service");
	
	// advanced feature: discount
	Double discount = 0.0;
	System.out.println(servicePaymentPrice);
=======
    // Get the price from the request or set a default if not provided
    String priceStr = request.getParameter("price");
    double price = 0.0;
    if (priceStr != null) {
        price = Double.parseDouble(priceStr);
    }
    
    // Calculate GST (8% of the price)
    double gstAmount = price * 0.08; // 8% GST
    double totalPrice = price + gstAmount;
    
    // Round both prices to 2 decimal places
    price = Math.round(price * 100.0) / 100.0;
    totalPrice = Math.round(totalPrice * 100.0) / 100.0;
>>>>>>> branch 'main' of https://github.com/spicychillisus/jad-assignment.git
%>

<div class="container mt-5">
    <h1>Book a Cleaning Service</h1>
    <p>Fill out the form below to book a service and provide your payment details</p>

    <!-- Booking Form -->
    <form action="bookService.jsp" method="post" class="mt-3">
        <div class="mb-3">
            <label for="serviceType" class="form-label">Service Type</label>
            <input type="text" id="serviceType" name="serviceType" class="form-control" 
                   value="<%= request.getParameter("service") != null ? request.getParameter("service") : "" %>" readonly>
        </div>

        <div class="mb-3">
            <label for="name" class="form-label">Your Name</label>
            <input type="text" id="name" name="name" class="form-control" 
                   value="<%= session.getAttribute("userName") %>" required>
        </div>

        <div class="mb-3">
            <label for="email" class="form-label">Email Address</label>
            <input type="email" id="email" name="email" class="form-control" 
                   value="<%= session.getAttribute("userEmail") %>" required>
        </div>

        <div class="mb-3">
            <label for="phone" class="form-label">Phone Number</label>
            <input type="tel" id="phone" name="phone" class="form-control" 
                   value="<%= session.getAttribute("userPhone") %>" required>
        </div>

        <div class="mb-3">
            <label for="date" class="form-label">Preferred Date</label>
            <input type="date" id="date" name="date" class="form-control" required>
        </div>

        <div class="mb-3">
            <label for="time" class="form-label">Preferred Time</label>
            <input type="time" id="time" name="time" class="form-control" required>
        </div>
        
        <div class="mb-3">
            <label for="location" class="form-label">Location</label>
            <input type="text" id="location" name="location" class="form-control" placeholder="Enter your address or location" required>
        </div>

        <!-- Payment Section -->
<<<<<<< HEAD
        <h2 class="mt-4">Payment Details</h2>
        <div class="container">
        	<div class="row">
        		<div class="col">
        			<div class="mb-3">
			            <label for="cardNumber" class="form-label">Credit Card Number</label>
			            <input type="text" id="cardNumber" name="cardNumber" class="form-control" placeholder="1234 5678 9012 3456" required>
			        </div>
			        <div class="row">
			            <div class="col-md-6 mb-3">
			                <label for="expiryDate" class="form-label">Expiry Date</label>
			                <input type="text" id="expiryDate" name="expiryDate" class="form-control" placeholder="MM/YY" required>
			            </div>
			            <div class="col-md-6 mb-3">
			                <label for="cvv" class="form-label">CVV</label>
			                <input type="text" id="cvv" name="cvv" class="form-control" placeholder="123" required>
			            </div>
			        </div>
        		</div>
        		<div class="col">
        			<h3>Booking Summary</h3>
        			<table class="table">
				        <tbody>
				          <tr>
				            <td><%= request.getParameter("service") %> service</td>
				            <td class="h5"><%= servicePaymentPrice %></td>
				          </tr>
				          <tr>
				            <td>Discounts Applied</td>
				            <td class="h5"><%= discount %></td>
				          </tr>
				          <tr>
				            <td>Subtotal</td>
				            <td class="h5"><%= servicePaymentPrice - discount %></td>
				          </tr>
				        </tbody>
				    </table>
        		</div>
        	</div>
        </div>
		
		<div class="d-flex justify-content-center align-items-center">
			<button type="submit" class="btn btn-primary">Submit Booking</button>
		</div>
        
=======
        <div class="payment-section">
            <h2>Payment Details</h2>
            <div class="payment-card-info">
                <div class="form-row">
                    <label for="cardNumber" class="form-label">Credit Card Number</label>
                    <input type="text" id="cardNumber" name="cardNumber" class="form-control" placeholder="1234 5678 9012 3456" required>
                </div>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="expiryDate" class="form-label">Expiry Date</label>
                        <input type="text" id="expiryDate" name="expiryDate" class="form-control" placeholder="MM/YY" required>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="cvv" class="form-label">CVV</label>
                        <input type="text" id="cvv" name="cvv" class="form-control" placeholder="123" required>
                    </div>
                </div>
                
                <div class="form-row">
                    <label for="price" class="form-label">Price (Excluding GST)</label>
                    <input type="text" id="price" name="price" class="form-control"
                           value="<%= price %>" readonly> <!-- Display price excluding GST -->
                </div>

                <div class="form-row">
                    <label for="totalPrice" class="form-label">Price (Including GST)</label>
                    <input type="text" id="totalPrice" name="totalPrice" class="form-control"
                           value="<%= totalPrice %>" readonly> <!-- Display total price including GST -->
                </div>
            </div>
            <button type="submit" class="payment-button">Submit Booking</button>
        </div>
>>>>>>> branch 'main' of https://github.com/spicychillisus/jad-assignment.git
    </form>

    <script>
        // Credit Card Number Validation
        const cardNumberInput = document.getElementById('cardNumber');
        cardNumberInput.addEventListener('input', function () {
            this.value = this.value.replace(/\D/g, ''); // Allow only numbers
            if (this.value.length > 16) {
                this.value = this.value.slice(0, 16); // Limit to 16 digits
            }
        });

        // Expiry Date Validation
        const expiryDateInput = document.getElementById('expiryDate');
        expiryDateInput.addEventListener('input', function () {
            let value = this.value.replace(/\D/g, ''); // Remove non-digit characters
            if (value.length > 4) {
                value = value.slice(0, 4); // Limit to 4 digits
            }

            if (value.length > 2 && !value.includes('/')) {
                value = value.slice(0, 2) + '/' + value.slice(2);
            }

            this.value = value;
        });

        // CVV Validation
        const cvvInput = document.getElementById('cvv');
        cvvInput.addEventListener('input', function () {
            this.value = this.value.replace(/\D/g, ''); // Allow only numbers
            if (this.value.length > 3) {
                this.value = this.value.slice(0, 3); // Limit to 3 digits
            }
        });
    </script>

    <%
        Config neon = new Config();
        String url = neon.getConnectionUrl();
        String username = neon.getUser();
        String password = neon.getPassword();
        int rowsInserted = 0;

        // Processing form data when the form is submitted
        if (request.getMethod().equalsIgnoreCase("POST")) {
            String serviceType = request.getParameter("serviceType");
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String dateStr = request.getParameter("date");
            String timeStr = request.getParameter("time");
            String location = request.getParameter("location"); 
            String cardNumber = request.getParameter("cardNumber");
            String expiryDate = request.getParameter("expiryDate");
            String cvv = request.getParameter("cvv");
            String priceStrPost = request.getParameter("price");

            // Parse price and calculate GST again for the database
            double pricePost = Double.parseDouble(priceStrPost);
            double gstAmountPost = pricePost * 0.08;
            double totalPricePost = pricePost + gstAmountPost;


            try {
                java.sql.Date date = java.sql.Date.valueOf(dateStr);
                java.sql.Time time = java.sql.Time.valueOf(timeStr + ":00");

                // Establish connection and execute insert
                Class.forName("org.postgresql.Driver");
                Connection connection = DriverManager.getConnection(url, username, password);
<<<<<<< HEAD
                String sql = "INSERT INTO bookings (service_type, customer_name, email, phone, date, time, location, card_number, expiry_date, cvv) " +
                             "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
=======
                String sql = "INSERT INTO bookings (service_type, customer_name, email, phone, date, time, location, card_number, expiry_date, cvv, price) " +
                             "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"; 
>>>>>>> branch 'main' of https://github.com/spicychillisus/jad-assignment.git
                PreparedStatement statement = connection.prepareStatement(sql);
                statement.setString(1, serviceType);
                statement.setString(2, name);
                statement.setString(3, email);
                statement.setString(4, phone);
                statement.setDate(5, date);
                statement.setTime(6, time);
                statement.setString(7, location);
                statement.setString(8, cardNumber);
                statement.setString(9, expiryDate);
                statement.setString(10, cvv);
                statement.setDouble(11, totalPricePost); // Insert total price including GST

                rowsInserted = statement.executeUpdate();
                statement.close();
                connection.close();
            } catch (Exception e) {
                out.println("<div class='alert alert-danger mt-4'>Error: " + e.getMessage() + "</div>");
            }

            // If insertion is successful, redirect to bookings.jsp
            if (rowsInserted > 0) {
                response.sendRedirect("bookings.jsp"); // Redirect to bookings page
                return; // Stop further processing
            }
        }
    %>
</div>

<%@ include file="components/footer.html" %>
</body>
</html>
