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
<h3>학생 정보</h3>

<%
String _id = "";
String dept = "";
String name = "";

try{
	Class.forName("com.mysql.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/KOPOCTC","root","alslf2gk");
	ResultSet rset = null;
	ResultSet rset2 = null;
	String query = null;
	PreparedStatement pstm = null;
	
	query = "select * from memberDB;";
	pstm = pstm = conn.prepareStatement(query);
	rset2 = pstm.executeQuery();
	if(!rset2.next()){
		out.println("학생 정보가 없습니다. 아래 버튼을 눌러 학생을 등록해 주세요.");
	}else{
	%>
		<table border=1 cellspacing=0>
		<tr>
			<th>학번</th><th>학과</th><th>이름</th><th>관리</th>
		</tr>	
	<%
		query = "select _id, dept, name from memberDB";
		pstm = conn.prepareStatement(query);
		rset = pstm.executeQuery();
		
		while(rset.next()){
			_id = rset.getString(1);
			dept = rset.getString(2);
			name = rset.getString(3);
			out.println("<tr>");
			out.println("<td>"+_id+"</td>");
			out.println("<td>"+dept+"</td>");
			out.println("<td>"+name+"</td>");
			out.println("<td>");
			out.println("<input type='button' class='btn btn-info' value='삭제' onclick='buttonToDel("+_id+")'/></td>");	
			out.println("</tr>");
		}
		rset.close();
	}
	
	rset2.close();
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
</table>
<button class='btn center-block btn-info' id="buttonToRegi">추가 등록</button>
<script>
$(function(){
	$("#buttonToRegi").click(function(){
		location.href = 'memberRegistration.jsp';
	});
});

function buttonToDel(id){
	location.href = "memberDelete.jsp?id="+id;
}
</script>
</body>
</html>