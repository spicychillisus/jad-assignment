<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Profile</title>
    <link rel="stylesheet" href="css/style.css">
    
    <script>
        // Function to validate the form before submission
        function validateEditForm() {
            const errorContainer = document.getElementById("passwordError");
            errorContainer.innerHTML = ""; // Clear any previous error messages

            const form = document.forms["editProfileForm"];
            const password = form["password"].value;
            const confirmPassword = form["confirmPassword"].value;
            const phoneNum = form["phoneNum"].value;
            const countryCode = form["countryCode"].value;

            // Password validation: Make sure password is not blank if the user wants to change it
            if (password !== "" && password !== confirmPassword) {
                errorContainer.innerHTML = "<div class='error-message'>Password and Confirm Password do not match.</div>";
                return false;
            }

            if (password === "") {
                errorContainer.innerHTML = "<div class='error-message'>Password cannot be blank.</div>";
                return false;
            }

            // Phone number validation
            const phoneRegex = /^[1-9][0-9]{6,11}$/; // Assuming 7-12 digit valid numbers (excluding leading 0)
            if (!phoneRegex.test(phoneNum)) {
                errorContainer.innerHTML = "<div class='error-message'>Invalid phone number: Must contain 7-12 digits without leading zeros.</div>";
                return false;
            }

            // Valid country-code-based checks (e.g., length)
            const countryPhoneLengths = {
                "+65": 8, // Singapore
                "+60": 9, // Malaysia
                "+95": 10, // Myanmar
                "+86": 11, // China
                "+63": 10  // Philippines
            };

            if (countryPhoneLengths[countryCode] && phoneNum.length !== countryPhoneLengths[countryCode]) {
                errorContainer.innerHTML = `<div class='error-message'>Invalid phone number: Expected ${countryPhoneLengths[countryCode]} digits for ${countryCode}.</div>`;
                return false;
            }

            return true;
        }

        // Function to update the password asterisks based on the current password
        function updatePasswordAsterisks(password) {
            const passwordField = document.getElementById("passwordDisplay");
            const asterisks = "*".repeat(password.length); // Generate asterisks based on password length
            passwordField.innerHTML = asterisks || "***"; // Default to *** if password is empty
        }
    </script>
</head>
<body>
<%@ include file="components/navbar.html" %>
  <%@ page import="java.sql.*, java.util.ArrayList, java.util.HashMap, java.util.Random, java.util.regex.*, pg.*" %>

<%
String message = ""; // Message to display
String userEmail = (String) session.getAttribute("userEmail");
if (session != null) {
	session.removeAttribute("discountCode");
	session.removeAttribute("discountValue");
}

if (userEmail == null) {
    response.sendRedirect("login.jsp");
    return;
}

String name = "";
String email = "";
String countryCode = "";
String phoneNum = "";
String password = "";

// Check if form is submitted
if ("POST".equalsIgnoreCase(request.getMethod())) {
    String newName = request.getParameter("name");
    String newPhoneNum = request.getParameter("phoneNum");
    String newCountryCode = request.getParameter("countryCode");
    String newPassword = request.getParameter("password");

    try {
        // Update the profile in the database
        Config neon = new Config();
        String url = neon.getConnectionUrl();
        String username = neon.getUser();
        String dbPassword = neon.getPassword();

        Class.forName("org.postgresql.Driver");
        Connection conn = DriverManager.getConnection(url, username, dbPassword);

        // SQL query to update profile
        String updateSql = "UPDATE users SET name = ?, country_code = ?, phone_number = ?, password = ? WHERE email = ?";
        PreparedStatement pstmt = conn.prepareStatement(updateSql);
        pstmt.setString(1, newName);
        pstmt.setString(2, newCountryCode);
        pstmt.setString(3, newPhoneNum);

        // Only set new password if it's not empty, otherwise use the old password
        String finalPassword = newPassword.isEmpty() ? password : newPassword;
        pstmt.setString(4, finalPassword);

        pstmt.setString(5, userEmail);
        
        int rowsUpdated = pstmt.executeUpdate();

        if (rowsUpdated > 0) {
            message = "<div class='success-message'>Profile updated successfully!</div>";
            name = newName;
            countryCode = newCountryCode;
            phoneNum = newPhoneNum;
            password = finalPassword; // Update password with the final value (either new or current)
        } else {
            message = "<div class='error-message'>An error occurred while updating your profile. Please try again later.</div>";
        }

        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
        message = "<div class='error-message'>An error occurred while updating your profile. Please try again later.</div>";
    }
} else {
    try {
        // Fetch user details (if the form hasn't been submitted yet)
        Config neon = new Config();
        String url = neon.getConnectionUrl();
        String username = neon.getUser();
        String dbPassword = neon.getPassword();

        Class.forName("org.postgresql.Driver");
        Connection conn = DriverManager.getConnection(url, username, dbPassword);

        String sql = "SELECT name, email, country_code, phone_number, password FROM users WHERE email = ?";
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, userEmail);
        ResultSet rs = pstmt.executeQuery();

        if (rs.next()) {
            name = rs.getString("name");
            email = rs.getString("email");
            countryCode = rs.getString("country_code");
            phoneNum = rs.getString("phone_number");
            password = rs.getString("password");
        }
        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
        message = "<div class='error-message'>An error occurred while fetching your profile. Please try again later.</div>";
    }
}
%>

<div class="container pt-10">
    <div class="row">
        <div class="col">
            <%-- Display success or error message here --%>
            <%= message %>
            <h2>Edit Profile</h2>
            <form name="editProfileForm" class="mt-3" method="post" action="editProfile.jsp" onsubmit="return validateEditForm()">
                <div class="form-group">
                    <label for="name">Name:</label>
                    <input type="text" class="form-control" name="name" value="<%= name %>" required>
                </div>
                <div class="form-group">
                    <label for="email">Email:</label>
                    <input type="email" class="form-control" name="email" value="<%= email %>" disabled required>
                </div>
                <div class="form-group">
                    <label for="phoneNum">Phone Number:</label>
                    <div class="row">
                        <div class="col-md-3">
                            <select name="countryCode" class="form-control" required>
                                <% for (String country : new String[]{"+65", "+60", "+95", "+86", "+63"}) { %>
                                    <option value="<%= country %>" <%= country.equals(countryCode) ? "selected" : "" %>><%= country %></option>
                                <% } %>
                            </select>
                        </div>
                        <div class="col-md-9">
                            <input type="text" class="form-control" name="phoneNum" value="<%= phoneNum %>" required>
                        </div>
                    </div>
                </div>
                <div class="form-group">
                    <label for="password">Password:</label>
                    <input type="password" class="form-control" name="password" value="" required oninput="updatePasswordAsterisks(this.value)">
                    <small>If you want to change the password, please enter a new password.</small>
                </div>
                <div class="form-group">
                    <label for="confirmPassword">Confirm New Password:</label>
                    <input type="password" class="form-control" name="confirmPassword" value="" placeholder="Type current password if changing other details">
                    <div id="passwordError"></div>
                </div>
                <div class="form-group">
                    <button type="submit" class="btn btn-primary">Update Profile</button>
                </div>
            </form>
        </div>
    </div>
</div>

<%@ include file="components/footer.html" %>

</body>
</html>
