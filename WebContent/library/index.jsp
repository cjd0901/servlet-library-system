<%@ page language="java" import="java.util.*" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="xdd.jdbc.*" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<link href="lib/layui/css/layui.css" rel="stylesheet" type="text/css" />
<link href="lib/bootstrap-3.3.7-dist/css/bootstrap.css" rel="stylesheet" type="text/css" />
<style>
	.hide {
		display: none;
	}
	#header a, #sidebar a {
		cursor: pointer;
	}
	#addBookPart .layui-form-label, #editBookForm .layui-form-label {
	    width: 110px;
	    font-weight: 200;
	    line-height: 35px;
	    font-size: 20px;
	    height: 50px;
	}
	#addBookPart .layui-input, #editBookForm .layui-input{
	    height: 50px;
	    font-size: 20px;
	}
	.pagination > .active > a {
		background-color: #009688FF;
	}
	.pagination > li > a {
		color: #009688FF;
	}
</style>
<title>图书管理系统</title>
</head>
<body>

<%
	String session_userName = (String)session.getAttribute("userName");
	String session_realName = (String)session.getAttribute("realName");
	if(session_userName == null){
		response.sendRedirect("./login.jsp");
	}
%>
<div class="layui-layout layui-layout-admin">
	<!-- 头部区域（可配合layui已有的水平导航） -->
  <div id="header" class="layui-header">
    <div style="font-size:23px;" class="layui-logo">图书管理系统</div>
    <ul class="layui-nav layui-layout-left">
      <li class="layui-nav-item"><a>控制台</a></li>
      <li class="layui-nav-item"><a>商品管理</a></li>
      <li class="layui-nav-item"><a>用户</a></li>
      <li class="layui-nav-item">
        <a>其它系统</a>
        <dl class="layui-nav-child">
          <dd><a>邮件管理</a></dd>
          <dd><a>消息管理</a></dd>
          <dd><a>授权管理</a></dd>
        </dl>
      </li>
    </ul>
    <ul class="layui-nav layui-layout-right">
      <li class="layui-nav-item">
        <a>
          <%=session.getAttribute("userName") %>
        </a>
        <dl class="layui-nav-child">
          <dd><a>基本资料</a></dd>
          <dd><a>安全设置</a></dd>
        </dl>
      </li>
      <li class="layui-nav-item"><a id="quitBtn">退出</a></li>
    </ul>
  </div>
  
  	<!-- 左侧导航区域（可配合layui已有的垂直导航） -->
  <div id="sidebar" class="layui-side layui-bg-black">
    <div class="layui-side-scroll">
      <ul class="layui-nav layui-nav-tree"  lay-filter="test">
        <li id="library" class="layui-nav-item layui-nav-itemed">
          <a id="mainPartBtn">图书馆</a>
          <dl class="layui-nav-child">
          	<dd><a class="libraryBtn" id="bookListBtn">书籍列表</a></dd>
            <dd><a class="libraryBtn" id="borrowMsgBtn">借书记录</a></dd>
            <dd><a class="libraryBtn">...</a></dd>
          </dl>
        </li>
        <li id="libraryManager" class="layui-nav-item">
          <a id="bookManagePartBtn">管理图书(管理员)</a>
          <dl id="bookManageBtnList" class="layui-nav-child">
            <dd><a class="libraryManagerBtn" id="addBookBtn">新增图书</a></dd>
            <dd><a class="libraryManagerBtn" id="editBookBtn">修改图书</a></dd>
            <dd><a class="libraryManagerBtn">...</a></dd>
          </dl>
        </li>
        <li class="layui-nav-item"><a>1609030117</a></li>
        <li class="layui-nav-item"><a>陈家栋</a></li>
      </ul>
    </div>
  </div>
  
  <!-- 主体部分 -->
  <div id="mainPart" class="layui-body">
    <!-- 借阅记录 -->
    <div id="borrowMsg" class="hide">
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
	  <legend style="font-size:40px;">图书借阅记录</legend>
	</fieldset>
	<div class="layui-form layui-form-pane">
			<div style="margin-bottom:0px;padding-left:15px;" class="layui-form-item">
		    <label class="layui-form-label">查找筛选</label>
		    <div class="layui-input-inline">
		      <input id="filterMsgInput" type="text" lay-verify="required" placeholder="请输入查找内容" autocomplete="off" class="layui-input">
		    </div>
		  </div>
	</div>
    <div style="padding: 15px 15px 0px 15px;"> 
    	<table id="borrowMsgTable" class="layui-table" lay-even="" lay-skin="row">
		  <colgroup>
		    <col>
		  </colgroup>
		  <thead>
		    <tr>
		      <th>编号</th>
		      <th>借阅人帐号</th>
		      <th>借阅人姓名</th>
		      <th>借阅书籍</th>
		      <th>作者</th>
		      <th>出版社</th>
		      <th>借阅日期</th>
		      <th>借阅天数</th>
		      <th>是否归还</th>
		      <th>归还书籍</th>
		    </tr> 
		  </thead>
		  <tbody>
		  <%
		  	final int NUM = 10;
			int borrowCount = 0;
			int borrowPageNo = 1;
			String s = request.getParameter("borrowPageNo");
			if (s != null) {
				borrowPageNo = Integer.parseInt(s.trim());
			}
			String url = "index.jsp?borrowPageNo=";
			//System.out.print(session_userName);
			if(session_userName != null){
				String sql8 = null;
				if(session_userName.equals("admin")){
					sql8 = "SELECT COUNT(*) from borrow_msg";
				}else{
					sql8 = "SELECT COUNT(*) from borrow_msg WHERE borrow_username="+"'"+session_userName+"'";
				}
				Connection conn8 = xddJDBC.getConnection();
				PreparedStatement pst8 = xddJDBC.getPst(conn8, sql8);
				ResultSet rs8 = xddJDBC.query(pst8);
				if(rs8 != null){
					if(rs8.next()){
						borrowCount = rs8.getInt(1);
					}
				}
				xddJDBC.close(conn8, pst8, rs8);
			}
			//System.out.print(sql8);
			int borrowPageNum = (borrowCount-1)/NUM + 1;
			//System.out.print(borrowPageNum);
			String prevBorrowPage = (borrowPageNo-1 == 0)? "#" : url + (borrowPageNo-1);
			String nextBorrowPage = (borrowPageNo+1 > borrowPageNum)? "#" : url + (borrowPageNo+1);
			String firstBorrowPage = url + 1;
			String endBorrowPage = url + borrowPageNum;
		  %>
		  <%
		  	String sql1;  	
		  	Connection conn1 = xddJDBC.getConnection();
		  	PreparedStatement pst1 = null;
		  	ResultSet rs1 = null;
		 	if(("admin").equals(session_userName)){
		 		sql1 = "SELECT * from borrow_msg LIMIT ?,?";
		 		pst1 = xddJDBC.getPst(conn1, sql1);
			 	rs1 = xddJDBC.query(pst1, (borrowPageNo-1)*NUM, NUM);
		 	}else{
			  	sql1 = "SELECT * from borrow_msg  where borrow_username=? LIMIT ?,?";
			  	pst1 = xddJDBC.getPst(conn1, sql1);
			 	rs1 = xddJDBC.query(pst1, session_userName, (borrowPageNo-1)*NUM, NUM);
		 	}
		  	if(rs1 != null){
		  		while(rs1.next()){
		  			int borrowId = rs1.getInt("borrow_id");
		  			int borrowBookId = rs1.getInt("borrow_bookid");
		  			String borrowUserName = rs1.getString("borrow_username");
		  			String borrowDate = rs1.getString("borrow_time");
		  			int borrowDays = rs1.getInt("borrow_days");
		  			int returnMsg = rs1.getInt("return_msg");
		  			out.print("<tr>");
		  			out.print("<td>" + borrowId +"</td>");
				  	String sql3 = "SELECT * from user where username=?";
				  	Connection conn3 = xddJDBC.getConnection();
				  	PreparedStatement pst3 = xddJDBC.getPst(conn3, sql3);
				  	ResultSet rs3 = null;
		  			if(session_userName.equals("admin")){
		  				rs3 = xddJDBC.query(pst3, borrowUserName);
		  			}else{
		  				rs3 = xddJDBC.query(pst3, session_userName);
		  			}
				  	if(rs3 !=null ){
				  		while(rs3.next()){
				  			String userName = rs3.getString("username");
				  		   	String realName = rs3.getString("name");
				  		  	out.print("<td>"+ userName +"</td>");
				  			out.print("<td>"+ realName +"</td>");
				  		}
				  	}
				  	xddJDBC.close(conn3, pst3, rs3);
				  	String sql2 = "SELECT * from book where book_id=?";
				  	Connection conn2 = xddJDBC.getConnection();
				  	PreparedStatement pst2 = xddJDBC.getPst(conn2, sql2);
		  			ResultSet rs2 = xddJDBC.query(pst2, borrowBookId);
		  			if(rs2 != null){
		  				while(rs2.next()){
		  					String bookName = rs2.getString("book_name");
		  					int bookId = rs2.getInt("book_id");
		  					String bookAuthor = rs2.getString("book_author");
		  					String press = rs2.getString("press");
		  					out.print("<td style='display:none;'>"+ bookId +"</td>");
		  					out.print("<td>"+ bookName +"</td>");
		  					out.print("<td>"+ bookAuthor +"</td>");
		  					out.print("<td>"+ press +"</td>");
		  				}
		  			}
		  			xddJDBC.close(conn2, pst2, rs2);
		  			out.print("<td>" + borrowDate +"</td>");
  					out.print("<td>"+ borrowDays +"</td>");
  					if(returnMsg == 1){
  						out.print("<td>已归还</td>");
  	  					out.print("<td><button class='layui-btn layui-btn-disabled'>归还书籍</button></td>");
  					}else{
  						out.print("<td>未归还</td>");
  	  					out.print("<td><button class='layui-btn returnBtn'>归还书籍</button></td>");
  					}
		  			out.print("</tr>");
		  		}
		  	}
		  	xddJDBC.close(conn1, pst1, rs1);
		  	int borrowMsgMaxID = 0;
		  	String sql11 = "SELECT MAX(borrow_id) from borrow_msg";
		  	Connection conn11 = xddJDBC.getConnection();
		  	PreparedStatement pst11 = xddJDBC.getPst(conn11, sql11);
		  	ResultSet rs11 = xddJDBC.query(pst11);
		  	if(rs11 != null){
		  		if(rs11.next()){
		  			borrowMsgMaxID = rs11.getInt(1);
		  		}
		  	}
		  	xddJDBC.close(conn11, pst11, rs11);
		  %>
		  </tbody>
		</table>  
    </div>
    <nav>
  		<ul style="margin-top:0px;margin-left:15px;" class="pagination">
  			<li><a href="<%=firstBorrowPage %>">首页<span class="sr-only">(current)</span></a></li>
    		<li><a href="<%=prevBorrowPage %>" aria-label="Previous"><span aria-hidden="true">&laquo;</span></a></li>
			<%
				for(int i=1;i<=borrowPageNum;i++){
					if(i == borrowPageNo){
						out.print("<li class='active'><a href='#'>" + i +" <span class='sr-only'>(current)</span></a></li>");
					}else{
						out.print("<li><a href='" + (url + i) + "'>" + i +" <span class='sr-only'>(current)</span></a></li>");
					}
				}
			%>
    		<li><a href="<%=nextBorrowPage %>" aria-label="Previous"><span aria-hidden="true">&raquo;</span></a></li>
    		<li><a href="<%=endBorrowPage %>">尾页<span class="sr-only">(current)</span></a></li>
  		</ul>
	</nav>
  	</div>
	
	<!-- 书籍 列表 -->
	<div id="bookList" class="hide">
		<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
		  <legend style="font-size:40px;">书籍列表</legend>
		</fieldset>
		<div class="layui-form layui-form-pane">
			<div style="margin-bottom:0px;padding-left:15px;" class="layui-form-item">
		    <label class="layui-form-label">查找筛选</label>
		    <div class="layui-input-inline">
		      <input id="filterBookInput" type="text" lay-verify="required" placeholder="请输入查找内容" autocomplete="off" class="layui-input">
		    </div>
		  </div>
		</div>
		<div style="padding: 15px;">
			<table id="bookListTable" class="layui-table" lay-skin="line">
			  <colgroup>
			    <col width="150">
			    <col width="200">
			    <col width="200">
			    <col width="200">
			    <col width="200">
			    <col width="200">
			  </colgroup>
			  <thead>
			    <tr>
			      <th>书籍编号</th>
			      <th>书籍名称</th>
			      <th>作者</th>
			      <th>书籍出版社</th>
			      <th>剩余数量</th>
			      <th>借阅</th>
			    </tr> 
			  </thead>
			  <tbody>
			  <%
				int bookCount = 0;
				int bookPageNo = 1;
				String b = request.getParameter("bookPageNo");
				if (b != null) {
					bookPageNo = Integer.parseInt(b.trim());
				}
				String url2 = "index.jsp?bookPageNo=";
				String sql9 = "SELECT COUNT(*) from book";
				Connection conn9 = xddJDBC.getConnection();
				PreparedStatement pst9 = xddJDBC.getPst(conn9, sql9);
				ResultSet rs9 = xddJDBC.query(pst9);
				if(rs9.next()){
					bookCount = rs9.getInt(1);
				}
				int bookPageNum = (bookCount-1)/NUM + 1;
				String prevBookPage = (bookPageNo-1 == 0)? "#" : url2 + (bookPageNo-1);
				String nextBookPage = (bookPageNo+1 > bookPageNum)? "#" : url2 + (bookPageNo+1);
				String firstBookPage = url2 + 1;
				String endBookPage = url2 + bookPageNum;
				xddJDBC.close(conn9, pst9, rs9);
			  %>
			  	<%  
			  		String sql4 = "SELECT * FROM book LIMIT ?,?";
			  		Connection conn4 = xddJDBC.getConnection();
			  		PreparedStatement pst4 = xddJDBC.getPst(conn4, sql4);
			  		ResultSet rs4 = xddJDBC.query(pst4, (bookPageNo - 1)*NUM, NUM);
			  		if(rs4 != null){
			  			while(rs4.next()){
			  				int book_id = rs4.getInt("book_id");
			  				String book_name = rs4.getString("book_name");
			  				String book_author = rs4.getString("book_author");
			  				int book_num = rs4.getInt("book_num");
			  				String press = rs4.getString("press");
			  				out.print("<tr>");
			  				out.print("<td>" + book_id + "</td>");
			  				out.print("<td>" + book_name + "</td>");
			  				out.print("<td>" + book_author + "</td>");
			  				out.print("<td>" + press + "</td>");
			  				out.print("<td>" + book_num + "</td>");
			  				String sql5 = "SELECT return_msg FROM borrow_msg WHERE borrow_bookid=? AND borrow_username=?";
			  				Connection conn5 = xddJDBC.getConnection();
			  				PreparedStatement pst5 = xddJDBC.getPst(conn5, sql5);
			  				ResultSet rs5 = xddJDBC.query(pst5, book_id, session_userName);
			  				if(rs5 != null){
			  					boolean isReturn = true;
			  					while(rs5.next()){
			  						int return_msg = Integer.parseInt(rs5.getString("return_msg"));
			  						if(return_msg == 0){
			  							isReturn = false;
			  						}
			  					}
			  					if(isReturn){
			  						out.print("<td><button class='layui-btn borrowBookBtn'>借阅书籍</button></td>");
			  					}else{
			  						out.print("<td><button class='layui-btn layui-btn-disabled'>已借阅</button></td>");
			  					}
			  				}
			  				xddJDBC.close(conn5, pst5, rs5);
			  				out.print("</tr>");
			  			}
			  		}
			  		xddJDBC.close(conn4, pst4, rs4);
			  		int maxBookId = 0;
			  		String sql12 = "SELECT MAX(book_id) FROM book";
			  		Connection conn12 = xddJDBC.getConnection();
			  		PreparedStatement pst12 = xddJDBC.getPst(conn12, sql12);
			  		ResultSet rs12 = xddJDBC.query(pst12);
			  		if(rs12 != null){
			  			if(rs12.next()){
			  				maxBookId = rs12.getInt(1);
			  			}
			  		}
			  	%>
			  </tbody>
			</table>  
		</div> 
		<nav>
  		<ul style="margin-top:0px;margin-left:15px;" class="pagination">
  			<li><a href="<%=firstBookPage %>">首页<span class="sr-only">(current)</span></a></li>
    		<li><a href="<%=prevBookPage %>" aria-label="Previous"><span aria-hidden="true">&laquo;</span></a></li>
			<%
				for(int i=1;i<=bookPageNum;i++){
					if(i == bookPageNo){
						out.print("<li class='active'><a href='#'>" + i +" <span class='sr-only'>(current)</span></a></li>");
					}else{
						out.print("<li><a href='" + (url2 + i) + "'>" + i +" <span class='sr-only'>(current)</span></a></li>");
					}
				}
			%>
    		<li><a href="<%=nextBookPage %>" aria-label="Previous"><span aria-hidden="true">&raquo;</span></a></li>
    		<li><a href="<%=endBookPage %>">尾页<span class="sr-only">(current)</span></a></li>
  		</ul>
	</nav>
	</div>
  
  </div>
  
  <!-- 图书管理部分 -->
  <div id="bookManagePart" class="layui-body hide">
  		<!-- 添加图书区域 -->
  		<div id="addBookPart" class="hide">
  			<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
	  			<legend style="font-size:40px;">添加书籍</legend>
			</fieldset>
			<div class="layui-form">
				<div class="layui-form-item">
			    	<label class="layui-form-label">书籍名称</label>
			    	<div class="layui-input-block">
			      		<input type="text" name="title" id="addBookName" placeholder="请输入书籍名称*" class="layui-input">
			    	</div>
			 	</div>
			 	<div class="layui-form-item">
			    	<label class="layui-form-label">作者</label>
			    	<div class="layui-input-block">
			      		<input type="text" name="title" id="addBookAuthor" placeholder="请输入作者*" class="layui-input">
			    	</div>
			 	</div>
			 	<div class="layui-form-item">
			    	<label class="layui-form-label">书本数量</label>
			    	<div class="layui-input-block">
			      		<input type="text" name="title" id="addBookNum" placeholder="请输入书本数量*" class="layui-input">
			    	</div>
			 	</div>
			 	<div class="layui-form-item">
			    	<label class="layui-form-label">出版社</label>
			    	<div class="layui-input-block">
			      		<input type="text" name="title" id="addBookPress" placeholder="请输入书籍出版社*" class="layui-input">
			    	</div>
			 	</div>
			 	<button style="margin-left:110px;" id="addBtn" class="layui-btn layui-btn-lg">添加</button>
		 	</div>
  		</div>
  		
  		<!-- 修改图书区域 -->
  		<div id="editBookPart">
  			<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
	  			<legend style="font-size:40px;">修改书籍</legend>
			</fieldset>
			<div class="layui-form layui-form-pane">
				<div style="margin-bottom:0px;padding-left:15px;" class="layui-form-item">
			    <label class="layui-form-label">查找筛选</label>
			    <div class="layui-input-inline">
			      <input id="filterEditBookInput" type="text" lay-verify="required" placeholder="请输入查找内容" autocomplete="off" class="layui-input">
			    </div>
			  </div>
			</div>
			<div style="padding: 15px;">
				<table id="editbookListTable" class="layui-table" lay-skin="line">
				  <colgroup>
				    <col width="150">
				    <col width="200">
				    <col width="200">
				    <col width="200">
				    <col width="200">
				    <col width="200">
				  </colgroup>
				  <thead>
				    <tr>
				      <th>书籍编号</th>
				      <th>书籍名称</th>
				      <th>作者</th>
				      <th>书籍出版社</th>
				      <th>剩余数量</th>
				      <th>修改</th>
				    </tr> 
				  </thead>
				  <tbody>
				  <%
					int adminBookCount = 0;
					int adminBookPageNo = 1;
					String ab = request.getParameter("adminBookPageNo");
					if (ab != null) {
						adminBookPageNo = Integer.parseInt(ab.trim());
					}
					String url3 = "index.jsp?adminBookPageNo=";
					String sql10 = "SELECT COUNT(*) from book";
					Connection conn10 = xddJDBC.getConnection();
					PreparedStatement pst10 = xddJDBC.getPst(conn10, sql10);
					ResultSet rs10 = xddJDBC.query(pst10);
					if(rs10.next()){
						adminBookCount = rs10.getInt(1);
					}
					int adminBookPageNum = (adminBookCount-1)/NUM + 1;
					String adminPrevBookPage = (adminBookPageNo-1 == 0)? "#" : url3 + (adminBookPageNo-1);
					String adminNextBookPage = (adminBookPageNo+1 > adminBookPageNum)? "#" : url3 + (adminBookPageNo+1);
					String adminFirstBorrowPage = url3 + 1;
					String adminEndBorrowPage = url3 + adminBookPageNo;
					xddJDBC.close(conn10, pst10, rs10);
				  %>
				  	<%  
				  		String sql6 = "SELECT * FROM book LIMIT ?,?";
				  		Connection conn6 = xddJDBC.getConnection();
				  		PreparedStatement pst6 = xddJDBC.getPst(conn6, sql6);
				  		ResultSet rs6 = xddJDBC.query(pst6, (adminBookPageNo-1)*NUM, NUM);
				  		if(rs6 != null){
				  			while(rs6.next()){
				  				int book_id = rs6.getInt("book_id");
				  				String book_name = rs6.getString("book_name");
				  				String book_author = rs6.getString("book_author");
				  				int book_num = rs6.getInt("book_num");
				  				String press = rs6.getString("press");
				  				out.print("<tr>");
				  				out.print("<td>" + book_id + "</td>");
				  				out.print("<td>" + book_name + "</td>");
				  				out.print("<td>" + book_author + "</td>");
				  				out.print("<td>" + press + "</td>");
				  				out.print("<td>" + book_num + "</td>");
				  				out.print("<td><button class='layui-btn editBookBtn'>编辑</button><button class='delBookBtn layui-btn'>删除</button></td>");
				  				out.print("</tr>");
				  			}
				  		}
				  		xddJDBC.close(conn6, pst6, rs6);
				  	%>
				  </tbody>
				</table>  
			</div>
			 <nav>
		  		<ul style="margin-top:0px;margin-left:15px;" class="pagination">
		  			<li><a href="<%=adminFirstBorrowPage %>">首页<span class="sr-only">(current)</span></a></li>
		    		<li><a href="<%=adminPrevBookPage %>" aria-label="Previous"><span aria-hidden="true">&laquo;</span></a></li>
					<%
						for(int i=1;i<=adminBookPageNum;i++){
							if(i == adminBookPageNo){
								out.print("<li class='active'><a href='#'>" + i +" <span class='sr-only'>(current)</span></a></li>");
							}else{
								out.print("<li><a href='" + (url3 + i) + "'>" + i +" <span class='sr-only'>(current)</span></a></li>");
							}
						}
					%>
		    		<li><a href="<%=adminNextBookPage %>" aria-label="Previous"><span aria-hidden="true">&raquo;</span></a></li>
		    		<li><a href="<%=adminEndBorrowPage %>">尾页<span class="sr-only">(current)</span></a></li>
		  		</ul>
			</nav>
  		</div>
  
  		<!-- 编辑图书区域 -->
  		<div id="editBookForm" class="hide">
  			<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
	  			<legend style="font-size:40px;">编辑书籍</legend>
			</fieldset>
			<div class="layui-form">
				<div class="layui-form-item">
			    	<label class="layui-form-label">书籍名称</label>
			    	<div class="layui-input-block">
			      		<input type="text" name="title" id="editBookName" placeholder="请输入书籍名称*" class="layui-input">
			    	</div>
			 	</div>
			 	<div class="layui-form-item">
			    	<label class="layui-form-label">作者</label>
			    	<div class="layui-input-block">
			      		<input type="text" name="title" id="editBookAuthor" placeholder="请输入作者*" class="layui-input">
			    	</div>
			 	</div>
			 	<div class="layui-form-item">
			    	<label class="layui-form-label">书本数量</label>
			    	<div class="layui-input-block">
			      		<input type="text" name="title" id="editBookNum" placeholder="请输入书本数量*" class="layui-input">
			    	</div>
			 	</div>
			 	<div class="layui-form-item">
			    	<label class="layui-form-label">出版社</label>
			    	<div class="layui-input-block">
			      		<input type="text" name="title" id="editBookPress" placeholder="请输入书籍出版社*" class="layui-input">
			    	</div>
			 	</div>
			 	<button style="margin-left:110px;" id="editBtn" class="layui-btn layui-btn-lg">修改</button>
		 	</div>
  		</div>
  </div>
