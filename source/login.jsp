<!DOCTYPE HTML>
<%@ page contentType="text/html; charset=utf-8" language="java" %>
<%@ page import="java.util.*, java.text.*" %>
<%@ page import="java.sql.*, javax.sql.*, java.net.*, java.io.*" %>
<html>
<head>
<style>
	table.mytable {
		border-collapse: separate;
		border-spacing: 1px;
		//text-align: center;
		line-height: 1.5;
		border-top: 1px solid #ccc;
	  margin : 20px 10px;
	}
	table.mytable th {
		//width: 150px;
		padding: 10px;
		font-weight: bold;
		vertical-align: top;
		border-bottom: 1px solid #ccc;
	}
	table.mytable td {
		//width: 350px;
		padding: 10px;
		vertical-align: top;
		border-bottom: 1px solid #ccc;
	}
	a:no-uline { text-decoration:none; }
	a:link{color:black; text-decoration:none;}
	a:visited {text-decoration:none;}
	a:hover{text-decoration:none;}
	a:active {text-decoration:none;}
</style>
</head>
<body>
<%
	//get방식으로 url에서 받아온 jump주소입니다. (login_check.jsp) 
	String jump = request.getParameter("jump");
	if(jump==null){
		jump = "login_check.jsp";
	}
%>
<center>
<br><br><br><br><br>
<p>로그인</p>
<form method='post' action='login_id_pw_check.jsp'>
<table class=mytable>
	<tr>
		<td>학번
		</td>
		<td><input type='text' name='id' autofocus required />
		</td>
	</tr>
	<tr>
		<td>비밀번호
		</td>
		<td><input type='password' name='passwd' required />
		</td>
	</tr>
</table>
<input type=submit value=로그인 />
<!--화면에 나타나진 않지만 jump라는 이름의 파라메터를 post방식으로 건네줍니다. value값은 (login_check.jsp)-->
<input type='hidden' name='jump' value='<%=jump%>' />
</form>
</center>
</body>
</html>