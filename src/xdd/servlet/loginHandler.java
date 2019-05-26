package xdd.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import xdd.jdbc.*;

/**
 * Servlet implementation class loginHandler
 */
@WebServlet("/loginHandler")
public class loginHandler extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public loginHandler() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.setCharacterEncoding("UTF-8");
		HttpSession session=request.getSession();
		String session_userName = (String)session.getAttribute("userName");
		if(session_userName != null) {
			session.removeAttribute("userName");
			session.removeAttribute("realName");
		}
		String userName = request.getParameter("userName");
		String pwd = request.getParameter("pwd");
		boolean exit = false;
		try {
			String sql = "select * from user where username=? and password=?";
			Connection conn = xddJDBC.getConnection();
			PreparedStatement pst = xddJDBC.getPst(conn, sql);
			ResultSet rs = xddJDBC.query(pst, userName, pwd);
			if(rs != null) {
				//System.out.println(userName + pwd);
				try {
					while(rs.next()) {
						exit = true;
						String realName = rs.getString("name");
						session.setAttribute("realName", realName);
						//System.out.println(realName);
					}
				}catch(Exception e) {
					exit = false;
				}

			}
			xddJDBC.close(conn, pst, rs);
		}catch(Exception e) {
			e.printStackTrace();
		}
		if(exit) {
			response.getWriter().write("1");
			session.setAttribute("userName", userName);
			
		}else {
			response.getWriter().write("0");
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
