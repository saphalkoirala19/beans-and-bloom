<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.demo.models.UserModel" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>Edit Profile - Brew and Beans</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-dashboard.css">
    <style>
        /* Additional styles for edit profile page */
        .password-fields {
            margin-top: 2rem;
            padding-top: 1rem;
            border-top: 1px solid #eee;
        }

        .current-image {
            display: flex;
            align-items: center;
            margin-bottom: 1rem;
        }

        .current-image img {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            margin-right: 1rem;
            object-fit: cover;
            border: 3px solid #e0c9a6;
        }

        .form-actions {
            display: flex;
            justify-content: flex-end;
            gap: 1rem;
            margin-top: 1.5rem;
        }

        small {
            display: block;
            margin-top: 0.5rem;
            color: #888;
            font-size: 0.85rem;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: bold;
            color: #555;
        }

        .form-group input[type="text"],
        .form-group input[type="email"],
        .form-group input[type="password"],
        .form-group input[type="file"] {
            width: 100%;
            padding: 0.75rem;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 1rem;
        }

        .form-group input[type="file"] {
            padding: 0.5rem;
        }

        .btn {
            padding: 0.75rem 1.5rem;
            border: none;
            border-radius: 4px;
            font-size: 1rem;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        .btn-primary {
            background-color: #3498db;
            color: white;
        }

        .btn-primary:hover {
            background-color: #2980b9;
        }

        .btn-secondary {
            background-color: #95a5a6;
            color: white;
        }

        .btn-secondary:hover {
            background-color: #7f8c8d;
        }

        .alert {
            padding: 1rem;
            margin-bottom: 1.5rem;
            border-radius: 4px;
            font-weight: bold;
        }

        .alert-success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .alert-error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
    </style>
</head>
<body>
<c:if test="${not empty success}">
    <div class="alert alert-success">
        <p>${success}</p>
    </div>
</c:if>
<c:if test="${not empty error}">
    <div class="alert alert-error">
        <p>${error}</p>
    </div>
</c:if>

<header>
    <h1>Edit Profile</h1>
    <p>Brew and Beans - Cafe Management System</p>
</header>

<div class="container clearfix">
    <div class="sidebar">
        <h2>Admin Menu</h2>
        <div class="menu-item"><a href="${pageContext.request.contextPath}/AdminDashboardServlet">Dashboard</a></div>
        <div class="menu-item"><a href="${pageContext.request.contextPath}/ListItemsServlet">Manage Items</a></div>
        <div class="menu-item"><a href="${pageContext.request.contextPath}/EditAdminProfileServlet" class="active">Profile Settings</a></div>
        <div class="menu-item"><a href="${pageContext.request.contextPath}/LogoutServlet">Logout</a></div>
        <div class="menu-item"><a href="${pageContext.request.contextPath}/view-order">Manage Orders</a></div>
    </div>

    <div class="main-content">
        <div class="card">
            <h2>Edit Your Profile</h2>

            <form action="${pageContext.request.contextPath}/EditAdminProfileServlet" method="post" enctype="multipart/form-data">
                <div class="form-group">
                    <label for="name">Full Name:</label>
                    <input type="text" id="name" name="name" value="${user.name}" required>
                </div>

                <div class="form-group">
                    <label for="email">Email:</label>
                    <input type="email" id="email" name="email" value="${user.email}" required>
                </div>

                <div class="form-group">
                    <label>Profile Picture:</label>
                    <c:if test="${not empty base64Image}">
                        <div class="current-image">
                            <img src="data:image/jpeg;base64,${base64Image}" alt="Profile">
                            <span>Current Photo</span>
                        </div>
                    </c:if>
                    <input type="file" id="profilePicture" name="profilePicture" accept="image/*">
                    <small>Upload a new image (JPG/PNG, max 5MB)</small>
                </div>

                <div class="password-fields">
                    <h3>Change Password</h3>

                    <div class="form-group">
                        <label for="currentPassword">Current Password:</label>
                        <input type="password" id="currentPassword" name="currentPassword">
                    </div>

                    <div class="form-group">
                        <label for="newPassword">New Password:</label>
                        <input type="password" id="newPassword" name="newPassword">
                        <small>Leave blank to keep current password</small>
                    </div>

                    <div class="form-group">
                        <label for="confirmPassword">Confirm New Password:</label>
                        <input type="password" id="confirmPassword" name="confirmPassword">
                    </div>
                </div>

                <div class="form-actions">
                    <a href="${pageContext.request.contextPath}/AdminDashboardServlet" class="btn btn-secondary">Cancel</a>
                    <button type="submit" class="btn btn-primary">Save Changes</button>
                </div>
            </form>
        </div>
    </div>
</div>

<footer>
    <p>&copy; 2025 Brew and Beans - Cafe Management System</p>
</footer>

<script>
    document.querySelector('form').addEventListener('submit', function (e) {
        const newPassword = document.getElementById('newPassword').value;
        const confirmPassword = document.getElementById('confirmPassword').value;
        const currentPassword = document.getElementById('currentPassword').value;

        if (newPassword || confirmPassword || currentPassword) {
            if (!currentPassword) {
                alert('Please enter your current password');
                e.preventDefault();
                return;
            }

            if (!newPassword) {
                alert('Please enter a new password');
                e.preventDefault();
                return;
            }

            if (newPassword.length < 8) {
                alert('Password must be at least 8 characters');
                e.preventDefault();
                return;
            }

            if (newPassword !== confirmPassword) {
                alert('New passwords do not match');
                e.preventDefault();
                return;
            }
        }
    });
</script>
</body>
</html>