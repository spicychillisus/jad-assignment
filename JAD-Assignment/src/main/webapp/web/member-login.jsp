<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Member Registration</title>
<link rel="stylesheet" href="css/style.css">
</head>
<body>
<%@ include file = "components/navbar.html" %>
<%@page import ="java.sql.*, java.*"%>
<%

String sloganText = "";
sloganText = "im feeling romantical";

// displays randomly upon the page opening
// a ? will be added at the end by default
String[] slogans = {"Feeling Dirty", "Messy Situation"};

%>

<div class="registration-page-background"> <!-- this is the background -->
	<div class="container">
		<div class="row">
			<div class="col">
				<h2><%= sloganText %></h2>
			</div>
			<div class="col-4">
				<!-- form -->
				<div class="border mt-4 rounded bg-white">
		            <div class="mx-4 py-4">
		                <h1 class="d-flex justify-content-center align-items-center px-5 inter-h1 mb-2">
		                    Login Here
		                </h1>
		                <span class="inter-normal text-center">Enter your email and password to continue</span>
		                <form class="inter-normal mt-3">
		                    <div class="form-group inter-normal mb-3">
		                        <label for="email" class="w-100">Email address</label>
		                        <input type="email" class="form-control" id="email" aria-describedby="emailHelp" placeholder="e.g. soda@gmail.com" required>
		                    </div>
		                    <div class="form-group position-relative">
		                        <label for="password" class="w-100">Password</label>
		                        <input type="password" class="form-control w-300" id="password" placeholder="Password" required>
		                        <span class="fa-solid toggle-btn fa-eye" id="eyebox" onclick="togglePassword()"></span>                        
		                    </div>
		                    <div class="d-flex justify-content-center">
		                        <button type="submit" class="btn btn-dark mt-2 inter-500" onclick="login()">Login</button>
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