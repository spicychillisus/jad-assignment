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
<%@page import ="java.sql.*, java.*, java.util.*"%>
<%


String sloganText = "";

// displays randomly upon the page opening
// a ? will be added at the end by default
String[] slogans = {"Feeling Dirty", "Messy Situation"};


// countries
ArrayList<String> countries = new ArrayList<String>();
countries.add("+65");
countries.add("+60");
countries.add("+95");
countries.add("+86");
countries.add("+63");

//placeholders
ArrayList<String> countryNums = new ArrayList<String>(); 
// must follow the phone number format as shown by these placeholders
countryNums.add("9666-6666"); // singapore
countryNums.add("0611111111"); // malaysia
countryNums.add("966666666"); // myanmmar
countryNums.add("56666666"); // china
countryNums.add("782-9992435"); // philippines

try {
	
	String url = "jdbc:postgresql://ep-yellow-sunset-a5h4poax.us-east-2.aws.neon.tech:5432/neondb";
} catch (Exception e) {
	
}
%>

<div class="registration-page-background"> <!-- this is the background -->
	<div class="container pt-10">
		<div class="row">
			<div class="col">
			<%
			for (int k = 0; k < slogans.length; k++) {
				Random random = new Random();
				
				sloganText = slogans[random.nextInt(slogans.length)];
			}
			%>
				<h2 class="montserrat-700"><%= sloganText %>?</h2>
				<span class="inter-500">Engage with us now!</span>
			</div>
			<div class="col-4">
				<!-- form -->
				<div class="border mt-4 rounded bg-white">
		            <div class="mx-4 py-4">
		                <h1 class="d-flex justify-content-center align-items-center px-5 inter-h1 mb-2 inter-700">
		                    Registration
		                </h1>
		                <span class="inter-normal d-flex justify-content-center">Sign up with us to start using our services</span>
		                <form class="inter-normal mt-3">
		                    <div class="form-group inter-normal mb-3">
		                        <input type="text" class="form-control" id="name" placeholder="Name" required>
		                    </div>
		                    <!-- country code and phone number -->
                            <div class="form-group inter-normal mb-3 position-relative">
                                <div class="row">
                                  <div class="col-md-3">
                                    <select id="countryCode" class="form-control" required>
                                        <!--  <option selected>+</option> -->
                                        <%
                                        int i = 0;
                                        int placeholderDisplay = 0;
                                        for (i = 0; i < countries.size(); i++) {
                                        	System.out.println(i);
                                        %>	
                                        	<option value="<%= i %>"><%= countries.get(i) %></option>
                                        <%
                                        	
                                        }
                                        %>
                                    </select>
                                  </div>
                                  <div class="col-md-9">
                                  	<%
                                  	System.out.println(placeholderDisplay);
                                  	%>
                                  	<input type="number" class="form-control" id="phoneNum" placeholder="1111" required>
                                  </div>
                                </div>
                              </div>
                            <!-- email -->
		                    <div class="form-group inter-normal mb-3">
		                        <input type="email" class="form-control" id="email" aria-describedby="emailHelp" placeholder="Email" required>
		                    </div>
		                    <div class="form-group position-relative">
		                        <input type="password" class="form-control w-300" id="password" placeholder="Password" required>
		                        <span class="fa-solid toggle-btn fa-eye" id="eyebox" onclick="togglePassword()"></span>                        
		                    </div>
                            <div class="form-group position-relative mt-3">
		                        <input type="password" class="form-control w-300" id="password" placeholder="Confirm Password" required>
		                        <span class="fa-solid toggle-btn fa-eye" id="eyebox" onclick="togglePassword()"></span>                        
		                    </div>
		                    <div class="d-flex justify-content-center">
		                        <button type="submit" class="btn btn-dark mt-3 inter-500" onclick="login()">Register</button>
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