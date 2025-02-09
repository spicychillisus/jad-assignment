<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%@ include file="../components/admin-navbar.html" %>

<div class="container mt-4">
    <h2>Create Discount</h2>
    <form action="/JAD-Assignment/createDiscount" method="post">
        

        <!-- Discount Code -->
        <div class="mb-3">
            <label for="discountCode" class="form-label">Discount Code</label>
            <input type="text" class="form-control" id="discountCode" name="discountCode" required>
        </div>
        
        <!-- Discount Description -->
        <div class="mb-3">
            <label for="discountDescription" class="form-label">Discount Description</label>
            <input type="text" class="form-control" id="discountName" name="discountDescription" required>
        </div>

        <!-- Discount Percentage -->
        <div class="mb-3">
            <label for="discountAmount" class="form-label">Discount Amount</label>
            <input type="number" class="form-control" id="discountAmount" name="discountAmount" required step="0.01">
        </div>

        <!-- Start Date -->
        <div class="mb-3">
            <label for="startDate" class="form-label">Start Date</label>
            <input type="date" class="form-control" id="startDate" name="startDate" required>
        </div>

        <!-- End Date -->
        <div class="mb-3">
            <label for="endDate" class="form-label">End Date</label>
            <input type="date" class="form-control" id="endDate" name="endDate" required>
        </div>

        <!-- Submit Button -->
        <button type="submit" class="btn btn-primary">Create Discount</button>
    </form>
</div>



<%@ include file="../components/footer.html" %>
</body>
</html>