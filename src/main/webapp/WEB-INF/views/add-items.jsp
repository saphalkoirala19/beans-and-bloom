<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Add New Item -Beans & Bloom</title>
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
        .form-actions {
            margin-top: 20px;
            display: flex;
            justify-content: flex-end;
            gap: 10px;
        }
        .image-preview-container {
            margin-top: 10px;
        }
        #imagePreview {
            max-width: 200px;
            max-height: 200px;
            display: none;
            margin-top: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        .char-count {
            font-size: 12px;
            color: #666;
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
    <h1>Add New Item</h1>
    <p>Brew and Beans - Cafe Management System</p>
</header>

<div class="container clearfix">
    <div class="sidebar">
        <h2>Admin Menu</h2>
        <div class="menu-item"><a href="${pageContext.request.contextPath}/AdminDashboardServlet">Dashboard</a></div>
        <div class="menu-item"><a href="${pageContext.request.contextPath}/ListItemsServlet">Manage Items</a></div>
        <div class="menu-item"><a href="${pageContext.request.contextPath}/ListUsersServlet">Manage Users</a></div>
        <div class="menu-item"><a href="${pageContext.request.contextPath}/admin/profile.jsp">Profile Settings</a></div>
        <div class="menu-item"><a href="${pageContext.request.contextPath}/LogoutServlet">Logout</a></div>
    </div>

    <div class="main-content">
        <div class="card">
            <h2>Add New Item</h2>

            <form action="${pageContext.request.contextPath}/AddItemServlet" method="post" enctype="multipart/form-data" class="item-form" onsubmit="return validateForm()">
                <div class="form-group">
                    <label for="name">Name <span class="required">*</span></label>
                    <input type="text" id="name" name="name" required>
                </div>

                <div class="form-group">
                    <label for="description">Description</label>
                    <textarea id="description" name="description" rows="3" maxlength="255" oninput="updateCharCount()"></textarea>
                    <div class="char-count"><span id="charCount">0</span>/255 characters</div>
                </div>

                <div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 15px;">
                    <div class="form-group">
                        <label for="price">Price <span class="required">*</span></label>
                        <input type="number" step="0.01" id="price" name="price" min="0.01" required>
                    </div>

                    <div class="form-group">
                        <label for="quantity">Quantity <span class="required">*</span></label>
                        <input type="number" id="quantity" name="quantity" min="0" required>
                    </div>

                    <div class="form-group">
                        <label for="category">Category <span class="required">*</span></label>
                        <select id="category" name="category" required>
                            <option value="">-- Select --</option>
                            <option value="DRINKS">Drinks</option>
                            <option value="DESSERT">Dessert</option>
                            <option value="BAKERY">Bakery</option>
                            <option value="OTHER">Other</option>
                        </select>
                    </div>
                </div>

                <div style="display: grid; grid-template-columns: repeat(2, 1fr); gap: 15px;">
                    <div class="form-group">
                        <label for="status">Status <span class="required">*</span></label>
                        <select id="status" name="status" required>
                            <option value="AVAILABLE">Available</option>
                            <option value="UNAVAILABLE">Unavailable</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="itemImage">Item Image</label>
                        <input type="file" id="itemImage" name="itemImage" accept="image/*" onchange="previewImage(this)">
                        <small class="form-text">Max 5MB (JPEG, PNG, GIF)</small>
                        <div class="image-preview-container">
                            <img id="imagePreview" src="#" alt="Preview">
                        </div>
                    </div>
                </div>

                <div class="form-actions">
                    <a href="${pageContext.request.contextPath}/ListItemsServlet" class="btn-small">Cancel</a>
                    <button type="submit" class="btn-small">Add Item</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    function previewImage(input) {
        const preview = document.getElementById('imagePreview');
        const file = input.files[0];

        if (file) {
            const reader = new FileReader();

            reader.onload = function(e) {
                preview.src = e.target.result;
                preview.style.display = 'block';
            }

            reader.readAsDataURL(file);
        } else {
            preview.src = "#";
            preview.style.display = 'none';
        }
    }

    function updateCharCount() {
        const textarea = document.getElementById('description');
        const charCount = document.getElementById('charCount');
        charCount.textContent = textarea.value.length;
    }

    function validateForm() {
        const fileInput = document.getElementById('itemImage');
        if (fileInput.files.length > 0) {
            const file = fileInput.files[0];
            const validTypes = ['image/jpeg', 'image/png', 'image/gif'];

            if (!validTypes.includes(file.type)) {
                alert('Please upload a valid image file (JPEG, PNG, GIF)');
                return false;
            }

            if (file.size > 5 * 1024 * 1024) {
                alert('Image size must be less than 5MB');
                return false;
            }
        }
        return true;
    }

    // Initialize character count
    document.addEventListener('DOMContentLoaded', function() {
        updateCharCount();
    });
</script>
</body>
</html>