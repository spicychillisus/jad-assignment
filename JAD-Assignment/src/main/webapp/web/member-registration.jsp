<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Member Registration</title>
<link rel="stylesheet" href="css/style.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
</head>
<body>

<%

%>
<div class="d-flex align-items-center justify-content-center">
        <!-- form -->
        <div class="border mt-4 rounded">
            <div class="mx-4 py-4">
                <h1 class="d-flex justify-content-center align-items-center px-5 inter-h1 mb-2">
                    Login Here
                </h1>
                <span class="inter-normal">Enter your email and password to continue</span>
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
    
<script>
function togglePassword() {
    const password = document.getElementById('password');
    const toggleButton = document.getElementById('eyebox');

    console.log(toggleButton)

    if (password.type === 'password') {
        password.type = 'text';
        toggleButton.classList.remove('fa-eye')
        toggleButton.classList.add('fa-eye-slash')
    } else {
        password.type = 'password';
        toggleButton.classList.add('fa-eye')
        toggleButton.classList.remove('fa-eye-slash')
    }
  }
</script>
</body>
</html>