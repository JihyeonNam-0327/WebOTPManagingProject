<meta http-equiv="Content-Type" content="text/html; charset=utf-8" >
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*, javax.sql.*, java.io.*, java.util.Date, java.math.*, java.text.*" %>
<%
request.setCharacterEncoding("utf-8");
String _id = request.getParameter("_id");
if(_id==null){
	_id = "2018231001";
}
%>
<html>
<head>
</head>
<body>
학번 : <%=_id%><br>
<%
try{
	Class.forName("com.mysql.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/KOPOCTC","root","alslf2gk");
	ResultSet rset = null;
	String query = null;
	PreparedStatement pstm = null;
	
	/* 랜덤값 생성 */
	int max = 999999999;
	int min = 0;
	/* 향후 select count(_id) from otpDB 값으로 대체  */
	int totalCount = 10;
	int cnt = 0;
	int id = Integer.parseInt(_id);
	
	/* otp 데이터 바로 생성 */
	while(cnt<totalCount){
		/* Math.random() 은 double 타입의 0.0 이상 1.0 미만의 랜덤한 숫자를 리턴한다. */
		double random = Math.random() * (max - min + 1);
		int otpForId = (int) random;
		
		query = "update otpDB set otp=?"
				 + " where _id=?;";
		pstm = conn.prepareStatement(query);
		pstm.setInt(1, otpForId);
		pstm.setInt(2, id);
		pstm.execute();	
		
		cnt++;
		id++; // id: 001 ~ 010 
	}
	
	id = Integer.parseInt(_id);
	
	query = "select otp from otpDB where _id=?";
	pstm = conn.prepareStatement(query);
	pstm.setInt(1, id);
	rset = pstm.executeQuery();
	
	int qrcode = 0;
	while(rset.next()){
		qrcode = rset.getInt(1);
	}
%>
QR코드 : <%=qrcode%><br>
<%
	Date today = new Date();
	SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
	String curDate = date.format(today);
	date = new SimpleDateFormat("hh:mm:ss");
	String curTime = date.format(today);
	query = "update managingDB set date=?,time_in=?,status=? "
	      + "where _id=?;";

	pstm = conn.prepareStatement(query);
	pstm.setString(1, curDate);
	pstm.setString(2, curTime);
	pstm.setInt(3, 0);
	pstm.setInt(4, id);
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
정상적으로 출석 체크되었습니다.
</body>
</html>