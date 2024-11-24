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
<%@ page import="java.sql.*, java.util.*, pg.*, services.*" %>

<%
    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;
    
    try {
        Config neon = new Config();
        String url = neon.getConnectionUrl();     
        String username = neon.getUser();       	
        String password = neon.getPassword();    

        Class.forName("org.postgresql.Driver");
        conn = DriverManager.getConnection(url, username, password);
        
        String query = "SELECT * FROM services";
        stmt = conn.createStatement();
        rs = stmt.executeQuery(query);
%>

    <div class="content-container">
        <h1>Our Cleaning Services</h1>
        <p class="text-center">Choose from our range of cleaning services, designed to keep your spaces spotless and comfortable.</p>

        <!-- Service Cards Container -->
        <div class="service-card-container">
        
            <%
                // Loop through the result set and display each service dynamically
                while (rs.next()) {
                    String serviceTitle = rs.getString("servicetitle");
                    String serviceDescription = rs.getString("servicedescription");
                    double price = rs.getDouble("price");
                    String serviceId = serviceTitle.toLowerCase().replace(" ", ""); // Creates unique ID for each service
                    String iconClass = ""; // Default icon

                    // Dynamically assign icons based on service type
                    if (serviceTitle.contains("Home")) {
                        iconClass = "fas fa-home"; // Home service icon
                    } else if (serviceTitle.contains("Office")) {
                        iconClass = "fas fa-building"; // Office service icon
                    } else if (serviceTitle.contains("Toilet")) {
                        iconClass = "fas fa-toilet"; // Toilet service icon
                    } else if (serviceTitle.contains("Upholstery")) {
                        iconClass = "fas fa-couch"; // Upholstery service icon
                    } else if (serviceTitle.contains("Kitchen")) {
                        iconClass = "fas fa-utensils"; // Kitchen icon
                    } else if (serviceTitle.contains("Window")) {
                        iconClass = "fas fa-window-maximize"; // Window icon
                    } else if (serviceTitle.contains("Conference")) {
                        iconClass = "fas fa-chalkboard"; // Conference Room icon
                    } else if (serviceTitle.contains("Post-Renovation")) {
                        iconClass = "fas fa-hammer"; // Hammer icon
                    } else if (serviceTitle.contains("Move-In")) {
                        iconClass = "fas fa-truck-moving"; // Moving Truck icon
                    }
                    // No icon if no match is found
                    else {
                        iconClass = "";
                    }
            %>

            <div class="service-card <%= serviceId %>">
                <% if (!iconClass.isEmpty()) { %>
                    <i class="<%= iconClass %>"></i> <!-- Dynamically set the icon -->
                <% } %>
                <h2><%= serviceTitle %></h2>
                <p><%= serviceDescription %></p>
                <p class="price">$<%= price %></p>
                <a href="bookService.jsp?service=<%= serviceId %>" class="book-button">Book Now</a>
            </div>

            <%
                }
            %>
        </div>
    </div>

<%
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>");
    } finally {
        // Close database connections
        try {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        } catch (SQLException se) {
            se.printStackTrace();
        }
    }
%>

<%@ include file="components/footer.html" %>
</body>
</html>
