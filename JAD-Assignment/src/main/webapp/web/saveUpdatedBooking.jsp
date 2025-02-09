<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, pg.*" %>

<style>
  /* Feedback Messages */
  .feedback {
    padding: 20px;
    border-radius: 5px;
    font-weight: bold;
    text-align: center;
    margin-top: 20px;
  }

  .feedback.success {
    background-color: #d4edda;
    color: #155724;
    border: 1px solid #c3e6cb;
  }

  .feedback.error {
    background-color: #f8d7da;
    color: #721c24;
    border: 1px solid #f5c6cb;
  }

  /* Back button */
  .btn-back {
    background-color: #6c757d;
    border-color: #6c757d;
    color: white;
    padding: 12px 25px;
    font-size: 16px;
    font-weight: bold;
    text-decoration: none;
    border-radius: 5px;
    display: inline-block;
    transition: background-color 0.3s ease;
    margin-top: 30px;
    width: 100%;
    max-width: 300px;
    text-align: center;
  }

  .btn-back:hover {
    background-color: #5a6268;
    border-color: #4e555b;
  }
</style>

<%
    // Get the form data from the request
    int bookingId = Integer.parseInt(request.getParameter("id"));
    String phone = request.getParameter("phone");
    String date = request.getParameter("date");
    String time = request.getParameter("time");

    // Database connection details
    Config neon = new Config();
    String url = neon.getConnectionUrl();
    String username = neon.getUser();
    String password = neon.getPassword();

    try {
        // Connect to the database
        Class.forName("org.postgresql.Driver");
        Connection connection = DriverManager.getConnection(url, username, password);

        // Check if the 'time' field is empty or invalid
        if (time == null || time.isEmpty()) {
            // Fetch the current time from the database for the booking
            String fetchTimeSql = "SELECT time FROM bookings WHERE id = ?";
            PreparedStatement fetchTimeStatement = connection.prepareStatement(fetchTimeSql);
            fetchTimeStatement.setInt(1, bookingId);
            ResultSet fetchTimeResult = fetchTimeStatement.executeQuery();

            if (fetchTimeResult.next()) {
                time = fetchTimeResult.getTime("time").toString(); // Use the current time from the database
            }
            fetchTimeStatement.close();
        }

        // Ensure the time is in the correct format (HH:mm:ss)
        if (time.length() == 5) { // If time is in HH:mm format
            time += ":00";
        }

        // Update query
        String sql = "UPDATE bookings SET phone = ?, date = ?, time = ? WHERE id = ?";
        PreparedStatement statement = connection.prepareStatement(sql);
        statement.setString(1, phone); // Update phone instead of service_type
        statement.setDate(2, Date.valueOf(date)); // Convert date to SQL Date
        statement.setTime(3, Time.valueOf(time)); // Convert time to SQL Time
        statement.setInt(4, bookingId);

        int rowsUpdated = statement.executeUpdate();

        // Close the connection
        statement.close();
        connection.close();

        // Provide feedback to the user
        if (rowsUpdated > 0) {
%>
            <div class="feedback success">
                Booking updated successfully!
            </div>
<%
        } else {
%>
            <div class="feedback error">
                Failed to update the booking. Booking ID not found.
            </div>
<%
        }
    } catch (Exception e) {
%>
        <div class="feedback error">
            Error: <%= e.getMessage() %>
        </div>
<%
    }
%>

<!-- Back button to return to the previous page -->
<a href="bookings.jsp" class="btn-back">Back to Bookings</a>
