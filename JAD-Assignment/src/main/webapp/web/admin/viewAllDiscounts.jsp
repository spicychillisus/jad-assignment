<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>All Discounts</title>
</head>
<body>
<%@ include file="../components/admin-navbar.html" %>
<%@ page import="java.sql.*, java.util.*, admin.*, pg.*, services.*, discount.Discount, java.util.stream.*" %>

<div class="container">
	<div class="text-center">
		<h1>Discounts</h1>
		<p>All discount codes available.</p>
	</div>
	<form>
	</form>
	<table class="table">
	  <thead>
	    <tr>
	      <th scope="col">id</th>
	      <th scope="col">Discount Code</th>
	      <th scope="col">Discount Price</th>
	      <th scope="col">Description</th>
			<th scope="col">
			  <select class="form-select">
			    <option selected disabled>Start Usage</option>
			    <option value="option1">Option 1</option>
			    <option value="option2">Option 2</option>
			    <option value="option3">Option 3</option>
			  </select>
			</th>
	      <th scope="col">End Usage</th>
	      <th scope="col">View Users</th>
	    </tr>
	  </thead>
	  <tbody>
	  <%
	  	
	  if (session.getAttribute("adminRole") == null || !session.getAttribute("adminRole").equals("Admin")) {
          response.sendRedirect("../login.jsp");
          return; // Stop further processing if not logged in as admin
      }
	  
	  @SuppressWarnings("unchecked")
	  ArrayList<Discount> discountList = (ArrayList<Discount>) request.getAttribute("discountList");
	  System.out.println(discountList);
	  if (discountList != null) {
		  for (Discount discount : discountList) {
		      int discountId = discount.getId();
			  String discountCode = discount.getCode();
			  Double discountValue = discount.getDiscountValue();
			  String description = discount.getDescription();
			  Timestamp startUsage = discount.getStartDate();
			  Timestamp endUsage = discount.getEndDate();
			  
			  String discountDisplay = Double.toString(discountValue) + "%";
	%>
	  <tr>
	  	<th scope="row"><%= discountId %></th>
	      <td><%= discountCode %></td>
	      <td><%= discountDisplay %></td>
	      <td><%= description %></td>
	      <td><%= startUsage %></td>
	      <td><%= endUsage %></td>
	      <td><a href="viewDiscountOwners.jsp?id=<%= discountId %>"><button type="button" class="btn btn-info">View Users</button></a></td>
	   </tr>
	  <%
		  }
	  } 
	  %>

	  </tbody>
	</table>
</div>
</body>
</html>
