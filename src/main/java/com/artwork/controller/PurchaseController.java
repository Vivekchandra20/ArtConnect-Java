package com.artwork.controller;

import com.artwork.dao.PurchaseDao;
import com.artwork.model.Purchase;
import com.artwork.model.User;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class PurchaseController {

    @Autowired
    private PurchaseDao purchaseDao;

    @PostMapping("/artwork/purchase")
    public String purchaseArtwork(@RequestParam("artworkId") int artworkId, HttpSession session) {
        User user = (User) session.getAttribute("loggedInUser");
        if (user == null || !"BUYER".equals(user.getRole())) {
            return "redirect:/login";
        }

        Purchase purchase = new Purchase();
        purchase.setArtworkId(artworkId);
        purchase.setBuyerEmail(user.getEmail());

        purchaseDao.save(purchase);

        return "redirect:/dashboard?success=Congratulations! You have successfully purchased the artwork.";
    }
}
