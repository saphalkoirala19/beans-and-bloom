<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bean & Bloom</title>
    <link rel="stylesheet" href="./assets/css/index.css"> <%-- Adjust path as needed --%>
</head>
<body>
<header> 
    <h1>Bean & Bloom</h1>
</header>

<div class="container">
    <div class="role-selection">
        <div class="side-image-left"></div>
        <div class="side-image-right"></div>
        <h2>Welcome to Bean & Bloom</h2>
        <p>Please select your option to continue</p>

        <div class="role-cards">
            <div class="role-card" id="customer-card">
                <div class="role-icon">☕</div>
                <h3>Welcome Back</h3>
                <p>Access your account to place orders and view your favorites</p>
                <a href="./LoginServlet?role=customer" class="role-btn">Sign In</a>
            </div>

            <div class="role-card" id="register-card">
                <div class="role-icon">📝</div>
                <h3>New User?</h3>
                <p>Create a new account to start ordering from Bean & Bloom</p>
                <a href="./RegisterServlet" class="role-btn">Register Now</a>
            </div>
        </div>
    </div>
</div>

<footer>
    <p>&copy; 2025 Bean & Bloom</p>
</footer>

<script>
    document.getElementById('customer-card').addEventListener('click', function(e) {
        if (!e.target.classList.contains('role-btn')) {
            window.location.href = './LoginServlet?role=customer';
        }
    });

    document.getElementById('register-card').addEventListener('click', function(e) {
        if (!e.target.classList.contains('role-btn')) {
            window.location.href = './RegisterServlet';
        }
    });
</script>
</body>
</html>