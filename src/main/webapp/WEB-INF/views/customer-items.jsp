<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.demo.models.itemsModel" %>
<%@ page import="com.example.demo.models.itemsModel.Category" %>
<%@ page import="com.example.demo.models.itemsModel.Status" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>Item Catalog -Beans & Bloom</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-dashboard.css">
    <style>
        /* Overall Layout */
        /* Sidebar Styling - Exactly matching first example */

        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background-color: #f5f5f5;
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
            margin-left: 220px;
            flex: 1;
            display: flex;
            flex-direction: column;
        }

        .container {
            max-width: 1200px;
            width: 100%;
            margin: 0 auto;
            padding: 20px;
            box-sizing: border-box;
        }

        /* Item Card Styling */
        .item-card {
            background: #fff;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            text-align: center;
            padding: 15px;
            width: calc(33.333% - 30px);
            margin: 15px;
            transition: transform 0.3s ease;
            box-sizing: border-box;
        }

        .item-card:hover {
            transform: translateY(-5px);
        }

        /* Image Frame */
        .item-image-frame {
            width: 100%;
            height: 250px;
            border: 3px solid #e0c9a6;
            border-radius: 8px;
            background-color: #fff;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            margin: 0 auto 15px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .item-image {
            width: 100%;
            height: 100%;
            object-fit: cover;
            display: block;
        }

        .no-image-placeholder {
            width: 100%;
            height: 100%;
            background-color: #f5f5f5;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #999;
            font-size: 14px;
        }

        .item-card h3 {
            font-size: 1.2em;
            margin-top: 15px;
            color: #333;
        }

        .item-card p {
            font-size: 0.9em;
            color: #666;
            margin-top: 5px;
        }

        .item-card .price {
            font-size: 1.1em;
            font-weight: bold;
            color: #27ae60;
            margin-top: 10px;
        }

        .item-card .status {
            font-weight: bold;
            margin-top: 5px;
        }

        .item-card .status-available {
            color: green;
        }

        .item-card .status-unavailable {
            color: #e74c3c;
        }

        .item-card .order-now-btn {
            background-color: #2ecc71;
            color: white;
            padding: 8px 16px;
            border-radius: 4px;
            text-decoration: none;
            margin-top: 10px;
            display: inline-block;
            transition: background-color 0.3s;
        }

        .item-card .order-now-btn:hover {
            background-color: #27ae60;
        }

        /* Filter Form Styling */
        .filter-form {
            background: #f5f5f5;
            padding: 20px;
            margin-bottom: 20px;
            border-radius: 4px;
            width: 100%;
            box-sizing: border-box;
        }

        .filter-form label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }

        .filter-form select, .filter-form input {
            width: 100%;
            padding: 8px;
            margin-bottom: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-sizing: border-box;
        }

        .filter-buttons {
            display: flex;
            gap: 10px;
        }

        .btn-small {
            padding: 8px 16px;
            background-color: #3498db;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
            font-size: 14px;
        }

        .btn-small:hover {
            background-color: #2980b9;
        }

        /* Items Grid */
        .items-grid {
            display: flex;
            flex-wrap: wrap;
            justify-content: flex-start;
            margin: 0 -15px;
            width: calc(100% + 30px);
        }

        /* Header Styling */
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

        /* Footer Styling */
        /*footer {*/
        /*    background-color: #2c3e50;*/
        /*    color: white;*/
        /*    text-align: center;*/
        /*    padding: 15px 0;*/
        /*    margin-top: 30px;*/
        /*    width: 100%;*/
        /*}*/

        /* Menu Item Styling */
        .menu-item {
            padding: 10px;
            margin-bottom: 5px;
            border-radius: 4px;
            transition: background-color 0.3s;
        }

        .menu-item:hover {
            background-color: #e9ecef;
        }

        .menu-item a {
            text-decoration: none;
            color: #333;
            display: block;
        }

        /* Grid layout for filter form */
        .filter-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 15px;
        }

        @media (max-width: 992px) {
            .item-card {
                width: calc(50% - 30px);
            }

            .filter-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media (max-width: 768px) {
            .item-card {
                width: calc(100% - 30px);
            }

            .filter-grid {
                grid-template-columns: 1fr;
            }
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
        <h1>Item Catalog</h1>
        <p>Browse our selection of items atBeans & Bloom</p>
    </header>

    <div class="container">
        <!-- Filter Form -->
        <div class="filter-form">
            <form action="${pageContext.request.contextPath}/CustomerItemsServlet" method="get">
                <div class="filter-grid">
                    <div>
                        <label for="name">Search</label>
                        <input type="text" id="name" name="name" value="${param.name}" placeholder="Search by name...">
                    </div>
                    <div>
                        <label for="status">Status</label>
                        <select id="status" name="status">
                            <option value="">All Statuses</option>
                            <option value="AVAILABLE" ${param.status == 'AVAILABLE' ? 'selected' : ''}>Available</option>
                            <option value="UNAVAILABLE" ${param.status == 'UNAVAILABLE' ? 'selected' : ''}>Unavailable</option>
                        </select>
                    </div>
                    <div>
                        <label for="category">Category</label>
                        <select id="category" name="category">
                            <option value="">All Categories</option>
                            <option value="DRINKS" ${param.category == 'DRINKS' ? 'selected' : ''}>Drinks</option>
                            <option value="DESSERT" ${param.category == 'DESSERT' ? 'selected' : ''}>Dessert</option>
                            <option value="BAKERY" ${param.category == 'BAKERY' ? 'selected' : ''}>Bakery</option>
                            <option value="OTHER" ${param.category == 'OTHER' ? 'selected' : ''}>Other</option>
                        </select>
                    </div>
                </div>
                <div class="filter-buttons" style="margin-top: 10px;">
                    <button type="submit" class="btn-small">Filter</button>
                    <a href="${pageContext.request.contextPath}/CustomerItemsServlet" class="btn-small">Reset</a>
                </div>
            </form>
        </div>

        <!-- Items Grid -->
        <div class="items-grid">
            <c:forEach items="${items}" var="item">
                <div class="item-card">
                    <div class="item-image-frame">
                        <c:if test="${not empty item.image}">
                            <img src="data:image/jpeg;base64,${item.image}" class="item-image" alt="${item.name}">
                        </c:if>
                        <c:if test="${empty item.image}">
                            <div class="no-image-placeholder">No Image Available</div>
                        </c:if>
                    </div>
                    <h3>${item.name}</h3>
                    <p>${item.description}</p>
                    <p class="price">$${String.format("%.2f", item.price)}</p>
                    <p class="status ${item.status == 'AVAILABLE' ? 'status-available' : 'status-unavailable'}">${item.status}</p>
                    <div class="button-group">
                        <a href="AddOrderServlet?action=view&itemId=${item.id}" class="order-now-btn">Order</a>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>

    <footer>
        <p>&copy; 2025Beans & Bloom - Cafe Management System</p>
    </footer>
</div>

</body>
</html>