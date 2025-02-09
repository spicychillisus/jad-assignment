<%@ page import="java.util.ArrayList" %>
<%@ page import="services.*" %> <!-- Import your Service class -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

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

    <div class="content-container">
        <h1>Our Cleaning Services</h1>
        <p class="text-center">Choose from our range of cleaning services, designed to keep your spaces spotless and comfortable.</p>

        <!-- Search Form -->
        <form action="services" method="GET" class="search-form">
            <input type="text" name="search" placeholder="Search services..." class="form-control" value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>">
            <button type="submit" class="btn btn-primary">Search</button>
        </form>

        <!-- Services Display -->
        <%
        session.removeAttribute("discountCode");
    	session.removeAttribute("discountValue");
        	@SuppressWarnings("unchecked")
            ArrayList<Service> services = (ArrayList<Service>) request.getAttribute("services");
            String previousCategory = "";

            if (services != null) {
                for (Service service : services) {
                    String category = service.getCategory();

                    // Display category only if it's changed
                    if (!category.equals(previousCategory)) {
                        out.println("<div class='category-section'><h2>" + category + "</h2></div>");
                        previousCategory = category;
                    }

                    String iconClass = "fas fa-cogs"; // Default icon
                    if ("Residential Cleaning".equalsIgnoreCase(category)) {
                        iconClass = "fas fa-home";
                    } else if ("Office Cleaning".equalsIgnoreCase(category)) {
                        iconClass = "fas fa-building";
                    } else if ("Specialty Cleaning".equalsIgnoreCase(category)) {
                        iconClass = "fas fa-broom";
                    }

                    String serviceTitle = service.getServicetitle();
                    String serviceDescription = service.getServicedescription();
                    double price = service.getPrice();
                    double rating = service.getRating();
                    String serviceId = serviceTitle.toLowerCase().replace(" ", "");
                    
                    //int userId = (int)session.getAttribute("userId");

        %>
            <div class="service-card">
                <h3>
                    <i class="<%= iconClass %>"></i> <%= serviceTitle %>
                </h3>
                <p><%= serviceDescription %></p>
                <p><strong>Price: $<%= price %></strong></p>
                <p><strong>Rating: </strong><span class="rating"><%= rating %> / 5</span></p>
                <a href="/JAD-Assignment/serviceBooking?service=<%= serviceId %>&price=<%= price %>" class="book-button">Book Now</a>
            </div>
        <%
                }
            }
        %>

    </div>

    <%@ include file="components/footer.html" %>

</body>
</html>
