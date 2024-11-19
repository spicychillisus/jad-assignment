package pg;

import java.io.IOException;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/LoginServlet")  // URL pattern for the servlet
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private String url;
    private String username;
    private String dbPassword;

    @Override
    public void init() {
        Config neon = new Config();
        this.url = neon.getConnectionUrl();
        this.username = neon.getUser();
        this.dbPassword = neon.getPassword();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DriverManager.getConnection(url, username, dbPassword);

            // Check credentials
            String sql = "SELECT * FROM users WHERE email = ? AND password = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, email);
            pstmt.setString(2, password);

            rs = pstmt.executeQuery();

            if (rs.next()) {
                // Redirect to index.jsp after successful login
                response.sendRedirect("index.jsp");
            } else {
                // Invalid credentials, redirect back to login with an error message
                String message = "Invalid email or password.";
                response.sendRedirect("member-login.jsp?error=" + java.net.URLEncoder.encode(message, "UTF-8"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
            String message = "An error occurred. Please try again.";
            response.sendRedirect("member-login.jsp?error=" + java.net.URLEncoder.encode(message, "UTF-8"));
        } finally {
            // Clean up resources
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
