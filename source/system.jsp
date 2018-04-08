<!DOCTYPE HTML>
<html>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" >
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*, javax.sql.*, java.io.*, java.util.*, java.math.*, java.text.*" %>
<head>
</head>
<body>
<%
try{
out.println("JVM 시스템을 종료합니다.");
System.exit(0);
out.println("시스템을 종료했습니다.");

//절대 웹에서는 이렇게 쓰지 않습니다. 매우 위험합니다.
}catch(Exception e){
	out.println(e.toString());
}
%>
</body>
</html>