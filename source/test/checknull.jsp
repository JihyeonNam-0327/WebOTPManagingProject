<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*, javax.sql.*, java.io.*, java.util.*, java.math.*, java.text.*" %>

<%@ page import="java.util.Timer" %>
<%@ page import="java.util.TimerTask" %>
<%@ page import="java.util.Date" %>

<%
try{
	Class.forName("com.mysql.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/iamhpd7","iamhpd7","ctc@kopo");

	ResultSet rset = null;
	String query = null;
	PreparedStatement pstm = null;	
	String time_in="";
	String time_out="";
	String status = "0";
	query = "select time_in, time_out from attendanceDB where _id = 2018231002;";
	pstm = conn.prepareStatement(query);
	rset = pstm.executeQuery();
	while(rset.next()){
		time_in=rset.getString(1);
		time_out=rset.getString(2);
	}
	out.println("결과 : "+time_in+"<br>");
	out.println("결과2 : "+time_out+"<br>");
	
	if(time_in == null && time_out == null){
		status = "4"; // : 결석
	}else if(time_in == null && time_out!=null){
		status = "2"; // 2: 지각
	}else if(time_in!=null && time_out==null){
		status = "1"; // 1: 조퇴
	}else if(time_in != null && time_out!=null){
		status = "5"; // 5: 출석
	}
	
	out.println("결과 : "+time_in+"<br>");
	out.println("결과2 : "+time_out+"<br>");
	out.println("status : " + status);
	
	query = "update managingDB set status=? where _id=2018231001";
	pstm = conn.prepareStatement(query);
	pstm.setString(1,status);
	pstm.execute();
	
}catch(Exception e){
	
}
	%>
	