<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<link href="css/style.css" rel="stylesheet" type="text/css" media="all"/>
<link href="lib/bootstrap-3.3.7-dist/css/bootstrap.css" rel="stylesheet" type="text/css" />
<title>图书管理系统注册页面</title>
</head>
<body>
<div class="login">
	<h2>图书管理系统注册界面</h2>
	<div class="login-top">
		<h1>请注册</h1>
		<form method="get" id="form">
			<input type="text" id="userName" placeholder="用户名*" value=""  name="userName">
			<input type="password" id="pwd" placeholder="密码*" value="" name="pwd">
			<input type="text" id="realName" placeholder="真实姓名*" value="" name="realName">
			<input type="text" id="phone" placeholder="手机号码*" value=""  name="phone">
	    <div class="forgot">
	    	<input type="submit" id="register"  value="注册" >
	    </div>
	    </form>
	</div>
	<div class="login-bottom">
		<h3>已有账号？ &nbsp;<a href="./login.jsp">点击这里</a>&nbsp 登录</h3>
	</div>
</div>
	
	<div class="modal fade" id="modal" tabindex="-1" role="dialog">
	  <div class="modal-dialog" role="document">
	    <div class="modal-content">
	      <div class="modal-header">
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
	        <h4 style="color:crimson;font-size:25px;" class="modal-title">恭喜你！注册成功！</h4>
	      </div>
	      <div class="modal-body">
	        <p style="color:crimson;font-size:20px;">页面将跳转到登录界面</p>
	      </div>
	      <div class="modal-footer">
	        <button type="button" class="btn btn-default" data-dismiss="modal">确定</button>
	      </div>
	    </div><!-- /.modal-content -->
	  </div><!-- /.modal-dialog -->
	</div><!-- /.modal -->
	
		
	<script src="js/jquery-3.3.1.js"></script>
	<script src="lib/bootstrap-3.3.7-dist/js/bootstrap.js"></script>
	<script>
		$("#register").on('click',function(e){
			//console.log($("#userName").val().trim() === '')
			var userName = $("#userName").val().trim();
			var pwd = $("#pwd").val().trim();
			var realName = $("#realName").val().trim();
			var phone = $("#phone").val().trim();
			var $err = $("<p>");
			$err.attr("xdd","xdd")
			$err.css({"color":"crimson","font-size":"15px"})
			e.preventDefault();
			if($("#userName").val().trim() === '' || $("#pwd").val().trim() === '' || $("#realName").val().trim() === '' || $("#phone").val().trim() === ''){
				$err.html("请将所有内容填写完整！")
				if($("#phone").next().attr("xdd") != "xdd"){
					$("#phone").after($err);
				}
			}else if(phone.trim().length !== 11){
				$err.html("请输入正确的手机号");
				if($("#phone").next().attr("xdd") != "xdd"){
					$("#phone").after($err);
				}	
			}else{
				$.ajax({
					url: "./../registerHandler",
					type: "POST",
					data: {
						userName: userName,
						pwd: pwd,
						realName: realName,
						phone: phone
					},
					success: function(data){
						console.log(data)
						if(data === '0'){
							$err.html("用户名已存在，请更改");
							if($("#phone").next().attr("xdd") != "xdd"){
								$("#phone").after($err);
							}
						}else if(data === '1'){
							//console.log("注册成功");
							$("#modal").modal()
							$("#modal").on("hidden.bs.modal",function(){
								window.location.href = "./login.jsp";
							})
						}else{
							$err.html("服务器异常");
							if($("#phone").next().attr("xdd") != "xdd"){
								$("#phone").after($err);
							}
						}
					}
					
				})
			}
		})
		$(":text,:password").on("focus",function(){
			if($("#phone").next().attr("xdd") === "xdd"){
				$("#phone").next().remove();
			}

		})
	</script>
</body>
</html>