<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.demo.models.UserModel" %>
<%@ page import="java.util.Base64" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Edit Profile - Brew & Beans</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-dashboard.css">
    <style>
        /* Overall Layout */
        body {
            display: flex;
            min-height: 100vh;
            margin: 0;
            font-family: Arial, sans-serif;
            background-color: #f5f5f5;
        }

        /* Sidebar - Exactly matching first example */
        .sidebar {
            width: 220px;
            background-color: #f8f9fa;
            padding: 20px;
            position: fixed;
            height: 100%;
            overflow-y: auto;
            box-shadow: 2px 0 5px rgba(0,0,0,0.1);
        }

        .sidebar h2 {
            color: #333;
            font-size: 1.3em;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 1px solid #ddd;
        }

        .menu-item {
            padding: 12px 15px;
            margin-bottom: 5px;
            border-radius: 4px;
            transition: all 0.3s;
        }

        .menu-item:hover {
            background-color: #e9ecef;
        }

        .menu-item a {
            text-decoration: none;
            color: #333;
            display: block;
            font-size: 0.95em;
        }

        /* Main Content Area */
        .main-content {
            margin-left: 240px; /* Sidebar width + padding */
            padding: 20px;
            flex: 1;
        }

        /* Header matching first example */
        /*header {*/
        /*    background-color: #c4d5de;*/
        /*    color: white;*/
        /*    padding: 20px 0;*/
        /*    text-align: center;*/
        /*    margin-bottom: 30px;*/
        /*}*/

        /*header h1 {*/
        /*    margin: 0;*/
        /*    font-size: 2em;*/
        /*}*/

        /*header p {*/
        /*    margin: 5px 0 0;*/
        /*    font-size: 1em;*/
        /*}*/

        /* Form Styling */
        .card {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 25px;
            margin-bottom: 30px;
        }

        .card h2 {
            margin-top: 0;
            color: #333;
            padding-bottom: 15px;
            border-bottom: 1px solid #eee;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: #555;
        }

        .form-group input[type="text"],
        .form-group input[type="email"],
        .form-group input[type="password"],
        .form-group input[type="file"] {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 1em;
        }

        .password-fields {
            margin-top: 2rem;
            padding-top: 1.5rem;
            border-top: 1px solid #eee;
        }

        .password-fields h3 {
            margin-top: 0;
            color: #333;
            font-size: 1.1em;
        }

        .current-image {
            display: flex;
            align-items: center;
            margin-bottom: 15px;
        }

        .current-image img {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            margin-right: 15px;
            object-fit: cover;
            border: 2px solid #eee;
        }

        small {
            display: block;
            margin-top: 5px;
            color: #6c757d;
            font-size: 0.85em;
        }

        /* Buttons */
        .form-actions {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 25px;
            gap: 15px;
        }

        .btn {
            padding: 10px 20px;
            border-radius: 4px;
            text-decoration: none;
            font-weight: 500;
            font-size: 1em;
            cursor: pointer;
            border: none;
            transition: all 0.2s;
        }

        .btn-primary {
            background-color: #3498db;
            color: white;
        }

        .btn-primary:hover {
            background-color: #2980b9;
        }

        .btn-secondary {
            background-color: #6c757d;
            color: white;
        }

        .btn-secondary:hover {
            background-color: #5a6268;
        }

        /* Alerts */
        .alert {
            padding: 15px;
            margin-bottom: 20px;
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

        /* Footer */
        footer {
            background-color: #2c3e50;
            color: white;
            text-align: center;
            padding: 15px 0;
            margin-top: 30px;
        }
    </style>
</head>
<body>



<div class="sidebar">
    <h2>Customer Menu</h2>
    <div class="menu-item"><a href="UserDashboardServlet">Dashboard</a></div>
    <div class="menu-item"><a href="CustomerItemsServlet">Browse Menu</a></div>
    <div class="menu-item"><a href="${pageContext.request.contextPath}/view-order">My Orders</a></div>
    <div class="menu-item"><a href="EditProfileServlet">Profile Settings</a></div>
    <div class="menu-item"><a href="${pageContext.request.contextPath}/LogoutServlet">Logout</a></div>
    <div class="menu-item"><a href="${pageContext.request.contextPath}/AboutUsServlet">About Us</a></div>
    <div class="menu-item"><a href="${pageContext.request.contextPath}/ContactUsServlet">Contact Us</a></div>
</div>

<div class="container">

    <header>
        <h1>Edit User</h1>
        <p>Advanced Programming and Technologies - Itahari International College</p>
    </header>

    <div class="card">
        <a href="AdminDashboardServlet" class="btn">Back to Dashboard</a>

        <form action="UpdateUserServlet" method="post" enctype="multipart/form-data">
            <input type="hidden" name="id" value="${userToEdit.id}">

            <div class="form-group">
                <label for="name">Name:</label>
                <input type="text" id="name" name="name" value="${userToEdit.name}" required>
            </div>

            <div class="form-group">
                <label for="email">Email:</label>
                <input type="email" id="email" name="email" value="${userToEdit.email}" required>
            </div>

            <div class="form-group">
                <label for="role">Role:</label>
                <select id="role" name="role" required>
                    <option value="admin" ${userToEdit.role == 'admin' ? 'selected' : ''}>Admin</option>
                    <option value="user" ${userToEdit.role == 'user' ? 'selected' : ''}>User</option>
                </select>
            </div>

            <div class="form-group">
                <label>Current Profile Picture:</label>
                <img src="data:image/jpeg;base64,${base64Image}" alt="Profile Picture"
                     onerror="this.src='${pageContext.request.contextPath}/assets/images/default-profile.svg'"
                     width="100" height="100">
            </div>

            <div class="form-group">
                <label for="image">Change Profile Picture:</label>
                <input type="file" id="image" name="image" accept="image/*">
            </div>

            <button type="submit" class="btn">Update User</button>
        </form>
    </div>
    <footer>
        <p>&copy; 2025 Brew and Beans - Cafe Management System</p>
    </footer>
</div>

</body>
</html>