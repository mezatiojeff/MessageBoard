import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import java.sql.*;

public class DeleteReplyServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));

        try {
            Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/studentdb", "root", "Vinicus77"
            );

            PreparedStatement ps = con.prepareStatement("DELETE FROM replies WHERE id = ?");
            ps.setInt(1, id);
            ps.executeUpdate();

            con.close();
            response.sendRedirect("admin.jsp");

        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().println("Database error : " + e.getMessage());
        }
    }
}