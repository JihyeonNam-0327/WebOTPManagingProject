<!DOCTYPE HTML>
<html>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" >
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*, javax.sql.*, java.io.*, java.util.*, java.math.*, java.text.*" %>
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
		  + "dept varchar(15),"
		  + "name varchar(20),"
		  + "_id int(10) primary key,"
		  + "password varchar(50),"
		  + "phone varchar(30),"
		  + "email varchar(50),"
		  + "hidden int(1) default '0')"
		  + "ENGINE=InnoDB DEFAULT CHARSET=utf8;";
	pstm = conn.prepareStatement(query);
	pstm.execute();		// memberDB 테이블 생성 (가장 먼저 생성되어야 한다.)
	
	query =  "create table otpDB("
           + "_id int(10),"
           + "otp int(10) unique key,"
		   + "FOREIGN KEY (_id) REFERENCES memberDB (_id) "
		   + "ON DELETE CASCADE "
		   + "ON UPDATE CASCADE)"
           + "ENGINE=InnoDB DEFAULT CHARSET=utf8;";
	pstm = conn.prepareStatement(query);
	pstm.execute();		// otpDB 테이블 생성
	
	out.println("optDB 테이블 생성 완료");
	
	query =  "create table managingDB("
           + "date TIMESTAMP default current_timestamp,"
           + "_id int(10),"
           + "time_in TIME,"
           + "time_out TIME,"
           + "status int(1) default '9',"
		   + "FOREIGN KEY (_id) REFERENCES otpDB (_id) "
		   + "ON DELETE CASCADE "
		   + "ON UPDATE CASCADE)"
		   + "ENGINE=InnoDB DEFAULT CHARSET=utf8;";
	pstm = conn.prepareStatement(query);
	pstm.execute();		// managingDB 테이블 생성 
	/* 9: 초기값(체크이전상태), 0: 입실완료, 1: 지각, 2: 조퇴, 3: 퇴실, 4: 결석, 5: 정상출석(입/퇴실 모두체크) */
	
	out.println("managingDB 테이블 생성 완료");
	
	query = "create table attendanceDB("
		  + "date TIMESTAMP default current_timestamp,"
		  + "_id int(10),"
		  + "time_in TIME,"
		  + "time_out TIME,"
		  + "status int(1))"
		  + "ENGINE=InnoDB DEFAULT CHARSET=utf8;";
	pstm = conn.prepareStatement(query);
	pstm.execute();		// attendanceDB 테이블 생성
	
	out.println("attendanceDB 테이블 생성 완료");
	
	query = "CREATE EVENT IF NOT EXISTS evt1_makestatus"
		  + " ON SCHEDULE EVERY '1' DAY"
		  + " STARTS '2018-03-28 23:59:00'"
		  + " COMMENT 'Make status at 23:59 daily'"
		  + " DO"
		  + " UPDATE KOPOCTC.managingDB SET status = 4 WHERE time_in is null AND time_out is null;";
	pstm = conn.prepareStatement(query);
	pstm.execute();		// 이벤트 생성 - evt1_makestatus
	
	query = "CREATE EVENT IF NOT EXISTS evt2_makestatus"
		  + " ON SCHEDULE EVERY '1' DAY"
		  + " STARTS '2018-03-28 23:59:02'"
		  + " COMMENT 'Make status at 23:59 daily'"
		  + " DO"
		  + " UPDATE KOPOCTC.managingDB SET status = 2 WHERE time_in is not null AND time_out is null;";
	pstm = conn.prepareStatement(query);
	pstm.execute();		// 이벤트 생성 - evt2_makestatus
	
	query = "CREATE EVENT IF NOT EXISTS evt3_makestatus"
		  + " ON SCHEDULE EVERY '1' DAY"
		  + " STARTS '2018-03-28 23:59:04'"
		  + " COMMENT 'Make status at 23:59 daily'"
		  + " DO"
		  + " UPDATE KOPOCTC.managingDB SET status = 1 WHERE time_in is null AND time_out is not null;";
	pstm = conn.prepareStatement(query);
	pstm.execute();		// 이벤트 생성 - evt3_makestatus
	
	query = "CREATE EVENT IF NOT EXISTS evt4_makestatus"
		  + " ON SCHEDULE EVERY '1' DAY"
		  + " STARTS '2018-03-28 23:59:06'"
		  + " COMMENT 'Make status at 23:59 daily'"
		  + " DO"
		  + " UPDATE KOPOCTC.managingDB SET status = 5 WHERE time_in is not null AND time_out is not null;";
	pstm = conn.prepareStatement(query);
	pstm.execute();		// 이벤트 생성 - evt4_makestatus
	
	query = "CREATE EVENT IF NOT EXISTS evt_save"
		  + " ON SCHEDULE EVERY '1' DAY"
		  + " STARTS '2018-03-28 23:59:10'"
		  + " COMMENT 'Sate status at 23:59 daily'"
		  + " DO"
		  + " INSERT INTO KOPOCTC.attendanceDB(_id,time_in,time_out,status,date) SELECT _id,time_in,time_out,status,date FROM KOPOCTC.managingDB;";
	pstm = conn.prepareStatement(query);
	pstm.execute();		// 이벤트 생성 - evt_save
	
	query = "CREATE EVENT IF NOT EXISTS evt_delete"
		  + " ON SCHEDULE EVERY '1' DAY"
		  + " STARTS '2018-03-28 23:58:20'"
		  + " COMMENT 'Delete managingDB at 23:59 daily'"
		  + " DO"
		  + " DELETE FROM KOPOCTC.managingDB;";
	pstm = conn.prepareStatement(query);
	pstm.execute();		// 이벤트 생성 - evt_delete
	
	query = "CREATE EVENT IF NOT EXISTS evt_insert"
		  + " ON SCHEDULE EVERY '1' DAY"
		  + " STARTS '2018-03-29 00:00:01'"
		  + " COMMENT 'Insert into managingDB at 23:59 daily'"
		  + " DO"
		  + " INSERT INTO KOPOCTC.managingDB(_id) SELECT _id FROM KOPOCTC.otpDB;";
	pstm = conn.prepareStatement(query);
	pstm.execute();		// 이벤트 생성 - evt_delete
	
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