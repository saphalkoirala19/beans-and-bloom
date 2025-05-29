<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>Order Details - Brew & Beans</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/customer-dashboard.css">
    <style>
        .order-details-container {
            padding: 2rem;
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            max-width: 800px;
            margin: 0 auto;
        }
        .order-header {
            margin-bottom: 2rem;
            padding-bottom: 1rem;
            border-bottom: 1px solid #eee;
        }
        .order-meta {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
            margin-bottom: 1rem;
        }
        .status {
            padding: 0.3rem 0.8rem;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: bold;
            display: inline-block;
        }
        .status-PENDING { background: #FFF3CD; color: #856404; }
        .status-COMPLETED { background: #D4EDDA; color: #155724; }
        .status-CANCELLED { background: #F8D7DA; color: #721C24; }
        .order-items {
            margin-top: 2rem;
        }
        .item-row {
            display: grid;
            grid-template-columns: 3fr 1fr 1fr 1fr;
            gap: 1rem;
            padding: 0.75rem 0;
            border-bottom: 1px solid #eee;
            align-items: center;
        }
        .item-header {
            font-weight: bold;
            border-bottom: 2px solid #eee;
        }
        .order-summary {
            margin-top: 1rem;
            text-align: right;
            font-size: 1.1rem;
            font-weight: bold;
        }
        .btn {
            padding: 0.5rem 1rem;
            border-radius: 4px;
            text-decoration: none;
            font-weight: 500;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }
        .btn-outline {
            background-color: transparent;
            color: #6c757d;
            border: 1px solid #6c757d;
        }
    </style>
</head>
<body>
<div class="dashboard-container">
    <jsp:include page="/WEB-INF/views/partials/sidebar.jsp" />

    <div class="main-content">
        <header class="content-header">
            <h2>Order #${order.id} Details</h2>
            <a href="${pageContext.request.contextPath}/customer-orders" class="btn btn-outline">
                <i class="fas fa-arrow-left"></i> Back to Orders
            </a>
        </header>

        <div class="order-details-container">
            <div class="order-header">
                <h3>Order Information</h3>
                <div class="order-meta">
                    <div>
                        <strong>Date:</strong>
                        <fmt:formatDate value="${order.orderDate}" pattern="MMM dd, yyyy"/>
                    </div>
                    <div>
                        <strong>Time:</strong>
                        <fmt:formatDate value="${order.orderDate}" pattern="hh:mm a"/>
                    </div>
                    <div>
                        <strong>Status:</strong>
                        <span class="status status-${order.status}">${order.status}</span>
                    </div>
                    <div>
                        <strong>Items:</strong> ${order.quantity}
                    </div>
                </div>
            </div>

            <div class="order-items">
                <div class="item-row item-header">
                    <div>Item Name</div>
                    <div>Price</div>
                    <div>Qty</div>
                    <div>Total</div>
                </div>

                <c:forEach items="${items}" var="item">
                    <div class="item-row">
                        <div>${item.name}</div>
                        <div>$<fmt:formatNumber value="${item.price}" minFractionDigits="2"/></div>
                        <div>${item.quantity}</div>
                        <div>$<fmt:formatNumber value="${item.price * item.quantity}" minFractionDigits="2"/></div>
                    </div>
                </c:forEach>

                <div class="order-summary">
                    Total: $<fmt:formatNumber value="${order.totalAmount}" minFractionDigits="2"/>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>