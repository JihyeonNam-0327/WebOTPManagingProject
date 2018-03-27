<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*, javax.sql.*, java.io.*, java.util.Date, java.math.*, java.text.*" %>
<%@ page import = "java.util.List" %>
<%
request.setCharacterEncoding("utf-8");
String name = request.getParameter("name");
String _id = request.getParameter("_id");
String pwd = request.getParameter("pwd");
String phone = request.getParameter("phone");
String email = request.getParameter("email");

/* memberDB 에 넣고 동시에 otpDB에 넣을 것 */

try{
	Class.forName("com.mysql.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/KOPOCTC","root","alslf2gk");
	ResultSet rset = null;
	String query = null;
	PreparedStatement pstm = null;
	
	query = "insert into memberDB"
			 + " value(?,?,?,?,?,0);";
	pstm = conn.prepareStatement(query);
	pstm.setString(1, name);
	pstm.setString(2, _id);
	pstm.setString(3, pwd);
	pstm.setString(4, phone);
	pstm.setString(5, email);
	pstm.execute();
	
	out.println(name);
	out.println(_id);
	out.println(pwd);
	out.println(phone);
	out.println(email);
	
	out.println("<h1>학생 "+name+"의 학번("+_id+")을 등록했습니다.</h1>");
	out.println("<button class='btn center-block' value='메인으로'></button>");
	
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
