package com.artwork.dao;

import com.artwork.model.Artwork;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

@Repository
public class ArtworkDao {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    private RowMapper<Artwork> artworkRowMapper = new RowMapper<Artwork>() {
        @Override
        public Artwork mapRow(ResultSet rs, int rowNum) throws SQLException {
            Artwork artwork = new Artwork();
            artwork.setId(rs.getInt("id"));
            artwork.setTitle(rs.getString("title"));
            artwork.setDescription(rs.getString("description"));
            artwork.setPrice(rs.getDouble("price"));
            artwork.setImageUrl(rs.getString("image_url"));
            artwork.setSellerEmail(rs.getString("seller_email"));
            artwork.setCreatedAt(rs.getTimestamp("created_at"));
            return artwork;
        }
    };

    public void save(Artwork artwork) {
        String sql = "INSERT INTO artworks (title, description, price, image_url, seller_email) VALUES (?, ?, ?, ?, ?)";
        jdbcTemplate.update(sql, artwork.getTitle(), artwork.getDescription(), artwork.getPrice(), artwork.getImageUrl(), artwork.getSellerEmail());
    }

    public List<Artwork> findAll() {
        String sql = "SELECT a.* FROM artworks a LEFT JOIN purchases p ON a.id = p.artwork_id WHERE p.id IS NULL ORDER BY a.created_at DESC";
        return jdbcTemplate.query(sql, artworkRowMapper);
    }

    public Artwork findById(int id) {
        String sql = "SELECT * FROM artworks WHERE id = ?";
        List<Artwork> artworks = jdbcTemplate.query(sql, artworkRowMapper, id);
        return artworks.isEmpty() ? null : artworks.get(0);
    }

    public List<Artwork> findBySellerEmail(String sellerEmail) {
        String sql = "SELECT * FROM artworks WHERE seller_email = ? ORDER BY created_at DESC";
        return jdbcTemplate.query(sql, artworkRowMapper, sellerEmail);
    }
}
