<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Artwork Platform</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg-color: #0f172a;
            --nav-bg: rgba(30, 41, 59, 0.8);
            --text-color: #f8fafc;
            --primary-accent: #3b82f6;
            --primary-hover: #2563eb;
            --card-bg: rgba(30, 41, 59, 0.5);
        }
        body { margin: 0; padding: 0; font-family: 'Outfit', sans-serif; background: var(--bg-color); color: var(--text-color); }
        nav { background: var(--nav-bg); backdrop-filter: blur(10px); padding: 1rem 2rem; display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid rgba(255, 255, 255, 0.1); position: sticky; top: 0; z-index: 100;}
        .logo { font-size: 1.5rem; font-weight: 600; color: white; text-decoration: none; }
        .nav-links a { color: #cbd5e1; text-decoration: none; margin-left: 1.5rem; transition: color 0.3s; padding: 0.5rem 1rem; border-radius: 8px; border: 1px solid transparent;}
        .nav-links a:hover { color: white; border: 1px solid rgba(255,255,255,0.2); }
        .container { padding: 3rem 2rem; max-width: 1200px; margin: 0 auto; }
        
        /* Seller Form styles */
        .upload-card { background: var(--card-bg); padding: 2rem; border-radius: 16px; border: 1px solid rgba(255,255,255,0.05); margin-bottom: 3rem; }
        .form-group { margin-bottom: 1rem; }
        .form-group label { display: block; margin-bottom: 0.5rem; font-size: 0.9rem; color: #cbd5e1; }
        .form-group input, .form-group textarea { width: 100%; padding: 0.75rem; border-radius: 8px; border: 1px solid rgba(255,255,255,0.2); background: rgba(15,23,42,0.6); color: var(--text-color); box-sizing: border-box; outline: none; transition: border 0.3s; }
        .form-group input:focus, .form-group textarea:focus { border-color: var(--primary-accent); }
        .submit-btn { padding: 0.75rem 2rem; border-radius: 8px; border: none; background: var(--primary-accent); color: white; font-weight: 600; cursor: pointer; transition: background 0.3s; }
        .submit-btn:hover { background: var(--primary-hover); }
        
        /* Buyer Gallery styles */
        .gallery { display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap: 2rem; }
        .art-card { background: var(--card-bg); border-radius: 16px; overflow: hidden; border: 1px solid rgba(255,255,255,0.05); transition: transform 0.3s ease, box-shadow 0.3s ease; display: flex; flex-direction: column;}
        .art-card:hover { transform: translateY(-5px); box-shadow: 0 10px 25px rgba(0,0,0,0.5); }
        .art-image-wrapper { width: 100%; height: 250px; overflow: hidden; }
        .art-image { width: 100%; height: 100%; object-fit: cover; transition: transform 0.5s ease; }
        .art-card:hover .art-image { transform: scale(1.1); }
        .art-info { padding: 1.5rem; flex-grow: 1; display: flex; flex-direction: column;}
        .art-title { margin: 0 0 0.5rem 0; font-size: 1.2rem; font-weight: 600; }
        .art-desc { color: #94a3b8; font-size: 0.9rem; margin-bottom: 1rem; flex-grow: 1;}
        .art-footer { display: flex; justify-content: space-between; align-items: center; margin-top: auto;}
        .art-price { font-weight: 600; color: var(--primary-accent); font-size: 1.2rem; }
        .buy-btn { padding: 0.5rem 1rem; border-radius: 6px; background: transparent; border: 1px solid var(--primary-accent); color: white; cursor: pointer; transition: all 0.3s; }
        .buy-btn:hover { background: var(--primary-accent); }
        .success-msg { color: #10b981; margin-bottom: 1rem; padding: 1rem; background: rgba(16,185,129,0.1); border-radius: 8px;}
    </style>
</head>
<body>
    <nav>
        <a href="/dashboard" class="logo">ArtConnect</a>
        <div class="nav-links">
            <c:choose>
                <c:when test="${not empty user}">
                    <span>Welcome, ${user.name}</span>
                    <a href="/logout">Logout</a>
                </c:when>
                <c:otherwise>
                    <a href="/login">Login</a>
                    <a href="/register" style="background: var(--primary-accent); color: white;">Register</a>
                </c:otherwise>
            </c:choose>
        </div>
    </nav>

    <div class="container">
        
        <c:if test="${not empty param.success}">
            <div class="success-msg">${param.success}</div>
        </c:if>

        <c:choose>
            <c:when test="${user.role == 'SELLER'}">
                <div class="upload-card">
                    <h2>Upload New Artwork</h2>
                    <form action="/artwork/upload" method="POST">
                        <div class="form-group">
                            <label>Title</label>
                            <input type="text" name="title" required placeholder="e.g. Starry Night">
                        </div>
                        <div class="form-group">
                            <label>Description</label>
                            <textarea name="description" rows="3" required placeholder="Tell us about your art..."></textarea>
                        </div>
                        <div class="form-group">
                            <label>Price ($)</label>
                            <input type="number" step="0.01" name="price" required placeholder="99.99">
                        </div>
                        <div class="form-group">
                            <label>Image URL</label>
                            <input type="url" name="imageUrl" required placeholder="https://example.com/image.jpg">
                        </div>
                        <button type="submit" class="submit-btn">Upload Artwork</button>
                    </form>
                </div>

                <h2>Your Uploaded Artworks</h2>
                <div class="gallery">
                    <c:forEach items="${artworks}" var="art">
                        <div class="art-card">
                            <div class="art-image-wrapper">
                                <img src="${art.imageUrl}" alt="${art.title}" class="art-image" onerror="this.src='https://via.placeholder.com/400x300?text=No+Image'">
                            </div>
                            <div class="art-info">
                                <h3 class="art-title">${art.title}</h3>
                                <p class="art-desc">${art.description}</p>
                                <div class="art-footer">
                                    <span class="art-price">$${art.price}</span>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                    <c:if test="${empty artworks}">
                        <p style="color: #94a3b8;">You haven't uploaded any artworks yet.</p>
                    </c:if>
                </div>
                
                <h2 style="margin-top: 4rem;">Reviews on Your Artworks</h2>
                <div class="gallery">
                    <c:forEach items="${sellerReviews}" var="review">
                        <div class="art-card" style="padding: 1.5rem; display: block;">
                            <h3 style="margin-top: 0; color: var(--primary-accent);">${review.artworkTitle}</h3>
                            <div style="color: #fbbf24; margin-bottom: 0.5rem;">
                                <c:forEach begin="1" end="${review.rating}">★</c:forEach><c:forEach begin="${review.rating + 1}" end="5">☆</c:forEach>
                            </div>
                            <p style="font-size: 0.9rem; margin-bottom: 1rem;">"${review.comment}"</p>
                            <p style="font-size: 0.8rem; color: #94a3b8; margin: 0;">By ${review.buyerEmail} on ${review.createdAt}</p>
                        </div>
                    </c:forEach>
                    <c:if test="${empty sellerReviews}">
                        <p style="color: #94a3b8;">No reviews yet.</p>
                    </c:if>
                </div>
            </c:when>
            
            <c:otherwise>
                <!-- Buyer View -->
                <h1 style="margin-bottom: 2rem;">Discover Amazing Artworks</h1>
                <div class="gallery">
                    <c:forEach items="${artworks}" var="art">
                        <div class="art-card">
                            <div class="art-image-wrapper">
                                <img src="${art.imageUrl}" alt="${art.title}" class="art-image" onerror="this.src='https://via.placeholder.com/400x300?text=No+Image'">
                            </div>
                            <div class="art-info">
                                <h3 class="art-title">${art.title}</h3>
                                <p class="art-desc">${art.description}</p>
                                <div class="art-footer">
                                    <span class="art-price">$${art.price}</span>
                                    <c:choose>
                                        <c:when test="${not empty user}">
                                            <button class="buy-btn" onclick="startCheckout(${art.id})">Purchase</button>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="/login" class="buy-btn" style="text-decoration: none; display: inline-block;">Login to Purchase</a>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                    <c:if test="${empty artworks}">
                        <p style="color: #94a3b8;">No artworks available at the moment. Please check back later!</p>
                    </c:if>
                </div>

                <c:if test="${not empty user}">
                <h2 style="margin-top: 4rem; margin-bottom: 2rem;">My Collection</h2>
                <div class="gallery">
                    <c:forEach items="${myPurchases}" var="purchase">
                        <div class="art-card">
                            <div class="art-image-wrapper">
                                <img src="${purchase.artwork.imageUrl}" alt="${purchase.artwork.title}" class="art-image" onerror="this.src='https://via.placeholder.com/400x300?text=No+Image'">
                            </div>
                            <div class="art-info">
                                <h3 class="art-title">${purchase.artwork.title}</h3>
                                <p style="font-size: 0.8rem; color: #10b981;">Purchased on ${purchase.purchaseDate}</p>
                                
                                <form action="/artwork/review" method="POST" style="margin-top: 1rem; padding-top: 1rem; border-top: 1px solid rgba(255,255,255,0.1);">
                                    <input type="hidden" name="artworkId" value="${purchase.artwork.id}">
                                    <div class="form-group" style="margin-bottom: 0.5rem;">
                                        <label>Rating (1-5)</label>
                                        <input type="number" name="rating" min="1" max="5" required style="padding: 0.5rem; width: 100%; border-radius: 6px; border: 1px solid rgba(255,255,255,0.2); background: rgba(15,23,42,0.6); color: white;">
                                    </div>
                                    <div class="form-group" style="margin-bottom: 0.5rem;">
                                        <label>Comment</label>
                                        <textarea name="comment" rows="2" required style="padding: 0.5rem; width: 100%; border-radius: 6px; border: 1px solid rgba(255,255,255,0.2); background: rgba(15,23,42,0.6); color: white;"></textarea>
                                    </div>
                                    <button type="submit" class="buy-btn" style="width: 100%;">Leave Review</button>
                                </form>
                            </div>
                        </div>
                    </c:forEach>
                    <c:if test="${empty myPurchases}">
                        <p style="color: #94a3b8;">You haven't purchased any artworks yet.</p>
                    </c:if>
                </div>
                </c:if>
            </c:otherwise>
        </c:choose>
    </div>

    <script src="https://checkout.razorpay.com/v1/checkout.js"></script>
    <script>
        function startCheckout(artworkId) {
            fetch('/api/create-order', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ artworkId: artworkId })
            })
            .then(response => response.json())
            .then(order => {
                if (order.error) {
                    alert('Error creating order: ' + order.error);
                    return;
                }

                var options = {
                    "key": order.key_id, 
                    "amount": order.amount,
                    "currency": order.currency,
                    "name": "ArtConnect",
                    "description": "Artwork Purchase",
                    "order_id": order.order_id,
                    "handler": function (response) {
                        fetch('/api/verify-payment', {
                            method: 'POST',
                            headers: { 'Content-Type': 'application/json' },
                            body: JSON.stringify({
                                razorpay_payment_id: response.razorpay_payment_id,
                                razorpay_order_id: response.razorpay_order_id,
                                razorpay_signature: response.razorpay_signature,
                                artworkId: artworkId
                            })
                        })
                        .then(res => res.json())
                        .then(data => {
                            if (data.status === 'success') {
                                window.location.href = '/dashboard?success=Payment Successful!';
                            } else {
                                alert('Payment verification failed: ' + data.error);
                            }
                        });
                    },
                    "theme": {
                        "color": "#3b82f6"
                    }
                };
                var rzp1 = new Razorpay(options);
                rzp1.on('payment.failed', function (response){
                    alert('Payment failed: ' + response.error.description);
                });
                rzp1.open();
            })
            .catch(err => {
                console.error('Error:', err);
                alert('Something went wrong!');
            });
        }
    </script>
</body>
</html>