</div>
<!-- 模态对话框1 -->
<div id="modal" class="modal fade" tabindex="-1" role="dialog">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 style="color:#009688FF;font-size:25px;" class="modal-title">书籍归还日期还未到</h4>
      </div>
      <div class="modal-body">
        <p style="color:#009688FF;font-size:17px;">你确定现在归还吗？</p>
      </div>
      <div class="modal-footer">
      	<button class="layui-btn layui-btn-primary" data-dismiss="modal">取消</button>
      	<button id="returnConfirm" class="layui-btn">确认</button>
      </div>
    </div>
  </div>
</div>

<!-- 模态对话框2 -->
<div id="modal2" class="modal fade" tabindex="-1" role="dialog">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 style="color:#009688FF;font-size:25px;" class="modal-title">请输入需要借阅的时间</h4>
      </div>
      <div class="modal-body">
        <div class="form-group">
            <label style="color:#009688FF;font-size:17px;font-weight:100;" for="borrowDaysInput" class="control-label">借阅时间</label>
            <input type="text" class="form-control" id="borrowDaysInput" value="7">
        </div>
      </div>
      <div class="modal-footer">
        <button class="layui-btn layui-btn-primary" data-dismiss="modal">取消</button>
        <button id="borrowConfirm" class="layui-btn">确认</button>
      </div>
    </div>
  </div>
