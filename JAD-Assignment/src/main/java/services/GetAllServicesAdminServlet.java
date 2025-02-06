package services;

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

import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLEncoder;
import java.util.ArrayList;

/**
 * Servlet implementation class GetAllServicesAdminServlet
 */
@WebServlet("/services/admin")
public class GetAllServicesAdminServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public GetAllServicesAdminServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		//response.getWriter().append("Served at: ").append(request.getContextPath());
		PrintWriter out = response.getWriter();
		Client client = ClientBuilder.newClient();
		
		String searchQuery = request.getParameter("search");
		
		String restUrl = "http://localhost:8081/services/allServices";
		if (searchQuery != null && !searchQuery.trim().isEmpty()) {
	        restUrl += "?search=" + URLEncoder.encode(searchQuery, "UTF-8");
	    }
		
		WebTarget target = client.target(restUrl);
		Invocation.Builder invocationBuilder = target.request(MediaType.APPLICATION_JSON);
		Response resp = invocationBuilder.get();
		System.out.println(resp.getStatus());
		
		if (resp.getStatus() == Response.Status.OK.getStatusCode()) {
			ArrayList<Service> services = resp.readEntity(new GenericType<ArrayList<Service>>() {});
			for (Service service : services) {
				out.print("<br>id: " + service.getServiceid());
				out.print("<br>id: " + service.getServicetitle());
			}
			
			request.setAttribute("services", services);
			String url = "web/admin/viewAllServices.jsp";
			RequestDispatcher rd = request.getRequestDispatcher(url);
			rd.forward(request, response);
		} else {
			String url = "web/admin/viewAllServices.jsp";
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
