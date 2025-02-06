<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cleaning Services</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <script src="https://kit.fontawesome.com/your-fontawesome-kit.js" crossorigin="anonymous"></script>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f8f9fa;
            color: #333;
        }
        .content-container {
            padding: 2rem;
            max-width: 1200px;
            margin: 0 auto;
        }
        h1, h2, h3 {
            color: #ffffff;
            margin-bottom: 1.5rem;
        }
        .search-form {
            margin-bottom: 2rem;
        }
        .search-form input {
            border-radius: 25px;
            padding: 10px 20px;
            border: 1px solid #ddd;
        }
        .search-form button {
            border-radius: 25px;
            padding: 10px 20px;
            margin-left: 10px;
        }
        .category-section {
            margin-bottom: 3rem;
            padding: 1rem;
            background: linear-gradient(to right, #007bff, #0056b3);
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            text-align: center;
        }
        .category-section h2 {
            font-size: 2rem;
            font-weight: bold;
            text-transform: uppercase;
            letter-spacing: 2px;
            background-color: #007bff;
            color: #fff;
            padding: 10px 20px;
            border-radius: 5px;
            box-shadow: 0 3px 6px rgba(0, 0, 0, 0.1);
            margin-bottom: 1.5rem;
        }
        .service-card-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 1.5rem;
        }
        .service-card {
            background: #fff;
            border-radius: 10px;
            padding: 1.5rem;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            transition: transform 0.2s, box-shadow 0.2s;
        }
        .service-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 6px 12px rgba(0, 0, 0, 0.15);
        }
        .service-card h3 {
            margin-bottom: 1rem;
            color: #007bff;
        }
        .service-card p {
            margin-bottom: 0.5rem;
            color: #555;
        }
        .service-card .book-button {
            display: inline-block;
            padding: 10px 20px;
            background: #007bff;
            color: #fff;
            border-radius: 25px;
            text-decoration: none;
            transition: background 0.3s;
        }
        .service-card .book-button:hover {
            background: #0056b3;
        }
        .rating {
            color: #ffc107;
            font-weight: bold;
        }

    </style>
</head>
<body>
    <%@ include file="components/navbar.html" %>
    <%@ page import="java.sql.*, java.util.*, pg.*, services.*" %>

    <%
    	@SuppressWarnings("unchecked")
    	ArrayList<Service> services = (ArrayList<Service>) request.getAttribute("services");
    	if (services != null) {
    		for (Service service : services) {
    			
    		}
    	}
    
    
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
            String previousCategory = "";
    %>

    <div class="content-container">
        <h1>Our Cleaning Services</h1>
        <p class="text-center">Choose from our range of cleaning services, designed to keep your spaces spotless and comfortable.</p>

        <!-- Search Form -->
        <form action="services.jsp" method="GET" class="search-form">
            <input type="text" name="searchQuery" placeholder="Search services..." class="form-control" value="<%= searchQuery %>">
            <button type="submit" class="btn btn-primary">Search</button>
        </form>

<%
    // Loop through the result set and display each service dynamically
    while (rs.next()) {
        String category = rs.getString("category"); // Get category from database
        
        // Only display the category if it has changed
        if (!category.equals(previousCategory)) {
            out.println("<div class='category-section'><h2>" + category + "</h2></div>");
            previousCategory = category; // Update the previous category to current one
        }
        
        // Assign an icon based on category
        String iconClass = "";
        if ("Residential Cleaning".equalsIgnoreCase(category)) {
            iconClass = "fas fa-home";
        } else if ("Office Cleaning".equalsIgnoreCase(category)) {
            iconClass = "fas fa-building";
        } else if ("Specialty Cleaning".equalsIgnoreCase(category)) {
            iconClass = "fas fa-broom";
        } else {
            iconClass = "fas fa-cogs";
        }

        String serviceTitle = rs.getString("servicetitle");
        String serviceDescription = rs.getString("servicedescription");
        double price = rs.getDouble("price");
        double rating = rs.getDouble("rating");
        String serviceId = serviceTitle.toLowerCase().replace(" ", "");

%>
    <div class="service-card <%= serviceId %>">
        <h3>
            <i class="<%= iconClass %>"></i> <%= serviceTitle %>
        </h3>
        <p><%= serviceDescription %></p>
        <p><strong>Price: $<%= price %></strong></p>
        <p><strong>Rating: </strong><span class="rating"><%= rating %> / 5</span></p>
        <a href="bookService.jsp?service=<%= serviceId %>&price=<%= price %>" class="book-button">Book Now</a>
    </div>
<%
    }
%>

    </div>

    <% 
        } catch (Exception e) {
            out.println("<p>Error: " + e.getMessage() + "</p>");
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    %>

    <%@ include file="components/footer.html" %>

</body>
</html>