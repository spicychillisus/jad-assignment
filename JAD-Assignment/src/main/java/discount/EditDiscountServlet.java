package discount;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.ws.rs.client.Client;
import jakarta.ws.rs.client.ClientBuilder;
import jakarta.ws.rs.client.Entity;
import jakarta.ws.rs.client.Invocation;
import jakarta.ws.rs.client.WebTarget;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;

import java.io.IOException;
import java.io.PrintWriter;

/**
 * Servlet implementation class EditDiscountServlet
 */
@WebServlet("/updateDiscount")
public class EditDiscountServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public EditDiscountServlet() {
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
        PrintWriter out = response.getWriter();
        
        // Get discount data from the request (could be JSON or form data)
        int discountId = Integer.parseInt(request.getParameter("discountId"));
        String code = request.getParameter("code");
        double discountValue = Double.parseDouble(request.getParameter("discountValue"));
        String description = request.getParameter("description");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        
        // Prepare the discount data in the correct format (for instance, as JSON)
        String jsonData = String.format(
            "{\"code\":\"%s\", \"discountValue\":%f, \"description\":\"%s\", \"startDate\":\"%s\", \"endDate\":\"%s\"}",
            code, discountValue, description, startDate, endDate);

        // Make the PUT request to the external service
        Client client = ClientBuilder.newClient();
        String restUrl = "http://localhost:8081/discounts/updateDiscount/" + discountId;
        WebTarget target = client.target(restUrl);
        Invocation.Builder invocationBuilder = target.request(MediaType.APPLICATION_JSON);
        Response resp = invocationBuilder.put(Entity.entity(jsonData, MediaType.APPLICATION_JSON));
        
        // Check if the response is successful
        if (resp.getStatus() == Response.Status.OK.getStatusCode()) {
            out.print("Discount updated successfully.");
        } else {
            out.print("Failed to update the discount.");
        }

        // Forward to a JSP page
        String url = "web/admin/viewDiscounts.jsp";
        RequestDispatcher rd = request.getRequestDispatcher(url);
        rd.forward(request, response);
    }

}
