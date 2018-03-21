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
String mon = "";							//setting 페이지에서 받아올 변수들
String tue = "";
String wed = "";
String thu = "";
String fri = "";
String sat = "";
String sun = "";
String attd = "";
String attd_interval = "";
String leave_ = "";
String leave_interval = "";

mon = request.getParameter("mon");
tue = request.getParameter("tue");
wed = request.getParameter("wed");
thu = request.getParameter("thu");
fri = request.getParameter("fri");
sat = request.getParameter("sat");
sun = request.getParameter("sun");
attd = request.getParameter("attd");
attd_interval = request.getParameter("attd_interval");
leave_ = request.getParameter("leave_");
leave_interval = request.getParameter("leave_interval");

attd_interval = "00:"+attd_interval;
leave_interval = "00:"+leave_interval;

out.println("write setting 값은 다음과 같습니다.<br><br>");
out.println("attd :" + attd + "<br>");
out.println("request.getParameter('attd') :" + request.getParameter("attd") + "<br>");
out.println("attd_interval :" + attd_interval + "<br>");
out.println("leave_ :" + leave_ + "<br>");
out.println("leave_interval :" + leave_interval + "<br><br>");

try{
	Class.forName("com.mysql.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/KOPOCTC","root","alslf2gk");
	ResultSet rset = null;
	String query = null;
	PreparedStatement pstm = null;
	
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
	
	out.println("sysMaster 테이블에 입력했습니다.<br>");
	out.println("랜덤 OTP를 생성했습니다.<br>");
	
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