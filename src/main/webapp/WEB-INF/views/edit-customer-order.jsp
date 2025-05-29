<%--<%@ page contentType="text/html;charset=UTF-8" language="java" %>--%>
<%--<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>--%>
<%--<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>--%>
<%--<html>--%>
<%--<head>--%>
<%--    <title>Edit Order - Brew & Beans</title>--%>
<%--    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/customer-dashboard.css">--%>
<%--    <style>--%>
<%--        .edit-order-container {--%>
<%--            padding: 2rem;--%>
<%--            background: white;--%>
<%--            border-radius: 10px;--%>
<%--            box-shadow: 0 2px 10px rgba(0,0,0,0.1);--%>
<%--        }--%>
<%--        .order-header {--%>
<%--            display: flex;--%>
<%--            justify-content: space-between;--%>
<%--            border-bottom: 1px solid #eee;--%>
<%--            padding-bottom: 1rem;--%>
<%--            margin-bottom: 1rem;--%>
<%--        }--%>
<%--        .status {--%>
<%--            padding: 0.3rem 0.8rem;--%>
<%--            border-radius: 20px;--%>
<%--            font-size: 0.8rem;--%>
<%--            font-weight: bold;--%>
<%--        }--%>
<%--        .status-PENDING { background: #FFF3CD; color: #856404; }--%>
<%--        .order-items {--%>
<%--            margin-top: 2rem;--%>
<%--        }--%>
<%--        .item-row {--%>
<%--            display: flex;--%>
<%--            justify-content: space-between;--%>
<%--            padding: 1rem;--%>
<%--            border: 1px solid #eee;--%>
<%--            border-radius: 4px;--%>
<%--            margin-bottom: 1rem;--%>
<%--            align-items: center;--%>
<%--        }--%>
<%--        .item-info {--%>
<%--            flex: 1;--%>
<%--        }--%>
<%--        .item-actions {--%>
<%--            display: flex;--%>
<%--            gap: 1rem;--%>
<%--            align-items: center;--%>
<%--        }--%>
<%--        .quantity-control {--%>
<%--            display: flex;--%>
<%--            align-items: center;--%>
<%--            gap: 0.5rem;--%>
<%--        }--%>
<%--        .btn {--%>
<%--            padding: 0.5rem 1rem;--%>
<%--            border-radius: 4px;--%>
<%--            text-decoration: none;--%>
<%--            font-weight: 500;--%>
<%--            display: inline-flex;--%>
<%--            align-items: center;--%>
<%--            gap: 0.5rem;--%>
<%--        }--%>
<%--        .btn-primary {--%>
<%--            background-color: #6c757d;--%>
<%--            color: white;--%>
<%--            border: 1px solid #6c757d;--%>
<%--        }--%>
<%--        .btn-danger {--%>
<%--            background-color: #dc3545;--%>
<%--            color: white;--%>
<%--            border: 1px solid #dc3545;--%>
<%--        }--%>
<%--        .btn-outline {--%>
<%--            background-color: transparent;--%>
<%--            color: #6c757d;--%>
<%--            border: 1px solid #6c757d;--%>
<%--        }--%>
<%--        .alert {--%>
<%--            padding: 1rem;--%>
<%--            margin: 1rem 2rem;--%>
<%--            border-radius: 4px;--%>
<%--        }--%>
<%--        .alert-success {--%>
<%--            background-color: #d4edda;--%>
<%--            color: #155724;--%>
<%--            border: 1px solid #c3e6cb;--%>
<%--        }--%>
<%--        .alert-danger {--%>
<%--            background-color: #f8d7da;--%>
<%--            color: #721c24;--%>
<%--            border: 1px solid #f5c6cb;--%>
<%--        }--%>
<%--    </style>--%>
<%--</head>--%>
<%--<body>--%>
<%--<div class="dashboard-container">--%>
<%--    <jsp:include page="/WEB-INF/views/partials/sidebar.jsp" />--%>

<%--    <div class="main-content">--%>
<%--        <c:if test="${not empty param.success}">--%>
<%--            <div class="alert alert-success">--%>
<%--                    ${param.success}--%>
<%--            </div>--%>
<%--        </c:if>--%>
<%--        <c:if test="${not empty param.error}">--%>
<%--            <div class="alert alert-danger">--%>
<%--                    ${param.error}--%>
<%--            </div>--%>
<%--        </c:if>--%>

<%--        <header class="content-header">--%>
<%--            <h2>Edit Order #${order.id}</h2>--%>
<%--            <a href="${pageContext.request.contextPath}/customer-orders" class="btn btn-outline">--%>
<%--                <i class="fas fa-arrow-left"></i> Back to Orders--%>
<%--            </a>--%>
<%--        </header>--%>

<%--        <div class="edit-order-container">--%>
<%--            <div class="order-header">--%>
<%--                <div>--%>
<%--                    <small class="text-muted">--%>
<%--                        <fmt:formatDate value="${order.orderDate}" pattern="MMM dd, yyyy hh:mm a"/>--%>
<%--                    </small>--%>
<%--                    <span class="status status-${order.status}">--%>
<%--                        ${order.status}--%>
<%--                    </span>--%>
<%--                </div>--%>
<%--                <div>--%>
<%--                    <strong>Total: $<fmt:formatNumber value="${order.totalAmount}" minFractionDigits="2"/></strong>--%>
<%--                </div>--%>
<%--            </div>--%>

<%--&lt;%&ndash;            <form action="${pageContext.request.contextPath}/edit-order" method="post">&ndash;%&gt;--%>
<%--&lt;%&ndash;                <input type="hidden" name="orderId" value="${order.id}">&ndash;%&gt;--%>

<%--&lt;%&ndash;                <div class="order-items">&ndash;%&gt;--%>
<%--&lt;%&ndash;                    <h3>Order Items</h3>&ndash;%&gt;--%>

<%--&lt;%&ndash;                    <c:forEach items="${items}" var="item">&ndash;%&gt;--%>
<%--&lt;%&ndash;                        <div class="item-row">&ndash;%&gt;--%>
<%--&lt;%&ndash;                            <div class="item-info">&ndash;%&gt;--%>
<%--&lt;%&ndash;                                <h4>${item.name}</h4>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                <p>Price: $<fmt:formatNumber value="${item.price}" minFractionDigits="2"/></p>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                <input type="hidden" name="itemId" value="${item.id}">&ndash;%&gt;--%>
<%--&lt;%&ndash;                            </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                            <div class="item-actions">&ndash;%&gt;--%>
<%--&lt;%&ndash;                                <div class="quantity-control">&ndash;%&gt;--%>
<%--&lt;%&ndash;                                    <button type="button" class="btn btn-outline btn-sm quantity-decrease">-</button>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                    <input type="number" name="quantity"&ndash;%&gt;--%>
<%--&lt;%&ndash;                                           value="${item.quantity}" min="1" class="quantity-input">&ndash;%&gt;--%>
<%--&lt;%&ndash;                                    <button type="button" class="btn btn-outline btn-sm quantity-increase">+</button>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                <button type="button" class="btn btn-danger btn-sm remove-item">&ndash;%&gt;--%>
<%--&lt;%&ndash;                                    <i class="fas fa-trash"></i>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                </button>&ndash;%&gt;--%>
<%--&lt;%&ndash;                            </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                        </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                    </c:forEach>&ndash;%&gt;--%>
<%--&lt;%&ndash;                </div>&ndash;%&gt;--%>

<%--&lt;%&ndash;                <div class="order-actions" style="margin-top: 2rem; display: flex; justify-content: flex-end; gap: 1rem;">&ndash;%&gt;--%>
<%--&lt;%&ndash;                    <a href="${pageContext.request.contextPath}/customer-orders" class="btn btn-outline">&ndash;%&gt;--%>
<%--&lt;%&ndash;                        Cancel&ndash;%&gt;--%>
<%--&lt;%&ndash;                    </a>&ndash;%&gt;--%>
<%--&lt;%&ndash;                    <button type="submit" class="btn btn-primary">&ndash;%&gt;--%>
<%--&lt;%&ndash;                        <i class="fas fa-save"></i> Save Changes&ndash;%&gt;--%>
<%--&lt;%&ndash;                    </button>&ndash;%&gt;--%>
<%--&lt;%&ndash;                </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;            </form>&ndash;%&gt;--%>
<%--        </div>--%>
<%--    </div>--%>
<%--</div>--%>

<%--<script>--%>
<%--    // Quantity controls--%>
<%--    document.querySelectorAll('.quantity-increase').forEach(button => {--%>
<%--        button.addEventListener('click', function() {--%>
<%--            const input = this.parentElement.querySelector('.quantity-input');--%>
<%--            input.value = parseInt(input.value) + 1;--%>
<%--        });--%>
<%--    });--%>

<%--    document.querySelectorAll('.quantity-decrease').forEach(button => {--%>
<%--        button.addEventListener('click', function() {--%>
<%--            const input = this.parentElement.querySelector('.quantity-input');--%>
<%--            if (parseInt(input.value) > 1) {--%>
<%--                input.value = parseInt(input.value) - 1;--%>
<%--            }--%>
<%--        });--%>
<%--    });--%>

<%--    // Remove item--%>
<%--    document.querySelectorAll('.remove-item').forEach(button => {--%>
<%--        button.addEventListener('click', function() {--%>
<%--            if (confirm('Are you sure you want to remove this item?')) {--%>
<%--                this.closest('.item-row').remove();--%>
<%--            }--%>
<%--        });--%>
<%--    });--%>
<%--</script>--%>
<%--</body>--%>
<%--</html>--%>