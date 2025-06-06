<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
  <title>Order Management -Beans & Bloom</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-dashboard.css">
  <style>
    .order-table {
      width: 100%;
      border-collapse: collapse;
    }
    .order-table th, .order-table td {
      padding: 12px 15px;
      text-align: left;
      border-bottom: 1px solid #ddd;
    }
    .order-table th {
      background-color: #f8f9fa;
      font-weight: 600;
    }
    .status-filter {
      margin-bottom: 20px;
    }
    .status-badge {
      padding: 4px 8px;
      border-radius: 12px;
      font-size: 12px;
      font-weight: 500;
    }
    .status-PENDING { background-color: #fff3cd; color: #856404; }
    .status-ON_THE_WAY { background-color: #cce5ff; color: #004085; }
    .status-COMPLETED { background-color: #d4edda; color: #155724; }
    .status-CANCELLED { background-color: #f8d7da; color: #721c24; }
    .customer-name {
      font-weight: 500;
    }
    .customer-id {
      font-size: 0.8rem;
      color: #6c757d;
    }
    .action-group {
      display: flex;
      gap: 8px;
      align-items: center;
    }
    .btn {
      padding: 6px 12px;
      border-radius: 4px;
      text-decoration: none;
      font-size: 14px;
      cursor: pointer;
    }
    /*.btn-view {*/
    /*  background-color: #6c757d;*/
    /*  color: white;*/
    /*  border: 1px solid #6c757d;*/
    /*}*/
    .btn-delete {
      background-color: #dc3545;
      color: white;
      border: 1px solid #dc3545;
    }
    .status-select {
      padding: 6px;
      border-radius: 4px;
      border: 1px solid #ced4da;
    }
    .status-select option:disabled {
      color: #adb5bd;
    }
    .alert {
      padding: 10px 15px;
      margin-bottom: 20px;
      border-radius: 4px;
    }
    .alert-success {
      background-color: #d4edda;
      color: #155724;
    }
    .alert-error {
      background-color: #f8d7da;
      color: #721c24;
    }
  </style>
</head>
<body>
<c:if test="${not empty success}">
  <div class="alert alert-success">
    <p>${success}</p>
  </div>
</c:if>
<c:if test="${not empty error}">
  <div class="alert alert-error">
    <p>${error}</p>
  </div>
</c:if>

<header>
  <h1>Order Management</h1>
  <p>Brew and Beans - Cafe Management System</p>
</header>

<div class="container clearfix">
  <div class="sidebar">
    <h2>Admin Menu</h2>
    <div class="menu-item"><a href="${pageContext.request.contextPath}/AdminDashboardServlet">Dashboard</a></div>
    <div class="menu-item"><a href="${pageContext.request.contextPath}/ListItemsServlet">Manage Items</a></div>
    <div class="menu-item"><a href="${pageContext.request.contextPath}/EditAdminProfileServlet">Profile Settings</a></div>
    <div class="menu-item"><a href="${pageContext.request.contextPath}/LogoutServlet">Logout</a></div>
    <div class="menu-item"><a href="${pageContext.request.contextPath}/view-order" class="active">Manage Orders</a></div>
  </div>

  <div class="main-content">
    <div class="card">
      <div class="header-actions">
        <form class="status-filter" method="get">
          <label for="status">Filter by Status:</label>
          <select id="status" name="status" onchange="this.form.submit()">
            <option value="">All Orders</option>
            <c:forEach items="${statusValues}" var="status">
              <option value="${status}" ${param.status == status ? 'selected' : ''}>
                  ${status}
              </option>
            </c:forEach>
          </select>
        </form>
      </div>

      <table class="order-table">
        <thead>
        <tr>
          <th>Order ID</th>
          <th>Customer</th>
          <th>Date</th>
          <th>Items</th>
          <th>Total</th>
          <th>Status</th>
          <th>Actions</th>
        </tr>
        </thead>
        <tbody>
        <c:choose>
          <c:when test="${empty orders}">
            <tr>
              <td colspan="7" class="text-center">No orders found</td>
            </tr>
          </c:when>
          <c:otherwise>
            <c:forEach items="${orders}" var="order">
              <tr>
                <td>#${order.id}</td>
                <td>
                  <div class="customer-name">${order.customerName}</div>
                  <div class="customer-id">ID: ${order.userId}</div>
                </td>
                <td><fmt:formatDate value="${order.orderDate}" pattern="MMM dd, yyyy HH:mm"/></td>
                <td>${order.quantity} items</td>
                <td>$<fmt:formatNumber value="${order.totalAmount}" minFractionDigits="2"/></td>
                <td>
                  <span class="status-badge status-${order.status}">
                      ${order.status}
                  </span>
                </td>
                <td>
                  <div class="action-group">
<%--                    <a href="${pageContext.request.contextPath}/order-details?id=${order.id}"--%>
<%--                       class="btn btn-view">--%>
<%--                      View--%>
<%--                    </a>--%>
                    <form method="post" style="display:inline;">
                      <input type="hidden" name="orderId" value="${order.id}">
                      <select name="status" onchange="this.form.submit()"
                              class="status-select">
                        <c:forEach items="${statusValues}" var="status">
                          <option value="${status}"
                            ${order.status == status ? 'selected' : ''}
                            ${(order.status == 'COMPLETED' || order.status == 'CANCELLED') && status != order.status ? 'disabled' : ''}>
                              ${status}
                          </option>
                        </c:forEach>
                      </select>
                    </form>
                    <c:if test="${order.status == 'COMPLETED' || order.status == 'CANCELLED'}">
                      <form method="post" action="${pageContext.request.contextPath}/delete-order"
                            style="display:inline;"
                            onsubmit="return confirm('Are you sure you want to delete this order?');">
                        <input type="hidden" name="orderId" value="${order.id}">
                        <button type="submit" class="btn btn-delete">
                          Delete
                        </button>
                      </form>
                    </c:if>
                  </div>
                </td>
              </tr>
            </c:forEach>
          </c:otherwise>
        </c:choose>
        </tbody>
      </table>
    </div>
  </div>
</div>

<footer>
  <p>&copy; 2025Beans & Bloom - Cafe Management System</p>
</footer>
</body>
</html>