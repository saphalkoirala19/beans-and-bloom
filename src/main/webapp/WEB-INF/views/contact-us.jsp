<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Contact Us -Beans & Bloom</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-dashboard.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f5f5f5;
            margin: 0;
            padding: 0;
            color: #333;
        }

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

        .main-content {
            margin-left: 240px;
            padding: 40px;
            min-height: calc(100vh - 60px);
        }

        .container {
            max-width: 1000px;
            background: #fff;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            padding: 40px;
            margin-bottom: 40px;
        }

        h2 {
            color: #5a3921;
            font-size: 2.2rem;
            margin-bottom: 20px;
            position: relative;
        }

        h2:after {
            content: '';
            display: block;
            width: 60px;
            height: 4px;
            background: #a9744f;
            margin-top: 10px;
            border-radius: 2px;
        }

        p {
            color: #555;
            line-height: 1.8;
            font-size: 1.05rem;
        }

        .contact-details {
            margin-top: 30px;
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 30px;
        }

        .contact-card {
            background: #fffaf4;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.05);
            transition: transform 0.3s, box-shadow 0.3s;
        }

        .contact-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }

        .contact-card i {
            font-size: 2rem;
            color: #a9744f;
            margin-bottom: 15px;
        }

        .contact-card h3 {
            color: #5a3921;
            margin: 10px 0;
        }

        .highlight {
            color: #a9744f;
            font-weight: bold;
        }

        .contact-form {
            margin-top: 40px;
            background: #fffaf4;
            padding: 30px;
            border-radius: 10px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #5a3921;
            font-weight: 500;
        }

        .form-group input,
        .form-group textarea {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-family: inherit;
            font-size: 1rem;
            transition: border 0.3s;
        }

        .form-group input:focus,
        .form-group textarea:focus {
            border-color: #a9744f;
            outline: none;
        }

        .form-group textarea {
            min-height: 150px;
            resize: vertical;
        }

        .submit-btn {
            background: #a9744f;
            color: white;
            border: none;
            padding: 12px 25px;
            border-radius: 6px;
            cursor: pointer;
            font-size: 1rem;
            transition: background 0.3s;
        }

        .submit-btn:hover {
            background: #8a5d3f;
        }

        .map-container {
            margin-top: 40px;
            height: 300px;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
        }

        .map-container iframe {
            width: 100%;
            height: 100%;
            border: none;
        }

        footer {
            background-color: #2c3e50;
            color: white;
            text-align: center;
            padding: 20px 0;
            position: relative;
            width: 100%;
            margin-top: 40px;
        }

        footer p {
            color: white;
        }

        .social-links {
            margin-top: 30px;
        }

        .social-links a {
            display: inline-block;
            margin: 0 10px;
            color: #5a3921;
            font-size: 1.5rem;
            transition: color 0.3s;
        }

        .social-links a:hover {
            color: #a9744f;
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

<div class="main-content">
    <header>
        <h2>Contact Us</h2>
        <p>We'd love to hear from you! Whether it's feedback, inquiries, or you just want to say hello, our virtual coffee shop is always open. Our team is dedicated to providing you with the best service and will respond to your message within 24 hours.</p>
    </header>

    <div class="container">
        <div class="contact-details">
            <div class="contact-card">
                <i class="fas fa-envelope"></i>
                <h3>Email Us</h3>
                <p>For general inquiries and feedback</p>
                <p class="highlight">contact@brewandbeans.com</p>
            </div>

            <div class="contact-card">
                <i class="fas fa-phone-alt"></i>
                <h3>Call Us</h3>
                <p>Available during support hours</p>
                <p class="highlight">+977-9876543210</p>
            </div>

            <div class="contact-card">
                <i class="fas fa-map-marker-alt"></i>
                <h3>Visit Us</h3>
                <p>Come enjoy our cozy atmosphere</p>
                <p class="highlight">Itahari, Nepal</p>
            </div>

            <div class="contact-card">
                <i class="fas fa-clock"></i>
                <h3>Hours</h3>
                <p>We're here for you</p>
                <p class="highlight">9 AM – 6 PM (Mon to Sat)</p>
            </div>
        </div>


        <div class="social-links">
            <p>Connect with us on social media</p>
            <a href="#"><i class="fab fa-facebook"></i></a>
            <a href="#"><i class="fab fa-instagram"></i></a>
            <a href="#"><i class="fab fa-twitter"></i></a>
            <a href="#"><i class="fab fa-tiktok"></i></a>
        </div>

        <div class="map-container">
            <div class="map-container">

                <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3560.328620068761!2d87.2993729!3d26.6554085!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x39ef6ea070e7b18b%3A0x2959e2a3e2bf54e0!2sItahari%20International%20College!5e0!3m2!1sen!2snp!4v1712345678901!5m2!1sen!2snp"
                        allowfullscreen="" loading="lazy"
                        referrerpolicy="no-referrer-when-downgrade"></iframe>
            </div>
        </div>
    </div>
</div>

<footer>
    <p>&copy; 2025Beans & Bloom - Cafe Management System. All rights reserved.</p>
</footer>
</body>
</html>