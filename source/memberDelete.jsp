<!DOCTYPE HTML>
<html>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" >
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*, javax.sql.*, java.io.*, java.util.*, java.math.*, java.text.*" %>
<head>
<link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.3/css/bootstrap.min.css">
<script src="//code.jquery.com/jquery-3.2.1.slim.min.js"></script>
<script src="//cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"></script>
<script src="//maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.3/js/bootstrap.min.js"></script>
<script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
</head>
<body>
<%
request.setCharacterEncoding("utf-8");
String id = "";
id = request.getParameter("id");

try{
	Class.forName("com.mysql.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/iamhpd7","iamhpd7","ctc@kopo");
	ResultSet rset = null;
	String query = null;
	PreparedStatement pstm = null;
	
	// 외래키가 정해져있으므로 삭제 순서가 중요합니다.
	query = "delete from managingDB where _id=?";
	pstm = conn.prepareStatement(query);
	pstm.setString(1,id);
	pstm.execute();
		
	query = "delete from attendanceDB where _id=?";
	pstm = conn.prepareStatement(query);
	pstm.setString(1,id);
	pstm.execute();
	
	query = "delete from otpDB where _id=?";
	pstm = conn.prepareStatement(query);
	pstm.setString(1,id);
	pstm.execute();
	
	query = "delete from memberDB where _id=?";
	pstm = conn.prepareStatement(query);
	pstm.setString(1,id);
	pstm.execute();
	
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
	<h1 align=center>학번(<%=id%>)의 정보를 삭제했습니다.</h1>
	<center><button class='btn center-block btn-info' id="buttonToBack">돌아가기</button></center>
	<script>
	$(function(){
		$("#buttonToBack").click(function(){
			location.href = 'memberManage.jsp';
		});
	});
	</script>
</body>
</html>