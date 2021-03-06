﻿<!DOCTYPE html>
<html>
<head>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*, javax.sql.*, java.io.*, java.util.Date, java.math.*, java.text.*" %>
<%@ page import = "java.util.List" %>
<link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.3/css/bootstrap.min.css">
<script src="//code.jquery.com/jquery-3.2.1.slim.min.js"></script>
<script src="//cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"></script>
<script src="//maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.3/js/bootstrap.min.js"></script>
<script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
</head>
<body>
<%
request.setCharacterEncoding("utf-8");
String dept = request.getParameter("dept");
String name = request.getParameter("name");
String _id = request.getParameter("_id");
String pwd = request.getParameter("password");
String phone = request.getParameter("phone");
String email = request.getParameter("email");


/* memberDB 에 넣고 동시에 otpDB에도 넣을 것 */

dept = dept.substring(7);

try{
	Class.forName("com.mysql.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/iamhpd7","iamhpd7","ctc@kopo");
	ResultSet rset = null;
	String query = null;
	PreparedStatement pstm = null;
	
	query = "insert into memberDB(dept,name,_id,password,phone,email,hidden)"
			 + " value(?,?,?,?,?,?,0);";
	pstm = conn.prepareStatement(query);
	pstm.setString(1, dept);
	pstm.setString(2, name);
	pstm.setString(3, _id);
	pstm.setString(4, pwd);
	pstm.setString(5, phone);
	pstm.setString(6, email);
	pstm.execute();
	%>
	<h3 align=center><%=name%>의 학번(<%=_id%>)과 정보를 등록했습니다.</h1>
	<center><button class='btn center-block btn-info' id="buttonToBack">돌아가기</button></center>
	<script>
	$(function(){
		$("#buttonToBack").click(function(){
			location.href = 'memberManage.jsp';
		});
	});
	</script>
	<%
	query = "insert into otpDB(_id)"
			 + " value(?);";
	pstm = conn.prepareStatement(query);
	pstm.setString(1,_id);
	pstm.execute();
	
	query = "insert into managingDB(_id)"
			 + " value(?);";
	pstm = conn.prepareStatement(query);
	pstm.setString(1,_id);
	pstm.execute();				/* status 0: 입실완료, 1: 지각, 2: 조퇴, 3: 퇴실완료, 4:결석, 5:출석 9: 체크되기 이전 상태 */
	
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
</body>
</html>
