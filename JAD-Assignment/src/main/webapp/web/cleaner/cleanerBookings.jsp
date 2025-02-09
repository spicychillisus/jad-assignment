<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, pg.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin - All Bookings</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
</head>
<body>

<nav class="navbar navbar-dark bg-dark">
    <div class="container-fluid d-flex justify-content-end">
	  <a href="../logout.jsp" class="btn btn-warning text-dark">Logout</a>
    </div>
</nav>


<div class="container mt-5">
    <h1 class="text-center">All Bookings</h1>
    <p class="text-center">Manage and view bookings for cleaning services.</p>

    <!-- Filters -->
    <div class="mb-3">
        <label for="filterLocation" class="form-label">Filter by Residential Area Code:</label>
        <input type="text" id="filterLocation" class="form-control" placeholder="Enter area code" onchange="location = '?areaCode=' + this.value">
    </div>

    <div class="mb-3">
        <label for="filterDate" class="form-label">Filter by Date:</label>
        <input type="date" id="filterDate" class="form-control" onchange="location = '?date=' + this.value">
    </div>

    <div class="mb-3">
        <label for="filterService" class="form-label">Filter by Service Type:</label>
        <select id="filterService" class="form-select" onchange="location = '?service=' + this.value">
            <option value="">Select Service</option>
            <% 
                // Fetching available service types from the database
                Config neon = new Config();
                String url = neon.getConnectionUrl();
                String username = neon.getUser();
                String password = neon.getPassword();
                
                try {
                    Class.forName("org.postgresql.Driver");
                    Connection connection = DriverManager.getConnection(url, username, password);
                    String query = "SELECT DISTINCT service_type FROM bookings";
                    PreparedStatement statement = connection.prepareStatement(query);
                    ResultSet resultSet = statement.executeQuery();
                    
                    while (resultSet.next()) {
                        String serviceType = resultSet.getString("service_type");
            %>
            <option value="<%= serviceType %>"><%= serviceType %></option>
            <%
                    }
                    statement.close();
                    connection.close();
                } catch (Exception e) {
                    out.println("<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>");
                }
            %>
        </select>
    </div>

    <div class="row">
        <div class="col">
            <table class="table table-striped">
                <thead>
                    <tr>
                        <th scope="col">ID</th>
                        <th scope="col">Service</th>
                        <th scope="col">User</th>
                        <th scope="col">Phone Number</th>
                        <th scope="col">Email</th>
                        <th scope="col">Booked On</th>
                        <th scope="col">Location</th>	
                        <th scope="col">Action</th>
                    </tr>
                </thead>
                <%
                    // Fetch filters from the request
                    String areaCodeFilter = request.getParameter("areaCode");
                    String dateFilter = request.getParameter("date");
                    String serviceFilter = request.getParameter("service");
                    
                    // Build the query based on filters
                    StringBuilder query = new StringBuilder("SELECT * FROM bookings");

                    boolean firstFilter = true;
                    
                    if (areaCodeFilter != null && !areaCodeFilter.isEmpty()) {
                        query.append(firstFilter ? " WHERE" : " AND").append(" location ILIKE '%").append(areaCodeFilter).append("%'");
                        firstFilter = false;
                    }


                    if (dateFilter != null && !dateFilter.isEmpty()) {
                        query.append(firstFilter ? " WHERE" : " AND").append(" date = '").append(dateFilter).append("'");
                        firstFilter = false;
                    }

                    if (serviceFilter != null && !serviceFilter.isEmpty()) {
                        query.append(firstFilter ? " WHERE" : " AND").append(" service_type = '").append(serviceFilter).append("'");
                        firstFilter = false;
                    }

                    // Query execution
                    try {
                        Config neonConfig = new Config();
                        String dbUrl = neonConfig.getConnectionUrl();
                        String dbUsername = neonConfig.getUser();
                        String dbPassword = neonConfig.getPassword();
                        Connection connection = DriverManager.getConnection(dbUrl, dbUsername, dbPassword);
                        PreparedStatement statement = connection.prepareStatement(query.toString());
                        ResultSet resultSet = statement.executeQuery();

                        while (resultSet.next()) {
                            int id = resultSet.getInt("id");
                            String service_type = resultSet.getString("service_type");
                            String customer_name = resultSet.getString("customer_name");
                            String email = resultSet.getString("email");
                            String phone = resultSet.getString("phone");
                            String date = resultSet.getString("date");
                            String location = resultSet.getString("location");
                %>
                <tbody>
                    <tr>
                        <th scope="row"><%= id %></th>
                        <td><%= service_type %></td>
                        <td><%= customer_name %></td>
                        <td><%= phone %></td>
                        <td><%= email %></td>
                        <td><%= date %></td>
                        <td><%= location %></td>
                        <td>
                         
                            <a href="updateCleanerStatus.jsp?id=<%= id %>" class="btn btn-info btn-sm">Update Status</a>
                        </td>
                    </tr>
                </tbody>
                <% 
                        }

                        statement.close();
                        connection.close();
                    } catch (Exception e) {
                        out.println("<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>");
                    }
                %>
            </table>
        </div>
    </div>
</div>

</body>
</html>
