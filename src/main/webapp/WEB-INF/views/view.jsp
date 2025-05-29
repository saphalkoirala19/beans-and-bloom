<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<h2>Order Details #${order.id}</h2>

<!-- Basic Order Info -->
<div class="order-info">
    <p><strong>Date:</strong> <fmt:formatDate value="${order.orderDate}" pattern="yyyy-MM-dd HH:mm"/></p>
    <p><strong>Status:</strong> ${order.status}</p>
    <p><strong>Total Amount:</strong> $<fmt:formatNumber value="${order.totalAmount}" minFractionDigits="2"/></p>
</div>

<!-- Admin Controls -->
<c:if test="${isAdmin}">
    <div class="admin-controls">
        <form action="update-order-status" method="post">
            <input type="hidden" name="orderId" value="${order.id}">
            <select name="status" class="form-control">
                <c:forEach items="${requestScope.statusValues}" var="status">
                    <option value="${status}" ${order.status == status ? 'selected' : ''}>
                            ${status}
                    </option>
                </c:forEach>
            </select>
            <button type="submit" class="btn btn-primary">Update Status</button>
        </form>
    </div>
</c:if>

<!-- Order Items Table -->
<table class="table">
    <thead>
    <tr>
        <th>Item</th>
        <th>Price</th>
        <th>Quantity</th>
        <th>Subtotal</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach items="${items}" var="item">
        <tr>
            <td>${item.itemName}</td>
            <td>$<fmt:formatNumber value="${item.itemPrice}" minFractionDigits="2"/></td>
            <td>${item.quantity}</td>
            <td>$<fmt:formatNumber value="${item.itemPrice * item.quantity}" minFractionDigits="2"/></td>
        </tr>
    </c:forEach>
    </tbody>
</table>

<!-- Back Button -->
<a href="${isAdmin ? 'admin/orders' : 'my-orders'}" class="btn btn-secondary">
    Back to Orders
</a>