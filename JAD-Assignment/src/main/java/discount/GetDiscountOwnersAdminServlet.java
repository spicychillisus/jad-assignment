package discount;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
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
import pg.Config;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;

/**
 * Servlet implementation class GetDiscountOwners
 */
@WebServlet("/discountOwners")
public class GetDiscountOwnersAdminServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private String url;
    private String username;
    private String dbPassword;   
    /**
     * @see HttpServlet#HttpServlet()
     */
    public GetDiscountOwnersAdminServlet() {
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
		String discountId = request.getParameter("id");
		PrintWriter out = response.getWriter();
		Client client = ClientBuilder.newClient();
		String restUrl = "http://localhost:8081/discounts/getDiscountOwner/" + discountId;
		WebTarget target = client.target(restUrl);
		Invocation.Builder invocationBuilder = target.request(MediaType.APPLICATION_JSON);
		Response resp = invocationBuilder.get();
		System.out.println(resp.getStatus());
		
		if (resp.getStatus() == Response.Status.OK.getStatusCode()) {
			ArrayList<DiscountOwner> discountOwnerList = resp.readEntity(new GenericType<ArrayList<DiscountOwner>>() {});
			for (DiscountOwner discountOwner : discountOwnerList) {
				out.print("<br>id: " + discountOwner.getDiscountId());
			}
			
			request.setAttribute("discountOwnerList", discountOwnerList);
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
