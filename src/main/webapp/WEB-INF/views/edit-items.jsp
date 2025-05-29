<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.demo.models.itemsModel" %>
<html>
<head>
    <title>Edit Item - Brew and Beans</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-dashboard.css">
    <style>
        .item-form {
            max-width: 800px;
            margin: 0 auto;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
        .form-group input[type="text"],
        .form-group input[type="number"],
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        .current-image {
            margin-bottom: 15px;
        }
        .current-image img {
            max-width: 200px;
            max-height: 200px;
            display: block;
        }
        .form-actions {
            margin-top: 20px;
            display: flex;
            justify-content: flex-end;
            gap: 10px;
        }
    </style>
</head>
<body>
<c:if test="${not empty error}">
    <div class="alert alert-error">
        <p>${error}</p>
    </div>
</c:if>

<header>
    <h1>Edit Item</h1>
    <p>Brew and Beans - Cafe Management System</p>
</header>

<div class="container clearfix">
    <div class="sidebar">
        <h2>Admin Menu</h2>
        <div class="menu-item"><a href="${pageContext.request.contextPath}/admin/dashboard.jsp">Dashboard</a></div>
        <div class="menu-item"><a href="${pageContext.request.contextPath}/ListItemsServlet">Manage Items</a></div>
        <div class="menu-item"><a href="${pageContext.request.contextPath}/ListUsersServlet">Manage Users</a></div>
        <div class="menu-item"><a href="${pageContext.request.contextPath}/admin/profile.jsp">Profile Settings</a></div>
        <div class="menu-item"><a href="${pageContext.request.contextPath}/LogoutServlet">Logout</a></div>
    </div>

    <div class="main-content">
        <div class="card">
            <h2>Edit Item</h2>

            <form action="${pageContext.request.contextPath}/EditItemServlet" method="post" enctype="multipart/form-data" class="item-form">
                <input type="hidden" name="id" value="${item.id}">

                <div class="form-group">
                    <label for="name">Name</label>
                    <input type="text" id="name" name="name" value="${item.name}" required>
                </div>

                <div class="form-group">
                    <label for="description">Description</label>
                    <textarea id="description" name="description" rows="3">${item.description}</textarea>
                </div>

                <div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 15px;">
                    <div class="form-group">
                        <label for="price">Price</label>
                        <input type="number" step="0.01" id="price" name="price" min="0" value="${item.price}" required>
                    </div>

                    <div class="form-group">
                        <label for="quantity">Quantity</label>
                        <input type="number" id="quantity" name="quantity" min="0" value="${item.quantity}" required>
                    </div>

                    <div class="form-group">
                        <label for="category">Category</label>
                        <select id="category" name="category" required>
                            <option value="DRINKS" ${item.category == 'DRINKS' ? 'selected' : ''}>Drinks</option>
                            <option value="DESSERT" ${item.category == 'DESSERT' ? 'selected' : ''}>Dessert</option>
                            <option value="BAKERY" ${item.category == 'BAKERY' ? 'selected' : ''}>Bakery</option>
                            <option value="OTHER" ${item.category == 'OTHER' ? 'selected' : ''}>Other</option>
                        </select>
                    </div>
                </div>

                <div style="display: grid; grid-template-columns: repeat(2, 1fr); gap: 15px;">
                    <div class="form-group">
                        <label for="status">Status</label>
                        <select id="status" name="status" required>
                            <option value="AVAILABLE" ${item.status == 'AVAILABLE' ? 'selected' : ''}>Available</option>
                            <option value="UNAVAILABLE" ${item.status == 'UNAVAILABLE' ? 'selected' : ''}>Unavailable</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="itemImage">Item Image</label>
                        <input type="file" id="itemImage" name="itemImage" accept="image/*">
                    </div>
                </div>

                <c:if test="${not empty base64Image}">
                    <div class="current-image">
                        <label>Current Image</label>
                        <img src="data:image/jpeg;base64,${base64Image}" alt="Current item image">
                    </div>
                </c:if>

                <div class="form-actions">
                    <a href="${pageContext.request.contextPath}/ListItemsServlet" class="btn-small">Cancel</a>
                    <button type="submit" class="btn-small">Update Item</button>
                </div>
            </form>
        </div>
    </div>
</div>

<footer>
    <p>&copy; 2025 Brew and Beans - Cafe Management System</p>
</footer>
</body>
</html>