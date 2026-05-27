<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%
    // Check if admin is logged in
    String admin = (String) session.getAttribute("admin");
    if (admin == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<html>
<head>
    <title>Admin Panel</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 900px;
            margin: 50px auto;
            background-color: #f5f5f5;
        }
        h1 { color: #333; text-align: center; }
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        th {
            background-color: #4CAF50;
            color: white;
            padding: 12px;
            text-align: left;
        }
        td {
            padding: 12px;
            border-bottom: 1px solid #ddd;
        }
        tr:hover { background-color: #f9f9f9; }
        .delete-btn {
            background-color: #f44336;
            color: white;
            padding: 5px 10px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        .delete-btn:hover { background-color: #d32f2f; }
        .logout-btn {
            background-color: #f44336;
            color: white;
            padding: 8px 15px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
        }
    </style>
</head>
<body>

    <div class="header">
        <h1>🔧 Admin Panel</h1>
        <a href="logout" class="logout-btn">Logout</a>
    </div>

    <h2>All Messages</h2>

    <table>
        <tr>
            <th>ID</th>
            <th>Name</th>
            <th>Email</th>
            <th>Message</th>
            <th>Date</th>
            <th>Action</th>
        </tr>

        <%
            try {
                Class.forName("com.mysql.jdbc.Driver");
                Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/studentdb", "root", "Vinicus77"
                );

                Statement st = con.createStatement();
                ResultSet rs = st.executeQuery("SELECT * FROM messages ORDER BY date_post DESC");

                while (rs.next()) {
        %>
            <tr>
                <td><%= rs.getInt("id") %></td>
                <td><%= rs.getString("name") %></td>
                <td><%= rs.getString("email") %></td>
                <td><%= rs.getString("message") %></td>
                <td><%= rs.getString("date_post") %></td>
                <td>
                    <form action="deleteMessage" method="post">
                        <input type="hidden" name="id" value="<%= rs.getInt("id") %>" />
                        <button class="delete-btn" type="submit">Delete</button>
                    </form>
                </td>
            </tr>
        <%
                }
                rs.close();
                st.close();
                con.close();
            } catch (Exception e) {
                out.println("Error : " + e.getMessage());
            }
        %>
    </table>

    <h2 style="margin-top: 40px;">All Replies</h2>

        <table>
            <tr>
                <th>ID</th>
                <th>Message ID</th>
                <th>Name</th>
                <th>Email</th>
                <th>Reply</th>
                <th>Date</th>
                <th>Action</th>
            </tr>

            <%
                try {
                    Class.forName("com.mysql.jdbc.Driver");
                    Connection con2 = DriverManager.getConnection(
                        "jdbc:mysql://localhost:3306/studentdb", "root", "Vinicus77"
                    );

                    Statement st2 = con2.createStatement();
                    ResultSet rs2 = st2.executeQuery("SELECT * FROM replies ORDER BY date_post DESC");

                    while (rs2.next()) {
            %>
                <tr>
                    <td><%= rs2.getInt("id") %></td>
                    <td><%= rs2.getInt("message_id") %></td>
                    <td><%= rs2.getString("name") %></td>
                    <td><%= rs2.getString("email") %></td>
                    <td><%= rs2.getString("reply") %></td>
                    <td><%= rs2.getString("date_post") %></td>
                    <td>
                        <form action="deleteReply" method="post">
                            <input type="hidden" name="id" value="<%= rs2.getInt("id") %>" />
                            <button class="delete-btn" type="submit">Delete</button>
                        </form>
                    </td>
                </tr>
            <%
                    }
                    rs2.close();
                    st2.close();
                    con2.close();
                } catch (Exception e) {
                    out.println("Error : " + e.getMessage());
                }
            %>
        </table>

</body>
</html>