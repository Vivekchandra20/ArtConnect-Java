package com.artwork.model;

import java.sql.Timestamp;

public class Purchase {
    private int id;
    private int artworkId;
    private String buyerEmail;
    private Timestamp purchaseDate;

    // Additionally, we might want to store the joined Artwork object for display
    private Artwork artwork;

    public Purchase() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getArtworkId() { return artworkId; }
    public void setArtworkId(int artworkId) { this.artworkId = artworkId; }
    public String getBuyerEmail() { return buyerEmail; }
    public void setBuyerEmail(String buyerEmail) { this.buyerEmail = buyerEmail; }
    public Timestamp getPurchaseDate() { return purchaseDate; }
    public void setPurchaseDate(Timestamp purchaseDate) { this.purchaseDate = purchaseDate; }
    public Artwork getArtwork() { return artwork; }
    public void setArtwork(Artwork artwork) { this.artwork = artwork; }
}
