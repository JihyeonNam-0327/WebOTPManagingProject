<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*, javax.sql.*, java.io.*, java.util.Date, java.math.*, java.text.*" %>
<%
request.setCharacterEncoding("utf-8");
String code = request.getParameter("code");

int re = 3;	/* 상태 0: 에러, 1:입실, 2:퇴실, 3:default */
int status = 9;
String name = "";
String dept = "";
String _id = "";

try{
	Class.forName("com.mysql.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/iamhpd7","iamhpd7","ctc@kopo");
	ResultSet rset = null;
	String query = null;
	PreparedStatement pstm = null;
		
	//sysMaster 테이블에서 출결 체크 시간이 언제인지 확인합니다.
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
	//숫자 형태로 변환
	int attdTime = Integer.parseInt(attd.replaceAll(":",""));
	int attd_intervalTime = Integer.parseInt(attd_interval.replaceAll(":",""));
	int leave_Time = Integer.parseInt(leave_.replaceAll(":",""));
	int leave_intervalTime = Integer.parseInt(leave_interval.replaceAll(":",""));
	int currentTime = Integer.parseInt(curTime.replaceAll(":",""));
	/* status 상태에 따라 다르게 입력
       0: 입실, 1: 지각, 2: 조퇴, 3: 퇴실, 4:결석, 5:출석, 9: 체크되기 이전 상태 
	   여기에서는 0 또는 3 을 선택하여 입력 */
	
	query = "select _id from otpDB where otp=?";
	pstm = conn.prepareStatement(query);
	pstm.setString(1,code);
	rset = pstm.executeQuery();
	if(!rset.next()){
		//해당 otp 는 유효하지 않습니다.
		re = 0;
		//out.println("아이디가 없음.");
	}else{
		//해당 otp가 존재할 때
		_id = rset.getString(1);
	}
	
	if(_id != null){
		int id = Integer.parseInt(_id);
	
		if(code != null){
			// managingDB의 상태 변경 -> 입실 완료
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
				re = 1; //입실
			}
			// managingDB의 상태 변경 -> 퇴실 완료
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
				re = 2; //퇴실
			}
		}else{
			re = 0;	//에러
			out.println("otp가 유효하지 않습니다. QR코드를 다시 발급받아 주세요.");
		}
		
		query = "select name, dept from memberDB where _id=?;";
		pstm = conn.prepareStatement(query);
		pstm.setString(1,_id);
		rset = pstm.executeQuery();
		while(rset.next()){
			name = rset.getString(1);
			dept = rset.getString(2);
		}

		//xml 방식으로 값 보내기
		response.setContentType("text/xml;charset=utf-8");
		PrintWriter pw = response.getWriter();
		pw.print("<?xml version='1.0' encoding='UTF-8' ?>");
		pw.print("<data>");
		pw.print("<result>");
		pw.print(re);
		pw.print("</result>");
		pw.print("<name>");
		pw.print(name);
		pw.print("</name>");
		pw.print("<dept>");
		pw.print(dept);
		pw.print("</dept>");
		pw.print("<studentid>");
		pw.print(_id);
		pw.print("</studentid>");
		pw.print("<date>");
		pw.print(curDate);
		pw.print("</date>");
		pw.print("</data>");	
	}
	
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
