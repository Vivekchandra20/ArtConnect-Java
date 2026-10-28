package com.artwork.dao;

import com.artwork.model.Artwork;
import com.artwork.model.Purchase;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

@Repository
public class PurchaseDao {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    public void save(Purchase purchase) {
        String sql = "INSERT INTO purchases (artwork_id, buyer_email) VALUES (?, ?)";
        jdbcTemplate.update(sql, purchase.getArtworkId(), purchase.getBuyerEmail());
    }

    public List<Purchase> findByBuyerEmail(String buyerEmail) {
        // We will do a JOIN to fetch the artwork details as well
        String sql = "SELECT p.*, a.title, a.description, a.price, a.image_url, a.seller_email " +
                     "FROM purchases p JOIN artworks a ON p.artwork_id = a.id " +
                     "WHERE p.buyer_email = ? ORDER BY p.purchase_date DESC";
                     
        return jdbcTemplate.query(sql, new RowMapper<Purchase>() {
            @Override
            public Purchase mapRow(ResultSet rs, int rowNum) throws SQLException {
                Purchase purchase = new Purchase();
                purchase.setId(rs.getInt("id"));
                purchase.setArtworkId(rs.getInt("artwork_id"));
                purchase.setBuyerEmail(rs.getString("buyer_email"));
                purchase.setPurchaseDate(rs.getTimestamp("purchase_date"));

                Artwork artwork = new Artwork();
                artwork.setId(rs.getInt("artwork_id"));
                artwork.setTitle(rs.getString("title"));
                artwork.setDescription(rs.getString("description"));
                artwork.setPrice(rs.getDouble("price"));
                artwork.setImageUrl(rs.getString("image_url"));
                artwork.setSellerEmail(rs.getString("seller_email"));
                
                purchase.setArtwork(artwork);
                return purchase;
            }
        }, buyerEmail);
    }
}
