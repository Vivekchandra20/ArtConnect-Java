package com.artwork.model;

import java.sql.Timestamp;

public class Review {
    private int id;
    private int artworkId;
    private String buyerEmail;
    private int rating;
    private String comment;
    private Timestamp createdAt;
    
    private String artworkTitle; // For displaying to sellers

    public Review() {}

    public String getArtworkTitle() { return artworkTitle; }
    public void setArtworkTitle(String artworkTitle) { this.artworkTitle = artworkTitle; }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getArtworkId() { return artworkId; }
    public void setArtworkId(int artworkId) { this.artworkId = artworkId; }
    public String getBuyerEmail() { return buyerEmail; }
    public void setBuyerEmail(String buyerEmail) { this.buyerEmail = buyerEmail; }
    public int getRating() { return rating; }
    public void setRating(int rating) { this.rating = rating; }
    public String getComment() { return comment; }
    public void setComment(String comment) { this.comment = comment; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
