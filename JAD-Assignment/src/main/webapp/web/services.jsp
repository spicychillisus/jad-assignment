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
    String searchQuery = request.getParameter("searchQuery"); // Get the search query from the user
    
    if (searchQuery == null) {
        searchQuery = ""; // Default to an empty string if no search term is provided
    }
    
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
    
    try {
        Config neon = new Config();
        String url = neon.getConnectionUrl();     
        String username = neon.getUser();       	
        String password = neon.getPassword();    

        Class.forName("org.postgresql.Driver");
        conn = DriverManager.getConnection(url, username, password);
        
        // SQL query with a WHERE clause to filter by service title or description
        String query = "SELECT * FROM services WHERE servicetitle ILIKE ? OR servicedescription ILIKE ? ORDER BY category, servicetitle";
        
        stmt = conn.prepareStatement(query);
        stmt.setString(1, "%" + searchQuery + "%"); // Search by service title
        stmt.setString(2, "%" + searchQuery + "%"); // Search by service description
        
        rs = stmt.executeQuery();

        // Variables to track the current category title
        String currentCategory = "";
%>

    <div class="content-container">
        <h1>Our Cleaning Services</h1>
        <p class="text-center">Choose from our range of cleaning services, designed to keep your spaces spotless and comfortable.</p>

        <!-- Search Form -->
        <form action="services.jsp" method="GET" class="search-form">
            <input type="text" name="searchQuery" placeholder="Search services..." class="form-control" value="<%= searchQuery %>">
            <button type="submit" class="btn btn-primary">Search</button>
        </form>

        <!-- Service Cards Container -->
        <div class="service-card-container">
        
            <%
                // Loop through the result set and display each service dynamically
                while (rs.next()) {
                    String serviceTitle = rs.getString("servicetitle");
                    String serviceDescription = rs.getString("servicedescription");
                    double price = rs.getDouble("price");
                    double rating = rs.getDouble("rating"); // Rating field
                    int demand = rs.getInt("demand"); // Demand field
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
                <p><strong>Price: $<%= price %></strong></p>
                
                <!-- Display Rating -->
                <p><strong>Rating: </strong>
                    <span class="rating">
                        <%= rating %> / 5
                    </span>
                </p>

                <!-- Display Demand -->
                <p><strong>Demand: </strong>
                    <%= demand %> bookings
                </p>

                <a href="bookService.jsp?service=<%= serviceId %>&price=<%= price %>" class="book-button">Book Now</a>
            </div>

            <%
                }
            %>
        </div>
        
        <!-- Best and Lowest Rated Services Section -->
        <h2>Best and Lowest Rated Services</h2>
        <div class="best-lowest-rating-container">
            <%
                // SQL query to fetch the best and lowest rated services
                String ratingQuery = "SELECT * FROM services ORDER BY rating DESC LIMIT 5";
                String lowestRatingQuery = "SELECT * FROM services ORDER BY rating ASC LIMIT 5";

                // Fetch best rated services
                stmt = conn.prepareStatement(ratingQuery);
                rs = stmt.executeQuery();
                out.println("<div class='best-rated-services'>");
                out.println("<h3>Best Rated Services</h3>");
                while (rs.next()) {
                    String bestRatedService = rs.getString("servicetitle");
                    double bestRating = rs.getDouble("rating");
                    out.println("<p>" + bestRatedService + " - Rating: " + bestRating + " / 5</p>");
                }
                out.println("</div>");

                // Fetch lowest rated services
                stmt = conn.prepareStatement(lowestRatingQuery);
                rs = stmt.executeQuery();
                out.println("<div class='lowest-rated-services'>");
                out.println("<h3>Lowest Rated Services</h3>");
                while (rs.next()) {
                    String lowestRatedService = rs.getString("servicetitle");
                    double lowestRating = rs.getDouble("rating");
                    out.println("<p>" + lowestRatedService + " - Rating: " + lowestRating + " / 5</p>");
                }
                out.println("</div>");
            %>
        </div>
        
        <!-- Low and High Demand Services Section -->
        <h2>Low and High Demand Services</h2>
        <div class="low-high-demand-container">
            <%
                // SQL query to fetch services with high and low demand
                String highDemandQuery = "SELECT * FROM services ORDER BY demand DESC LIMIT 5";
                String lowDemandQuery = "SELECT * FROM services ORDER BY demand ASC LIMIT 5";

                // Fetch high demand services
                stmt = conn.prepareStatement(highDemandQuery);
                rs = stmt.executeQuery();
                out.println("<div class='high-demand-services'>");
                out.println("<h3>High Demand Services</h3>");
                while (rs.next()) {
                    String highDemandService = rs.getString("servicetitle");
                    int highDemand = rs.getInt("demand");
                    out.println("<p>" + highDemandService + " - Demand: " + highDemand + " bookings</p>");
                }
                out.println("</div>");

                // Fetch low demand services
                stmt = conn.prepareStatement(lowDemandQuery);
                rs = stmt.executeQuery();
                out.println("<div class='low-demand-services'>");
                out.println("<h3>Low Demand Services</h3>");
                while (rs.next()) {
                    String lowDemandService = rs.getString("servicetitle");
                    int lowDemand = rs.getInt("demand");
                    out.println("<p>" + lowDemandService + " - Demand: " + lowDemand + " bookings</p>");
                }
                out.println("</div>");
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
