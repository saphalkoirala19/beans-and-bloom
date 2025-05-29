
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.demo.models.UserModel" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Base64" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>Admin Dashboard - Advanced Programming and Technologies</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-dashboard.css">
</head>
<body>
<c:if test="${not empty param.success}">
    <div class="alert alert-success">
        <p>${param.success}</p>
    </div>
</c:if>
<c:if test="${not empty param.error}">
    <div class="alert alert-error">
        <p>${param.error}</p>
    </div>
</c:if>
<header>
    <h1>Admin Dashboard</h1>
    <p>Brew and Beans - Cafe Management System</p>
</header>

<div class="container clearfix">
    <div class="sidebar">
        <h2>Admin Menu</h2>
        <div class="menu-item"><a href="${pageContext.request.contextPath}/AdminDashboardServlet">Dashboard</a></div>
        <div class="menu-item"><a href="${pageContext.request.contextPath}/ListItemsServlet">Manage Items</a></div>
        <div class="menu-item"><a href="${pageContext.request.contextPath}/EditAdminProfileServlet">Profile Settings</a></div>
        <div class="menu-item"><a href="${pageContext.request.contextPath}/LogoutServlet">Logout</a></div>
        <div class="menu-item"><a href="${pageContext.request.contextPath}/view-order">manage order</a></div>
    </div>

    <div class="main-content">
        <div class="card">
            <h2>Welcome, <span><%= ((UserModel)request.getAttribute("user")).getName() %></span></h2>
            <div class="admin-profile">
                <div class="profile-image">
                    <img src="data:image/jpeg;base64,${base64Image}" alt="Profile Picture" onerror="this.src='${pageContext.request.contextPath}/assets/images/default-profile.svg'" width="120" height="120">
                </div>
                <div class="profile-details">
                    <p><strong>Email:</strong> <span><%= ((UserModel)session.getAttribute("user")).getEmail() %></span></p>
                    <p><strong>Role:</strong> Administrator</p>
                    <p><strong>User ID:</strong> <span><%= ((UserModel)session.getAttribute("user")).getId() %></span></p>
                </div>
            </div>
        </div>

        <div class="card">
            <h2>User Management</h2>
            <table>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Role</th>
                    <th>Actions</th>
                </tr>
                <c:forEach var="user" items="${allUsers}">
                    <tr>
                        <td>${user.id}</td>
                        <td>${user.name}</td>
                        <td>${user.email}</td>
                        <td>${user.role}</td>
                        <td>
                            <a href="${pageContext.request.contextPath}/UpdateUserServlet?id=${user.id}" class="btn-small">Edit</a>
                            <form action="${pageContext.request.contextPath}/DeleteUserServlet" method="post" style="display:inline;">
                                <input type="hidden" name="id" value="${user.id}">
                                <button type="submit" class="btn-small btn-danger"
                                        onclick="return confirm('Are you sure you want to delete this user?')">
                                    Delete
                                </button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
            </table>
        </div>


    </div>
</div>

<footer>
    <p>&copy; 2025 Bean and Bloom - Cafe Management System</p>
</footer>
</body>
</html>