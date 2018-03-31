<!DOCTYPE HTML>
<%@ page contentType="text/html; charset=utf-8" language="java" %>
<%@ page import="java.util.*, java.text.*" %>
<%@ page import="java.sql.*, javax.sql.*, java.net.*, java.io.*" %>
<% request.setCharacterEncoding("utf-8");%>
<html>
<head>
</head>
<body>
<center>
<%
	String jump = request.getParameter("jump");
	String id = request.getParameter("id");
	//특수문자 체크
	if(id!=null){
		id = id.replaceAll("'","&apos;");
	}
	String pass = request.getParameter("passwd");
	//특수문자 체크
	if(pass!=null){
		pass = pass.replaceAll("'","&apos;");
	}
	boolean bPassCk=false;	//기본값은 false

try{	
	Class.forName("com.mysql.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/KOPOCTC","root","alslf2gk");
	ResultSet rset = null;
	PreparedStatement pstm = null;
	String query = null;
	
	String admin_id = null;
	String admin_pw = null;
	int howmanytimes = 0;
	
	query = "select id, pass, hidden from admininfo where id=?;";
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
			query = "update admininfo set hidden = 0 where id=?;";
			pstm = conn.prepareStatement(query);
			pstm.setString(1, id);
			pstm.execute();
			
		}else{
			bPassCk=false;
			out.println("<center><br><br><br><br><br><br><br>로그인이 제한된 아이디입니다.</center>");
			out.println("<input type=button value='다시 로그인' onclick=\"location.href='login.jsp?jump="+jump+"'\">");
			rset.close();
			pstm.close();
			conn.close();
			return;
		}
	
	//아이디는 맞는데 비밀번호가 틀린 경우
	}else if( id.replaceAll(" ","").equals(admin_id) &&  !pass.replaceAll(" ","").equals(admin_pw)){
		bPassCk=false;
		query = "select hidden from admininfo where id=?;";
		pstm = conn.prepareStatement(query);
		pstm.setString(1, id);
		rset = pstm.executeQuery();		//데이터 저장
		
		while(rset.next()){
			howmanytimes = rset.getInt(1);
		}
		
		howmanytimes++;
		if(howmanytimes < 5){
			out.println("<center><br><br><br><br><br><br><br>비밀번호가 "+howmanytimes+"회 틀렸습니다.<br>5회 이상 잘못 입력하시면 아이디가 정지됩니다.</center>");
		}
		
		//아이디는 맞는데 비밀번호가 틀린 경우 hidden컬럼에 1을 추가해줍니다.
		query = "update admininfo set hidden=hidden+1 where id='"+admin_id+"';";
		pstm = conn.prepareStatement(query);
		pstm.execute();
	
	//아이디가 틀린경우
	}else if( !id.replaceAll(" ","").equals(admin_id)){
		bPassCk=false;
		out.println("<center><br><br><br><br><br><br><br>아이디가 틀렸습니다.</center>");
	}else{
		//아이디와 비밀번호 둘다 틀린 경우
		bPassCk=false;
		out.println("<center><br><br><br><br><br><br><br>아이디 또는 비밀번호가 틀렸습니다.</center>");
		query = "update admininfo set hidden=hidden+1 where id='"+admin_id+"';";
		pstm = conn.prepareStatement(query);
		pstm.execute();
	}
	
	//아이디와 비밀번호 체크가 끝나면 세션을 기록하고 점프합니다.
	if(bPassCk){
		session.setAttribute("login_ok",id);	//key값은 login_ok, 이에 해당하는 value는 yes
		response.sendRedirect(jump +"?id="+ id);	//로그인 체크 이후 돌아갈 곳
	}else{
		if(howmanytimes < 5){
			//out.println("<br><br><br><br><br><br><br><p>아이디 또는 패스워드 오류입니다.</p>");
			out.println("<input type=button value='다시 로그인' onclick=\"location.href='login.jsp?jump="+jump+"'\">");
		}else{
			out.println("<br><br><br><br><br><br><br>비밀번호를 5회 이상 잘못 입력하셨습니다.");
			out.println("해당 아이디의 로그인이 제한되었습니다.<br>");
			out.println("<input type=button value='다시 로그인' onclick=\"location.href='login.jsp?jump="+jump+"'\">");
		}
	}
	
	rset.close();
	pstm.close();
	conn.close();
	
}catch(SQLException e){
	out.println(e.toString());
}catch(Exception e){
	out.println(e.toString());
}
%>
</center>
</body>
</html>