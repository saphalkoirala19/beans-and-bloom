<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - Bean & Bloom</title>
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

        .register-container {
            width: 450px;
            background-color: white;
            border-radius: 12px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.07);
            padding: 40px;
            position: relative;
            overflow: hidden;
        }

        .register-header {
            text-align: center;
            margin-bottom: 30px;
        }

        .register-header h1 {
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

        select.input-field {
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='16' height='16' viewBox='0 0 24 24' fill='none' stroke='%235a4738' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3E%3Cpath d='M6 9l6 6 6-6'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 15px center;
            padding-right: 40px;
        }

        .toggle-password {
            position: absolute;
            top: 50%;
            right: 15px;
            transform: translateY(-50%);
            cursor: pointer;
            color: #a77c52;
        }

        .register-btn {
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

        .register-btn:hover {
            background-color: #3e3125;
        }

        .login-link {
            text-align: center;
            margin-top: 25px;
            color: #5a4738;
            font-size: 14px;
        }

        .login-link a {
            color: #a77c52;
            text-decoration: none;
            font-weight: 500;
        }

        .login-link a:hover {
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

        .image-preview-container {
            margin-top: 15px;
            text-align: center;
        }

        .image-preview {
            width: 120px;
            height: 120px;
            object-fit: cover;
            border-radius: 50%;
            border: 2px solid #e0d6cc;
            margin-top: 10px;
            transition: transform 0.3s ease;
        }

        .image-preview:hover {
            transform: scale(1.05);
        }

        .preview-text {
            font-size: 13px;
            color: #5a4738;
            opacity: 0.7;
            margin-top: 6px;
        }

        .error-alert {
            background-color: #f8d7da;
            padding: 10px;
            border: 1px solid #f5c2c7;
            color: #842029;
            border-radius: 4px;
            margin-bottom: 20px;
        }

        input[type="file"] {
            padding: 10px;
        }
    </style>
</head>
<body>
<div class="register-container">


    <div class="register-header">
        <div class="brand-name">Bean & <span>Bloom</span></div>
        <h1>Create Account</h1>
        <p>Join the Bean & Bloom community</p>
    </div>

    <% if(request.getAttribute("errorMessage") != null) { %>
    <div class="error-alert">
        <%= request.getAttribute("errorMessage") %>
    </div>
    <% } %>

    <form id="registerForm" action="RegisterServlet" method="post" enctype="multipart/form-data">
        <div class="form-group">
            <label for="name">Full Name</label>
            <input type="text" id="name" name="name" class="input-field" required>
        </div>

        <div class="form-group">
            <label for="email">Email</label>
            <input type="email" id="email" name="email" class="input-field" required>
        </div>

        <div class="form-group">
            <label for="password">Password</label>
            <div class="input-wrapper">
                <input type="password" id="password" name="password" class="input-field" required>
                <i class="fas fa-eye toggle-password" id="togglePassword"></i>
            </div>
        </div>

        <div class="form-group">
            <label for="confirm-password">Confirm Password</label>
            <div class="input-wrapper">
                <input type="password" id="confirm-password" name="confirm-password" class="input-field" required>
                <i class="fas fa-eye toggle-password" id="toggleConfirmPassword"></i>
            </div>
        </div>

        <div class="form-group">
            <label for="role">Role</label>
            <select id="role" name="role" class="input-field" required>
                <option value="user">Customer</option>
                <option value="admin">Administrator</option>
            </select>
        </div>

        <div class="form-group">
            <label for="image">Profile Picture</label>
            <input type="file" id="image" name="image" accept="image/*" class="input-field" onchange="previewImage(event)">
            <div class="image-preview-container">
                <img id="imagePreview" class="image-preview" src="${pageContext.request.contextPath}/assets/images/img.png" alt="Image Preview">
                <p class="preview-text">Upload an image to change the default profile picture</p>
            </div>
        </div>

        <button type="submit" class="register-btn">Register</button>
    </form>

    <div class="login-link">
        <p>Already have an account? <a href="./LoginServlet">Login here</a></p>
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
    function togglePassword(inputId, toggleId) {
        const input = document.getElementById(inputId);
        const toggle = document.getElementById(toggleId);
        const isPassword = input.type === "password";
        input.type = isPassword ? "text" : "password";
        toggle.classList.toggle("fa-eye");
        toggle.classList.toggle("fa-eye-slash");
    }

    document.getElementById("togglePassword").addEventListener("click", function () {
        togglePassword("password", "togglePassword");
    });

    document.getElementById("toggleConfirmPassword").addEventListener("click", function () {
        togglePassword("confirm-password", "toggleConfirmPassword");
    });

    function previewImage(event) {
        const reader = new FileReader();
        reader.onload = function () {
            const output = document.getElementById('imagePreview');
            output.src = reader.result;
        };
        reader.readAsDataURL(event.target.files[0]);
    }
</script>
</body>
</html>