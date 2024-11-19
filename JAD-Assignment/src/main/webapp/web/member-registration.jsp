<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Member Registration</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
<%@ include file="components/navbar.html" %>
<%@ page import="java.sql.*, java.util.ArrayList, java.util.Random, members.*, pg.*" %>

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
        Class.forName("org.postgresql.Driver");
        Connection conn = DriverManager.getConnection(url, username, password);

        String sql = "INSERT INTO users (name, country_code, phone_number, email, password) VALUES (?, ?, ?, ?, ?)";
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, name);
        pstmt.setString(2, countryCode);
        pstmt.setString(3, phoneNum);
        pstmt.setString(4, email);
        pstmt.setString(5, passwordInput); // Consider hashing this before saving

        int rowsInserted = pstmt.executeUpdate();
        if (rowsInserted > 0) {
            message = "<div class='success-message'>Registration successful! Welcome, " + name + ".</div>";
        }

        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
        message = "<div class='error-message'>Error during registration: " + e.getMessage() + "</div>";
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
                        <form class="inter-normal mt-3" method="post" action="">
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
</body>
</html>
