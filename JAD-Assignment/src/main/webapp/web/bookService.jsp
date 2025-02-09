<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, discount.*, pg.*, java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Book Cleaning Service</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="/JAD-Assignment/web/css/bookService.css">
</head>
<body>

<%@ include file="components/navbar.html" %>

<%
    // Check if the user is logged in
    if (session.getAttribute("userName") == null) {
        // Redirect to login page if not logged in
        response.sendRedirect("/JAD-Assignment/web/login.jsp");
        return; 
    }

    int userid = (int)session.getAttribute("userId");

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
    
    String service = request.getParameter("service");
    session.setAttribute("price", priceStr);
    session.setAttribute("serviceName", service);
    
   	// get discount code after validation
   	String discountCode = "";
    
    
%>

<div class="container mt-5">
    <h1>Book a Cleaning Service</h1>
    <p>Fill out the form below to book a service and provide your payment details</p>

    <!-- Booking Form -->
    <form action="/JAD-Assignment/web/bookService.jsp" method="post" class="mt-3">
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
                
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="price" class="form-label">Price (Excluding GST)</label>
                        <input type="text" id="price" name="price" class="form-control"
                               value="<%= price %>" readonly> <!-- Display price excluding GST -->
                    </div>
                    
                    <button type="button" class="btn btn-info mt-2 col-md-6 mb-3" data-bs-toggle="modal" data-bs-target="#discountModal">
						View Available Discounts
					</button>
					
                </div>

                <div class="form-row">
			    <label for="totalPrice" class="form-label">Price (Including GST)</label>
			    <input type="text" id="totalPrice" name="totalPrice" class="form-control"
			           value="<%= totalPrice %>" readonly> <!-- Display total price including GST -->
			    
			     <!-- Adjusted margin for spacing -->
			</div>

            </div>
            <button type="submit" class="payment-button">Submit Booking</button>
        </div>
    </form>
    <form action="/JAD-Assignment/verifyDiscount" method="POST">
    	<div class="modal fade" id="discountModal" tabindex="-1" aria-labelledby="discountModalLabel" aria-hidden="true">
			<div class="modal-dialog">
						        <div class="modal-content">
						            <div class="modal-header">
						                <h5 class="modal-title" id="discountModalLabel">Available Discounts</h5>
						                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
						            </div>
						            <div class="modal-body">
						            <!-- input discount code here -->
						            <div class="row">
						            	<div class="col-md-6 mb-3">
										    <label for="discount" class="form-label">Enter Discount Code</label>
										    <div class="col-md-6 mb-3">
										    	<input type="text" id="discount" name="discount" class="form-control" placeholder="Enter your discount code">
										    </div>
										    <button type="submit" class="col-md-6 mb-3 btn btn-info">Submit</button>
										</div>
										
						            </div>
						            
						                <ul class="list-group">
						                    <% 
						                    @SuppressWarnings("unchecked")
					    					ArrayList<Discount> allDiscounts = (ArrayList<Discount>) request.getAttribute("validDiscounts");
								    		discountCode = (String) session.getAttribute("discountCode");
								            System.out.println(discountCode);
								            Double discountValue = null;
						                    if (allDiscounts != null && !allDiscounts.isEmpty()) {
						                    	for (int i = 0; i < allDiscounts.size(); i++) { 
						                    	     Discount discount = allDiscounts.get(i);
						                    	     if (discount.getCode().equals(discountCode)) { 
						                                 discountValue = discount.getDiscountValue(); 
						                                 System.out.println(discountValue);
						                             }
						                    %>
						                        <li class="list-group-item">
						                            <strong><%= discount.getCode() %></strong> - <%= discount.getDescription() %> 
						                            (Valid until: <%= discount.getEndDate() %>)
						                            <span>value=<%= discountValue %></span>
						                        </li>
						                    <% 
						                        }
						                    } else { 
						                    %>
						                        <li class="list-group-item">No discounts available</li>
						                    <% 
						                    	} 
						                    %>
						                </ul>
						            </div>
						            <div class="modal-footer">
						                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
						            </div>
						        </div>
						    </div>
						</div>			    
    </form>
    
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
                String sql = "INSERT INTO bookings (service_type, customer_name, email, phone, date, time, location, card_number, expiry_date, cvv, price) " +
                             "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"; 
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
                response.sendRedirect("/JAD-Assignment/web/bookings.jsp"); // Redirect to bookings page
                return; // Stop further processing
            }
        }
    %>

</div>

<%@ include file="components/footer.html" %>
</body>
</html>
