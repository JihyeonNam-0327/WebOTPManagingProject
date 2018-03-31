<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*, javax.sql.*, java.io.*, java.util.Date, java.math.*, java.text.*" %>
<%
request.setCharacterEncoding("utf-8");
String id = request.getParameter("user_id");

//out.println(":::::::: 문서시작 :::::::::::");
//out.println("아이디랍시고 받은 값 : " + id);
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
//out.println("비밀번호랍시고 받은 값 : " + pass);

try{	
	Class.forName("com.mysql.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/KOPOCTC","root","alslf2gk");
	ResultSet rset = null;
	PreparedStatement pstm = null;
	String query = null;
	
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
		//out.println(id+",");
		//out.println(pass+",");
		//out.println("성공");
		
		//로그인 성공했을 시 XML 로 DB 내용 출력
		int size = 0;
		query = "select count(_id) from memberDB;";
		pstm = conn.prepareStatement(query);
		rset = pstm.executeQuery();
		while(rset.next()){
			size = rset.getInt(1);
		}
		
		String[] id_managing = new String[size];
		String[] time_in = new String[size];
		String[] time_out = new String[size];
		String[] status = new String[size];
		
		//일일 입/퇴실 현황 확인
		query = "select _id,time_in,time_out,status from managingDB;";
		pstm = conn.prepareStatement(query);
		rset = pstm.executeQuery();
		int i = 0;
		while(rset.next()){
			id_managing[i] = rset.getString(1);
			time_in[i] = rset.getString(2);
			time_out[i] = rset.getString(3);
			status[i] = rset.getString(4);
			i++;
		}

		//xml 방식으로 값 보내기
		response.setContentType("text/xml;charset=utf-8");
		PrintWriter pw = response.getWriter();
		pw.print("<?xml version='1.0' encoding='UTF-8' ?>");
		pw.print("<datas>");
		for(int j = 0; j < size; j++){
			pw.print("<data>");
			pw.print("<id>");
			pw.print(id_managing[j]);
			pw.print("</id>");
			pw.print("<time_in>");
			pw.print(time_in[j]);
			pw.print("</time_in>");
			pw.print("<time_out>");
			pw.print(time_out[j]);
			pw.print("</time_out>");
			pw.print("<status>");
			pw.print(status[j]);
			pw.print("</status>");
			pw.print("</data>");
		}
		pw.print("</datas>");
				
	}else{
		if(howmanytimes < 5){
			//out.println("아이디 또는 패스워드 오류입니다.");
			
		}else{
			//out.println("비밀번호를 5회 이상 잘못 입력하셨습니다.");
			//out.println("해당 아이디의 로그인이 제한되었습니다.");
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
