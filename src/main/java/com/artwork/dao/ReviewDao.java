package com.artwork.dao;

import com.artwork.model.Review;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

@Repository
public class ReviewDao {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    public void save(Review review) {
        String sql = "INSERT INTO reviews (artwork_id, buyer_email, rating, comment) VALUES (?, ?, ?, ?)";
        jdbcTemplate.update(sql, review.getArtworkId(), review.getBuyerEmail(), review.getRating(), review.getComment());
    }

    public java.util.List<Review> findBySellerEmail(String sellerEmail) {
        String sql = "SELECT r.*, a.title as artwork_title FROM reviews r JOIN artworks a ON r.artwork_id = a.id WHERE a.seller_email = ? ORDER BY r.created_at DESC";
        return jdbcTemplate.query(sql, (rs, rowNum) -> {
            Review review = new Review();
            review.setId(rs.getInt("id"));
            review.setArtworkId(rs.getInt("artwork_id"));
            review.setBuyerEmail(rs.getString("buyer_email"));
            review.setRating(rs.getInt("rating"));
            review.setComment(rs.getString("comment"));
            review.setCreatedAt(rs.getTimestamp("created_at"));
            review.setArtworkTitle(rs.getString("artwork_title"));
            return review;
        }, sellerEmail);
    }
}
