<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - Artwork Platform</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg-color: #0f172a;
            --card-bg: rgba(30, 41, 59, 0.7);
            --text-color: #f8fafc;
            --primary-accent: #3b82f6;
            --primary-hover: #2563eb;
            --input-bg: rgba(15, 23, 42, 0.6);
            --error-color: #ef4444;
        }
        body {
            margin: 0;
            padding: 0;
            font-family: 'Outfit', sans-serif;
            background: linear-gradient(135deg, var(--bg-color), #000000);
            color: var(--text-color);
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .login-container {
            background: var(--card-bg);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            padding: 3rem;
            border-radius: 20px;
            box-shadow: 0 8px 32px 0 rgba(0, 0, 0, 0.37);
            border: 1px solid rgba(255, 255, 255, 0.1);
            width: 100%;
            max-width: 400px;
            text-align: center;
        }
        h1 { margin-top: 0; font-weight: 600; font-size: 2rem; margin-bottom: 1.5rem; }
        .form-group { margin-bottom: 1rem; text-align: left; }
        .form-group label { display: block; margin-bottom: 0.5rem; font-size: 0.9rem; color: #cbd5e1; }
        .form-group input, .form-group select {
            width: 100%; padding: 0.75rem; border-radius: 8px;
            border: 1px solid rgba(255,255,255,0.2); background: var(--input-bg);
            color: var(--text-color); box-sizing: border-box; outline: none;
            transition: border 0.3s ease;
        }
        .form-group input:focus, .form-group select:focus { border-color: var(--primary-accent); }
        .submit-btn {
            width: 100%; padding: 0.75rem; border-radius: 8px; border: none;
            background: var(--primary-accent); color: white; font-size: 1rem;
            font-weight: 600; cursor: pointer; transition: background 0.3s ease;
            margin-top: 1rem;
        }
        .submit-btn:hover { background: var(--primary-hover); }
        .error { color: var(--error-color); margin-bottom: 1rem; font-size: 0.9rem; }
        .login-link { display: block; margin-top: 1.5rem; color: #94a3b8; text-decoration: none; font-size: 0.9rem; }
        .login-link:hover { color: white; }
    </style>
</head>
<body>
    <div class="login-container">
        <h1>Create Account</h1>
        
        <c:if test="${not empty error}">
            <div class="error">${error}</div>
        </c:if>

        <form action="/register" method="POST">
            <div class="form-group">
                <label for="name">Full Name</label>
                <input type="text" id="name" name="name" required placeholder="John Doe">
            </div>
            <div class="form-group">
                <label for="email">Email Address</label>
                <input type="email" id="email" name="email" required placeholder="you@example.com">
            </div>
            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" required placeholder="••••••••">
            </div>
            <div class="form-group">
                <label for="role">I am a...</label>
                <select id="role" name="role" required>
                    <option value="BUYER">Buyer (Looking for Art)</option>
                    <option value="SELLER">Seller (Artist)</option>
                </select>
            </div>
            <button type="submit" class="submit-btn">Register</button>
        </form>
        
        <a href="/login" class="login-link">Already have an account? Login here.</a>
    </div>
</body>
</html>