</div>

<!-- 模态对话框3 -->
<div id="modal3" class="modal fade" tabindex="-1" role="dialog">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 style="color:#009688FF;font-size:25px;" class="modal-title">没有权限</h4>
      </div>
      <div class="modal-body">
        <div class="form-group">
            <label style="color:#009688FF;font-size:17px;font-weight:100;" class="control-label">此操作只有管理员才能进行，请使用管理员帐号登录</label>
        </div>
      </div>
      <div class="modal-footer">
        <button class="layui-btn" data-dismiss="modal">确认</button>
      </div>
    </div>
  </div>
</div>

<!-- 模态对话框4 -->
<div id="modal4" class="modal fade" tabindex="-1" role="dialog">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 style="color:#009688FF;font-size:25px;" class="modal-title">添加书籍</h4>
      </div>
      <div class="modal-body">
        <div class="form-group">
            <label style="color:#009688FF;font-size:17px;font-weight:100;" class="control-label">你确定添加吗</label>
        </div>
      </div>
      <div class="modal-footer">
        <button class="layui-btn layui-btn-primary" data-dismiss="modal">取消</button>
        <button id="addConfirm" class="layui-btn">确认</button>
      </div>
    </div>
  </div>
</div>

<!-- 模态对话框5 -->
<div id="modal5" class="modal fade" tabindex="-1" role="dialog">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 style="color:#009688FF;font-size:25px;" id="modal5Text" class="modal-title"></h4>
      </div>
      <div class="modal-body">
        <div class="form-group">
            <label style="color:#009688FF;font-size:17px;font-weight:100;" id="modal5Label" class="control-label"></label>
        </div>
      </div>
      <div class="modal-footer">
        <button class="layui-btn" data-dismiss="modal">确认</button>
      </div>
    </div>
  </div>
