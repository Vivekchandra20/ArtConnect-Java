package com.artwork.controller;

import com.artwork.dao.ArtworkDao;
import com.artwork.dao.PurchaseDao;
import com.artwork.model.Artwork;
import com.artwork.model.Purchase;
import com.artwork.model.User;
import com.razorpay.Order;
import com.razorpay.RazorpayClient;
import com.razorpay.RazorpayException;
import com.razorpay.Utils;
import io.github.cdimascio.dotenv.Dotenv;
import jakarta.servlet.http.HttpSession;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api")
public class RazorpayController {

    @Autowired
    private ArtworkDao artworkDao;

    @Autowired
    private PurchaseDao purchaseDao;

    private String getKeyId() {
        Dotenv dotenv = Dotenv.configure().ignoreIfMissing().load();
        String key = dotenv.get("RAZORPAY_KEY_ID");
        if (key == null) key = System.getenv("RAZORPAY_KEY_ID");
        return key;
    }

    private String getKeySecret() {
        Dotenv dotenv = Dotenv.configure().ignoreIfMissing().load();
        String key = dotenv.get("RAZORPAY_KEY_SECRET");
        if (key == null) key = System.getenv("RAZORPAY_KEY_SECRET");
        return key;
    }

    @PostMapping("/create-order")
    public ResponseEntity<Map<String, Object>> createOrder(@RequestBody Map<String, Object> data, HttpSession session) {
        User user = (User) session.getAttribute("loggedInUser");
        if (user == null || !"BUYER".equals(user.getRole())) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }

        try {
            int artworkId = Integer.parseInt(data.get("artworkId").toString());
            Artwork artwork = artworkDao.findById(artworkId);

            if (artwork == null) {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(Map.of("error", "Artwork not found"));
            }

            // Price in paise
            int amountInPaise = (int) (artwork.getPrice() * 100);
            if (amountInPaise < 100) {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(Map.of("error", "Minimum amount is 100 paise"));
            }

            RazorpayClient razorpayClient = new RazorpayClient(getKeyId(), getKeySecret());

            JSONObject orderRequest = new JSONObject();
            orderRequest.put("amount", amountInPaise);
            orderRequest.put("currency", "INR");
            orderRequest.put("receipt", "txn_" + System.currentTimeMillis());

            Order order = razorpayClient.orders.create(orderRequest);

            Map<String, Object> response = new HashMap<>();
            response.put("order_id", order.get("id"));
            response.put("amount", order.get("amount"));
            response.put("currency", order.get("currency"));
            response.put("key_id", getKeyId()); // Key ID needs to be returned to frontend

            return ResponseEntity.ok(response);

        } catch (RazorpayException e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(Map.of("error", "Razorpay Error"));
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(Map.of("error", "Server Error"));
        }
    }

    @PostMapping("/verify-payment")
    public ResponseEntity<Map<String, Object>> verifyPayment(@RequestBody Map<String, Object> data, HttpSession session) {
        User user = (User) session.getAttribute("loggedInUser");
        if (user == null || !"BUYER".equals(user.getRole())) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }

        try {
            String razorpayPaymentId = data.get("razorpay_payment_id").toString();
            String razorpayOrderId = data.get("razorpay_order_id").toString();
            String razorpaySignature = data.get("razorpay_signature").toString();
            int artworkId = Integer.parseInt(data.get("artworkId").toString());

            if (razorpayPaymentId == null || razorpayOrderId == null || razorpaySignature == null) {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(Map.of("error", "Missing fields"));
            }

            JSONObject verifyRequest = new JSONObject();
            verifyRequest.put("razorpay_order_id", razorpayOrderId);
            verifyRequest.put("razorpay_payment_id", razorpayPaymentId);
            verifyRequest.put("razorpay_signature", razorpaySignature);

            boolean isSignatureValid = Utils.verifyPaymentSignature(verifyRequest, getKeySecret());

            if (isSignatureValid) {
                // Payment Successful, save the purchase
                Purchase purchase = new Purchase();
                purchase.setArtworkId(artworkId);
                purchase.setBuyerEmail(user.getEmail());
                purchaseDao.save(purchase);

                return ResponseEntity.ok(Map.of("status", "success"));
            } else {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(Map.of("error", "Signature mismatch"));
            }
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(Map.of("error", "Verification Error"));
        }
    }
}
