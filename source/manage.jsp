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
sdf = new SimpleDateFormat("yyyy-MM-dd");
String compareTime = sdf.format(today);
%>
<b><%=curDate%> 입/퇴실 List</b>
<br>
<form method="post">
<table border=1 cellspacing=0>
	<tr>
		<td>학번</td>
		<td>입실 시간</td>
		<td>퇴실 시간</td>
		<td>출결현황</td>
	</tr>
<%
int id = 0;
String time_in = "";
String time_out = "";
int status = 0;
String resultStatus = "";

try{
	Class.forName("com.mysql.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/KOPOCTC","root","alslf2gk");
	ResultSet rset = null;
	String query = null;
	PreparedStatement pstm = null;	
	
	query = "select _id from managingDB where date_format(date,'%Y-%m-%d')=? order by _id";
	pstm = conn.prepareStatement(query);
	pstm.setString(1, compareTime);
	rset = pstm.executeQuery();
	if(!rset.next()){
		out.println("오늘 일일 출석 체크는 끝났습니다. 월간 출퇴근 현황을 확인하세요.");
		return;
	}
	
	/* managingDB 의 상태를 보여주는 부분 */
	query = "select _id,time_in,time_out,status from managingDB where date_format(date,'%Y-%m-%d')=? order by _id";
	pstm = conn.prepareStatement(query);
	pstm.setString(1, compareTime);
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
	<tr>
		<td><%=id%></td>
		<td><%=time_in%></td>
		<td><%=time_out%></td>
		<td><%=resultStatus%></td>
	</tr>
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
</form>
</body>
</html>

