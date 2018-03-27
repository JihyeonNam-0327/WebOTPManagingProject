<!DOCTYPE HTML>
<html>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" >
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*, javax.sql.*, java.io.*, java.util.*, java.math.*, java.text.*" %>
<%@ page import="org.quartz.*"%>
<head>
<%
try{
	Class.forName("com.mysql.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/KOPOCTC","root","alslf2gk");
	String query = null;
	PreparedStatement pstm = null;
	
	/* table이 존재한다면 삭제한 뒤 다시 생성한다. */
	query = "drop table if exists sysMaster;";
	pstm = conn.prepareStatement(query);
	pstm.execute();		// sysMaster 테이블을 새로 생성하기 위해 기존에 테이블이 있었다면 삭제
	
	query =  "create table sysMaster("
		   + "attd TIME,"
		   + "attd_interval TIME,"
           + "leave_ TIME,"
           + "leave_interval TIME)"
           + "ENGINE=InnoDB DEFAULT CHARSET=utf8;";
	pstm = conn.prepareStatement(query);
	pstm.execute();		// sysMaster 테이블 생성
	
	
	query = "drop table if exists attendanceDB;";
	pstm = conn.prepareStatement(query);
	pstm.execute();		// attendanceDB 테이블을 새로 생성하기 위해 기존에 테이블이 있었다면 삭제 	
	query = "drop table if exists managingDB;";
	pstm = conn.prepareStatement(query);
	pstm.execute();		// managingDB 테이블을 새로 생성하기 위해 기존에 테이블이 있었다면 삭제(otpDB 보다 먼저 삭제해야 한다.)
	query = "drop table if exists otpDB;";
	pstm = conn.prepareStatement(query);
	pstm.execute();		// otpDB 테이블을 새로 생성하기 위해 기존에 테이블이 있었다면 삭제 
	query = "drop table if exists memberDB;";
	pstm = conn.prepareStatement(query);
	pstm.execute();		// memberDB 테이블을 새로 생성하기 위해 기존에 테이블이 있었다면 삭제 
	
	query = "create table memberDB("
		  + "name varchar(20),"
		  + "_id int(10) primary key,"
		  + "password varchar(50),"
		  + "phone varchar(30),"
		  + "email varchar(50),"
		  + "hidden int(1))"
		  + "ENGINE=InnoDB DEFAULT CHARSET=utf8;";
	pstm = conn.prepareStatement(query);
	pstm.execute();		// memberDB 테이블 생성 (가장 먼저 생성되어야 한다.)
	
	query =  "create table otpDB("
           + "_id int(10) primary key,"
           + "otp int(10) unique key)"
           + "ENGINE=InnoDB DEFAULT CHARSET=utf8;";
	pstm = conn.prepareStatement(query);
	pstm.execute();		// otpDB 테이블 생성
	
	query =  "create table managingDB("
           + "date TIMESTAMP default current_timestamp,"
           + "_id int(10),"
           + "time_in TIME,"
           + "time_out TIME,"
           + "status int(1),"
		   + "FOREIGN KEY (_id) REFERENCES otpDB (_id) "
		   + "ON DELETE CASCADE "
		   + "ON UPDATE CASCADE)"
		   + "ENGINE=InnoDB DEFAULT CHARSET=utf8;";
	pstm = conn.prepareStatement(query);
	pstm.execute();		// managingDB 테이블 생성
	
	/*** TODO : memberDB에 있는 _id 내용을 이제 otp와 managingDB로 옮길 것 ***/
	
	// otpDB 임의 id 데이터 생성
	int id = 2018231001;
	for(int i = 0; i < 10; i++){
		query = "insert into otpDB (_id)"
				 + "values(?);";
		pstm = conn.prepareStatement(query);
		pstm.setInt(1, id);
		pstm.execute();	
		id++;
	}
	
	// managingDB id & 입퇴실시간 임의 데이터 생성
	id = 2018231001;
	for(int i = 0; i < 10; i++){
		query = "insert into managingDB (_id,status)"
				 + "values(?,?);";
		pstm = conn.prepareStatement(query);
		pstm.setInt(1, id);
		pstm.setInt(2, 9);
		pstm.execute();			/* status 0: 입실완료, 1: 지각, 2: 조퇴, 3: 퇴실완료, 4:결석 9: 체크되기 이전 상태 */
		id++;
	}
	
	query = "create table attendanceDB("
		  + "_id int(10),"
		  + "status int(1),"
		  + "date TIME)"
		  + "ENGINE=InnoDB DEFAULT CHARSET=utf8;";
	pstm = conn.prepareStatement(query);
	pstm.execute();		// attendanceDB 테이블 생성
	
	out.println("테이블 및 임의의 데이터 생성 완료");
	pstm.close();
	conn.close();
	
}catch(SQLException e){
	out.println("SQL 에러 메세지 입니다. ==> "+e.toString());
}catch(Exception e){
	out.println("에러 메세지 입니다. ==> "+e.toString());
}
%>
</head>
<body>
</body>
</html>