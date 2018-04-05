<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<%@ page import="java.sql.*, javax.sql.*, java.io.*, java.util.Date, java.math.*, java.text.*" %>
<%@ page import="java.net.*, java.io.*" %>
<!DOCTYPE html>
<html>
<head>
<%
request.setCharacterEncoding("utf-8");
String title = "";
String content = "";
String id = "";
id = request.getParameter("id"); //글 번호
title = request.getParameter("title");
content = request.getParameter("content");

try{
	Class.forName("com.mysql.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/iamhpd7","iamhpd7","ctc@kopo");
	ResultSet rset = null;
	String query = null;
	PreparedStatement pstm = null;
	
	query = "update gongji set title=?, content=? where id=?;";
	pstm = conn.prepareStatement(query);
	pstm.setString(1,title);
	pstm.setString(2,content);
	pstm.setString(3,id);
	pstm.execute();
	
	pstm.close();
	conn.close();
}catch(SQLException e){
	out.println("SQLe " + e.toString());
}catch(Exception e){
	out.println("Exception " + e.toString());
}
%>
<script>
function go(){
	location.href="gongji_list.jsp";
}
</script>
<head>
<body>
<script>go();</script>
</body>
</html>