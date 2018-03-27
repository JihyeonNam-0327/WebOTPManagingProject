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
	int id = Integer.parseInt(_id);
	
	/* 랜덤값 생성 */
	int max = 999999999;
	int min = 0;
	int totalCount = 0;
	int status = 9;
	
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
QR코드 : <%=qrcode%><br>
<%
	Date today = new Date();
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String curDate = sdf.format(today);
	sdf = new SimpleDateFormat("HH:mm:ss");
	String curTime = sdf.format(today);
	String attd = "";
	String attd_interval = "";
	String leave_ = "";
	String leave_interval = "";
	query = "select attd,attd_interval,leave_,leave_interval from sysMaster;";
	pstm = conn.prepareStatement(query);
	rset = pstm.executeQuery();
	while(rset.next()){
		attd = rset.getString(1);
		attd_interval = rset.getString(2);
		leave_ = rset.getString(3);
		leave_interval = rset.getString(4);
	}
	int attdTime = Integer.parseInt(attd.replaceAll(":",""));
	int attd_intervalTime = Integer.parseInt(attd_interval.replaceAll(":",""));
	int leave_Time = Integer.parseInt(leave_.replaceAll(":",""));
	int leave_intervalTime = Integer.parseInt(leave_interval.replaceAll(":",""));
	int currentTime = Integer.parseInt(curTime.replaceAll(":",""));
	/* status 상태에 따라 다르게 입력
       0: 입실, 1: 지각, 2: 조퇴, 3: 퇴실, 4:결석, 5:출석, 9: 체크되기 이전 상태 
	   여기에서는 0 또는 3 을 선택하여 입력 */
	// 상태가 9일 때에만 값을 변경할 수 있다.
	if(currentTime >= attdTime && 
	   currentTime <= (attdTime+attd_intervalTime)){
		query = "update managingDB set date=?,time_in=?,status=? "
	      + "where _id=? and status=9;";
		pstm = conn.prepareStatement(query);
		pstm.setString(1, curDate);
		pstm.setString(2, curTime);
		status = 0;				// 입실 완료
		pstm.setInt(3, status);
		pstm.setInt(4, id);
		pstm.execute();
		out.println("<br>정상적으로 출석 체크되었습니다.");
	}
	if(currentTime >= leave_Time &&
	         currentTime <= (leave_Time+leave_intervalTime)){
		query = "update managingDB set date=?,time_out=?,status=? "
	      + "where _id=? and (status=0 or status=9);";
		pstm = conn.prepareStatement(query);
		pstm.setString(1, curDate);
		pstm.setString(2, curTime);
		status = 3;				// 퇴실 완료
		pstm.setInt(3, status);
		pstm.setInt(4, id);
		pstm.execute();
		out.println("<br>정상적으로 퇴실 체크되었습니다.");
	}
	
	// 인정받지 못하는 시간에는 아예 데이터에 변화를 주지 않음.
	/*if(currentTime < attdTime || 
	   (currentTime > (attdTime+attd_intervalTime) && currentTime < leave_Time) ||
	    currentTime > (leave_Time+leave_intervalTime)){
		query = "update managingDB set date=?,status=? "
			  + "where _id=? and status!=5 and status!=4 and status!=2 and status!=1 and;";
		pstm = conn.prepareStatement(query);
		pstm.setString(1, curDate);
		status = 9;				
		pstm.setInt(2, status);
		pstm.setInt(3, id);
		pstm.execute();
	}*/
	
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