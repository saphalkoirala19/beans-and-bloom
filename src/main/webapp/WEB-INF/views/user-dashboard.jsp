<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.demo.models.UserModel" %>
<%
    UserModel user = (UserModel) request.getAttribute("user");
    String base64Image = (String) request.getAttribute("base64Image");
%>
<html>
<head>
    <title>Customer Dashboard -Beans & Bloom</title>
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
            margin-left: 240px;
            flex: 1;
            display: flex;
            flex-direction: column;
        }

        /*header {*/
        /*    background-color: #c4d5de;*/
        /*    color: white;*/
        /*    padding: 20px 0;*/
        /*    text-align: center;*/
        /*    margin-bottom: 30px;*/
        /*    width: 100%;*/
        /*}*/

        /*header h1 {*/
        /*    margin: 0;*/
        /*    font-size: 2em;*/
        /*}*/

        /*header p {*/
        /*    margin: 5px 0 0;*/
        /*    font-size: 1em;*/
        /*}*/

        .container {
            padding: 20px;
            max-width: 1200px;
            margin: 0 auto;
            width: 100%;
        }

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

        .admin-profile {
            display: flex;
            align-items: center;
            gap: 30px;
        }

        .profile-image img {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid #e0c9a6;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .profile-details p {
            margin: 10px 0;
            font-size: 1em;
        }

        .profile-details strong {
            color: #555;
            display: inline-block;
            width: 80px;
        }

        .welcome-section {
            display: flex;
            align-items: center;
            gap: 40px;
            background-color: #f9f5f0;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }

        .frame-group {
            display: flex;
            gap: 20px;
        }

        .coffee-cup-frame {
            width: 120px;
            height: 180px;
            border-radius: 60px 60px 0 0;
            border: 4px solid #e0c9a6;
            overflow: hidden;
            background: #fff;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            position: relative;
        }

        .coffee-cup-frame img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .coffee-cup-frame::after {
            content: '';
            position: absolute;
            top: 20px;
            right: -15px;
            width: 20px;
            height: 40px;
            border: 3px solid #e0c9a6;
            border-left: none;
            border-radius: 0 20px 20px 0;
            background: #f9f5f0;
        }

        .welcome-message {
            flex: 1;
        }

        .welcome-message h2 {
            color: #5a3921;
            margin-bottom: 15px;
            font-size: 1.8em;
        }

        .welcome-message p {
            color: #6c757d;
            line-height: 1.6;
            font-size: 1.05em;
        }

        /*footer {*/
        /*    background-color: #2c3e50;*/
        /*    color: white;*/
        /*    text-align: center;*/
        /*    padding: 15px 0;*/
        /*    margin-top: 30px;*/
        /*}*/

    </style>
</head>
<body>

<!-- Sidebar -->
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
    <header >
        <h1>Welcome back, <%= user.getName() %> ☕</h1>
        <p>Your personalized coffee space at <strong>Brew & Beans</strong></p>
    </header>

    <div class="container">
        <!-- Profile Section -->
        <div class="card" style="background-color: #fffdf9;">
            <h2>Your Profile</h2>
            <div class="admin-profile">
                <div class="profile-image">
                    <img src="data:image/jpeg;base64,<%= base64Image %>" alt="Profile Picture">
                </div>
                <div class="profile-details">
                    <p><strong>Name:</strong> <%= user.getName() %></p>
                    <p><strong>Email:</strong> <%= user.getEmail() %></p>
                </div>
            </div>
        </div>

        <!-- Welcome Message Section -->
        <div class="card welcome-section" style="background-color: #fffaf4;">
<%--            <div class="frame-group">--%>
<%--                <div class="coffee-cup-frame">--%>
<%--                    <img src="${pageContext.request.contextPath}/assets/images/coffee-cup.jpg" alt="Coffee Cup">--%>
<%--                </div>--%>
<%--            </div>--%>
            <div class="welcome-message">
                <h2>Hey <%= user.getName().split(" ")[0] %>, fancy a coffee break?</h2>
                <p>We’re thrilled to have you back! Explore our menu, track your orders, or enjoy the aromas of your favorite brews right here on your dashboard.</p>
                <p style="margin-top: 15px; font-style: italic; color: #7c5c42;">“Coffee is a language in itself.” – Jackie Chan</p>
            </div>
        </div>

        <!-- Explore Menu CTA -->
        <div class="card" style="text-align: center; background-color: #f9f5f0;">
            <h2>Ready for your next sip?</h2>
            <p>Browse our handpicked drinks and seasonal specials crafted just for you.</p>
            <a href="CustomerItemsServlet" style="display: inline-block; margin-top: 15px; padding: 10px 25px; background-color: #a9744f; color: white; text-decoration: none; border-radius: 25px; font-weight: bold; transition: background-color 0.3s;">
                Browse Menu
            </a>
        </div>
    </div>

    <footer>
        <p>&copy; 2025Beans & Bloom - Crafted with ❤️ for coffee lovers</p>
    </footer>
</div>


</body>
</html>
