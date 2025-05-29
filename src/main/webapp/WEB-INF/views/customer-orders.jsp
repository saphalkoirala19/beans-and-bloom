<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>My Orders - Brew & Beans</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-dashboard.css">
    <style>
        /* Overall Layout */
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background-color: #f5f5f5;
        }

        /* Sidebar Styling - Exactly matching first example */
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
        }

        /*!* Header matching first example *!*/
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

        /* Orders Container */
        .orders-container {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 25px;
            margin-bottom: 30px;
        }

        /* Order Cards */
        .order-card {
            border: 1px solid #eee;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
            transition: all 0.3s ease;
        }

        .order-card:hover {
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            transform: translateY(-3px);
        }

        .order-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid #eee;
            padding-bottom: 15px;
            margin-bottom: 15px;
        }

        .order-header h3 {
            margin: 0;
            font-size: 1.2em;
            color: #333;
        }

        .order-header small {
            color: #6c757d;
            font-size: 0.9em;
        }

        .status {
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 0.85em;
            font-weight: bold;
            text-transform: uppercase;
        }

        .status-PENDING { background: #FFF3CD; color: #856404; }
        .status-COMPLETED { background: #D4EDDA; color: #155724; }
        .status-CANCELLED { background: #F8D7DA; color: #721C24; }

        .order-summary {
            display: flex;
            justify-content: space-between;
            margin-bottom: 15px;
        }

        .summary-row {
            display: flex;
            justify-content: space-between;
            width: 48%;
        }

        .summary-row span:first-child {
            font-weight: 500;
            color: #555;
        }

        .summary-row span:last-child {
            font-weight: 600;
            color: #333;
        }

        .order-actions {
            display: flex;
            gap: 12px;
            margin-top: 15px;
        }

        .btn {
            padding: 8px 16px;
            border-radius: 4px;
            text-decoration: none;
            font-weight: 500;
            font-size: 0.9em;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: all 0.2s;
        }

        .btn-primary {
            background-color: #6c757d;
            color: white;
            border: 1px solid #6c757d;
        }

        .btn-primary:hover {
            background-color: #5a6268;
            border-color: #545b62;
        }

        .btn-danger {
            background-color: #dc3545;
            color: white;
            border: 1px solid #dc3545;
        }

        .btn-danger:hover {
            background-color: #c82333;
            border-color: #bd2130;
        }

        .btn-outline {
            background-color: transparent;
            color: #6c757d;
            border: 1px solid #6c757d;
        }

        .btn-outline:hover {
            background-color: #f8f9fa;
        }

        .btn-sm {
            padding: 6px 12px;
            font-size: 0.85em;
        }

        /* Empty State */
        .empty-orders {
            text-align: center;
            padding: 40px 20px;
            color: #6c757d;
        }

        .empty-orders i {
            font-size: 3em;
            color: #e9ecef;
            margin-bottom: 15px;
        }

        .empty-orders h3 {
            color: #495057;
            margin-bottom: 10px;
        }

        .empty-orders p {
            margin-bottom: 20px;
        }

        /* Content Header */
        .content-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
        }

        .content-header h2 {
            margin: 0;
            color: #333;
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
        <h1>My Orders</h1>
        <p>View your order history at Brew and Beans</p>
    </header>

    <div class="orders-container">
        <div class="content-header">
            <h2>Order History</h2>

        </div>

        <c:choose>
            <c:when test="${empty orders}">
                <div class="empty-orders">
                    <i class="fas fa-clipboard-list"></i>
                    <h3>No orders yet</h3>
                    <p>You haven't placed any orders with us yet.</p>
                    <a href="${pageContext.request.contextPath}/menu" class="btn btn-primary">
                        Browse Our Menu
                    </a>
                </div>
            </c:when>
            <c:otherwise>
                <c:forEach items="${orders}" var="order">
                    <div class="order-card">
                        <div class="order-header">
                            <div>
                                <h3>Order #${order.id}</h3>
                                <small>
                                    <fmt:formatDate value="${order.orderDate}" pattern="MMM dd, yyyy hh:mm a"/>
                                </small>
                            </div>
                            <div>
                                <span class="status status-${order.status}">
                                        ${order.status}
                                </span>
                            </div>
                        </div>

                        <div class="order-summary">
                            <div class="summary-row">
                                <span>Items:</span>
                                <span>${order.quantity}</span>
                            </div>
                            <div class="summary-row">
                                <span>Total:</span>
                                <span>$<fmt:formatNumber value="${order.totalAmount}" minFractionDigits="2"/></span>
                            </div>
                        </div>

                        <div class="order-actions">
                            <c:if test="${order.status == 'PENDING'}">
                                <form action="${pageContext.request.contextPath}/cancel-order" method="post" style="display: inline;">
                                    <input type="hidden" name="orderId" value="${order.id}">
                                    <button type="submit" class="btn btn-danger btn-sm">
                                        <i class="fas fa-times"></i> Cancel
                                    </button>
                                </form>
                            </c:if>
                            <a href="${pageContext.request.contextPath}/order-details?id=${order.id}"
                               class="btn btn-outline btn-sm">
                                <i class="fas fa-eye"></i> View Details
                            </a>
                        </div>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>

    <footer>
        <p>&copy; 2025 Brew and Beans - Cafe Management System</p>
    </footer>
</div>
</body>
</html>