</div>

<!-- 模态对话框6 -->
<div id="modal6" class="modal fade" tabindex="-1" role="dialog">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 style="color:#009688FF;font-size:25px;" class="modal-title">删除书籍</h4>
      </div>
      <div class="modal-body">
        <div class="form-group">
            <label style="color:#009688FF;font-size:17px;font-weight:100;" class="control-label">你确定删除吗</label>
        </div>
      </div>
      <div class="modal-footer">
        <button class="layui-btn layui-btn-primary" data-dismiss="modal">取消</button>
        <button id="delConfirm" class="layui-btn">确认</button>
      </div>
    </div>
  </div>
</div>

<!-- 模态对话框7 -->
<div id="modal7" class="modal fade" tabindex="-1" role="dialog">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 style="color:#009688FF;font-size:25px;" class="modal-title">修改书籍</h4>
      </div>
      <div class="modal-body">
        <div class="form-group">
            <label style="color:#009688FF;font-size:17px;font-weight:100;" class="control-label">你确定修改吗</label>
        </div>
      </div>
      <div class="modal-footer">
        <button class="layui-btn layui-btn-primary" data-dismiss="modal">取消</button>
        <button id="editConfirm" class="layui-btn">确认</button>
      </div>
    </div>
  </div>
</div>


<script src="js/jquery-3.3.1.js"></script>
<script src="lib/bootstrap-3.3.7-dist/js/bootstrap.js"></script>
<script src="lib/layui/layui.js"></script>
<script>
	layui.use('element', function(){
	  var element = layui.element;
	  
	});
	
	$(function(){
		if('<%=session_userName%>' != "admin"){
			$("#bookManageBtnList").addClass("hide");
		}
		if(window.location.search.indexOf("bookPageNo") > 0){
			$("#borrowMsg").addClass("hide");
			$("#bookList").removeClass("hide");
		}else if(window.location.search.indexOf("borrowPageNo") > 0){
			$("#borrowMsg").removeClass("hide");
			$("#bookList").addClass("hide");
		}else if(window.location.search.indexOf("adminBookPageNo") > 0){
			$("#mainPart").addClass("hide");
			$("#bookManagePart").removeClass("hide");
		}else{
			$("#borrowMsg").removeClass("hide");
			$("#bookList").addClass("hide");
		}
	})
	
	/* 主体部分的js代码 */
	$("#library").on("click", ".libraryBtn", function(e){
		e.preventDefault();
		$("#mainPart").removeClass("hide");
		$("#bookManagePart").addClass("hide");
	})
	
	$("#borrowMsgTable").on("click", ".returnBtn", function(){
		$("#modal").modal();
		var $_this = $(this);
		var ReturnBookUserName = '<%=session_realName%>';
		var id = $(this).parent().parent().find("td").eq(0).text();
		var ReturnBookId = $(this).parent().parent().find("td").eq(3).text();
		$('#modal').on('hidden.bs.modal', function () {
			$("#returnConfirm").off();
		})
		$("#returnConfirm").click(function(){
			$('#modal').modal('hide')
			$.ajax({
				type: 'GET',
				url: './../returnBookHandler',
				data: {
					id: id,
					ReturnBookId: ReturnBookId,
					ReturnBookUserName: ReturnBookUserName
				},
				success: function(data){
					if(data == '1'){
						//console.log(1)
						$_this.addClass("layui-btn-disabled");
						$_this.removeClass("returnBtn");
						$_this.attr("disabled","true");
						$_this.parent().prev().text("已归还");
					}else if(data == '2'){
						$_this.addClass("layui-btn-disabled");
						$_this.removeClass("returnBtn");
						$_this.attr("disabled","true");
						$_this.parent().prev().text("已归还");
						
						$("#bookListTable tbody tr").each(function(){
							if(parseInt($(this).find("td").eq(0).text()) == ReturnBookId){
								$(this).find("td").last().remove();
								var num = parseInt($(this).find("td").eq(4).text());
								$(this).find("td").eq(4).text(num+1);
								var $td = $("<td><button class='layui-btn borrowBookBtn'>借阅书籍</button></td>");
								$(this).append($td);
							}
						})
					}
				}
				
			})
		})
	})
	
	
	$("#quitBtn").click(function(e){
		e.preventDefault();
		$.ajax({
			url: "./../quitHandler",
			type: "POST",
			success: function(data){
				window.location.href="./login.jsp";
			}
		})
	})
	
	
	$("#bookListBtn").click(function(e){
		e.preventDefault();
		$("#bookList").removeClass("hide").siblings().addClass("hide");
	})
	$("#borrowMsgBtn").click(function(e){
		e.preventDefault();
		$("#borrowMsg").removeClass("hide").siblings().addClass("hide");
	})
	
	
	$("#filterBookInput").on("keyup",function(){
		var val = $('#filterBookInput').val().trim().toLocaleUpperCase();
		if(!val.length){
			$("#bookListTable tr td").show();
		}
		$("#bookListTable tbody tr").each(function(x,y){
			if($(this).find("td").text().toString().toLocaleUpperCase().indexOf(val) > -1){
				$(this).show();
			}else{
				$(this).hide();
			}
		})
	})
	
	
	$("#filterMsgInput").on("keyup",function(){
		var val = $('#filterMsgInput').val().trim().toLocaleUpperCase();
		if(!val.length){
			$("#borrowMsgTable tr td").show();
			$("#borrowMsgTable tbody tr").each(function(x,y){
				$(this).find("td").eq(3).hide();
			})
		}
		$("#borrowMsgTable tbody tr").each(function(x,y){
			if($(this).find("td").text().toString().toLocaleUpperCase().indexOf(val) > -1){
				$(this).show();
			}else{
				$(this).hide();
			}
		})
	})

	var borrowId = <%=borrowMsgMaxID%>;
	$("#bookListTable").on("click", ".borrowBookBtn", function(){
		//console.log(111)
		//console.log('<%=session_realName%>')
		var $_this = $(this);
		if($(this).parent().prev().text() == '0'){
			alert("此书借阅人数过多，已经没有剩余的书可以借了");
		}else{
			$("#modal2").modal();
			var borrowUserName = '<%=session_userName%>';
			var borrowBookId = $(this).parent().parent().find("td").first().text();
			var borrowBookName = $(this).parent().parent().find("td").eq(1).text();
			var borrowBookAuthor = $(this).parent().parent().find("td").eq(2).text();
			var borrowBookPress = $(this).parent().parent().find("td").eq(3).text();
			//获取当前日期
			var date = new Date();
			var year = date.getFullYear();
			var month = date.getMonth() + 1;
			var day = date.getDate();
			if (month < 10) {
			    month = "0" + month;
			}
			if (day < 10) {
			    day = "0" + day;
			}
			var borrowDate = year + "-" + month + "-" + day;
			//console.log(borrowDate)
			$('#modal2').on('hidden.bs.modal', function () {
				$("#borrowConfirm").off();
			})
			$("#borrowConfirm").click(function(){
				var borrowDays = $("#borrowDaysInput").val();
				$('#modal2').modal('hide');
				$.ajax({
					url: "./../borrowBookHandler",
					type: "POST",
					data: {
						borrowDays: borrowDays,
						borrowUserName: borrowUserName,
						borrowBookId: borrowBookId
					},
					success: function(data){
						if(data == '1'){
							borrowId += 1;
							$_this.addClass("layui-btn-disabled");
							$_this.removeClass("borrowBookBtn");
							$_this.attr("disabled","true");
							$_this.text("已借阅");
							var num = $_this.parent().prev().text();
							$_this.parent().prev().text(num-1);
							
							var $tr = $("<tr></tr>");
							$tr.html("<td>"+ borrowId +"</td>\n<td>" + borrowUserName + "</td>\n<td>" + '<%=session_realName%>' + "</td>\n<td style='display:none;'>" + borrowBookId + "</td>\n<td>" + borrowBookName + "</td>\n<td>" + borrowBookAuthor + "</td>\n<td>" + borrowBookPress + "</td>\n<td>" + borrowDate + "</td>\n<td>" + borrowDays + "</td>\n<td>未归还</td>\n<td><button class='layui-btn returnBtn'>归还书籍</button></td>");
							$("#borrowMsgTable").prepend($tr);
						}
					}
				})
			})
							
		}
	})

	
	/* 图书管理部分的代码 */
	$("#bookManagePartBtn").click(function(e){
		e.preventDefault();
		if('<%=session_userName%>' != "admin"){
			$("#modal3").modal();
		}
	})
	$("#libraryManager").on("click", ".libraryManagerBtn", function(e){
		e.preventDefault();
		$("#mainPart").addClass("hide");
		$("#bookManagePart").removeClass("hide");
	})
	
	$("#addBookBtn").click(function(){
		$("#addBookPart").removeClass("hide").siblings().addClass("hide");
	})
	$("#editBookBtn").click(function(){
		$("#editBookPart").removeClass("hide").siblings().addClass("hide");
	})
	
	var addBookId = <%=maxBookId%>;
	$("#addBtn").click(function(){
		$("#modal4").modal();
		$('#modal4').on('hidden.bs.modal', function () {
			$("#addConfirm").off();
		})
		var addBookName = $("#addBookName").val().trim();
		var addBookAuthor = $("#addBookAuthor").val().trim();
		var addBookNum = parseInt($("#addBookNum").val().trim());
		var addBookPress = $("#addBookPress").val().trim();
		$("#addConfirm").click(function(){
			$("#modal4").modal('hide');
			$.ajax({
				url: './../addBookHandler',
				type: 'POST',
				data: {
					addBookName: addBookName,
					addBookAuthor: addBookAuthor,
					addBookNum: addBookNum,
					addBookPress: addBookPress
				},
				success: function(data){
					//console.log(data)
					if(data == '1'){
						addBookId += 1;
						$("#modal5Text").text("添加成功");
						$("#modal5Label").text("");
						$("#modal5").modal();
						$("#addBookName").val('');
						$("#addBookAuthor").val('');
						$("#addBookNum").val('');
						$("#addBookPress").val('');
						
						var $tr = $("<tr></tr>");
						$tr.html("<td>" + addBookId + "</td>\n<td>" + addBookName + "</td>\n<td>" + addBookAuthor + "</td>\n<td>" + addBookNum + "</td>\n<td>" + addBookPress + "</td><td><button class='layui-btn borrowBookBtn'>借阅书籍</button></td>")
						$("#bookListTable").prepend($tr);
						var $tr2 = $("<tr></tr>");
						$tr2.html("<td>" + addBookId + "</td>\n<td>" + addBookName + "</td>\n<td>" + addBookAuthor + "</td>\n<td>" + addBookNum + "</td>\n<td>" + addBookPress + "</td><td><button class='layui-btn'>编辑</button><button class='delBookBtn layui-btn'>删除</button></td>")
						$("#editbookListTable").prepend($tr2);
					}else{
						$("#modal5Text").text("添加失败");
						$("#modal5Label").text("输入字段有误，请检查并修改后再试");
						$("#modal5").modal();
					}
				}
			})
		})
	})
	
	$("#filterEditBookInput").on("keyup",function(){
		var val = $('#filterEditBookInput').val().trim().toLocaleUpperCase();
		if(!val.length){
			$("#editbookListTable tr td").show();
		}
		$("#editbookListTable tbody tr").each(function(x,y){
			if($(this).find("td").text().toString().toLocaleUpperCase().indexOf(val) > -1){
				$(this).show();
			}else{
				$(this).hide();
			}
		})
	})
	
	$("#editbookListTable").on("click", ".delBookBtn", function(){
		$("#modal6").modal();
		$('#modal6').on('hidden.bs.modal', function () {
			$("#delConfirm").off();
		})
		var bookId = $(this).parent().parent().find("td").first().text();
		$("#delConfirm").click(function(){
			$("#modal6").modal("hide");
			$.ajax({
				url: "./../delBookHandler",
				type: "POST",
				data: {
					bookId: bookId
				},
				success: function(data){
					//console.log(data)
					if(data == '1'){
						$("#modal5Text").text("删除成功");
						$("#modal5").modal();
						$('#modal5').on('hidden.bs.modal', function () {
							window.location.reload();
						})
					}else {
						$("#modal5Text").text("删除失败");
						$("#modal5Label").text("此书籍有被借阅记录，无法删除");
						$("#modal5").modal();
					}
				}
			})
		})
	})
	$("#editbookListTable").on("click", ".editBookBtn", function(){
		var editBookId = parseInt($(this).parent().parent().find("td").eq(0).text());
		var editBookName = $(this).parent().parent().find("td").eq(1).text();
		var editBookAuthor = $(this).parent().parent().find("td").eq(2).text();
		var editBookPress = $(this).parent().parent().find("td").eq(3).text();
		var editBookNum = parseInt($(this).parent().parent().find("td").eq(4).text());
		$("#editBookForm").removeClass("hide").siblings().addClass("hide");
		$("#editBookName").val(editBookName);
		$("#editBookAuthor").val(editBookAuthor);
		$("#editBookNum").val(editBookNum);
		$("#editBookPress").val(editBookPress);
		$("#editBtn").click(function(){
			editBookName = $("#editBookName").val();
			editBookAuthor = $("#editBookAuthor").val();
			editBookNum = $("#editBookNum").val();
			editBookPress = $("#editBookPress").val();
			$("#modal7").modal();
			$('#modal7').on('hidden.bs.modal', function () {
				$("#editConfirm").off();
			})
			$("#editConfirm").click(function(){
				$("#modal7").modal("hide");
				$.ajax({
					url: "./../editBookHandler",
					type: "POST",
					data: {
						editBookId: editBookId,
						editBookName: editBookName,
						editBookAuthor: editBookAuthor,
						editBookNum: editBookNum,
						editBookPress: editBookPress
					},
					success: function(data){
						if(data == '1'){
							$("#modal5Text").text("修改成功");
							$("#modal5").modal();
							$('#modal5').on('hidden.bs.modal', function () {
								window.location.reload();
							})
						}else {
							$("#modal5Text").text("修改失败");
							$("#modal5Label").text("请仔细检查修改后的字段是否有效");
							$("#modal5").modal();
						}
					}
				})
			})
		})
	})
</script>
</body>
</html>