package com.artwork.controller;

import com.artwork.dao.ArtworkDao;
import com.artwork.model.Artwork;
import com.artwork.model.User;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class ArtworkController {

    @Autowired
    private ArtworkDao artworkDao;

    @PostMapping("/artwork/upload")
    public String uploadArtwork(@RequestParam("title") String title,
                                @RequestParam("description") String description,
                                @RequestParam("price") double price,
                                @RequestParam("imageUrl") String imageUrl,
                                HttpSession session) {
        User user = (User) session.getAttribute("loggedInUser");
        if (user == null || !"SELLER".equals(user.getRole())) {
            return "redirect:/login";
        }

        Artwork artwork = new Artwork();
        artwork.setTitle(title);
        artwork.setDescription(description);
        artwork.setPrice(price);
        artwork.setImageUrl(imageUrl);
        artwork.setSellerEmail(user.getEmail());

        artworkDao.save(artwork);

        return "redirect:/dashboard?success=Artwork uploaded successfully";
    }
}
