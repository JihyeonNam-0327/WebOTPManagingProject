﻿<!DOCTYPE html>
<html>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" >
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*, javax.sql.*, java.io.*, java.util.Date, java.math.*, java.text.*" %>
<%@ page import="java.net.*, java.io.*" %>
<head>
<link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.3/css/bootstrap.min.css">
<script src="//code.jquery.com/jquery-3.2.1.slim.min.js"></script>
<script src="//cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"></script>
<script src="//maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.3/js/bootstrap.min.js"></script>
<script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
</head>
<body>
<% request.setCharacterEncoding("utf-8");%>
<%
//세션을 체크해서 없다면 로그인창으로 보냅니다. 그리고 로그인이 되면 자기 자신에게 와야하므로 
//자기 자신의 url을 써주어야 합니다. 여기에선 login_check.jsp
String loginOK="";
String jumpURL="login.jsp?jump=manageMonth.jsp";
String id = request.getParameter("id");
String checkID = (String) session.getAttribute("login_ok");
//login값이 없는지, login_ok 키의 value값이 yes가 맞는지 확인합니다.
loginOK = (String)session.getAttribute("login_ok");
if(loginOK==null || !loginOK.equals(checkID)){
	response.sendRedirect(jumpURL);
	return;
}
%>
<h1 align=center>월간 출결 현황</h1>
<br>
<div style='width:600px; margin:auto;'>
<%
String _id = "";
String dept = "";
String name = "";

try{
	Class.forName("com.mysql.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/iamhpd7","iamhpd7","ctc@kopo");
	ResultSet rset = null;
	ResultSet rset2 = null;
	String query = null;
	PreparedStatement pstm = null;
	
	query = "select * from memberDB;";
	pstm = pstm = conn.prepareStatement(query);
	rset2 = pstm.executeQuery();
	if(!rset2.next()){
		out.println("<center>학생 정보가 없습니다. 아래 버튼을 눌러 학생을 등록해 주세요.</center>");
	}else{
	%>
	<table class='table table-bordered table-hover' border=1 cellspacing=0 align=center style="text-align:center;" width=400>
	<thead>
	<tr>
		<th>학과</th><th>이름</th><th>학번</th><th>현황 확인</th>
	</tr>
	</thead>
	<tbody>
	<%
		query = "select dept, name, _id from memberDB";
		pstm = conn.prepareStatement(query);
		rset = pstm.executeQuery();
		
		while(rset.next()){
			dept = rset.getString(1);
			name = rset.getString(2);
			_id = rset.getString(3);
			out.println("<tr>");
			out.println("<td>"+dept+"</td>");
			out.println("<td>"+name+"</td>");
			out.println("<td>"+_id+"</td>");
			out.println("<td>");
			%>
			<input type='button' class='btn btn-info' value='자세히' onclick="buttonToDetail('<%=_id%>','<%=name%>')"/></td>
			<%
			
			out.println("</tr>");
		}
		rset.close();
	}
	
	rset2.close();
	pstm.close();
	conn.close(); 
}catch(SQLException e){
	if(e.getMessage().contains("Duplicate")){
		out.println(e.toString());
	} else {
		out.println(e.toString());
	}
}catch(Exception e){
	out.println(e.toString());
}
%>
</tbody>
</table>
</div>
<script>
function buttonToDetail(id, name){
	location.href = "manageMonthDetail.jsp?id="+id+"&name="+name;
}
</script>
</body>
</html>