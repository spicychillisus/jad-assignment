package services;
import pg.Config;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.ws.rs.client.Client;
import jakarta.ws.rs.client.ClientBuilder;
import jakarta.ws.rs.client.Invocation;
import jakarta.ws.rs.client.WebTarget;
import jakarta.ws.rs.core.GenericType;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import discount.Discount;


/**
 * Servlet implementation class GetUserDiscountServlet
 */
@WebServlet("/serviceBooking")
public class BookServiceServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private Config neon = new Config();
	private String url = neon.getConnectionUrl();
	private String username = neon.getUser();
	private String dbPassword = neon.getPassword();
    public BookServiceServlet() {
        super();
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	 HttpSession session = request.getSession(false);
         if (session == null || session.getAttribute("userName") == null) {
             response.sendRedirect("/JAD-Assignment/web/login.jsp"); // Redirect to login if user is not logged in
             return;
         }

         Object userIdObj = session.getAttribute("userId");
         String userId = (userIdObj != null) ? userIdObj.toString() : null;
         System.out.println(userId);
        PrintWriter out = response.getWriter();
        Client client = ClientBuilder.newClient();
        String restUrl = "http://localhost:8081/discounts/getAllDiscounts";
        WebTarget target = client.target(restUrl);
        Invocation.Builder invocationBuilder = target.request(MediaType.APPLICATION_JSON);
        Response resp = invocationBuilder.get();
        System.out.println(resp.getStatus());
        
        // Check the response status from the REST API
        if (resp.getStatus() == Response.Status.OK.getStatusCode()) {
            // If successful, get all the discounts avialable for the user
            ArrayList<Discount> validDiscounts = resp.readEntity(new GenericType<ArrayList<Discount>>() {});
            System.out.println(validDiscounts.size());
            request.setAttribute("discounts", validDiscounts);
            
            // for the sake of filling the form
            // Retrieve the 'service' and 'price' parameters from the request
            String service = request.getParameter("service");
            String price = request.getParameter("price");

            // Check if the 'service' or 'price' parameters are missing, and assign default values
            if (service == null || service.isEmpty()) {
                service = "defaultService";  // Default service value
            }
            if (price == null || price.isEmpty()) {
                price = "0.00";  // Default price value
            }

            // Set the discount list as a request attribute
            request.setAttribute("validDiscounts", validDiscounts);
            
            // checking if discount code is valid
            String discountCode = request.getParameter("discountCode");

            if (discountCode != null && !discountCode.isEmpty()) {
                // Check if the entered discount code is valid
                boolean isValidDiscount = false;
                for (Discount discount : validDiscounts) {
                    if (discountCode.equals(discount.getCode())) {
                        isValidDiscount = true;
                        // Set a valid discount message
                        request.setAttribute("validDiscount", "Discount applied: " + discount.getCode());
                        break;
                    }
                }
                if (!isValidDiscount) {
                    // If the discount code is invalid, set an error message
                    request.setAttribute("invalidDiscount", "Invalid discount code.");
                }
            }

            // Construct the URL with the dynamic parameters
            String url = "web/bookService.jsp?service=" + service + "&price=" + price;
            RequestDispatcher rd = request.getRequestDispatcher(url);

            // Forward the request to the constructed URL
            rd.forward(request, response);
        } else {
            // In case of an error (e.g., response not OK), set error message and forward to 'viewAllDiscounts.jsp'
            String url = "web/services.jsp";
            request.setAttribute("err", "NotFound");
            RequestDispatcher rd = request.getRequestDispatcher(url);
            rd.forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	String discountCode = request.getParameter("discount");
        System.out.println(discountCode);
        doGet(request, response);

    }
}


