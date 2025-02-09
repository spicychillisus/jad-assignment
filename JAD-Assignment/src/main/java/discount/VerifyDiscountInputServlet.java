package discount;

import jakarta.servlet.RequestDispatcher;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.ws.rs.client.Client;
import jakarta.ws.rs.client.ClientBuilder;
import jakarta.ws.rs.client.Entity;
import jakarta.ws.rs.client.Invocation;
import jakarta.ws.rs.client.WebTarget;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import pg.Config;

import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.fasterxml.jackson.databind.ObjectMapper;
/**
 * Servlet implementation class VerifyDiscountInput
 */
@WebServlet("/verifyDiscount")
public class VerifyDiscountInputServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public VerifyDiscountInputServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		//response.getWriter().append("Served at: ").append(request.getContextPath());
		//response.sendRedirect("/JAD-Assignment/serviceBooking");
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	 protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	        HttpSession session = request.getSession(false);
	        if (session == null || session.getAttribute("userId") == null) {
	            response.sendRedirect("/JAD-Assignment/web/login.jsp");
	            return;
	        }

	        int userId = (int) session.getAttribute("userId");
	        String discountCode = request.getParameter("discount");
	        PrintWriter out = response.getWriter();

	        // First check if user has already used this discount
	        if (hasUserUsedDiscount(userId, discountCode)) {
	            response.setContentType("text/html");
	            out.println("<script type='text/javascript'>");
	            out.println("alert('You have already used this discount code.');");
	            out.println("window.location.href='/JAD-Assignment/serviceBooking';");
	            out.println("</script>");
	            return;
	        }

	        // If not used, proceed with discount validation
	        Client client = ClientBuilder.newClient();
	        String restUrl = "http://localhost:8081/discounts/checkDiscountExists";
	        WebTarget target = client.target(restUrl);
	        
	        String jsonBody = "{\"discountCode\": \"" + discountCode + "\"}";
	        String service = (String)session.getAttribute("serviceName");
	        String price = (String)session.getAttribute("price");
	        double svcPrice = Double.parseDouble(price);
	        String defaultRedirect = "/JAD-Assignment/serviceBooking?service=" + service + "&price=" + price;
	        try {
	            Invocation.Builder invocationBuilder = target.request(MediaType.APPLICATION_JSON);
	            Response resp = invocationBuilder.post(Entity.entity(jsonBody, MediaType.APPLICATION_JSON));
	            
	            if (resp.getStatus() == 200) {
	                String jsonResponse = resp.readEntity(String.class);
	                ObjectMapper objectMapper = new ObjectMapper();
	                @SuppressWarnings("unchecked")
					Map<String, Object> responseMap = objectMapper.readValue(jsonResponse, Map.class);
	                double discountAmt = (double) responseMap.get("discountValue");
	                double newPrice = svcPrice - (svcPrice * discountAmt);
	                
	                BigDecimal roundedPrice = new BigDecimal(newPrice).setScale(2, RoundingMode.HALF_UP);
	                double finalPrice = roundedPrice.doubleValue();
	                
	                session.setAttribute("discountCode", discountCode);
	                session.setAttribute("discountid", (int) responseMap.get("discountId"));
	                
	                response.sendRedirect("/JAD-Assignment/serviceBooking?service=" + service + "&price=" + finalPrice);
	            } else {
	                response.setContentType("text/html");
	                out.println("<script type='text/javascript'>");
	                out.println("alert('Invalid discount code.');");
	                out.println(String.format("window.location.href='%s';", defaultRedirect));
	                out.println("</script>");
	            }
	            
	            resp.close();
	        } finally {
	            client.close();
	        }
	    }
	 
	 private boolean hasUserUsedDiscount(int userId, String discountCode) {
	        Config neon = new Config();
	        String url = neon.getConnectionUrl();
	        String username = neon.getUser();
	        String password = neon.getPassword();
	        
	        try {
	            Class.forName("org.postgresql.Driver");
	            try (Connection conn = DriverManager.getConnection(url, username, password)) {
	                // First get the discount ID
	                String discountQuery = "SELECT id FROM discounts WHERE code = ?";
	                try (PreparedStatement ps = conn.prepareStatement(discountQuery)) {
	                    ps.setString(1, discountCode);
	                    ResultSet rs = ps.executeQuery();
	                    if (rs.next()) {
	                        int discountId = rs.getInt("id");
	                        
	                        // Then check if user has used this discount
	                        String usageQuery = "SELECT COUNT(*) FROM discount_usage WHERE userid = ? AND discountid = ?";
	                        try (PreparedStatement usagePs = conn.prepareStatement(usageQuery)) {
	                            usagePs.setInt(1, userId);
	                            usagePs.setInt(2, discountId);
	                            ResultSet usageRs = usagePs.executeQuery();
	                            if (usageRs.next()) {
	                                return usageRs.getInt(1) > 0;
	                            }
	                        }
	                    }
	                }
	            }
	        } catch (Exception e) {
	            e.printStackTrace();
	            return false;
	        }
	        return false;
	    }

}
