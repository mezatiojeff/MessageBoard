<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<html>
<head>
    <title>Message Board</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 800px;
            margin: 50px auto;
            background-color: #f5f5f5;
        }
        h1 { color: #333; text-align: center; }
        .form-container, .message-card {
            background: white;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        .reply-card {
            background: #f9f9f9;
            padding: 10px 15px;
            border-left: 3px solid #4CAF50;
            margin: 10px 0 0 20px;
            border-radius: 4px;
        }
        input, textarea {
            width: 100%;
            padding: 10px;
            margin: 8px 0;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-sizing: border-box;
        }
        button {
            background-color: #4CAF50;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        button:hover { background-color: #45a049; }
        .message-info { color: #888; font-size: 12px; }
        .reply-btn {
            background-color: #2196F3;
            font-size: 12px;
            padding: 5px 10px;
            margin-top: 10px;
        }
        .reply-form {
            margin-top: 10px;
            display: none;
        }
    </style>
</head>
<body>

    <h1>📋 Message Board</h1>

    <!-- Error message -->
    <% if ("invalid_email".equals(request.getParameter("error"))) { %>
        <p style="color: red; text-align: center; background: #ffe0e0; padding: 10px; border-radius: 4px;">
            ⚠️ Please enter a valid email address !
        </p>
    <% } %>

    <!-- Post a message -->
    <div class="form-container">
        <h2>Leave a Message</h2>
        <form action="addMessage" method="post">
            <input type="text" name="name" placeholder="Your name" required
                value="<%= request.getParameter("name") != null ? request.getParameter("name") : "" %>" />
            <input type="email" name="email" placeholder="Your email" required />
            <textarea name="message" rows="4" placeholder="Your message..." required><%= request.getParameter("message") != null ? request.getParameter("message") : "" %></textarea>
            <button type="submit">Post Message</button>
        </form>
    </div>

    <!-- Display messages -->
    <h2>Messages</h2>

    <%
        Connection con = null;
        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/studentdb", "root", "Vinicus77"
            );

            // Get all messages
            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery("SELECT * FROM messages ORDER BY date_post DESC");

            while (rs.next()) {
                int msgId = rs.getInt("id");
                String msgName = rs.getString("name");
                String msgEmail = rs.getString("email");
                String msgText = rs.getString("message");
                String msgDate = rs.getString("date_post");
    %>
        <div class="message-card">
            <p><strong><%= msgName %></strong> (<%= msgEmail %>)</p>
            <p><%= msgText %></p>
            <p class="message-info">Posted on : <%= msgDate %></p>

            <!-- Display replies -->
            <%
                PreparedStatement ps2 = con.prepareStatement(
                    "SELECT * FROM replies WHERE message_id = ? ORDER BY date_post ASC"
                );
                ps2.setInt(1, msgId);
                ResultSet rs2 = ps2.executeQuery();
                while (rs2.next()) {
            %>
                <div class="reply-card">
                    <p><strong><%= rs2.getString("name") %></strong> : <%= rs2.getString("reply") %></p>
                    <p class="message-info"><%= rs2.getString("date_post") %></p>
                </div>
            <%
                }
                rs2.close();
                ps2.close();
            %>

            <!-- Reply form -->
            <button class="reply-btn" onclick="document.getElementById('reply-<%= msgId %>').style.display='block'">
                💬 Reply
            </button>
            <div class="reply-form" id="reply-<%= msgId %>">
                <form action="addReply" method="post">
                    <input type="hidden" name="message_id" value="<%= msgId %>" />
                    <input type="text" name="name" placeholder="Your name" required />
                    <input type="email" name="email" placeholder="Your email" required />
                    <textarea name="reply" rows="2" placeholder="Your reply..." required></textarea>
                    <button type="submit">Send Reply</button>
                </form>
            </div>
        </div>
    <%
            }
            rs.close();
            st.close();
            con.close();

        } catch (Exception e) {
            out.println("Error : " + e.getMessage());
        }
    %>

    <!-- Discreet admin link -->
    <div style="text-align: right; margin-top: 30px;">
        <a href="login.jsp" style="color: white; font-size: 13px; text-decoration: none; background-color: #333; padding: 8px 15px; border-radius: 4px;">
            🔐 Admin Panel
        </a>
    </div>

    <!-- Script for English validation messages -->
        <script>
            document.addEventListener('invalid', function(e) {
                e.target.setCustomValidity('Please fill in this field.');
            }, true);
            document.addEventListener('change', function(e) {
                e.target.setCustomValidity('');
            }, true);
        </script>

    </body>
</html>
