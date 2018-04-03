<html>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" >
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*, javax.sql.*, java.io.*,java.util.*, java.math.*, java.text.*" %>
<% request.setCharacterEncoding("utf-8");%>
<%@ page import="java.util.Timer" %>
<%@ page import="java.util.TimerTask" %>
<%@ page import="java.util.Date" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<head>
<!-- 합쳐지고 최소화된 최신 CSS -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">
<!-- 부가적인 테마 -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap-theme.min.css">
<script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
<!-- 합쳐지고 최소화된 최신 자바스크립트 -->
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>
</head>
<%!
class CounterTimerTask extends java.util.TimerTask {

	private int count = 1;
	
	public CounterTimerTask() {}
	
	public void run() {
	if(count<2){
	   try{
		Class.forName("com.mysql.jdbc.Driver");
		Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/iamhpd7","iamhpd7","ctc@kopo");
		String query = null;
		PreparedStatement pstm = null;
		
		query = "update otpDB set otp=null where otp is not null;";
		pstm = conn.prepareStatement(query);
		pstm.execute();
		
		pstm.close();
		conn.close(); 
		}catch(SQLException e){
			return;
		}catch(Exception e){
			return;
		}
		
		count++;
	}else{
	   cancel();
	}
	}
}
%>
<body>
<%
try{
	Class.forName("com.mysql.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/iamhpd7","iamhpd7","ctc@kopo");
	ResultSet rset = null;
	String query = null;
	PreparedStatement pstm = null;
	
	/* index  */
	int size = 0;
	query = "select count(_id) from otpDB;";
	pstm = conn.prepareStatement(query);
	rset = pstm.executeQuery();
	while(rset.next()){
		size = rset.getInt(1);
	}
	
	/* 현재 otpDB에 있는 _id의 상황을 배열에 저장 */
	int[] idArray = new int[size];
	int index = 0;
	query = "select _id from otpDB;";
	pstm = conn.prepareStatement(query);
	rset = pstm.executeQuery();
	while(rset.next()){
		idArray[index] = rset.getInt(1);
		index++;
	}
	
	int max = 999999999;
	int min = 0;
	
	/* otp 데이터 바로 생성 */
	for(int i = 0; i<size; i++){
		/* Math.random() 은 double 타입의 0.0 이상 1.0 미만의 랜덤한 숫자를 리턴한다. */
		double random = Math.random() * (max - min + 1);
		int otpForId = (int) random;
		
		query = "update otpDB set otp=?"
				 + " where _id=?;";
		pstm = conn.prepareStatement(query);
		pstm.setInt(1, otpForId);
		pstm.setInt(2, idArray[i]);
		pstm.execute();	
	}
	
	String otp_interval = "";
	query = "select otp_interval from sysMaster;";
	pstm = conn.prepareStatement(query);
	rset = pstm.executeQuery();
	while(rset.next()){
		otp_interval = rset.getString(1);
	}
	//분 단위로 변환
	otp_interval = otp_interval.replaceAll(":","");
	otp_interval = otp_interval.substring(0,4);
	int otp_time = Integer.parseInt(otp_interval);
	//long 타입으로 변환
	long delay = Long.valueOf(otp_time);
	delay = delay * 60 * 1000;
	
	long intervalPeriod = 1 * 1000;
	
	Timer m_timer = new Timer();
	TimerTask task = new CounterTimerTask();
	m_timer.scheduleAtFixedRate(task, delay, intervalPeriod);
	
	rset.close();
	pstm.close();
	conn.close(); 
	
	out.println("OTP를 생성했습니다.");
	
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
<button class='btn center-block btn-info' id="buttonToBack">돌아가기</button>
<script>
$(function(){
	$("#buttonToBack").click(function(){
		location.href = 'setting.jsp';
	});
});
</script>
</body>
</html>