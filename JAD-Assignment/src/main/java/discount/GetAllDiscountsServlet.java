package discount;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import java.sql.*;
import java.util.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.ws.rs.client.Client;
import jakarta.ws.rs.client.ClientBuilder;
import jakarta.ws.rs.client.Invocation;
import jakarta.ws.rs.client.WebTarget;
import jakarta.ws.rs.core.GenericType;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import pg.*;

import java.io.IOException;
import java.io.PrintWriter;

/**
 * Servlet implementation class GetAllDiscountsServlet
 */
@WebServlet("/allDiscounts")
public class GetAllDiscountsServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private String url;
    private String username;
    private String dbPassword;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public GetAllDiscountsServlet() {
        super();
        // TODO Auto-generated constructor stub
    }
    
    @Override
    public void init() {
        Config neon = new Config();
        this.url = neon.getConnectionUrl();
        this.username = neon.getUser();
        this.dbPassword = neon.getPassword();
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		//response.getWriter().append("Served at: ").append(request.getContextPath());
		PrintWriter out = response.getWriter();
		Client client = ClientBuilder.newClient();
		String restUrl = "http://localhost:8081/discounts/getAllDiscounts";
		WebTarget target = client.target(restUrl);
		Invocation.Builder invocationBuilder = target.request(MediaType.APPLICATION_JSON);
		Response resp = invocationBuilder.get();
		System.out.println(resp.getStatus());
		
		if (resp.getStatus() == Response.Status.OK.getStatusCode()) {
			ArrayList<Discount> discountList = resp.readEntity(new GenericType<ArrayList<Discount>>() {});
			for (Discount discount : discountList) {
				out.print("<br>id: " + discount.getId());
				out.print("<br>code: " + discount.getCode());
				out.print("<br>discount_value: " + discount.getDiscountValue());
				out.print("<br>description: " + discount.getDescription());
				out.print("<br>start: " + discount.getStartDate());
				out.print("<br>end: " + discount.getEndDate());
				out.print("<br>made at: " + discount.getCreatedAt());
			}
			
			request.setAttribute("discountList", discountList);
			String url = "web/admin/viewAllDiscounts.jsp";
			RequestDispatcher rd = request.getRequestDispatcher(url);
			rd.forward(request, response);
		} else {
			String url = "web/admin/viewAllDiscounts.jsp";
			request.setAttribute("err", "NotFound");
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
