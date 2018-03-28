<!DOCTYPE HTML>
<html>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" >
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*, javax.sql.*, java.io.*, java.util.*, java.math.*, java.text.*" %>
<head>
</head>
<body>
<b>현재 설정된 입/퇴실 시간 및 OTP(QR코드) 유효시간 입니다.</b>
<br><br>
<table border=1 cellspacing=0>
<tr>
	<th>입실 시간</th><th>입실 OTP 유효시간</th><th>퇴실 시간</th><th>퇴실 OTP 유효시간</th>
</tr>
<%
String attd = "";
String attd_interval = "";
String leave_ = "";
String leave_interval = "";

try{
	Class.forName("com.mysql.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/KOPOCTC","root","alslf2gk");
	ResultSet rset = null;
	String query = null;
	PreparedStatement pstm = null;
	
	query = "select attd, attd_interval, leave_, leave_interval from sysMaster;";
	pstm = conn.prepareStatement(query);
	rset = pstm.executeQuery();
	while(rset.next()){
		attd = rset.getString(1);
		attd_interval = rset.getString(2);
		leave_ = rset.getString(3);
		leave_interval = rset.getString(4);
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
<tr>
	<td><%=attd%></td><td><%=attd_interval%></td><td><%=leave_%></td><td><%=leave_interval%></td>
</tr>
</table>
<br><br>
<b>입/퇴실 시간과 OTP(QR코드)의 유효 시간을 변경하려면 아래 폼에 원하는 시간을 입력한 뒤 '시간 설정'버튼을 눌러 주세요.</b>
<br><br>
<form method="post" >
입실 시간 : <input name='attd' type=time required/>
OPT 유효시간 설정 : <input name='attd_interval' type=number required/> *단위: 분
<br>
퇴실 시간 : <input name='leave_' type=time required/>
OPT 유효시간 설정 : <input name='leave_interval' type=number required/>
 &nbsp; <input type=submit name='setTime' value='시간 설정' formaction="writeTime.jsp"/><br><br><br>
<b>OTP 생성하기</b>
<input type=submit name='makeOTP' value='OTP 생성' formaction="writeOTP.jsp"/>
</form>
<script>

</script>
</body>
</html>