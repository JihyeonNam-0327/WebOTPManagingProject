<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*, javax.sql.*, java.io.*, java.util.Date, java.math.*, java.text.*" %>
<%
request.setCharacterEncoding("utf-8");
String _id = request.getParameter("_id");
if(_id==null){
	_id = "2018231001";
}

try{
	Class.forName("com.mysql.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/KOPOCTC","root","alslf2gk");
	ResultSet rset = null;
	String query = null;
	PreparedStatement pstm = null;
	int id = Integer.parseInt(_id);
	
	/* 랜덤값 생성 */
	int max = 999999999;
	int min = 0;
	int totalCount = 0;
	int status = 9;
	
	query = "select * from memberDB where _id=?";
	pstm = conn.prepareStatement(query);
	pstm.setInt(1, id);
	rset = pstm.executeQuery();
	if(!rset.next()){
		out.println("해당 아이디가 존재하지 않습니다.");
		return;
	}
	
	/* otp 데이터 생성 (1인 당 1개를 생성) */
	/* Math.random() 은 double 타입의 0.0 이상 1.0 미만의 랜덤한 숫자를 리턴한다. */
	double random = Math.random() * (max - min + 1);
	int otpForId = (int) random;
	query = "update otpDB set otp=?"
			 + " where _id=?;";
	pstm = conn.prepareStatement(query);
	pstm.setInt(1, otpForId);
	pstm.setInt(2, id);
	pstm.execute();	
	
	/* id에 해당하는 otp READ */
	query = "select otp from otpDB where _id=?";
	pstm = conn.prepareStatement(query);
	pstm.setInt(1, id);
	rset = pstm.executeQuery();
	int qrcode = 0;
	while(rset.next()){
		qrcode = rset.getInt(1);
	}
%>
<%=qrcode%>
<%
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