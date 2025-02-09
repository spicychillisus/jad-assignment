package discount;

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
import java.sql.Timestamp;
import java.text.SimpleDateFormat;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;

/**
 * Servlet implementation class CreateDiscountServlet
 */
@WebServlet("/createDiscount")
public class CreateDiscountServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public CreateDiscountServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	    HttpSession session = request.getSession(false);
	    if (session == null || session.getAttribute("adminRole") == null) {
	        response.sendRedirect("/JAD-Assignment/web/login.jsp");
	        return;
	    }

	    // Retrieve form parameters
	    String discountCode = request.getParameter("discountCode");
	    String discountDescription = request.getParameter("discountDescription");
	    String discountAmountStr = request.getParameter("discountAmount");
	    String startDateStr = request.getParameter("startDate");
	    String endDateStr = request.getParameter("endDate");

	    // Convert startDate and endDate to SQL timestamps
	    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
	    Timestamp startDate = null;
	    Timestamp endDate = null;
	    try {
	        startDate = new Timestamp(dateFormat.parse(startDateStr).getTime());
	        endDate = new Timestamp(dateFormat.parse(endDateStr).getTime());
	    } catch (Exception e) {
	        e.printStackTrace();
	        response.sendRedirect("/JAD-Assignment/web/error.jsp");
	        return;
	    }

	    // Validate required fields
	    if (discountCode == null || discountDescription == null || discountAmountStr == null ||
	        startDate == null || endDate == null) {
	        response.sendRedirect("/JAD-Assignment/web/admin/createDiscount.jsp");
	        return;
	    }

	    // Parse discount amount
	    double discountAmount;
	    try {
	        discountAmount = Double.parseDouble(discountAmountStr);
	        if (discountAmount < 0.01 || discountAmount > 1) {
	            throw new NumberFormatException();
	        }
	    } catch (NumberFormatException e) {
	        response.sendRedirect("/JAD-Assignment/web/admin/createDiscount.jsp");
	        return;
	    }

	    // Create JSON payload
	    ObjectMapper objectMapper = new ObjectMapper();
	    ObjectNode jsonBody = objectMapper.createObjectNode();
	    jsonBody.put("code", discountCode);
	    jsonBody.put("discountValue", discountAmount);
	    jsonBody.put("description", discountDescription);
	    jsonBody.put("startDate", startDate.toString());
	    jsonBody.put("endDate", endDate.toString());
	    System.out.println(jsonBody);
	    // Send to REST endpoint
	    Client client = ClientBuilder.newClient();
	    String restUrl = "http://localhost:8081/discounts/createDiscount";
	    WebTarget target = client.target(restUrl);
	    Invocation.Builder invocationBuilder = target.request(MediaType.APPLICATION_JSON);
	    
	    try (Response resp = invocationBuilder.post(Entity.entity(jsonBody.toString(), MediaType.APPLICATION_JSON))) {
	    	System.out.println(resp.getStatus());
	    	System.out.println(Response.Status.CREATED.getStatusCode());
	        if (resp.getStatus() == Response.Status.CREATED.getStatusCode()) {
	            response.sendRedirect("/JAD-Assignment/allDiscounts");
	        } else {
	            response.sendRedirect("/JAD-Assignment/web/admin/createDiscount.jsp");
	        }
	    } catch (Exception e) {
	    	e.printStackTrace();
	        response.sendRedirect("/JAD-Assignment/web/admin/createDiscount.jsp");
	    }
	}

}
