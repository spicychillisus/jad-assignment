<%@ page session="true" %>
<%
    // Invalidate the session to log out the user
    session.invalidate();
    
    // Redirect to the home page (or login page)
    response.sendRedirect("index.jsp");
%>
