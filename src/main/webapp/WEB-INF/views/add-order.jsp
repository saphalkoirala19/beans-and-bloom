<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
<head>
    <title>Confirm Order</title>
    <style>
        body {
            font-family: "Segoe UI", sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 20px;
            color: #333;
        }

        h2 {
            text-align: center;
            font-size: 28px;
            margin-bottom: 25px;
        }

        form {
            width: 600px;
            margin: 0 auto;
            background-color: #fff;
            border: 1px solid #ccc;
            border-radius: 10px;
            padding: 30px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        }

        p {
            margin: 12px 0;
            font-size: 18px;
        }

        label {
            font-weight: bold;
            font-size: 18px;
            display: block;
            margin-top: 15px;
        }

        input[type="number"] {
            width: 100%;
            padding: 10px;
            font-size: 16px;
            margin-top: 6px;
            border: 1px solid #bbb;
            border-radius: 6px;
            box-sizing: border-box;
        }

        .btn-group {
            margin-top: 25px;
            display: flex;
            justify-content: space-between;
        }

        button, a.button-link {
            padding: 12px 24px;
            font-size: 16px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            text-decoration: none;
        }

        button {
            background-color: #007bff;
            color: #fff;
        }

        button:hover {
            background-color: #0062cc;
        }

        a.button-link {
            background-color: #e2e6ea;
            color: #333;
        }

        a.button-link:hover {
            background-color: #d6d8db;
        }

        .not-found {
            text-align: center;
            font-size: 20px;
            margin-top: 50px;
        }

        .not-found a {
            display: inline-block;
            margin-top: 15px;
            font-size: 16px;
            text-decoration: none;
            color: #007bff;
        }

        .not-found a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

<h2>Confirm Order</h2>

<c:if test="${not empty item}">
    <form action="AddOrderServlet" method="get">
        <input type="hidden" name="action" value="add" />
        <input type="hidden" name="itemId" value="${item.id}" />

        <p><strong>Item:</strong> ${item.name}</p>
        <p><strong>Description:</strong> ${item.description}</p>
        <p><strong>Price (per unit):</strong> $${item.price}</p>
        <p><strong>Status:</strong> ${item.status}</p>

        <label for="quantity">Quantity</label>
        <input type="number" name="quantity" id="quantity" value="1" min="1" required />

        <div class="btn-group">
            <button type="submit">Place Order</button>
            <a href="CustomerItemsServlet" class="button-link">Cancel</a>
        </div>
    </form>
</c:if>

<c:if test="${empty item}">
    <div class="not-found">
        <p>Item not found.</p>
        <a href="CustomerItemsServlet">Back to Items</a>
    </div>
</c:if>

</body>
</html>
