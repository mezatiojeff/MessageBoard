import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import java.sql.*;

public class DeleteMessageServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));

        try {
            Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/studentdb", "root", "Vinicus77"
            );

            // Delete replies first
            PreparedStatement ps1 = con.prepareStatement("DELETE FROM replies WHERE message_id = ?");
            ps1.setInt(1, id);
            ps1.executeUpdate();

            // Then delete message
            PreparedStatement ps2 = con.prepareStatement("DELETE FROM messages WHERE id = ?");
            ps2.setInt(1, id);
            ps2.executeUpdate();

            con.close();
            response.sendRedirect("admin.jsp");

        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().println("Database error : " + e.getMessage());
        }
    }
}
