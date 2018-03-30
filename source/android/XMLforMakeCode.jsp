<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*, javax.sql.*, java.io.*, java.util.Date, java.math.*, java.text.*" %>
<%
request.setCharacterEncoding("utf-8");
String id = request.getParameter("user_id");
//특수문자 체크
if(id!=null){
	id = id.replaceAll("'","&apos;");
}

//try{
	Class.forName("com.mysql.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/KOPOCTC","root","alslf2gk");
	ResultSet rset = null;
	String query = null;
	PreparedStatement pstm = null;
	
	/* 랜덤값 생성 */
	int max = 999999999;
	int min = 0;
	int totalCount = 0;
	int status = 9;
	
	/* otp 데이터 생성 (1인 당 1개를 생성) */
	/* Math.random() 은 double 타입의 0.0 이상 1.0 미만의 랜덤한 숫자를 리턴한다. */
	double random = Math.random() * (max - min + 1);
	int otpForId = (int) random;
	
	query = "update otpDB set otp=? where _id=?;";
	pstm = conn.prepareStatement(query);
	pstm.setInt(1, otpForId);
	pstm.setString(2, id);
	pstm.execute();	
	
	String name = "";
	String dept = "";
	String otp = "";
	
	/* id에 해당하는 otp READ */
	query = "select B.name,B.dept,A.otp from memberDB B, otpDB A where A._id=? and B._id=?;";
	pstm = conn.prepareStatement(query);
	pstm.setString(1, id);
	pstm.setString(2, id);
	rset = pstm.executeQuery();
	
	while(rset.next()){
		name = rset.getString(1);
		dept = rset.getString(2);
		otp = rset.getString(3);
	}
	
	//xml 방식으로 값 보내기
	response.setContentType("text/xml;charset=utf-8");
	PrintWriter pw = response.getWriter();
	pw.print("<?xml version='1.0' encoding='UTF-8' ?>");
	pw.print("<datas>");
		pw.print("<data>");
			pw.print("<name>");
			pw.print(name);
			pw.print("</name>");
			pw.print("<dept>");
			pw.print(dept);
			pw.print("</dept>");
			pw.print("<otp>");
			pw.print(otp);
			pw.print("</otp>");
		pw.print("</data>");
	pw.print("</datas>");
	
	rset.close();
	pstm.close();
	conn.close(); 
/*}catch(SQLException e){
	if(e.getMessage().contains("Duplicate")){
		out.println(e.toString());
	} else {
		out.println(e.toString());
	}
}catch(Exception e){
	out.println(e.toString());
}*/
%>
