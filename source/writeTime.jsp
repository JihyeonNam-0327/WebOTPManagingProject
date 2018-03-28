<!DOCTYPE HTML>
<html>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" >
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*, javax.sql.*, java.io.*, java.util.*, java.math.*, java.text.*" %>
<% request.setCharacterEncoding("utf-8");%>
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
out.println("시간 setting 값은 다음과 같습니다.<br><br>");
out.println("<b>입실 시간 :" + attd + "</b><br>");
out.println("<b>입실 OTP 유효 시간 :" + attd_interval + "</b><br>");
out.println("<b>퇴실 시간 :" + leave_ + "</b><br>");
out.println("<b>퇴실 OTP 유효 시간 :" + leave_interval + "</b><br><br>");

try{
	Class.forName("com.mysql.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/KOPOCTC","root","alslf2gk");
	ResultSet rset = null;
	String query = null;
	PreparedStatement pstm = null;
	if(attd != null && attd_interval != null && leave_ != null && leave_interval != null){
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
	}else{
		out.println("설정 사항이 없습니다. 시간을 설정해 주세요.");
	}
	
	pstm.close();
	conn.close();
	out.println("설정 사항을 저장했습니다.<br>");
	
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
<button class='btn center-block btn-info' id="buttonToBack">돌아가기</button>
<script>
$(function(){
	$("#buttonToBack").click(function(){
		location.href = 'setting.jsp';
	});
});
</script>
</body>
</html>