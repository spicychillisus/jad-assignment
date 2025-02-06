package discount;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import pg.Config;

import java.io.IOException;

/**
 * Servlet implementation class GetDiscountOwners
 */
@WebServlet("/discountOwners")
public class GetDiscountOwners extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private String url;
    private String username;
    private String dbPassword;   
    /**
     * @see HttpServlet#HttpServlet()
     */
    public GetDiscountOwners() {
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
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
