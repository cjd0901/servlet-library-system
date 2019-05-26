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
 * Servlet implementation class editBookHandler
 */
@WebServlet("/editBookHandler")
public class editBookHandler extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public editBookHandler() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		int editBookId = Integer.parseInt(request.getParameter("editBookId"));
		String editBookName = request.getParameter("editBookName");
		String editBookAuthor = request.getParameter("editBookAuthor");
		int editBookNum = Integer.parseInt(request.getParameter("editBookNum"));
		String editBookPress = request.getParameter("editBookPress");
		String sql = "UPDATE book SET book_name=?,book_author=?,book_num=?,press=? WHERE book_id=?";
		Connection conn = xddJDBC.getConnection();
		PreparedStatement pst = xddJDBC.getPst(conn, sql);
		//System.out.println(editBookId+editBookName+editBookAuthor+editBookNum+editBookPress);
		int x = xddJDBC.execute(pst, editBookName, editBookAuthor, editBookNum, editBookPress, editBookId);
		if(x>0) {
			response.getWriter().write("1");
		}else {
			response.getWriter().write("0");
		}
		xddJDBC.close(conn, pst);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
