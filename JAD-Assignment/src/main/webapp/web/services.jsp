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
        
        // Updated SQL query to include category grouping
        String query = "SELECT * FROM services ORDER BY category, servicetitle";
                     
        stmt = conn.createStatement();
        rs = stmt.executeQuery(query);

        // Variables to track the current category title
        String currentCategory = "";
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
                    String category = rs.getString("category"); // Get category from database
                    
                    // Print category header only once for each category
                    if (!currentCategory.equals(category)) {
                        out.println("<h2>" + category + "</h2>");
                        currentCategory = category;
                    }
            %>

            <div class="service-card <%= serviceId %>">
                <% if (!iconClass.isEmpty()) { %>
                    <i class="<%= iconClass %>"></i> <!-- Dynamically set the icon -->
                <% } %>
                <h3><%= serviceTitle %></h3>
                <p><%= serviceDescription %></p>
				<a href="bookService.jsp?service=<%= serviceId %>&price=<%= price %>" class="book-button">Book Now</a>
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