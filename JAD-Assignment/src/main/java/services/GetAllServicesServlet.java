package services;

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
import java.net.URLEncoder;
import java.util.ArrayList;


/**
 * Servlet implementation class GetAllServicesServlet
 */
@WebServlet("/services")
public class GetAllServicesServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public GetAllServicesServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Initialize REST client
        Client client = ClientBuilder.newClient();
        String searchQuery = request.getParameter("search");

        String restUrl = "http://localhost:8081/services/allServices";
        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            restUrl += "?search=" + URLEncoder.encode(searchQuery, "UTF-8");
        }

        WebTarget target = client.target(restUrl);
        Invocation.Builder invocationBuilder = target.request(MediaType.APPLICATION_JSON);
        Response resp = invocationBuilder.get();

        if (resp.getStatus() == Response.Status.OK.getStatusCode()) {
            ArrayList<Service> services = resp.readEntity(new GenericType<ArrayList<Service>>() {});
            request.setAttribute("services", services);
        } else {
            request.setAttribute("err", "No services found.");
        }

        // Forward to JSP page
        RequestDispatcher rd = request.getRequestDispatcher("web/services.jsp");
        rd.forward(request, response);
    }


    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
