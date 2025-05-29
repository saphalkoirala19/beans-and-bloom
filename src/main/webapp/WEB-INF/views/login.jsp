<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Bean & Bloom</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        body {
            background-color: #f8f5f2;
            display: flex;
            justify-content: center;
            padding: 40px 20px;
            color: #5a4738;
            overflow-y: auto;
            min-height: 100vh;
        }

        .login-container {
            width: 400px;
            background-color: white;
            border-radius: 12px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.07);
            padding: 40px;
            position: relative;
            overflow: hidden;
        }

        .login-header {
            text-align: center;
            margin-bottom: 30px;
        }

        .login-header h1 {
            color: #5a4738;
            font-size: 24px;
            margin-bottom: 15px;
            font-weight: 400;
        }

        .brand-name {
            font-size: 28px;
            font-weight: 600;
            margin-bottom: 30px;
            color: #5a4738;
        }

        .brand-name span {
            color: #a77c52;
        }

        .form-group {
            margin-bottom: 25px;
        }

        .form-group label {
            display: block;
            color: #5a4738;
            font-size: 14px;
            margin-bottom: 8px;
            font-weight: 500;
        }

        .input-wrapper {
            position: relative;
        }

        .input-field {
            width: 100%;
            background-color: #f8f5f2;
            border: 1px solid #e0d6cc;
            border-radius: 6px;
            padding: 12px 15px;
            font-size: 14px;
            color: #5a4738;
            transition: all 0.3s ease;
        }

        .input-field:focus {
            outline: none;
            border-color: #a77c52;
            box-shadow: 0 0 0 2px rgba(167, 124, 82, 0.2);
        }

        .toggle-password {
            position: absolute;
            top: 50%;
            right: 15px;
            transform: translateY(-50%);
            cursor: pointer;
            cursor: pointer;
            color: #a77c52;
        }

        .login-btn {
            width: 100%;
            background-color: #5a4738;
            color: white;
            border: none;
            border-radius: 6px;
            padding: 12px;
            font-size: 16px;
            font-weight: 500;
            cursor: pointer;
            margin-top: 10px;
            transition: background-color 0.3s;
        }

        .login-btn:hover {
            background-color: #3e3125;
        }

        .forgot-password {
            text-align: right;
            margin-top: 5px;
        }

        .forgot-password a {
            color: #a77c52;
            font-size: 13px;
            text-decoration: none;
        }

        .forgot-password a:hover {
            text-decoration: underline;
        }

        .register-link {
            text-align: center;
            margin-top: 25px;
            color: #5a4738;
            font-size: 14px;
        }

        .register-link a {
            color: #a77c52;
            text-decoration: none;
            font-weight: 500;
        }

        .register-link a:hover {
            text-decoration: underline;
        }

        .benefits {
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #e0d6cc;
            font-size: 14px;
            color: #5a4738;
        }

        .benefits p {
            margin-bottom: 15px;
            font-style: italic;
        }

        .benefits ul {
            list-style-type: none;
        }

        .benefits li {
            margin-bottom: 8px;
            position: relative;
            padding-left: 20px;
        }

        .benefits li:before {
            content: "•";
            color: #a77c52;
            position: absolute;
            left: 0;
        }
    </style>
</head>
<body>
<div class="login-container">
    <div class="login-header">
        <div class="brand-name">Bean & <span>Bloom</span></div>
        <h1>Welcome Back</h1>
        <p>Log in to your Bean & Bloom account</p>
    </div>

    <!-- Show messages -->
    <c:if test="${not empty successMessage}">
        <div class="message success">${successMessage}</div>
    </c:if>
    <c:if test="${not empty errorMessage}">
        <div class="message error">${errorMessage}</div>
    </c:if>

    <form method="post" action="LoginServlet">
        <div class="form-group">
            <label for="email">Email</label>
            <input
                    type="email"
                    id="email"
                    class="input-field"
                    name="email"
                    placeholder="you@example.com"
                    value="${savedEmail != null ? savedEmail : ''}"
                    required>
        </div>

        <div class="form-group">
            <label for="password">Password</label>
            <div class="input-wrapper">
                <input
                        type="password"
                        id="password"
                        class="input-field"
                        name="password"
                        placeholder="Enter your password"
                        required>
                <i id="togglePassword" class="fas fa-eye toggle-password"></i>
            </div>
        </div>

        <div class="remember-me">
            <input type="checkbox" name="remember" id="remember">
            <label for="remember">Remember Me</label>
        </div>

        <input type="submit" class="login-btn" value="Login">
    </form>

    <div class="register-link">
        Don't have an account? <a href="${pageContext.request.contextPath}/RegisterServlet">Register here</a>
    </div>

    <div class="benefits">
        <p>Where Coffee Meets Calm.</p>
        <p>Experience the comfort of your favorite cafe:</p>
        <ul>
            <li>Artisan coffee blends</li>
            <li>Freshly baked pastries</li>
            <li>Cozy atmosphere</li>
            <li>Community events</li>
        </ul>
    </div>
</div>

<script>
    const togglePassword = document.getElementById("togglePassword");
    const passwordInput = document.getElementById("password");

    togglePassword.addEventListener("click", function () {
        const type = passwordInput.getAttribute("type") === "password" ? "text" : "password";
        passwordInput.setAttribute("type", type);
        this.classList.toggle("fa-eye");
        this.classList.toggle("fa-eye-slash");
    });
</script>
</body>
</html>