<!DOCTYPE HTML>
<html>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" >
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*, javax.sql.*, java.io.*, java.util.Date, java.math.*, java.text.*" %>

<head>
</head>
<body>
<%
Date today = new Date();
SimpleDateFormat sdf = new SimpleDateFormat("M월 d일");
String curDate = sdf.format(today);
sdf = new SimpleDateFormat("yyyy-MM-dd");
String compareTime = sdf.format(today);
%>
<b><%=curDate%> 입/퇴실 List</b>
<br>
<!-- TODO : today 날짜 출력되도록 할 것 -->
<!-- today 의 모든 학번에 해당하는 출결 상태를 표시할 것 -->
<br>
<form method="post">
<table border=1 cellspacing=0>
	<tr>
		<td>학번</td>
		<td>입실 시간</td>
		<td>퇴실 시간</td>
		<td>상태</td>
	</tr>
<%
int id = 0;
String time_in = "";
String time_out = "";
int status = 0;
String resultStatus = "";

//try{
	Class.forName("com.mysql.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/KOPOCTC","root","alslf2gk");
	ResultSet rset = null;
	String query = null;
	PreparedStatement pstm = null;	
	/* status 상태 보여주기 전에 먼저 퇴실 유효시간이 만료되었는지 확인 */
	/* 현재 시간을 구함 */
	sdf = new SimpleDateFormat("HHmmss");
	String curTime = sdf.format(today);
	/* 퇴실 시간과 유효 시간을 구함 */
	String leave_ = "";
	String leave_interval = "";
	query = "select leave_, leave_interval from sysMaster;";
	pstm = conn.prepareStatement(query);
	rset = pstm.executeQuery();
	while(rset.next()){
		leave_ = rset.getString(1);
		leave_interval = rset.getString(2);
	}
	leave_ = leave_.replaceAll(":","");
	leave_interval = leave_interval.replaceAll(":","");
	
	int current = Integer.parseInt(curTime);
	int endTime = 0;
	if(!"".equals(leave_)){
		endTime = Integer.parseInt(leave_);
	}
	int interval = 0;
	if(!"".equals(leave_interval)){
		interval = Integer.parseInt(leave_interval);
	}
	
	if("".equals(leave_)||"".equals(leave_interval)){
		out.println("먼저 입/퇴실 시간과 otp 유효시간을 설정해 주세요.");
	}else{
		int diff = current - (endTime + interval) ;
		/* 현재 시간이 (퇴실 시간 + 유효 시간) 보다 클 경우(퇴실 유효시간이 만료된 경우) */
		if(diff > 0){
			/* 1. QR코드를 폐기한다. */
			query = "update otpDB set otp = NULL where otp is not null;";
			pstm = conn.prepareStatement(query);
			pstm.execute();
			
			/* 2. in_time 과 out_time 의 상태를 비교하여 status 를 체크한다. */
			String first_check = "";	// time_in
			String second_check = "";	// time_out
			status = 9;
			for(int i = 2018231001; i < 2018231011; i++){
				query = "select time_in, time_out from managingDB where _id=? and date_format(date,'%Y-%m-%d')=?;";
				pstm = conn.prepareStatement(query);
				pstm.setInt(1, i);
				pstm.setString(2, compareTime);
				rset = pstm.executeQuery();
				while(rset.next()){
					first_check = rset.getString(1);
					second_check = rset.getString(2);
				}
				if(first_check == null && second_check == null){
					status = 4;		// 4 : 결석
				}else if(first_check != null && second_check == null){
					status = 2;		// 2 : 조퇴
				}else if(first_check == null && second_check != null){
					status = 1;		// 1 : 지각
				}else if(first_check != null && second_check != null){
					status = 5; 	// 5 : 출석(입/퇴실 모두 정상 체크되어있는 경우)
				}
				query = "update managingDB set status=? where _id=? and date_format(date,'%Y-%m-%d')=?;";
				pstm = conn.prepareStatement(query);
				pstm.setInt(1, status);
				pstm.setInt(2, i);
				pstm.setString(3,compareTime);
				pstm.execute();
			}
		}
	}
	
	query = "select * from managingDB where date_format(date,'%Y-%m-%d')=? order by _id";
	pstm = conn.prepareStatement(query);
	pstm.setString(1, compareTime);
	rset = pstm.executeQuery();
	if(!rset.next()){
		for(int i = 2018231001; i < 2018231011; i++){
			query = "insert into managingDB (_id,status)"
					 + "values(?,?);";
			pstm = conn.prepareStatement(query);
			pstm.setInt(1, i);
			pstm.setInt(2, 9);
			pstm.execute();			/* status 0: 입실완료, 1: 지각, 2: 조퇴, 3: 퇴실완료, 4:결석 9: 체크되기 이전 상태 */
		}
	}
	query = "select _id,time_in,time_out,status from managingDB where date_format(date,'%Y-%m-%d')=? order by _id";
	pstm = conn.prepareStatement(query);
	pstm.setString(1, compareTime);
	rset = pstm.executeQuery();
	while(rset.next()){
		id = rset.getInt(1);
		time_in = rset.getString(2);
		time_out = rset.getString(3);
		status = rset.getInt(4);
		if(time_in == null){
			time_in = "-";
		}
		if(time_out == null){
			time_out = "-";
		}
		switch(status){
			 case 0 : resultStatus = "입실 완료";
					  break;
			 case 1 : resultStatus = "지각";
					  break;
			 case 2 : resultStatus = "조퇴";
					  break;
			 case 3 : resultStatus = "퇴실 완료";
					  break;
			 case 4 : resultStatus = "결석";
					  break;
			 case 5 : resultStatus = "출석";
					  break;
			 case 9 : resultStatus = "체크 안 됨";
					  break;
		}
%>
	<tr>
		<td><%=id%></td>
		<td><%=time_in%></td>
		<td><%=time_out%></td>
		<td><%=resultStatus%></td>
	</tr>
<%
	}
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
</table>
</form>
</body>
</html>

