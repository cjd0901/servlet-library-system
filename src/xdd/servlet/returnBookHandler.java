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
 * Servlet implementation class returnBookHandler
 */
@WebServlet("/returnBookHandler")
public class returnBookHandler extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public returnBookHandler() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		int id = Integer.parseInt(request.getParameter("id"));
		int book_id = Integer.parseInt(request.getParameter("ReturnBookId"));
		boolean isReturn = true;
		String ReturnBookUserName = request.getParameter("ReturnBookUserName");
		//System.out.println(book_id);
		String sql1 = "UPDATE borrow_msg SET return_msg=1 where borrow_id=?";
		Connection conn1 = xddJDBC.getConnection();
		PreparedStatement pst1 = xddJDBC.getPst(conn1, sql1);
		int x = xddJDBC.execute(pst1,id);
		String sql2 = "UPDATE book SET book_num=book_num+1 where book_id=?";
		Connection conn2 = xddJDBC.getConnection();
		PreparedStatement pst2 = xddJDBC.getPst(conn2, sql2);
		xddJDBC.execute(pst2, book_id);
		xddJDBC.close(conn2, pst2);
		String sql5 = "SELECT return_msg FROM borrow_msg WHERE borrow_bookid=? AND borrow_username=?";
		Connection conn5 = xddJDBC.getConnection();
		PreparedStatement pst5 = xddJDBC.getPst(conn5, sql5);
		ResultSet rs = xddJDBC.query(pst5, book_id, ReturnBookUserName);
		if(rs != null){
			try {
				while(rs.next()){
					int return_msg = Integer.parseInt(rs.getString("return_msg"));
					if(return_msg == 0){
						isReturn = false;
					}
				}
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		xddJDBC.close(conn5, pst5, rs);
		if(x>0) {
			if(isReturn) {
				response.getWriter().write("2");
			}else {
				response.getWriter().write("1");
			}
		}else {
			response.getWriter().write("0");
		}
		xddJDBC.close(conn1, pst1);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
