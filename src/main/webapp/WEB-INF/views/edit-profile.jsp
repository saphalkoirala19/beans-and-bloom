<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.demo.models.UserModel" %>
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

<!-- Sidebar - Exactly matching first example -->
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

<!-- Main Content -->
<div class="main-content">
    <header>
        <h1>Edit Profile</h1>
        <p>Update your personal information at Brew and Beans</p>
    </header>

    <div class="card">
        <h2>Edit Your Profile</h2>

        <% if (request.getSession().getAttribute("success") != null) { %>
        <div class="alert alert-success"><%= request.getSession().getAttribute("success") %></div>
        <% request.getSession().removeAttribute("success"); %>
        <% } %>
        <% if (request.getSession().getAttribute("error") != null) { %>
        <div class="alert alert-error"><%= request.getSession().getAttribute("error") %></div>
        <% request.getSession().removeAttribute("error"); %>
        <% } %>

        <form action="EditProfileServlet" method="post" enctype="multipart/form-data">
            <div class="form-group">
                <label for="name">Full Name:</label>
                <input type="text" id="name" name="name"
                       value="<%= ((UserModel)request.getAttribute("user")).getName() %>" required>
            </div>

            <div class="form-group">
                <label for="email">Email:</label>
                <input type="email" id="email" name="email"
                       value="<%= ((UserModel)request.getAttribute("user")).getEmail() %>" required>
            </div>

            <div class="form-group">
                <label>Profile Picture:</label>
                <% if (request.getAttribute("base64Image") != null) { %>
                <div class="current-image">
                    <img src="data:image/jpeg;base64,<%= request.getAttribute("base64Image") %>" alt="Profile">
                    <span>Current Photo</span>
                </div>
                <% } %>
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
                <button type="submit" class="btn btn-primary">Save Changes</button>
                <a href="UserDashboardServlet" class="btn btn-secondary">Cancel</a>
            </div>
        </form>
    </div>

    <footer>
        <p>&copy; 2025 Brew and Beans - Cafe Management System</p>
    </footer>
</div>

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