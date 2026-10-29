<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>My Collection — ArtConnect</title>
  <link rel="stylesheet" href="/static/css/style.css">
</head>
<body>

  <%@ include file="/WEB-INF/jsp/fragments/nav.jsp" %>

  <!-- Page Header -->
  <div class="dash-header">
    <div class="dash-header__inner">
      <h1>My Collection</h1>
      <p>Welcome back, <strong>${user.name}</strong> — your personal art collection</p>
    </div>
  </div>

  <div class="section-sm">
    <div class="container">

      <c:if test="${not empty param.success}">
        <div class="alert-success" style="margin-bottom:2rem;">${param.success}</div>
      </c:if>

      <!-- Stats Row -->
      <div class="dash-stats">
        <div class="stat-card">
          <div class="stat-card__label">Artworks Owned</div>
          <div class="stat-card__value">${fn:length(myPurchases)}</div>
          <div class="stat-card__sub">in your collection</div>
        </div>
        <div class="stat-card">
          <div class="stat-card__label">Available to Buy</div>
          <div class="stat-card__value">${fn:length(artworks)}</div>
          <div class="stat-card__sub">in the gallery</div>
        </div>
        <div class="stat-card">
          <div class="stat-card__label">Account</div>
          <div class="stat-card__value" style="font-size:1rem;margin-top:0.25rem;">${user.email}</div>
          <div class="stat-card__sub">buyer account</div>
        </div>
      </div>

      <!-- Browse Gallery -->
      <div class="dash-section">
        <div class="section-header">
          <h2>Browse Available Artworks</h2>
          <a href="/dashboard" class="view-all">Full Gallery ↗</a>
        </div>
        <c:choose>
          <c:when test="${not empty artworks}">
            <div class="artwork-grid">
              <c:forEach items="${artworks}" var="art">
                <div class="artwork-card">
                  <div class="artwork-card__img-wrap">
                    <img src="${fn:escapeXml(art.imageUrl)}" alt="${fn:escapeXml(art.title)}" class="artwork-card__img"
                         onerror="this.src='https://images.unsplash.com/photo-1578301978693-85fa9c0320b9?w=600&q=70'">
                    <span class="artwork-card__badge badge-new">Original</span>
                  </div>
                  <div class="artwork-card__body">
                    <p class="artwork-card__artist">${fn:escapeXml(art.sellerEmail)}</p>
                    <h3 class="artwork-card__title">${fn:escapeXml(art.title)}</h3>
                    <p class="artwork-card__meta">${fn:escapeXml(art.description)}</p>
                    <div class="artwork-card__footer">
                      <span class="artwork-card__price"><span class="currency">₹ </span>${art.price}</span>
                      <button class="btn btn-sm btn-primary" onclick="startCheckout(${art.id})">Buy Now</button>
                    </div>
                  </div>
                </div>
              </c:forEach>
            </div>
          </c:when>
          <c:otherwise>
            <div class="empty-state">
              <div class="empty-state__icon">🖼</div>
              <h3>No artworks available</h3>
              <p>Check back soon for new listings from our artists.</p>
            </div>
          </c:otherwise>
        </c:choose>
      </div>

      <!-- My Purchases -->
      <div class="dash-section">
        <h2>My Purchased Artworks</h2>
        <c:choose>
          <c:when test="${not empty myPurchases}">
            <div style="display:grid;grid-template-columns:repeat(auto-fill,minmax(340px,1fr));gap:1.25rem;">
              <c:forEach items="${myPurchases}" var="purchase">
                <div class="purchase-card">
                  <img src="${fn:escapeXml(purchase.artwork.imageUrl)}" alt="${fn:escapeXml(purchase.artwork.title)}"
                       onerror="this.src='https://images.unsplash.com/photo-1578301978693-85fa9c0320b9?w=200&q=70'">
                  <div>
                    <div class="purchase-card__title">${fn:escapeXml(purchase.artwork.title)}</div>
                    <div class="purchase-card__date">Purchased ${purchase.purchaseDate}</div>
                    <!-- Review Form -->
                    <details style="margin-top:0.5rem;">
                      <summary style="font-size:0.8rem;cursor:pointer;color:var(--gold);letter-spacing:0.04em;">Leave a review ↓</summary>
                      <form action="/artwork/review" method="POST" style="margin-top:0.75rem;">
                        <input type="hidden" name="artworkId" value="${purchase.artwork.id}">
                        <div class="form-group">
                          <label>Rating (1–5)</label>
                          <input type="number" name="rating" min="1" max="5" required>
                        </div>
                        <div class="form-group">
                          <label>Comment</label>
                          <textarea name="comment" rows="2" required></textarea>
                        </div>
                        <button type="submit" class="btn btn-sm btn-outline">Submit Review</button>
                      </form>
                    </details>
                  </div>
                </div>
              </c:forEach>
            </div>
          </c:when>
          <c:otherwise>
            <div class="empty-state">
              <div class="empty-state__icon">🛒</div>
              <h3>Your collection is empty</h3>
              <p>Explore the gallery above and purchase your first piece.</p>
            </div>
          </c:otherwise>
        </c:choose>
      </div>

    </div>
  </div>

  <%@ include file="/WEB-INF/jsp/fragments/footer.jsp" %>

  <script src="https://checkout.razorpay.com/v1/checkout.js"></script>
  <script>
    function startCheckout(artworkId) {
      fetch('/api/create-order', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ artworkId: artworkId })
      })
      .then(r => r.json())
      .then(order => {
        if (order.error) { alert('Error: ' + order.error); return; }
        var rzp = new Razorpay({
          key: order.key_id, amount: order.amount, currency: order.currency,
          name: 'ArtConnect', description: 'Artwork Purchase', order_id: order.order_id,
          handler: function(response) {
            fetch('/api/verify-payment', {
              method: 'POST',
              headers: { 'Content-Type': 'application/json' },
              body: JSON.stringify({
                razorpay_payment_id: response.razorpay_payment_id,
                razorpay_order_id:   response.razorpay_order_id,
                razorpay_signature:  response.razorpay_signature,
                artworkId: artworkId
              })
            })
            .then(r => r.json())
            .then(data => {
              if (data.status === 'success') window.location.href = '/buyer?success=Payment+successful!';
              else alert('Payment verification failed.');
            });
          },
          theme: { color: '#b8962e' }
        });
        rzp.on('payment.failed', function(r) { alert('Payment failed: ' + r.error.description); });
        rzp.open();
      });
    }
  </script>
</body>
</html>
