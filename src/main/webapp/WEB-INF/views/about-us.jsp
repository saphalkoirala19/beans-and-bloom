<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>About Us -Beans & Bloom</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-dashboard.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        /* Keep all your existing CSS styles from contact page */
        /* Add these new styles for about page specific elements */

        .mission-vision {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 30px;
            margin: 40px 0;
        }



        .mission-card, .vision-card {
            background: #fffaf4;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.05);
        }

        .mission-card h3, .vision-card h3 {
            color: #5a3921;
            font-size: 1.5rem;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
        }

        .mission-card h3 i, .vision-card h3 i {
            margin-right: 10px;
            color: #a9744f;
        }

        .team-section {
            margin-top: 40px;
        }

        .team-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 30px;
            margin-bottom: 30px;
        }

        .team-card {
            background: white;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
            text-align: center;
        }

        .team-img {
            width: 100%;
            height: 250px;
            object-fit: cover;
        }

        .team-info {
            padding: 20px;
        }

        .team-info h4 {
            color: #5a3921;
            margin: 10px 0 5px;
        }

        .team-info p {
            color: #a9744f;
            font-weight: 500;
        }

        .history-section {
            margin-top: 40px;
        }

        .timeline {
            position: relative;
            max-width: 800px;
            margin: 40px auto;
        }

        .timeline-item {
            padding: 20px 0;
            position: relative;
        }

        .timeline-year {
            font-weight: bold;
            color: #a9744f;
            margin-bottom: 10px;
        }

        .timeline-content {
            background: #fffaf4;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.05);
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
        <h2>Our Story</h2>
        <p>Brew and Beans began as a small coffee cart in 2015 with a simple mission: to serve exceptional coffee in a warm, welcoming environment. Today, we've grown into Itahari's favorite specialty coffee shop while staying true to our roots.</p>
    </header>

    <div class="container">
        <div class="mission-vision">
            <div class="mission-card">
                <h3><i class="fas fa-heart"></i> Our Mission</h3>
                <p>To craft the perfect cup of coffee using ethically sourced beans while creating a community space that inspires connection and creativity.</p>
            </div>
            <div class="vision-card">
                <h3><i class="fas fa-eye"></i> Our Vision</h3>
                <p>To become Nepal's most beloved coffee brand by redefining the coffee experience through quality, innovation, and genuine hospitality.</p>
            </div>
        </div>

        <div class="history-section">
            <h2>Our Journey</h2>
            <div class="timeline">
                <div class="timeline-item">
                    <div class="timeline-year">2015</div>
                    <div class="timeline-content">
                        <p>Founded as a new cafe "Beans and Brew"</p>
                    </div>
                </div>
                <div class="timeline-item">
                    <div class="timeline-year">2017</div>
                    <div class="timeline-content">
                        <p>Opened our first brick-and-mortar location near Itahari International College</p>
                    </div>
                </div>
                <div class="timeline-item">
                    <div class="timeline-year">2020</div>
                    <div class="timeline-content">
                        <p>Launched our own line of signature coffee blends sourced from Nepali farmers</p>
                    </div>
                </div>
                <div class="timeline-item">
                    <div class="timeline-year">2023</div>
                    <div class="timeline-content">
                        <p>Recognized as "Best Coffee Shop in Province 1" by Nepal Hospitality Awards</p>
                    </div>
                </div>
                <div class="timeline-item">
                    <div class="timeline-year">2025</div>
                    <div class="timeline-content">
                        <p>Advanced as a mobile coffee cart serving local offices and colleges in Itahari</p>
                    </div>
                </div>
            </div>
        </div>

        <div class="team-section">
            <h2>Meet Our Team</h2>
            <div class="team-row">
                <div class="team-card">
                    <img src="${pageContext.request.contextPath}/assets/images/team1.jpg" alt="Founder" class="team-img">
                    <div class="team-info">
                        <h4>Saphal Koirala</h4>
                        <p>Founder & Head Barista</p>
                    </div>
                </div>
                <div class="team-card">
                    <img src="${pageContext.request.contextPath}/assets/images/team2.jpg" alt="Manager" class="team-img">
                    <div class="team-info">
                        <h4>John Doe</h4>
                        <p>Cafe Manager</p>
                    </div>
                </div>
            </div>
            <div class="team-row">
                <div class="team-card">
                    <img src="${pageContext.request.contextPath}/assets/images/team3.jpg" alt="Pastry Chef" class="team-img">
                    <div class="team-info">
                        <h4>Pukar Koirala</h4>
                        <p>Pastry Chef</p>
                    </div>
                </div>
                <div class="team-card">
                    <img src="${pageContext.request.contextPath}/assets/images/team4.jpg" alt="Barista" class="team-img">
                    <div class="team-info">
                        <h4>Alex Hales</h4>
                        <p>Lead Barista</p>
                    </div>
                </div>
                <div class="team-card">
                    <img src="${pageContext.request.contextPath}/assets/images/team5.jpg" alt="Marketing" class="team-img">
                    <div class="team-info">
                        <h4>Saffy Acharya</h4>
                        <p>Marketing Manager</p>
                    </div>
                </div>
            </div>
        </div>

        <div class="social-links">
            <p>Follow our coffee journey</p>
            <a href="#"><i class="fab fa-facebook"></i></a>
            <a href="#"><i class="fab fa-instagram"></i></a>
            <a href="#"><i class="fab fa-tiktok"></i></a>
        </div>
    </div>
</div>

<footer>
    <p>&copy; 2025Beans & Bloom - Cafe Management System. All rights reserved.</p>
</footer>
</body>
</html>