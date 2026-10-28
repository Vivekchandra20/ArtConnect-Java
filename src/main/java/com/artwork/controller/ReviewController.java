package com.artwork.controller;

import com.artwork.dao.ReviewDao;
import com.artwork.model.Review;
import com.artwork.model.User;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class ReviewController {

    @Autowired
    private ReviewDao reviewDao;

    @PostMapping("/artwork/review")
    public String leaveReview(@RequestParam("artworkId") int artworkId,
                              @RequestParam("rating") int rating,
                              @RequestParam("comment") String comment,
                              HttpSession session) {
        User user = (User) session.getAttribute("loggedInUser");
        if (user == null || !"BUYER".equals(user.getRole())) {
            return "redirect:/login";
        }

        Review review = new Review();
        review.setArtworkId(artworkId);
        review.setBuyerEmail(user.getEmail());
        review.setRating(rating);
        review.setComment(comment);

        reviewDao.save(review);

        return "redirect:/dashboard?success=Thank you! Your review has been submitted.";
    }
}
