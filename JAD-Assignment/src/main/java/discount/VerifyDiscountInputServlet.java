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

import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.math.RoundingMode;

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
        // Check if user is logged in
		System.out.println("test");
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("/JAD-Assignment/web/login.jsp"); // Redirect to login if user is not logged in
            return;
        }

        // Get the discount code from the request
        String discountCode = request.getParameter("discount");
        PrintWriter out = response.getWriter();
        
        // Prepare to call the external REST service
        Client client = ClientBuilder.newClient();
        String restUrl = "http://localhost:8081/discounts/checkDiscountExists";
        WebTarget target = client.target(restUrl);
        
        // Create JSON body for the POST request
        String jsonBody = "{\"discountCode\": \"" + discountCode + "\"}";
        System.out.println(jsonBody);

        // Make the POST request
        Invocation.Builder invocationBuilder = target.request(MediaType.APPLICATION_JSON);
        Response resp = invocationBuilder.post(Entity.entity(jsonBody, MediaType.APPLICATION_JSON));
        
        // Handle the response from the external service
        int status = resp.getStatus();
        if (status == 200) {
            // If the discount code is valid
        	String jsonResponse = resp.readEntity(String.class);
            System.out.println("Response JSON: " + jsonResponse);
            
            ObjectMapper objectMapper = new ObjectMapper();
            @SuppressWarnings("unchecked")
			Map<String, Object> responseMap = objectMapper.readValue(jsonResponse, Map.class);
            System.out.println("hehehehehe");
            System.out.println(responseMap.get("discountValue"));
            
            
            String discountCodeReturn = discountCode;
            out.println("<h3>Valid Discount Code:</h3>");
            out.println("<p>Discount Code: " + discountCodeReturn + "</p>");
            String price = (String)session.getAttribute("price");
            String service = (String)session.getAttribute("serviceName");
            double svcPrice = Double.parseDouble(price);
            double discountAmt = (double) responseMap.get("discountValue");
            double newPrice = svcPrice - (svcPrice * discountAmt);
            // Round to 2 decimal places using BigDecimal
            BigDecimal roundedPrice = new BigDecimal(newPrice).setScale(2, RoundingMode.HALF_UP);

            // Get the value as double
            double finalPrice = roundedPrice.doubleValue();
            System.out.println(service);
            System.out.println("berified!");
            System.out.println(discountCodeReturn);
            session.setAttribute("discountCode", discountCodeReturn);
            System.out.println("statuscode:" + status);
            response.sendRedirect("/JAD-Assignment/serviceBooking?service=" + service + "&price=" + finalPrice);
        } else {
            // If the discount code is invalid or some error occurred
            out.println("<h3>Invalid Discount Code or Error Occurred</h3>");
            out.println("<p>Please check the discount code and try again.</p>");
        }

        // Close the response to release resources
        resp.close();
        client.close(); // Close the client to free up resources
    }

}
