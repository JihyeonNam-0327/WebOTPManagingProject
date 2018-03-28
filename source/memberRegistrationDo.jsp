<!DOCTYPE html>
<html>
<head>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*, javax.sql.*, java.io.*, java.util.Date, java.math.*, java.text.*" %>
<%@ page import = "java.util.List" %>
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
String dept = request.getParameter("dept");
String name = request.getParameter("name");
String _id = request.getParameter("_id");
String pwd = request.getParameter("password");
String phone = request.getParameter("phone");
String email = request.getParameter("email");


/* memberDB 에 넣고 동시에 otpDB에도 넣을 것 */

dept = dept.substring(7);

try{
	Class.forName("com.mysql.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/KOPOCTC","root","alslf2gk");
	ResultSet rset = null;
	String query = null;
	PreparedStatement pstm = null;
	
	query = "insert into memberDB(dept,name,_id,password,phone,email,hidden)"
			 + " value(?,?,?,?,?,?,0);";
	pstm = conn.prepareStatement(query);
	pstm.setString(1, dept);
	pstm.setString(2, name);
	pstm.setString(3, _id);
	pstm.setString(4, pwd);
	pstm.setString(5, phone);
	pstm.setString(6, email);
	pstm.execute();
	%>
	<h1><%=name%>의 학번(<%=_id%>)과 정보를 등록했습니다.</h1>
	<button class='btn center-block btn-info' id="buttonToBack">돌아가기</button>
	<script>
	$(function(){
		$("#buttonToBack").click(function(){
			location.href = 'memberManage.jsp';
		});
	});
	</script>
	<%
	query = "insert into otpDB(_id)"
			 + " value(?);";
	pstm = conn.prepareStatement(query);
	pstm.setString(1,_id);
	pstm.execute();
	
	query = "insert into managingDB(_id)"
			 + " value(?);";
	pstm = conn.prepareStatement(query);
	pstm.setString(1,_id);
	pstm.execute();				/* status 0: 입실완료, 1: 지각, 2: 조퇴, 3: 퇴실완료, 4:결석 9: 체크되기 이전 상태 */
	
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
</body>
</html>
