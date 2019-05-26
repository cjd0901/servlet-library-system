<%@ page language="java" contentType="text/html" pageEncoding="utf-8"%>
<!DOCTYPE HTML>
<html>
<head>
<title>图书管理系统登录页面</title>
<link href="css/style.css" rel="stylesheet" type="text/css" media="all"/>
</head>
<body>
<div class="login">
	<h2>图书管理系统登录界面</h2>
	<div class="login-top">
		<h1>请登录</h1>
		<form method="get" id="form">
			<input type="text" id="userName" placeholder="用户名"  name="userName">
			<input type="password" id="pwd" placeholder="密码" name="pwd">
	    <div class="forgot">
	    	<a href="#">忘记密码？</a>
	    	<input type="submit" id="login"  value="登录" >
	    </div>
	    </form>
	</div>
	<div class="login-bottom">
		<h3>新用户 &nbsp;<a href="./register.jsp">点击这里</a>&nbsp 注册</h3>
	</div>
</div>	

 
 
	<script src="js/jquery-3.3.1.js"></script>
	<script>
		$("#login").click(function(e){
			var userName = $("#userName").val();
			var pwd = $("#pwd").val();
			e.preventDefault();
			$.ajax({
				type: "POST",
				url: "./../loginHandler",
				data: {
					userName: userName,
					pwd: pwd
				},
				success: function(data){
					if(data === "1"){
						window.location.href = './index.jsp'
					}else{
						//console.log(data)
						var $err = $("<p></p>");
						$err.html("用户名或密码错误，请重新输入");
						$err.attr("xdd","xdd");
						$err.css({"color":"crimson", "font-size":"15px"});
						//console.log($("#pwd").next().attr('xdd'))
						if($("#pwd").next().attr('xdd') != 'xdd'){
							$("#pwd").after($err);
						}
					}
					
				}
			}) 
		}) 
		$("#userName,#pwd").on('focus',function(){
			if($("#pwd").next().attr('xdd') == 'xdd'){
				$("#pwd").next().remove()
			}
		})

	</script>

</body>
</html>