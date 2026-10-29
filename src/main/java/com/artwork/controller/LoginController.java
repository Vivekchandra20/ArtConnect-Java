package com.artwork.controller;

import com.artwork.dao.ArtworkDao;
import com.artwork.dao.PurchaseDao;
import com.artwork.dao.ReviewDao;
import com.artwork.dao.UserDao;
import com.artwork.model.Artwork;
import com.artwork.model.User;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class LoginController {

    @Autowired private UserDao userDao;
    @Autowired private ArtworkDao artworkDao;
    @Autowired private PurchaseDao purchaseDao;
    @Autowired private ReviewDao reviewDao;

    /* ── Root ── */
    @GetMapping("/")
    public String home() { return "redirect:/dashboard"; }

    /* ── Auth ── */
    @GetMapping("/login")
    public String loginPage() { return "login"; }

    @PostMapping("/login")
    public String performLogin(@RequestParam("email") String email,
                               @RequestParam("password") String password,
                               @RequestParam("role") String role,
                               HttpSession session, Model model) {
        User user = userDao.findByEmail(email);
        if (user != null && user.getPassword().equals(password) && user.getRole().equals(role)) {
            session.setAttribute("loggedInUser", user);
            return "SELLER".equals(user.getRole()) ? "redirect:/seller" : "redirect:/buyer";
        }
        model.addAttribute("error", "Invalid email, password, or role. Please try again.");
        return "login";
    }

    @GetMapping("/register")
    public String registerPage() { return "register"; }

    @PostMapping("/register")
    public String performRegister(@RequestParam("name") String name,
                                  @RequestParam("email") String email,
                                  @RequestParam("password") String password,
                                  @RequestParam("role") String role,
                                  Model model) {
        if (userDao.findByEmail(email) != null) {
            model.addAttribute("error", "This email is already registered.");
            return "register";
        }
        userDao.save(new User(email, name, password, role));
        model.addAttribute("success", "Account created! Please sign in.");
        return "login";
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/dashboard";
    }

    /* ── Public Gallery ── */
    @GetMapping("/dashboard")
    public String dashboard(HttpSession session, Model model) {
        User user = (User) session.getAttribute("loggedInUser");
        if (user != null) model.addAttribute("user", user);
        model.addAttribute("artworks", artworkDao.findAll());
        return "dashboard";
    }

    /* ── Buyer Dashboard ── */
    @GetMapping("/buyer")
    public String buyerDashboard(HttpSession session, Model model) {
        User user = (User) session.getAttribute("loggedInUser");
        if (user == null || !"BUYER".equals(user.getRole())) return "redirect:/login";
        model.addAttribute("user", user);
        model.addAttribute("artworks", artworkDao.findAll());
        model.addAttribute("myPurchases", purchaseDao.findByBuyerEmail(user.getEmail()));
        return "buyer-dashboard";
    }

    /* ── Seller Dashboard ── */
    @GetMapping("/seller")
    public String sellerDashboard(HttpSession session, Model model) {
        User user = (User) session.getAttribute("loggedInUser");
        if (user == null || !"SELLER".equals(user.getRole())) return "redirect:/login";
        model.addAttribute("user", user);
        model.addAttribute("artworks", artworkDao.findBySellerEmail(user.getEmail()));
        model.addAttribute("sellerReviews", reviewDao.findBySellerEmail(user.getEmail()));
        return "seller-dashboard";
    }

    /* ── Artwork Detail ── */
    @GetMapping("/artwork/{id}")
    public String artworkDetail(@PathVariable("id") int id,
                                HttpSession session, Model model) {
        Artwork artwork = artworkDao.findById(id);
        if (artwork == null) return "redirect:/dashboard";
        User user = (User) session.getAttribute("loggedInUser");
        if (user != null) model.addAttribute("user", user);
        model.addAttribute("artwork", artwork);
        return "artwork-detail";
    }
}
