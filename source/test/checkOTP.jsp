<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*, javax.sql.*, java.io.*, java.util.Date, java.math.*, java.text.*" %>
<%
request.setCharacterEncoding("utf-8");
String _id = request.getParameter("id");
String code = request.getParameter("code");
if(_id==null){
	_id = "2018231001";
}
int re = 0;
int status = 9;

try{
	Class.forName("com.mysql.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/KOPOCTC","root","alslf2gk");
	ResultSet rset = null;
	String query = null;
	PreparedStatement pstm = null;
	
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
	
	int id = Integer.parseInt(_id);
	int otpCode = Integer.parseInt(code);
	int otpCodeFromDB = 0;
	
	query = "select otp from otpDB where _id = ?";
	pstm = conn.prepareStatement(query);
	pstm.setInt(1,id);
	rset = pstm.executeQuery();
	while(rset.next()){
		otpCodeFromDB = rset.getInt(1);
	}
	
	// 인증 학번과 코드가 같을 때,
	if(otpCode == otpCodeFromDB){
		// 상태가 9일 때에만 값을 변경할 수 있다.
		if(currentTime >= attdTime && 
		   currentTime <= (attdTime+attd_intervalTime)){
			query = "update managingDB set date=?,time_in=?,status=? "
			  + "where _id=?;";
			pstm = conn.prepareStatement(query);
			pstm.setString(1, curDate);
			pstm.setString(2, curTime);
			status = 0;				// 입실 완료
			pstm.setInt(3, status);
			pstm.setInt(4, id);
			pstm.execute();
			re = 1;
		}
		if(currentTime >= leave_Time &&
				 currentTime <= (leave_Time+leave_intervalTime)){
			query = "update managingDB set date=?,time_out=?,status=? "
			  + "where _id=?;";
			pstm = conn.prepareStatement(query);
			pstm.setString(1, curDate);
			pstm.setString(2, curTime);
			status = 3;				// 퇴실 완료
			pstm.setInt(3, status);
			pstm.setInt(4, id);
			pstm.execute();
			re = 2;
		}
		
	}else{
		out.println("코드가 일치하지 않습니다. QR코드를 다시 발급받아 주세요.");
	}
	
	//xml 방식으로 값 보내기
	response.setContentType("text/xml;charset=utf-8");
	PrintWriter pw = response.getWriter();
	pw.print("<?xml version='1.0' encoding='UTF-8' ?>");
	pw.print("<data>");
	pw.print("<result>");
	pw.print(re);
	pw.print("</result>");
	pw.print("</data>");
	
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
