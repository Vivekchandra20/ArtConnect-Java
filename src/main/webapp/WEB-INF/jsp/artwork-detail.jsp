<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>${fn:escapeXml(artwork.title)} — ArtConnect</title>
  <link rel="stylesheet" href="/static/css/style.css">
</head>
<body>

  <%@ include file="/WEB-INF/jsp/fragments/nav.jsp" %>

  <div class="detail-page">
    <div class="container">
      <div class="detail-grid">

        <!-- Left: Image -->
        <div class="detail-img-wrap">
          <img
            src="${fn:escapeXml(artwork.imageUrl)}"
            alt="${fn:escapeXml(artwork.title)}"
            class="detail-img"
            onerror="this.src='https://images.unsplash.com/photo-1578301978693-85fa9c0320b9?w=800&q=80'"
          >
        </div>

        <!-- Right: Info -->
        <div class="detail-info">
          <div class="detail-artist-row">
            <div>
              <div class="detail-artist-name">${fn:escapeXml(artwork.sellerEmail)}</div>
              <div class="detail-artist-role">Independent Artist</div>
            </div>
          </div>

          <h1 class="detail-title">${fn:escapeXml(artwork.title)}</h1>

          <p class="detail-description">
            <c:choose>
              <c:when test="${not empty artwork.description}">${fn:escapeXml(artwork.description)}</c:when>
              <c:otherwise>No description provided for this artwork.</c:otherwise>
            </c:choose>
          </p>

          <div class="detail-meta">
            <div class="detail-meta-item">
              <label>Listed By</label>
              <span>${fn:escapeXml(artwork.sellerEmail)}</span>
            </div>
            <div class="detail-meta-item">
              <label>Type</label>
              <span>Original Artwork</span>
            </div>
            <div class="detail-meta-item">
              <label>Listed On</label>
              <span>${artwork.createdAt}</span>
            </div>
            <div class="detail-meta-item">
              <label>Availability</label>
              <span class="badge badge-gold">Available</span>
            </div>
          </div>

          <div class="detail-price-row">
            <div>
              <div class="detail-price-label">Price</div>
              <div class="detail-price-value">₹${artwork.price}</div>
            </div>
            <div>
              <c:choose>
                <c:when test="${not empty user && user.role == 'BUYER'}">
                  <button class="btn btn-gold btn-lg" onclick="startCheckout(${artwork.id})">Purchase Artwork</button>
                </c:when>
                <c:when test="${empty user}">
                  <a href="/login" class="btn btn-gold btn-lg">Sign In to Purchase</a>
                </c:when>
                <c:otherwise>
                  <span class="badge badge-dark">Your Listing</span>
                </c:otherwise>
              </c:choose>
            </div>
          </div>

          <p style="font-size:0.78rem;color:var(--text-muted);margin-top:1rem;">
            🔒 Secure checkout via Razorpay &nbsp;·&nbsp; Original artwork, direct from the artist
          </p>
        </div>

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
