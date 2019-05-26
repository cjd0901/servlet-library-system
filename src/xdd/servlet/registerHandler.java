package xdd.servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import xdd.jdbc.*;
import java.sql.*;

/**
 * Servlet implementation class registerHandler
 */
@WebServlet("/registerHandler")
public class registerHandler extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public registerHandler() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.setCharacterEncoding("UTF-8");
		String userName = request.getParameter("userName");
		String pwd = request.getParameter("pwd");
		String realName = request.getParameter("realName");
		String phone = request.getParameter("phone");
		try {
			String sql1 = "SELECT * FROM user where username=?";
			Connection conn1 = xddJDBC.getConnection();
			PreparedStatement pst1 = xddJDBC.getPst(conn1, sql1);
			ResultSet rs = xddJDBC.query(pst1, userName);
			if(rs != null) {
				if(rs.next()) {
					response.getWriter().write('0');
				}else {
					String sql2 = "INSERT INTO user (username, password, name, phone) VALUES (?, ?, ?, ?)";
					Connection conn2 = xddJDBC.getConnection();
					PreparedStatement pst2 = xddJDBC.getPst(conn2, sql2);
					int x = xddJDBC.execute(pst2, userName, pwd, realName, phone);
					if(x>0) {
						response.getWriter().write('1');
					}else {
						response.getWriter().write('2');
					}
					xddJDBC.close(conn2, pst2);
				}
			}
			xddJDBC.close(conn1, pst1, rs);
		}catch(Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
