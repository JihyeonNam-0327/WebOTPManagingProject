<!DOCTYPE HTML>
<html>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" >
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*, javax.sql.*, java.io.*, java.util.*, java.math.*, java.text.*" %>
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
request.setCharacterEncoding("utf-8");
String id = "";
id = request.getParameter("id");

try{
	Class.forName("com.mysql.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/iamhpd7","iamhpd7","ctc@kopo");
	ResultSet rset = null;
	String query = null;
	PreparedStatement pstm = null;
	
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
	<h1>학번(<%=id%>)의 정보를 삭제했습니다.</h1>
	<button class='btn center-block btn-info' id="buttonToBack">돌아가기</button>
	<script>
	$(function(){
		$("#buttonToBack").click(function(){
			location.href = 'memberManage.jsp';
		});
	});
	</script>
</body>
</html>