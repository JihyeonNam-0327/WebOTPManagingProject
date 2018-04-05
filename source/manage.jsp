<!DOCTYPE HTML>
<html>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" >
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*, javax.sql.*, java.io.*, java.util.Date, java.math.*, java.text.*" %>
<head>
<link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.3/css/bootstrap.min.css">
<script src="//code.jquery.com/jquery-3.2.1.slim.min.js"></script>
<script src="//cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"></script>
<script src="//maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.3/js/bootstrap.min.js"></script>
<script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
</head>
<body>
<% request.setCharacterEncoding("utf-8");
//세션을 체크해서 없다면 로그인창으로 보냅니다. 그리고 로그인이 되면 자기 자신에게 와야하므로 
//자기 자신의 url을 써주어야 합니다. 여기에선 login_check.jsp
String loginOK="";
String jumpURL="login.jsp?jump=manage.jsp";
String checkID = (String) session.getAttribute("login_ok");
//login값이 없는지, login_ok 키의 value값이 yes가 맞는지 확인합니다.
loginOK = (String)session.getAttribute("login_ok");
if(loginOK==null || !loginOK.equals(checkID)){
	response.sendRedirect(jumpURL);
	return;
}

Date today = new Date();
SimpleDateFormat sdf = new SimpleDateFormat("M월 d일");
String curDate = sdf.format(today);
sdf = new SimpleDateFormat("yyyy-MM-dd");
String compareTime = sdf.format(today);
%>
<h1 align=center>일일 출결 현황</h1>
<h3 align=center><b><%=curDate%></b> 입/퇴실 List</h3>
<br>
<form method="post">
<%
int id = 0;
String time_in = "";
String time_out = "";
int status = 0;
String resultStatus = "";

try{
	Class.forName("com.mysql.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/iamhpd7","iamhpd7","ctc@kopo");
	ResultSet rset = null;
	String query = null;
	PreparedStatement pstm = null;	
	
	query = "select _id from managingDB order by _id";
	pstm = conn.prepareStatement(query);
	rset = pstm.executeQuery();
	if(!rset.next()){
		out.println("<center>오늘 일일 출석 체크는 끝났습니다.</center>");
		return;
	}
	
	%>
	<div style='width:600px; margin:auto;'>
	<table class='table table-bordered table-hover' border=1 cellspacing=0 align=center style="text-align:center;" width=400>
	<thead>
	<tr>
		<th>학번</th>
		<th>입실 시간</th>
		<th>퇴실 시간</th>
		<th>출결현황</th>
	</tr>
	</thead>
	<tbody>
	<%
	/* managingDB 의 상태를 보여주는 부분 */
	query = "select _id,time_in,time_out,status from managingDB order by _id";
	pstm = conn.prepareStatement(query);
	//pstm.setString(1, compareTime);
	rset = pstm.executeQuery();
	while(rset.next()){
		id = rset.getInt(1);
		time_in = rset.getString(2);
		time_out = rset.getString(3);
		status = rset.getInt(4);
		if(time_in == null){
			time_in = "-";
		}
		if(time_out == null){
			time_out = "-";
		}
		switch(status){
			 case 0 : resultStatus = "입실 완료";
					  break;
			 case 1 : resultStatus = "지각";
					  break;
			 case 2 : resultStatus = "조퇴";
					  break;
			 case 3 : resultStatus = "퇴실 완료";
					  break;
			 case 4 : resultStatus = "결석";
					  break;
			 case 5 : resultStatus = "출석";
					  break;
			 case 9 : resultStatus = "체크 안 함";
					  break;
		}
%>
	<tr scope='row'>
		<td><%=id%></td>
		<td><%=time_in%></td>
		<td><%=time_out%></td>
		<td><%=resultStatus%></td>
	</tr>
	</tbody>
<%
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
</table>
</div>
</form>
</body>
</html>

