﻿<!DOCTYPE HTML>
<html>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" >
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*, javax.sql.*, java.io.*, java.util.*, java.math.*, java.text.*" %>
<head>
<!-- 합쳐지고 최소화된 최신 CSS -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">
<!-- 부가적인 테마 -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap-theme.min.css">
<script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
<!-- 합쳐지고 최소화된 최신 자바스크립트 -->
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>
</head>
<body>
<% request.setCharacterEncoding("utf-8");%>
<%
//세션을 체크해서 없다면 로그인창으로 보냅니다. 그리고 로그인이 되면 자기 자신에게 와야하므로 
//자기 자신의 url을 써주어야 합니다.
	String loginOK="";
	String jumpURL="login.jsp?jump=setting.jsp";
	String id = request.getParameter("id");
	String checkID = (String) session.getAttribute("login_ok");
	//login값이 없는지, login_ok 키의 value값이 yes가 맞는지 확인합니다.
	loginOK = (String)session.getAttribute("login_ok");
	if(loginOK==null || !loginOK.equals(checkID)){
		response.sendRedirect(jumpURL);
		return;
	}
%>
<h1 align=center>입/퇴실 시간 설정</h1>
<br>
<%
String attd = "";
String attd_interval = "";
String leave_ = "";
String leave_interval = "";
String otp_interval = "";

try{
	Class.forName("com.mysql.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/iamhpd7","iamhpd7","ctc@kopo");
	ResultSet rset = null;
	String query = null;
	PreparedStatement pstm = null;
	
	query = "select attd, attd_interval, leave_, leave_interval,otp_interval from sysMaster;";
	pstm = conn.prepareStatement(query);
	rset = pstm.executeQuery();
	if(rset.next()){
		attd = rset.getString(1);
		attd_interval = rset.getString(2);
		leave_ = rset.getString(3);
		leave_interval = rset.getString(4);
		otp_interval = rset.getString(5);
		%>
		<table name=myForm align=center border=0 cellspacing=0>
		<tr><td>
		<b>현재 설정된 입/퇴실 시간 및 OTP(QR코드) 유효시간 입니다.</b>
		<br><br>
		<table border=1 cellspacing=0 align=center width=500 style="text-align:center;">
		<tr>
			<td>입실 시작 시간</td><td>입실 유효시간</td><td>퇴실 시작 시간</td><td>퇴실 유효시간</td><td><b>바코드 유효시간</b></td>
		</tr>
		<tr>
			<td><%=attd%></td><td><%=attd_interval%></td><td><%=leave_%></td><td><%=leave_interval%></td><td><b><%=otp_interval%></b></td>
		</tr>
		</table>
		<br><br>
		<b>입/퇴실 시간과 OTP(QR코드)의 유효 시간을 변경하려면 아래 폼에 원하는 시간을 입력한 뒤 '시간 설정'버튼을 눌러 주세요.<br>
		시간을 다시 설정하면 기존의 입/퇴실 기록은 사라집니다!</b>
		<%
	}else{
		out.println("<b>현재 설정된 입/퇴실 시간 및 OTP(QR코드) 유효시간이 없습니다.<br>");
		out.println("아래 폼에 입/퇴실 시간과 OTP(QR코드)의 유효 시간을 입력한 뒤 '시간 설정'버튼을 눌러 주세요.</b>");
	}
	
	rset.close();
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
<br><br>
<div style="margin:auto; width:500px;">
<form method="post">
입실 시작 시간 : <input name='attd' type=time required/> 부터 <input name='attd_interval' style="width:50px;"  type=number required/> 분 동안으로 설정
<br>
퇴실 시작 시간 : <input name='leave_' type=time required/> 부터 <input name='leave_interval' style="width:50px;"  type=number required/> 분 동안으로 설정
<br><br>
OTP 유효 시간 : OTP 생성 후 <input name='otp_interval' type=number style="width:50px;" required/> 분 동안 유효하도록 설정.
 &nbsp; <input type=submit name='setTime' value='시간 설정' formaction="writeTime.jsp"/>
<br><br><br>
</div>
</form>
<b>관리자 권한으로 OTP 일괄 생성하기</b>
<input type=button name='makeOTP' value='OTP 생성' onclick='location.href="writeOTP.jsp"'/>
</td></tr>
</table>
</body>
</html>