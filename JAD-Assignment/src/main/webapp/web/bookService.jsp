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
   	String discountCode = (String)session.getAttribute("discountCode");
    
    
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
                    
                    <%
                    System.out.println(discountCode);
                    if (discountCode == null) {
                    %>
                    <button type="button" class="btn btn-info mt-2 col-md-6 mb-3" data-bs-toggle="modal" data-bs-target="#discountModal">
						Enter Discount
					</button>
                    <%
                    } else {
                    %>
                    <button type="button" class="btn btn-info mt-2 col-md-6 mb-3 d-none" data-bs-toggle="modal" data-bs-target="#discountModal">
						Enter Discount
					</button>
                    <%	
                    }
                    %>
                    
					
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
											    <input type="text" id="discount" name="discount" class="form-control" placeholder="Enter your discount code">
											    <button type="submit" class="col-md-6 mb-3 btn btn-info">Submit</button>
											</div>
											
							            </div>
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

    // Processing form data when the form is submitted
    if (request.getMethod().equalsIgnoreCase("POST")) {
        Connection connection = null;
        try {
            // Get all form parameters
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
            
            // Parse price and calculate GST
            double pricePost = Double.parseDouble(priceStrPost);
            double gstAmountPost = pricePost * 0.08;
            double totalPricePost = pricePost + gstAmountPost;
            
            // Get discount information from session
            Integer discountIdObj = (Integer) session.getAttribute("discountid");
            int discountId = (discountIdObj != null) ? discountIdObj : 0;
            
            // Convert date and time
            java.sql.Date date = java.sql.Date.valueOf(dateStr);
            java.sql.Time time = java.sql.Time.valueOf(timeStr + ":00");

            // Begin transaction
            Class.forName("org.postgresql.Driver");
            connection = DriverManager.getConnection(url, username, password);
            connection.setAutoCommit(false);
            
            // First check if discount has been used (if applicable)
            if (discountId > 0) {
                String checkSQL = "SELECT COUNT(*) FROM discount_usage WHERE userid = ? AND discountid = ?";
                PreparedStatement ps = connection.prepareStatement(checkSQL);
                ps.setInt(1, userid);
                ps.setInt(2, discountId);
                ResultSet rs = ps.executeQuery();
                if (rs.next() && rs.getInt(1) > 0) {
                    throw new Exception("This discount has already been used.");
                }
                rs.close();
                ps.close();
            }
            
            // Insert booking
            String bookingSql = "INSERT INTO bookings (service_type, customer_name, email, phone, date, time, " +
                              "location, card_number, expiry_date, cvv, price) " +
                              "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?) RETURNING id";
            
            PreparedStatement statement = connection.prepareStatement(bookingSql);
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
            statement.setDouble(11, totalPricePost);

            ResultSet rs = statement.executeQuery();
            
            if (rs.next()) {
                int bookingId = rs.getInt(1);
                
                // If there's a discount, record its usage
                if (discountId > 0) {
                    String discountSql = "INSERT INTO discount_usage (discountId, times_used, userId, bookingId) " +
                                       "VALUES (?, ?, ?, ?)";
                    PreparedStatement discountStmt = connection.prepareStatement(discountSql);
                    discountStmt.setInt(1, discountId);
                    discountStmt.setInt(2, 1);
                    discountStmt.setInt(3, userid);
                    discountStmt.setInt(4, bookingId);
                    discountStmt.executeUpdate();
                    discountStmt.close();
                }
                
                // Commit the transaction
                connection.commit();
                
                // Clear the discount from session
                session.removeAttribute("discountid");
                
                // Clean up resources
                rs.close();
                statement.close();
                
                // Redirect to receipt page
                response.sendRedirect("receipt.jsp?serviceType=" + serviceType + 
                                              "&name=" + name + 
                                              "&email=" + email + 
                                              "&price=" + pricePost + 
                                              "&totalPrice=" + totalPricePost + 
                                              "&date=" + dateStr + 
                                              "&time=" + timeStr + 
                                              "&location=" + location
                                              );
                return;
            }
            
        } catch (Exception e) {
            // Rollback transaction if there's an error
            if (connection != null) {
                try {
                    connection.rollback();
                } catch (SQLException se) {
                    se.printStackTrace();
                }
            }
            out.println("<div class='alert alert-danger mt-4'>Error: " + e.getMessage() + "</div>");
        } finally {
            // Close connection in finally block
            if (connection != null) {
                try {
                    connection.close();
                } catch (SQLException se) {
                    se.printStackTrace();
                }
            }
        }
    }
%>

</div>

<%@ include file="components/footer.html" %>
</body>
</html>
