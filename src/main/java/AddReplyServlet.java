import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import java.sql.*;

public class AddReplyServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String reply = request.getParameter("reply");
        int messageId = Integer.parseInt(request.getParameter("message_id"));

        try {
            Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/studentdb", "root", "Vinicus77"
            );

            String sql = "INSERT INTO replies (message_id, name, email, reply) VALUES (?, ?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, messageId);
            ps.setString(2, name);
            ps.setString(3, email);
            ps.setString(4, reply);
            ps.executeUpdate();
            con.close();

            response.sendRedirect("index.jsp");

        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().println("Database error : " + e.getMessage());
        }
    }
}
