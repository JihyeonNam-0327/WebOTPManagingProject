<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*, javax.sql.*, java.io.*, java.util.Date, java.math.*, java.text.*" %>
<%
try{
	Class.forName("com.mysql.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/KOPOCTC","root","alslf2gk");
	ResultSet rset = null;
	String query = null;
	PreparedStatement pstm = null;
	int size = 0;
	query = "select count(_id) from memberDB;";
	pstm = conn.prepareStatement(query);
	rset = pstm.executeQuery();
	while(rset.next()){
		size = rset.getInt(1);
	}
	
	String[] id = new String[size];
	String[] name = new String[size];
	String[] password = new String[size];
	String[] dept = new String[size];
	
	query = "select _id,name,password,dept from memberDB;";
	pstm = conn.prepareStatement(query);
	rset = pstm.executeQuery();
	int i = 0;
	while(rset.next()){
		id[i] = rset.getString(1);
		name[i] = rset.getString(2);
		password[i] = rset.getString(3);
		dept[i] = rset.getString(4);
		i++;
	}
		
	//xml 방식으로 값 보내기
	response.setContentType("text/xml;charset=utf-8");
	PrintWriter pw = response.getWriter();
	pw.print("<?xml version='1.0' encoding='UTF-8' ?>");
	pw.print("<datas>");
	for(int j = 0; j < size; j++){
		pw.print("<data>");
		pw.print("<id>");
		pw.print(id[j]);
		pw.print("</id>");
		pw.print("<name>");
		pw.print(name[j]);
		pw.print("</name>");
		pw.print("<password>");
		pw.print(password[j]);
		pw.print("</password>");
		pw.print("<dept>");
		pw.print(dept[j]);
		pw.print("</dept>");
		pw.print("</data>");
	}
	pw.print("</datas>");
	
	rset.close();
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
