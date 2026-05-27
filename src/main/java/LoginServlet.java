import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import java.sql.*;

public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try {
            Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/studentdb", "root", "Vinicus77"
            );

            String sql = "SELECT * FROM admin WHERE username = ? AND password = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                HttpSession session = request.getSession();
                session.setAttribute("admin", username);
                response.sendRedirect("admin.jsp");
            } else {
                response.sendRedirect("login.jsp?error=1");
            }

            con.close();

        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().println("Database error : " + e.getMessage());
        }
    }
}
