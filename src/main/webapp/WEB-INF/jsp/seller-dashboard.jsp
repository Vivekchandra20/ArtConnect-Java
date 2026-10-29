<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>My Studio — ArtConnect</title>
  <link rel="stylesheet" href="/static/css/style.css">
</head>
<body>

  <%@ include file="/WEB-INF/jsp/fragments/nav.jsp" %>

  <!-- Page Header -->
  <div class="dash-header">
    <div class="dash-header__inner">
      <h1>My Studio</h1>
      <p>Welcome back, <strong>${user.name}</strong> — manage your artworks and track your sales</p>
    </div>
  </div>

  <div class="section-sm">
    <div class="container">

      <c:if test="${not empty param.success}">
        <div class="alert-success" style="margin-bottom:2rem;">${param.success}</div>
      </c:if>

      <!-- Stats -->
      <div class="dash-stats">
        <div class="stat-card">
          <div class="stat-card__label">Total Listings</div>
          <div class="stat-card__value">${fn:length(artworks)}</div>
          <div class="stat-card__sub">artworks listed</div>
        </div>
        <div class="stat-card">
          <div class="stat-card__label">Reviews Received</div>
          <div class="stat-card__value">${fn:length(sellerReviews)}</div>
          <div class="stat-card__sub">from collectors</div>
        </div>
        <div class="stat-card">
          <div class="stat-card__label">Account</div>
          <div class="stat-card__value" style="font-size:1rem;margin-top:0.25rem;">${user.email}</div>
          <div class="stat-card__sub">seller account</div>
        </div>
      </div>

      <!-- Upload New Artwork -->
      <div class="dash-section">
        <h2>List a New Artwork</h2>
        <div class="upload-card">
          <form action="/artwork/upload" method="POST">
            <div style="display:grid;grid-template-columns:1fr 1fr;gap:1rem;">
              <div class="form-group">
                <label>Title *</label>
                <input type="text" name="title" required placeholder="e.g. Autumn in the Valley">
              </div>
              <div class="form-group">
                <label>Price (₹) *</label>
                <input type="number" step="0.01" name="price" required placeholder="e.g. 4500">
              </div>
            </div>
            <div class="form-group">
              <label>Image URL *</label>
              <input type="url" name="imageUrl" required placeholder="https://example.com/artwork.jpg">
            </div>
            <div class="form-group">
              <label>Description</label>
              <textarea name="description" rows="3" placeholder="Tell collectors about this piece — medium, inspiration, dimensions..."></textarea>
            </div>
            <button type="submit" class="btn btn-primary">List Artwork</button>
          </form>
        </div>
      </div>

      <!-- My Artworks Grid -->
      <div class="dash-section">
        <h2>My Listed Artworks</h2>
        <c:choose>
          <c:when test="${not empty artworks}">
            <div class="artwork-grid">
              <c:forEach items="${artworks}" var="art">
                <div class="artwork-card">
                  <div class="artwork-card__img-wrap">
                    <img src="${fn:escapeXml(art.imageUrl)}" alt="${fn:escapeXml(art.title)}" class="artwork-card__img"
                         onerror="this.src='https://images.unsplash.com/photo-1578301978693-85fa9c0320b9?w=600&q=70'">
                    <span class="artwork-card__badge badge-new">Listed</span>
                  </div>
                  <div class="artwork-card__body">
                    <h3 class="artwork-card__title">${fn:escapeXml(art.title)}</h3>
                    <p class="artwork-card__meta">${fn:escapeXml(art.description)}</p>
                    <div class="artwork-card__footer">
                      <span class="artwork-card__price"><span class="currency">₹ </span>${art.price}</span>
                      <span class="badge badge-gold">For Sale</span>
                    </div>
                  </div>
                </div>
              </c:forEach>
            </div>
          </c:when>
          <c:otherwise>
            <div class="empty-state">
              <div class="empty-state__icon">🎨</div>
              <h3>No artworks listed yet</h3>
              <p>Use the form above to list your first piece.</p>
            </div>
          </c:otherwise>
        </c:choose>
      </div>

      <!-- Reviews Section -->
      <div class="dash-section">
        <h2>Reviews from Collectors</h2>
        <c:choose>
          <c:when test="${not empty sellerReviews}">
            <div style="display:grid;grid-template-columns:repeat(auto-fill,minmax(300px,1fr));gap:1.25rem;">
              <c:forEach items="${sellerReviews}" var="review">
                <div class="review-card">
                  <div class="review-card__artwork">${fn:escapeXml(review.artworkTitle)}</div>
                  <div class="review-card__stars">
                    <c:forEach begin="1" end="${review.rating}">★</c:forEach><c:forEach begin="${review.rating + 1}" end="5">☆</c:forEach>
                  </div>
                  <p class="review-card__comment">"${fn:escapeXml(review.comment)}"</p>
                  <div class="review-card__meta">— ${fn:escapeXml(review.buyerEmail)} &nbsp;·&nbsp; ${review.createdAt}</div>
                </div>
              </c:forEach>
            </div>
          </c:when>
          <c:otherwise>
            <div class="empty-state">
              <div class="empty-state__icon">💬</div>
              <h3>No reviews yet</h3>
              <p>Reviews from collectors will appear here once your artworks are purchased.</p>
            </div>
          </c:otherwise>
        </c:choose>
      </div>

    </div>
  </div>

  <%@ include file="/WEB-INF/jsp/fragments/footer.jsp" %>

</body>
</html>
