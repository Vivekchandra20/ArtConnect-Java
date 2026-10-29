<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Join ArtConnect</title>
  <link rel="stylesheet" href="/static/css/style.css">
</head>
<body>
<div class="auth-page">

  <!-- Left: Visual Panel -->
  <div class="auth-visual" style="background-image: url('https://images.unsplash.com/photo-1513364776144-60967b0f800f?w=1200&q=80');"></div>

  <!-- Right: Form Panel -->
  <div class="auth-form-side">
    <div class="auth-form-box">

      <a href="/dashboard" class="auth-logo">Art<span>Connect</span></a>

      <h1>Create your account</h1>
      <p class="auth-sub">Join thousands of artists and collectors</p>

      <c:if test="${not empty error}">
        <div class="alert-error">${error}</div>
      </c:if>

      <!-- Role Selector -->
      <div class="role-toggle">
        <input type="radio" name="role-display" id="role-buyer" checked>
        <label for="role-buyer" onclick="setRole('BUYER')">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><path stroke-linecap="round" stroke-linejoin="round" d="M15.75 6a3.75 3.75 0 11-7.5 0 3.75 3.75 0 017.5 0zM4.501 20.118a7.5 7.5 0 0114.998 0"/></svg>
          I'm a Buyer
        </label>
        <input type="radio" name="role-display" id="role-seller">
        <label for="role-seller" onclick="setRole('SELLER')">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><path stroke-linecap="round" stroke-linejoin="round" d="M9.53 16.122a3 3 0 00-5.78 1.128 2.25 2.25 0 01-2.4 2.245 4.5 4.5 0 008.4-2.245c0-.399-.078-.78-.22-1.128zm0 0a15.998 15.998 0 003.388-1.62m-5.043-.025a15.994 15.994 0 011.622-3.395m3.42 3.42a15.995 15.995 0 004.764-4.648l3.876-5.814a1.151 1.151 0 00-1.597-1.597L14.146 6.32a15.996 15.996 0 00-4.649 4.763m3.42 3.42a6.776 6.776 0 00-3.42-3.42"/></svg>
          I'm an Artist
        </label>
      </div>

      <form action="/register" method="POST">
        <input type="hidden" name="role" id="role-input" value="BUYER">

        <div class="form-group">
          <label for="name">Full name</label>
          <input type="text" id="name" name="name" required placeholder="Your full name">
        </div>

        <div class="form-group">
          <label for="email">Email address</label>
          <input type="email" id="email" name="email" required placeholder="you@example.com">
        </div>

        <div class="form-group">
          <label for="password">Password</label>
          <input type="password" id="password" name="password" required placeholder="Choose a strong password">
        </div>

        <button type="submit" class="btn btn-primary btn-full" style="margin-top:0.5rem;">Create Account</button>
      </form>

      <div class="auth-footer">
        Already have an account? <a href="/login">Sign in</a>
      </div>

    </div>
  </div>
</div>

<script>
  function setRole(role) {
    document.getElementById('role-input').value = role;
  }
</script>
</body>
</html>
