package xdd.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.sql.*;
import xdd.jdbc.*;

/**
 * Servlet implementation class delBookHandler
 */
@WebServlet("/delBookHandler")
public class delBookHandler extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public delBookHandler() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		int bookId = Integer.parseInt(request.getParameter("bookId"));
		boolean flag = false;
		try {
			String sql1 = "select * from borrow_msg where borrow_bookid=?";
			Connection conn1 = xddJDBC.getConnection();
			PreparedStatement pst1 = xddJDBC.getPst(conn1, sql1);
			ResultSet rs = xddJDBC.query(pst1, bookId);
			if(rs != null) {
				if(rs.next()) {
					flag = false;
				}else {
					flag = true;
				}
			}
			xddJDBC.close(conn1, pst1, rs);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		if(flag) {
			String sql2 = "delete from book where book_id=?";
			Connection conn2 = xddJDBC.getConnection();
			PreparedStatement pst2 = xddJDBC.getPst(conn2, sql2);
			int x = xddJDBC.execute(pst2, bookId);
			if(x>0) {
				response.getWriter().write("1");
			}else {
				response.getWriter().write("0");
			}
			xddJDBC.close(conn2, pst2);
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
