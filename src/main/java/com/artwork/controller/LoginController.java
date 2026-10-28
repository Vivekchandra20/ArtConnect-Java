package com.artwork.controller;

import com.artwork.dao.UserDao;
import com.artwork.model.User;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class LoginController {

    @Autowired
    private UserDao userDao;

    @GetMapping("/")
    public String home() {
        return "redirect:/dashboard";
    }

    @GetMapping("/login")
    public String loginPage() {
        return "login";
    }

    @PostMapping("/login")
    public String performLogin(@RequestParam("email") String email, 
                               @RequestParam("password") String password, 
                               @RequestParam("role") String role,
                               HttpSession session, 
                               Model model) {
        User user = userDao.findByEmail(email);
        if (user != null && user.getPassword().equals(password) && user.getRole().equals(role)) {
            session.setAttribute("loggedInUser", user);
            return "redirect:/dashboard";
        }
        model.addAttribute("error", "Invalid email, password, or role.");
        return "login";
    }

    @GetMapping("/register")
    public String registerPage() {
        return "register";
    }

    @PostMapping("/register")
    public String performRegister(@RequestParam("name") String name,
                                  @RequestParam("email") String email,
                                  @RequestParam("password") String password,
                                  @RequestParam("role") String role,
                                  Model model) {
        if (userDao.findByEmail(email) != null) {
            model.addAttribute("error", "Email is already registered.");
            return "register";
        }
        
        User newUser = new User(email, name, password, role);
        userDao.save(newUser);
        model.addAttribute("success", "Registration successful. Please login.");
        return "login";
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/login";
    }

    @Autowired
    private com.artwork.dao.ArtworkDao artworkDao;

    @Autowired
    private com.artwork.dao.PurchaseDao purchaseDao;

    @Autowired
    private com.artwork.dao.ReviewDao reviewDao;

    @GetMapping("/dashboard")
    public String dashboard(HttpSession session, Model model) {
        User user = (User) session.getAttribute("loggedInUser");
        
        if (user != null) {
            model.addAttribute("user", user);
            if ("SELLER".equals(user.getRole())) {
                model.addAttribute("artworks", artworkDao.findBySellerEmail(user.getEmail()));
                model.addAttribute("sellerReviews", reviewDao.findBySellerEmail(user.getEmail()));
            } else {
                model.addAttribute("artworks", artworkDao.findAll());
                model.addAttribute("myPurchases", purchaseDao.findByBuyerEmail(user.getEmail()));
            }
        } else {
            // Unauthenticated user viewing public gallery
            model.addAttribute("artworks", artworkDao.findAll());
        }
        
        return "dashboard";
    }
}
