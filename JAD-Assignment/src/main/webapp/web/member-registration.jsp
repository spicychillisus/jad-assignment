<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Member Registration</title>
    <link rel="stylesheet" href="css/style.css">
    <script>
        // Function to validate the form before submission
        function validateForm() {
            // Clear any previous error messages
            const errorContainer = document.getElementById("passwordError");
            errorContainer.innerHTML = ""; // Clear the error message

            const password = document.forms["registrationForm"]["password"].value;
            const confirmPassword = document.forms["registrationForm"]["confirmPassword"].value;

            if (password !== confirmPassword) {
                errorContainer.innerHTML = "<div class='error-message'>Password and Confirm Password do not match.</div>";
                return false; // Prevent form submission
            }

            return true; // Allow form submission
        }
    </script>
</head>
<body>
<%@ include file="components/navbar.html" %>
<%@ page import="java.sql.*, java.util.ArrayList, java.util.Random, java.util.regex.*, members.*, pg.*" %>

<%
String sloganText = "";
String[] slogans = {"Feeling Dirty", "Messy Situation"};
Random random = new Random();
sloganText = slogans[random.nextInt(slogans.length)];

ArrayList<String> countries = new ArrayList<>();
countries.add("+65");
countries.add("+60");
countries.add("+95");
countries.add("+86");
countries.add("+63");

Config neon = new Config();
String url = neon.getConnectionUrl();
String username = neon.getUser();
String password = neon.getPassword();

String message = ""; // Message to display

String name = request.getParameter("name");
String countryCode = request.getParameter("countryCode");
String phoneNum = request.getParameter("phoneNum");
String email = request.getParameter("email");
String passwordInput = request.getParameter("password");

if (name != null && countryCode != null && phoneNum != null && email != null && passwordInput != null) {
    try {
        // Validate username for special characters
        Pattern pattern = Pattern.compile("^[a-zA-Z0-9 ]+$");
        Matcher matcher = pattern.matcher(name);
        if (!matcher.matches()) {
            message = "<div class='error-message'>Invalid username: Special characters are not allowed.</div>";
        } else {
            // Proceed with database operations
            Class.forName("org.postgresql.Driver");
            Connection conn = DriverManager.getConnection(url, username, password);

            // Check if the phone number is already registered
            String checkPhoneSql = "SELECT COUNT(*) FROM users WHERE phone_number = ?";
            PreparedStatement checkPhoneStmt = conn.prepareStatement(checkPhoneSql);
            checkPhoneStmt.setString(1, phoneNum);
            ResultSet rs = checkPhoneStmt.executeQuery();
            rs.next();
            int phoneCount = rs.getInt(1);

            if (phoneCount > 0) {
                message = "<div class='error-message'>The phone number <strong>" + phoneNum + "</strong> is already associated with another account. Please use a different phone number.</div>";
            } else {
                // Insert new user
                String sql = "INSERT INTO users (name, country_code, phone_number, email, password) VALUES (?, ?, ?, ?, ?)";
                PreparedStatement pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, name);
                pstmt.setString(2, countryCode);
                pstmt.setString(3, phoneNum);
                pstmt.setString(4, email);
                pstmt.setString(5, passwordInput); // Consider hashing this before saving

                int rowsInserted = pstmt.executeUpdate();
                if (rowsInserted > 0) {
                    // Store user email and name in session
                    session.setAttribute("userEmail", email);
                    session.setAttribute("userName", name); // Store user's name

                    message = "<div class='success-message'>Registration successful! Welcome, " + name + ".</div>";
                    
                    // Redirect to index.jsp after successful registration
                    response.sendRedirect("index.jsp");
                    return;
                }
            }
            conn.close();
        }
    } catch (SQLException e) {
        e.printStackTrace();

        // Check for unique constraint violations (e.g., email uniqueness)
        if ("23505".equals(e.getSQLState())) {
            message = "<div class='error-message'>The email address <strong>" + email + "</strong> is already registered. Please use a different email or log in.</div>";
        } else {
            message = "<div class='error-message'>An unexpected error occurred during registration. Please try again later.</div>";
        }
    } catch (Exception e) {
        e.printStackTrace();
        message = "<div class='error-message'>An unexpected error occurred. Please try again later.</div>";
    }
}
%>

<div class="registration-page-background">
    <div class="container pt-10">
        <div class="row">
            <div class="col">
                <%-- Display success or error message here --%>
                <%= message %>
                <h2 class="montserrat-700"><%= sloganText %>?</h2>
                <span class="inter-500">Engage with us now!</span>
            </div>
            <div class="col-4">
                <div class="border mt-4 rounded bg-white">
                    <div class="mx-4 py-4">
                        <h1 class="d-flex justify-content-center align-items-center px-5 inter-h1 mb-2 inter-700">
                            Registration
                        </h1>
                        <span class="inter-normal d-flex justify-content-center">
                            Sign up with us to start using our services
                        </span>
                        <form name="registrationForm" class="inter-normal mt-3" method="post" action="" onsubmit="return validateForm()">
                            <div class="form-group inter-normal mb-3">
                                <input type="text" class="form-control" name="name" placeholder="Name" required>
                            </div>
                            <div class="form-group inter-normal mb-3 position-relative">
                                <div class="row">
                                    <div class="col-md-3">
                                        <select name="countryCode" class="form-control" required>
                                            <% for (String country : countries) { %>
                                                <option value="<%= country %>"><%= country %></option>
                                            <% } %>
                                        </select>
                                    </div>
                                    <div class="col-md-9">
                                        <input type="text" class="form-control" name="phoneNum" placeholder="Phone Number" required>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group inter-normal mb-3">
                                <input type="email" class="form-control" name="email" placeholder="Email" required>
                            </div>
                            <div class="form-group position-relative">
                                <input type="password" class="form-control" name="password" placeholder="Password" required>
                            </div>
                            <div class="form-group position-relative mt-3">
                                <input type="password" class="form-control" name="confirmPassword" placeholder="Confirm Password" required>
                            </div>
                            
                            <!-- Password Mismatch Error Message -->
                            <div id="passwordError" class="mb-3"></div>

                            <div class="d-flex justify-content-center">
                                <button type="submit" class="btn btn-dark mt-3 inter-500">Register</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
    <%@ include file="components/footer.html" %>
</body>
</html>
