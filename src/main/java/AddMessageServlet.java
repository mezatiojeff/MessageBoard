import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.*;
import java.sql.*;

@WebServlet("/addMessage")
public class AddMessageServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get form data
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String message = request.getParameter("message");

        // Validate email FIRST
        if (!email.matches("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$")) {
            response.sendRedirect("index.jsp?error=invalid_email&name=" +
                    java.net.URLEncoder.encode(name, "UTF-8") +
                    "&message=" + java.net.URLEncoder.encode(message, "UTF-8"));
            return;
        }

        // Save to database
        try {
            Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/studentdb", "root", "Vinicus77"
            );

            String sql = "INSERT INTO messages (name, email, message) VALUES (?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, message);
            ps.executeUpdate();
            con.close();

            // Redirect to index
            response.sendRedirect("index.jsp");

        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().println("Database error : " + e.getMessage());
        }


    }
}
