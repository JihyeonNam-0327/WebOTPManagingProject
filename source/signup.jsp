<!DOCTYPE HTML>
<html>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" >
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*, javax.sql.*, java.io.*, java.util.*, java.math.*, java.text.*" %>
<head>
</head>
<body>
<b>입/퇴실 시간과 QR코드의 유효 시간을 설정하세요.</b>
<br>
<form method="post" >
<br><br>
입실 시간 : <input name='attd' type=time />
OPT 유효 시간 설정(분) : <input name='attd_interval' type=number />
<br>
퇴실 시간 : <input name='leave_' type=time />
OPT 유효 시간 설정(분) : <input name='leave_interval' type=number />
<br><br>
OTP 생성하기
<input type=submit name='makeOTP' value='OTP 생성하기' formaction="writeA.jsp"/> 
</form>
</body>
</html>