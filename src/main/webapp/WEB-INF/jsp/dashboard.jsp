<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>ArtConnect — Discover Original Art</title>
  <link rel="stylesheet" href="/static/css/style.css">
</head>
<body>

  <%@ include file="/WEB-INF/jsp/fragments/nav.jsp" %>

  <!-- ===================== HERO ===================== -->
  <section class="hero">
    <div class="hero__bg"></div>
    <div class="hero__overlay"></div>
    <div class="hero__content">
      <p class="hero__eyebrow">— The Art Marketplace</p>
      <h1 class="hero__title">Discover Art That<br>Moves You.</h1>
      <p class="hero__sub">A curated platform connecting passionate collectors with independent artists and their original works.</p>
      <div class="hero__actions">
        <a href="#gallery" class="btn btn-gold btn-lg">Explore Gallery</a>
        <a href="/register" class="btn btn-lg" style="background:rgba(255,255,255,0.1);color:#fff;border-color:rgba(255,255,255,0.3);">
          Sell Your Art
        </a>
      </div>
    </div>
  </section>

  <!-- ===================== STRIP ===================== -->
  <div class="featured-strip">
    <div class="featured-strip__inner">
      <div class="featured-strip__item"><span>✦</span><span>Original artworks only</span></div>
      <div class="featured-strip__item"><span>✦</span><span>Secure Razorpay payments</span></div>
      <div class="featured-strip__item"><span>✦</span><span>Direct from the artist</span></div>
      <div class="featured-strip__item"><span>✦</span><span>Verified sellers</span></div>
      <div class="featured-strip__item"><span>✦</span><span>Every piece unique</span></div>
    </div>
  </div>

  <!-- ===================== GALLERY ===================== -->
  <section class="section" id="gallery">
    <div class="container">

      <c:if test="${not empty param.success}">
        <div class="alert-success" style="margin-bottom:2rem;">${param.success}</div>
      </c:if>

      <div class="section-header">
        <h2>Available Artworks</h2>
        <c:if test="${not empty user && user.role == 'SELLER'}">
          <a href="/seller" class="view-all">Go to My Studio ↗</a>
        </c:if>
      </div>

      <c:choose>
        <c:when test="${not empty artworks}">
          <div class="artwork-grid">
            <c:forEach items="${artworks}" var="art">
              <div class="artwork-card">
                <div class="artwork-card__img-wrap">
                  <img
                    src="${fn:escapeXml(art.imageUrl)}"
                    alt="${fn:escapeXml(art.title)}"
                    class="artwork-card__img"
                    onerror="this.src='https://images.unsplash.com/photo-1578301978693-85fa9c0320b9?w=600&q=70'"
                  >
                  <span class="artwork-card__badge badge-new">Original</span>
                </div>
                <div class="artwork-card__body">
                  <p class="artwork-card__artist">${fn:escapeXml(art.sellerEmail)}</p>
                  <h3 class="artwork-card__title">${fn:escapeXml(art.title)}</h3>
                  <p class="artwork-card__meta">${fn:escapeXml(art.description)}</p>
                  <div class="artwork-card__footer">
                    <div class="artwork-card__price">
                      <span class="currency">₹ </span>${art.price}
                    </div>
                    <c:choose>
                      <c:when test="${not empty user && user.role == 'BUYER'}">
                        <button class="btn btn-sm btn-primary" onclick="startCheckout(${art.id})">Buy Now</button>
                      </c:when>
                      <c:when test="${empty user}">
                        <a href="/login" class="btn btn-sm btn-outline">Login to Buy</a>
                      </c:when>
                    </c:choose>
                  </div>
                </div>
              </div>
            </c:forEach>
          </div>
        </c:when>
        <c:otherwise>
          <div class="empty-state">
            <div class="empty-state__icon">🖼</div>
            <h3>No artworks yet</h3>
            <p>Be the first artist to list a piece. <a href="/register" style="border-bottom:1px solid currentColor;">Join as a Seller.</a></p>
          </div>
        </c:otherwise>
      </c:choose>
    </div>
  </section>

  <!-- ===================== CTA BANNER ===================== -->
  <section style="background:var(--nav);padding:5rem 0;">
    <div class="container" style="text-align:center;color:#fff;">
      <p style="font-size:0.75rem;letter-spacing:0.18em;text-transform:uppercase;color:var(--gold);margin-bottom:1rem;">For Artists</p>
      <h2 style="font-family:var(--serif);font-size:clamp(1.8rem,4vw,3rem);color:#fff;margin-bottom:1rem;">Share Your Work With the World</h2>
      <p style="color:rgba(255,255,255,0.65);max-width:480px;margin:0 auto 2.5rem;line-height:1.75;">List your original artworks, reach passionate collectors, and receive secure payments directly.</p>
      <a href="/register" class="btn btn-gold btn-lg">Start Selling Today</a>
    </div>
  </section>

  <%@ include file="/WEB-INF/jsp/fragments/footer.jsp" %>

  <!-- Razorpay -->
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
          key: order.key_id,
          amount: order.amount,
          currency: order.currency,
          name: 'ArtConnect',
          description: 'Artwork Purchase',
          order_id: order.order_id,
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
      })
      .catch(() => alert('Something went wrong.'));
    }
  </script>
</body>
</html>
