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
out.println("JVM �ý����� �����մϴ�.");
System.exit(0);
out.println("�ý����� �����߽��ϴ�.");

//���� �������� �̷��� ���� �ʽ��ϴ�. �ſ� �����մϴ�.
}catch(Exception e){
	out.println(e.toString());
}
%>
</body>
</html>