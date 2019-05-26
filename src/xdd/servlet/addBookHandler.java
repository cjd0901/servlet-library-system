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
 * Servlet implementation class addBookHandler
 */
@WebServlet("/addBookHandler")
public class addBookHandler extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public addBookHandler() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		String addBookName = request.getParameter("addBookName");
		String addBookAuthor = request.getParameter("addBookAuthor");
		String addBookNum = request.getParameter("addBookNum");
		String addBookPress = request.getParameter("addBookPress");
		String sql = "INSERT INTO book (book_name,book_author,book_num,press) VALUES (?,?,?,?)";
		Connection conn = xddJDBC.getConnection();
		PreparedStatement pst = xddJDBC.getPst(conn, sql);
		int x = xddJDBC.execute(pst, addBookName, addBookAuthor, addBookNum, addBookPress);
		if(x>0) {
			response.getWriter().write('1');
		}else {
			response.getWriter().write('0');
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
