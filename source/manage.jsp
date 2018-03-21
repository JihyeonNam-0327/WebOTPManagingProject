<!DOCTYPE HTML>
<html>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" >
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*, javax.sql.*, java.io.*, java.util.Date, java.math.*, java.text.*" %>

<head>
</head>
<body>
<%
Date today = new Date();
SimpleDateFormat sdf = new SimpleDateFormat("M월 d일");
String curDate = sdf.format(today);
%>
<b><%=curDate%> 입/퇴실 List</b>
<br>
<!-- TODO : today 날짜 출력되도록 할 것 -->
<!-- today 의 모든 학번에 해당하는 출결 상태를 표시할 것 -->
<br>
<form method="post">
<table border=1 cellspacing=0>
	<tr>
		<td>학번</td>
		<td>입실 시간</td>
		<td>퇴실 시간</td>
		<td>상태</td>
	</tr>
<%
int id = 0;
String time_in = "";
String time_out = "";
int status = 0;

try{
	Class.forName("com.mysql.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/KOPOCTC","root","alslf2gk");
	ResultSet rset = null;
	String query = null;
	PreparedStatement pstm = null;

	query = "select _id,time_in,time_out,status from managingDB";
	pstm = conn.prepareStatement(query);
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
%>
	<tr>
		<td><%=id%></td>
		<td><%=time_in%></td>
		<td><%=time_out%></td>
		<td><%=status%></td>
	</tr>
<%
	}
	
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
</form>
</body>
</html>

