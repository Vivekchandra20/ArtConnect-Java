<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Artwork Platform</title>
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
            --success-color: #10b981;
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
        h1 { margin-top: 0; font-weight: 600; font-size: 2rem; margin-bottom: 2rem; }
        .role-selector { display: flex; justify-content: space-around; margin-bottom: 2rem; }
        .role-btn {
            background: transparent; border: 1px solid var(--primary-accent);
            color: var(--text-color); padding: 0.5rem 1.5rem; border-radius: 20px;
            cursor: pointer; transition: all 0.3s ease;
        }
        .role-btn.active { background: var(--primary-accent); color: white; }
        .form-group { margin-bottom: 1.5rem; text-align: left; }
        .form-group label { display: block; margin-bottom: 0.5rem; font-size: 0.9rem; color: #cbd5e1; }
        .form-group input {
            width: 100%; padding: 0.75rem; border-radius: 8px;
            border: 1px solid rgba(255,255,255,0.2); background: var(--input-bg);
            color: var(--text-color); box-sizing: border-box; outline: none;
            transition: border 0.3s ease;
        }
        .form-group input:focus { border-color: var(--primary-accent); }
        .submit-btn {
            width: 100%; padding: 0.75rem; border-radius: 8px; border: none;
            background: var(--primary-accent); color: white; font-size: 1rem;
            font-weight: 600; cursor: pointer; transition: background 0.3s ease;
        }
        .submit-btn:hover { background: var(--primary-hover); }
        .error { color: var(--error-color); margin-bottom: 1rem; font-size: 0.9rem; }
        .success { color: var(--success-color); margin-bottom: 1rem; font-size: 0.9rem; }
        .register-link { display: block; margin-top: 1.5rem; color: #94a3b8; text-decoration: none; font-size: 0.9rem; }
        .register-link:hover { color: white; }
    </style>
</head>
<body>

    <div class="login-container">
        <h1>ArtConnect</h1>
        
        <c:if test="${not empty error}">
            <div class="error">${error}</div>
        </c:if>
        <c:if test="${not empty success}">
            <div class="success">${success}</div>
        </c:if>
        
        <div class="role-selector">
            <button type="button" class="role-btn active" id="btn-buyer" onclick="selectRole('BUYER')">Buyer</button>
            <button type="button" class="role-btn" id="btn-seller" onclick="selectRole('SELLER')">Seller</button>
        </div>

        <form action="/login" method="POST">
            <input type="hidden" name="role" id="role-input" value="BUYER">
            
            <div class="form-group">
                <label for="email">Email Address</label>
                <input type="email" id="email" name="email" required placeholder="you@example.com">
            </div>
            
            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" required placeholder="••••••••">
            </div>

            <button type="submit" class="submit-btn">Login as Buyer</button>
        </form>
        
        <a href="/register" class="register-link">Don't have an account? Register here.</a>
    </div>

    <script>
        function selectRole(role) {
            document.getElementById('role-input').value = role;
            
            const btnBuyer = document.getElementById('btn-buyer');
            const btnSeller = document.getElementById('btn-seller');
            const submitBtn = document.querySelector('.submit-btn');

            if(role === 'BUYER') {
                btnBuyer.classList.add('active');
                btnSeller.classList.remove('active');
                submitBtn.textContent = 'Login as Buyer';
            } else {
                btnSeller.classList.add('active');
                btnBuyer.classList.remove('active');
                submitBtn.textContent = 'Login as Seller';
            }
        }
    </script>
</body>
</html>
