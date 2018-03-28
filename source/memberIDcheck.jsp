<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*, javax.sql.*, java.io.*, java.util.Date, java.math.*, java.text.*" %>
<%
request.setCharacterEncoding("utf-8");
String _id = request.getParameter("id");
String re = "0";

try{
	Class.forName("com.mysql.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/KOPOCTC","root","alslf2gk");
	ResultSet rset = null;
	String query = null;
	PreparedStatement pstm = null;
	int id = 0;
	if(_id != null){
		id = Integer.parseInt(_id);
	}
		
	query = "select * from memberDB"
			 + " where _id=?;";
	pstm = conn.prepareStatement(query);
	pstm.setInt(1, id);
	rset = pstm.executeQuery();
	if(rset.next()){
		re = "1";
	}
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

response.setContentType("text/xml;charset=utf-8");
PrintWriter pw = response.getWriter();
pw.print("<?xml version='1.0' encoding='UTF-8' ?>");
pw.print("<data>");
pw.print("<result>");
pw.print(re);
pw.print("</result>");
pw.print("</data>");
%>
