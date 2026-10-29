<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<nav class="nav">
  <div class="nav-inner">
    <a href="/dashboard" class="nav-logo">Art<span>Connect</span></a>

    <div class="nav-links">
      <a href="/dashboard">Explore</a>
      <a href="/dashboard">Artists</a>
      <a href="/dashboard">Collections</a>
      <a href="/dashboard">About</a>
    </div>

    <div class="nav-actions">
      <c:choose>
        <c:when test="${not empty user}">
          <span class="nav-user">Hello, ${user.name}</span>
          <div class="nav-divider"></div>
          <c:choose>
            <c:when test="${user.role == 'BUYER'}">
              <a href="/buyer">My Dashboard</a>
            </c:when>
            <c:otherwise>
              <a href="/seller">My Studio</a>
            </c:otherwise>
          </c:choose>
          <a href="/logout" class="btn-nav-primary btn">Sign Out</a>
        </c:when>
        <c:otherwise>
          <a href="/login">Sign In</a>
          <a href="/register" class="btn-nav-primary btn">Join</a>
        </c:otherwise>
      </c:choose>
    </div>

    <div class="nav-hamburger" onclick="document.querySelector('.nav-mobile').classList.toggle('open')">
      <span></span><span></span><span></span>
    </div>
  </div>
  <!-- Mobile menu -->
  <div class="nav-mobile" style="display:none; background:var(--nav); padding:1rem 2rem 1.5rem;">
    <style>.nav-mobile.open{display:block!important}</style>
    <div style="display:flex;flex-direction:column;gap:1rem;">
      <a href="/dashboard" style="color:rgba(255,255,255,0.8);font-size:0.95rem;">Explore</a>
      <a href="/dashboard" style="color:rgba(255,255,255,0.8);font-size:0.95rem;">Artists</a>
      <a href="/dashboard" style="color:rgba(255,255,255,0.8);font-size:0.95rem;">Collections</a>
      <c:choose>
        <c:when test="${not empty user}">
          <c:choose>
            <c:when test="${user.role == 'BUYER'}"><a href="/buyer" style="color:rgba(255,255,255,0.8);font-size:0.95rem;">My Dashboard</a></c:when>
            <c:otherwise><a href="/seller" style="color:rgba(255,255,255,0.8);font-size:0.95rem;">My Studio</a></c:otherwise>
          </c:choose>
          <a href="/logout" style="color:var(--gold);font-size:0.95rem;">Sign Out</a>
        </c:when>
        <c:otherwise>
          <a href="/login" style="color:rgba(255,255,255,0.8);font-size:0.95rem;">Sign In</a>
          <a href="/register" style="color:var(--gold);font-size:0.95rem;">Join ArtConnect</a>
        </c:otherwise>
      </c:choose>
    </div>
  </div>
</nav>
