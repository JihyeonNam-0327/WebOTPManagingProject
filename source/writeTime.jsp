<!DOCTYPE HTML>
<html>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" >
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*, javax.sql.*, java.io.*, java.util.Date, java.math.*, java.text.*" %>
<% request.setCharacterEncoding("utf-8");%>
<head>
<link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.3/css/bootstrap.min.css">
<script src="//code.jquery.com/jquery-3.2.1.slim.min.js"></script>
<script src="//cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"></script>
<script src="//maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.3/js/bootstrap.min.js"></script>
<script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
</head>
<body>
<%
String attd = "";
String attd_interval = "";
String leave_ = "";
String leave_interval = "";
String otp_interval = "";
attd = request.getParameter("attd");
attd_interval = request.getParameter("attd_interval");
leave_ = request.getParameter("leave_");
leave_interval = request.getParameter("leave_interval");
otp_interval = request.getParameter("otp_interval");
attd_interval = "00:"+attd_interval;
leave_interval = "00:"+leave_interval;
otp_interval = "00:"+otp_interval;
out.println("<center>시간 setting 값은 다음과 같습니다.<br><br>");
out.println("<b>입실 시간 :" + attd + "</b>");
out.println("<b>부터 " + attd_interval + " 분 동안</b><br>");
out.println("<b>퇴실 시간 :" + leave_ + "</b>");
out.println("<b>부터 " + leave_interval + " 분 동안</b><br><br>");
out.println("<b>OTP 유효 시간 :"+otp_interval+" 분 동안</b></center><br>");

Date today = new Date();
SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
String curDate = sdf.format(today);

try{
	Class.forName("com.mysql.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/iamhpd7","iamhpd7","ctc@kopo");
	ResultSet rset = null;
	String query = null;
	PreparedStatement pstm = null;
	if(attd != null && attd_interval != null && leave_ != null && leave_interval != null){
		// 기존 설정 값 삭제
		query = "truncate table sysMaster;";
		pstm = conn.prepareStatement(query);
		pstm.execute();
		// 새로 설정한 값 추가
		query = "insert into sysMaster(attd, attd_interval,leave_,leave_interval,otp_interval)"
			  + "value(?,?,?,?,?);";
		pstm = conn.prepareStatement(query);
		pstm.setString(1,attd);
		pstm.setString(2,attd_interval);
		pstm.setString(3,leave_);
		pstm.setString(4,leave_interval);
		pstm.setString(5,otp_interval);
		pstm.execute();		// 데이터 입력
		
		query = "update managingDB set time_in=null where time_in is not null;";
		pstm = conn.prepareStatement(query);
		pstm.execute();
		query = "update managingDB set time_out=null where time_out is not null;";
		pstm = conn.prepareStatement(query);
		pstm.execute(); //managingDB 의 time_in, time_out 컬럼의 값을 NULL로 만듭니다.
		query = "update managingDB set status=9 where time_in is null and time_out is null;";
		pstm = conn.prepareStatement(query);
		pstm.execute(); //managingDB 의 status 컬럼의 값을 default로 설정합니다.
		query = "delete from attendanceDB where date_format(date,'%Y-%m-%d')=?";
		pstm = conn.prepareStatement(query);
		pstm.setString(1,curDate);
		pstm.execute(); //attendanceDB 의 출석내역을 삭제합니다.
	}else{
		out.println("<center>설정 사항이 없습니다. 시간을 설정해 주세요.</center>");
	}
	
	pstm.close();
	conn.close();
	out.println("<center>설정 사항을 저장했습니다.<br></center>");
	
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
<center><button class='btn btn-info' id="buttonToBack">돌아가기</button></center>
<script>
$(function(){
	$("#buttonToBack").click(function(){
		location.href = 'setting.jsp';
	});
});
</script>
</body>
</html>