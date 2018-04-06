<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*, javax.sql.*, java.io.*, java.util.Date, java.math.*, java.text.*" %>
<%@ page import="java.util.Timer" %>
<%@ page import="java.util.TimerTask" %>
<%@ page import="java.util.Date" %>
<%!
class CounterTimerTask extends java.util.TimerTask {

private int count = 1;
private String id = "";

public CounterTimerTask(String id) {
	this.id = id;
}

public void run() {
   if(count<2){
	   try{
		Class.forName("com.mysql.jdbc.Driver");
		Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/iamhpd7","iamhpd7","ctc@kopo");
		String query = null;
		PreparedStatement pstm = null;
		
		query = "update otpDB set otp=null where _id=?;";
		pstm = conn.prepareStatement(query);
		pstm.setString(1,id);
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
<%
request.setCharacterEncoding("utf-8");
String id = request.getParameter("user_id");
//특수문자 체크
if(id!=null){
	id = id.replaceAll("'","&apos;");
}
String pass = request.getParameter("user_pwd");
//특수문자 체크
if(pass!=null){
	pass = pass.replaceAll("'","&apos;");
}
boolean bPassCk=false;	//기본값은 false

try{
	Class.forName("com.mysql.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/iamhpd7","iamhpd7","ctc@kopo");
	ResultSet rset = null;
	String query = null;
	PreparedStatement pstm = null;
	
	//로그인 체크
	String admin_id = null;
	String admin_pw = null;
	int howmanytimes = 0;
	
	query = "select _id, password, hidden from memberDB where _id=?;";
	pstm = conn.prepareStatement(query);
	pstm.setString(1, id);
	rset = pstm.executeQuery();		//데이터 저장
	
	while(rset.next()){
		admin_id = rset.getString(1);
		admin_pw = rset.getString(2);
		howmanytimes = rset.getInt(3);
	}
	
	//아이디와 비밀번호가 모두 일치하면 true값을 대입
	if( id.replaceAll(" ","").equals(admin_id) && pass.replaceAll(" ","").equals(admin_pw)){
		
		if(howmanytimes<5){
			bPassCk=true;
			query = "update memberDB set hidden = 0 where _id=?;";
			pstm = conn.prepareStatement(query);
			pstm.setString(1, id);
			pstm.execute();
		}else{
			bPassCk=false;
			rset.close();
			pstm.close();
			conn.close();
			return;
		}
	
	//아이디는 맞는데 비밀번호가 틀린 경우
	}else if( id.replaceAll(" ","").equals(admin_id) &&  !pass.replaceAll(" ","").equals(admin_pw)){
		bPassCk=false;
		query = "select hidden from memberDB where _id=?;";
		pstm = conn.prepareStatement(query);
		pstm.setString(1, id);
		rset = pstm.executeQuery();		//데이터 저장
		
		while(rset.next()){
			howmanytimes = rset.getInt(1);
		}
		
		howmanytimes++;
		if(howmanytimes < 5){
			//out.println("비밀번호가 "+howmanytimes+"회 틀렸습니다.5회 이상 잘못 입력하시면 아이디가 정지됩니다.");
		}
		
		//아이디는 맞는데 비밀번호가 틀린 경우 hidden컬럼에 1을 추가해줍니다.
		query = "update memberDB set hidden=hidden+1 where _id='"+admin_id+"';";
		pstm = conn.prepareStatement(query);
		pstm.execute();
	
	//아이디가 틀린경우
	}else if( !id.replaceAll(" ","").equals(admin_id)){
		bPassCk=false;
		//out.println("아이디가 틀렸습니다.");
	}else{
		//아이디와 비밀번호 둘다 틀린 경우
		bPassCk=false;
		//out.println("아이디 또는 비밀번호가 틀렸습니다.");
		query = "update memberDB set hidden=hidden+1 where _id='"+admin_id+"';";
		pstm = conn.prepareStatement(query);
		pstm.execute();
	}
	
	//아이디와 비밀번호 체크가 끝나면 세션을 기록하고 점프합니다.
	if(bPassCk){
		session.setAttribute("login_ok",id);	//key값은 login_ok, 이에 해당하는 value는 id
		
		//로그인 성공했을 때 결과를 XML로 출력
		
		/* 랜덤값 생성 */
		int max = 999999999;
		int min = 0;
		int totalCount = 0;
		int status = 9;
		double random = 0.0;
		/* otp 데이터 생성 (1인 당 1개를 생성) */
		/* Math.random() 은 double 타입의 0.0 이상 1.0 미만의 랜덤한 숫자를 리턴한다. */
		/* 생성되는 otp는 항상 9자리로 만듭니다. */
		while(true){
			random = Math.random() * (max - min + 1);
			if((int)random>=100000000){
				break;
			}
		}
		
		int otpForId = (int) random;
		
		query = "update otpDB set otp=? where _id=?;";
		pstm = conn.prepareStatement(query);
		pstm.setInt(1, otpForId);
		pstm.setString(2, id);
		pstm.execute();	
		
		/* otp 유효시간을 체크한 뒤 그 시간 뒤에 otp를 삭제해 줍니다. */
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
		TimerTask task = new CounterTimerTask(id);
		m_timer.scheduleAtFixedRate(task, delay, intervalPeriod);
		
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
				pw.print("<otp_interval>");
				pw.print(otp_interval);
				pw.print("</otp_interval>");
			pw.print("</data>");
		pw.print("</datas>");
		
		rset.close();
		pstm.close();
		conn.close(); 
	
	}else{
		if(howmanytimes < 5){
			//out.println("아이디 또는 패스워드 오류입니다.");
		}else{
			//out.println("비밀번호를 5회 이상 잘못 입력하셨습니다.");
			//out.println("해당 아이디의 로그인이 제한되었습니다.");
		}
	}
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
