<!DOCTYPE HTML>
<html>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" >
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*, javax.sql.*, java.io.*, java.util.*, java.math.*, java.text.*" %>
<% request.setCharacterEncoding("utf-8");%>
<head>
</head>
<body>
<%
String attd = "";
String attd_interval = "";
String leave_ = "";
String leave_interval = "";
attd = request.getParameter("attd");
attd_interval = request.getParameter("attd_interval");
leave_ = request.getParameter("leave_");
leave_interval = request.getParameter("leave_interval");
attd_interval = "00:"+attd_interval;
leave_interval = "00:"+leave_interval;
out.println("setting 값은 다음과 같습니다.<br><br>");
out.println("<b>attd :" + attd + "</b><br>");
out.println("<b>attd_interval :" + attd_interval + "</b><br>");
out.println("<b>leave_ :" + leave_ + "</b><br>");
out.println("<b>leave_interval :" + leave_interval + "</b><br><br>");

try{
	Class.forName("com.mysql.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/KOPOCTC","root","alslf2gk");
	ResultSet rset = null;
	String query = null;
	PreparedStatement pstm = null;
	// 기존 설정 값 삭제
	query = "truncate table sysMaster;";
	pstm = conn.prepareStatement(query);
	pstm.execute();
	// 새로 설정한 값 추가
	query = "insert into sysMaster(attd, attd_interval,leave_,leave_interval)"
		  + "value(?,?,?,?);";
	pstm = conn.prepareStatement(query);
	pstm.setString(1,attd);
	pstm.setString(2,attd_interval);
	pstm.setString(3,leave_);
	pstm.setString(4,leave_interval);
	pstm.execute();		// 데이터 입력
	int max = 999999999;
	int min = 0;
	/* 향후 select count(_id) from otpDB 값으로 대체  */
	int totalCount = 10;
	int cnt = 0;
	int id = 2018231001;
	/* otp 데이터 바로 생성 */
	while(cnt<totalCount){
		/* Math.random() 은 double 타입의 0.0 이상 1.0 미만의 랜덤한 숫자를 리턴한다. */
		double random = Math.random() * (max - min + 1);
		int otpForId = (int) random;
		
		query = "update otpDB set otp=?"
				 + " where _id=?;";
		pstm = conn.prepareStatement(query);
		pstm.setInt(1, otpForId);
		pstm.setInt(2, id);
		pstm.execute();	
		
		cnt++;
		id++;
	}
	
	pstm.close();
	conn.close(); 
	out.println("설정 사항을 sysMaster 테이블에 입력했습니다.<br>");
	out.println("OTP를 생성했습니다.<br>");
	
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