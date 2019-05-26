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
 * Servlet implementation class borrowBookHandler
 */
@WebServlet("/borrowBookHandler")
public class borrowBookHandler extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public borrowBookHandler() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		int borrowDays = Integer.parseInt(request.getParameter("borrowDays"));
		int borrowBookId = Integer.parseInt(request.getParameter("borrowBookId"));
		String borrowUserName = request.getParameter("borrowUserName");
		String sql1 = "INSERT INTO borrow_msg (borrow_username,borrow_bookid,borrow_days) VALUES (?,?,?)";
		Connection conn1 = xddJDBC.getConnection();
		PreparedStatement pst1 = xddJDBC.getPst(conn1, sql1);
		int x = xddJDBC.execute(pst1, borrowUserName, borrowBookId, borrowDays);
		String sql2 = "UPDATE book SET book_num=book_num-1 where book_id=?";
		Connection conn2 = xddJDBC.getConnection();
		PreparedStatement pst2 = xddJDBC.getPst(conn2, sql2);
		xddJDBC.execute(pst2, borrowBookId);
		xddJDBC.close(conn2, pst2);
		if(x > 0) {
			response.getWriter().write("1");
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
