<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login</title>
    <link rel="stylesheet" href="css/style.css">
    <script src="https://kit.fontawesome.com/a076d05399.js"></script>
</head>
<body>
<%@ include file="components/navbar.html" %>
<%@ page import="java.sql.*, java.util.*, pg.*"%>

<%
String sloganText = "";
String[] slogans = {"Welcome Back!", "Please Log In"};
Random random = new Random();
sloganText = slogans[random.nextInt(slogans.length)];
String message = ""; 

// Database connection details
Config neon = new Config();
String url = neon.getConnectionUrl();
String username = neon.getUser();
String password = neon.getPassword();

// Retrieve user input from the login form
String email = request.getParameter("email");
String passwordInput = request.getParameter("password");

if (email != null && passwordInput != null) {
    try {
        Class.forName("org.postgresql.Driver");
        Connection conn = DriverManager.getConnection(url, username, password);

        // Check if the email matches the admin credentials
        if (email.equals("admin@email.com") && passwordInput.equals("admin")) {
            // Admin login is valid
			session.setAttribute("adminRole", "Admin");
            session.setAttribute("userEmail", email);
            session.setAttribute("userName", "Admin");
            response.sendRedirect(request.getContextPath() + "/web/admin/adminDashboard.jsp");
        } else {
            // SQL query to find a member with the given email
            String sql = "SELECT * FROM users WHERE email = ?";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, email);

            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                // Retrieve stored password hash from database
                String storedPasswordHash = rs.getString("password");

                // Compare entered password with stored hash
                if (passwordInput.equals(storedPasswordHash)) {
                    // If a matching member is found, create session
                    session.setAttribute("userName", rs.getString("name"));           // Store user name
                    session.setAttribute("userEmail", rs.getString("email"));     // Store user email
                    session.setAttribute("userPhone", rs.getString("phone_number"));     // Store user phone
                    session.setAttribute("userRole", "Member");  // Set user role as Member
                    response.sendRedirect("index.jsp");  // Redirect to member's home page
                } else {
                    message = "<div class='error-message'>Invalid email or password. Please try again.</div>";
                }
            } else {
                // If no user found with the email
                message = "<div class='error-message'>User not found. Please check your email or register.</div>";
            }
        }

        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
        message = "<div class='error-message'>Error during login: " + e.getMessage() + "</div>";
    }
}
%>

<div class="registration-page-background">
    <div class="container">
        <div class="row">
            <div class="col">
                <%= message %>
                <h2 class="montserrat-700"><%= sloganText %></h2>
                <span class="inter-500">Access your account!</span>
            </div>
            <div class="col-4">
                <!-- Login Form -->
                <div class="border mt-4 rounded bg-white">
                    <div class="mx-4 py-4">
                        <h1 class="d-flex justify-content-center align-items-center px-5 inter-h1 mb-2">
                            Login Here
                        </h1>
                        <span class="inter-normal text-center">Enter your email and password to continue</span>
                        <form class="inter-normal mt-3" method="post" action="">
                            <div class="form-group inter-normal mb-3">
                                <label for="email" class="w-100">Email address</label>
                                <input type="email" class="form-control" id="email" name="email" placeholder="e.g. user@email.com" required>
                            </div>
                            <div class="form-group position-relative">
                                <label for="password" class="w-100">Password</label>
                                <input type="password" class="form-control w-300" id="password" name="password" placeholder="Password" required>
                                <span class="fa-solid toggle-btn fa-eye" id="eyebox" onclick="togglePassword()"></span>
                            </div>
                            <div class="d-flex justify-content-center">
                                <button type="submit" class="btn btn-dark mt-2 inter-500">Login</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
function togglePassword() {
    var passwordField = document.getElementById("password");
    var eyeIcon = document.getElementById("eyebox");

    if (passwordField.type === "password") {
        passwordField.type = "text";
        eyeIcon.classList.add("fa-eye-slash");
    } else {
        passwordField.type = "password";
        eyeIcon.classList.remove("fa-eye-slash");
    }
}
</script>

<%@ include file="components/footer.html" %>
</body>
</html>