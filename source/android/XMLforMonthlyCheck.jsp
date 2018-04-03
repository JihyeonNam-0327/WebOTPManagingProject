<!DOCTYPE html>
<html>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" >
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*, javax.sql.*, java.io.*, java.util.*, java.util.Date, java.math.*, java.text.*, java.net.*" %>
<%@ page import="java.net.*, java.io.*" %>
<head>
<!-- 합쳐지고 최소화된 최신 CSS -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">
<!-- 부가적인 테마 -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap-theme.min.css">
<script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
<!-- 합쳐지고 최소화된 최신 자바스크립트 -->
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>
<style type="text/css">
table.mytable {
    border-collapse: separate;
    border-spacing: 1px;
    //text-align: center;
    line-height: 1.5;
    border-top: 1px solid #ccc;
	margin : 20px 10px;
	font-size:10pt;
}
table.mytable th {
    //width: 150px;
    padding: 10px;
    font-weight: bold;
    vertical-align: top;
    border-bottom: 1px solid #ccc;
}
table.mytable td {
    //width: 350px;
    padding: 10px;
    vertical-align: top;
    border-bottom: 1px solid #ccc;
}
a:no-uline { text-decoration:none; }
a, a:link, a:visited, a:active{
	text-decoration: none;
	color: #122293;
}
a:hover{
	text-decoration: none;
	font-size: 10pt
}
</style>
<%!
	//연도, 달 이동 헬퍼 메소드
	private String traverseDate(String type, int year, int month, String id){
		String href = "";
		if(type.equals("upYear")){
			href = "./manageMonthDetail.jsp?year=" + (year+1) + "&month=" + month + "&id=" + id;
		}else if(type.equals("downYear")){
			href = "./manageMonthDetail.jsp?year=" + (year-1) + "&month=" + month + "&id=" + id;
		}else if(type.equals("upMonth")){
			if(month == 11){
				href = "./manageMonthDetail.jsp?year=" + (year+1) + "&month=0" + "&id=" + id;
			}else{
				href = "./manageMonthDetail.jsp?year=" + year + "&month=" + (month+1) + "&id=" + id;
			}
		}else if(type.equals("downMonth")){
			if(month == 0){
				href = "./manageMonthDetail.jsp?year=" + (year-1) + "&month=11" + "&id=" + id;
			}else{
				href = "./manageMonthDetail.jsp?year=" + year + "&month=" + (month-1) + "&id=" + id;
			}
		}
		return href;
	}
	
	//today 및 출결현황 출력 헬퍼 메소드
	private String printToday(int todayYear, int year, int todayMonth, int month, int todayDate, int day, String[][] attd_status, int size){
		String substring_day = Integer.toString(day-1); //day++된 이후에 파라메타값으로 넘겨받으므로 하나를 빼줍니다!
		String substring_month = Integer.toString(month+1); //month는 -1되어서 들어오므로 db의 데이터와 비교하려면 +1해준다.
		String print = "";
				
		if(todayYear == year && todayMonth == month && todayDate == day){	//당일 날짜인 경우
			
			//today가 찍히는 날짜에는 출결현황이 찍히지 않습니다. 출결현황은 하루 지나야 달력으로 넘어옴.
			return "<br><b><font size=3>Today</font></b>";
		}//당일 날짜인 경우 if문 종료
		
		if(todayYear == year && todayMonth == month && day < todayDate){
			day--;
			int cnt = 0;
			String question = "";
			if(day < 10){
				substring_day = "0" + substring_day;
			}
			if(month < 10){
				substring_month = "0" + substring_month;
			}
			String bigyo = substring_month + "-" + substring_day;
			for(int i = 0; i < size; i++){
				if(attd_status[0][i].substring(5,10).equals(bigyo)){
					cnt = i;
				}
			}
			if(attd_status[0][cnt].substring(5,10).equals(bigyo)){
				print = "<br><font color=red size=6>"+attd_status[1][cnt]+"</font>";
			}
			return print;
		}//같은 달인데 오늘보다 이전인 경우 if문 종료
		
		if(todayYear == year && month == todayMonth-1 && day > todayDate){
			day--;
			int cnt = 0;
			if(day < 10){
				substring_day = "0" + substring_day;
			}
			if(month < 10){
				substring_month = "0" + substring_month;
			}
			String bigyo = substring_month + "-" + substring_day;
			for(int i = 1; i < size; i++){
				if(attd_status[0][i].substring(5,10).equals(bigyo)){
					cnt = i;
				}
			}
			if(attd_status[0][cnt].substring(5,10).equals(bigyo)){
				print = "<br><font color=red size=6>"+attd_status[1][cnt]+"</font>";
			}
			return print;
		}//이전달인데 나보다 큰 날 종료
		
		return "";
	}
%>
</head>
<body>
<h1>월간 출퇴근 현황</h1>
<table border=1 cellspacing=0>
<!-- TODO : 학번을 클릭하면 그 학생의 월별 출석현황을 보여줄 것 -->
<%
request.setCharacterEncoding("utf-8");

String id = "";

id = request.getParameter("id");
if(id == null){
	id = "2018231001";
}

int status = 0;
String resultStatus = "";

try{
	Class.forName("com.mysql.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/iamhpd7","iamhpd7","ctc@kopo");
	ResultSet rset = null;
	PreparedStatement pstm = null;
	String query = null;
	
	Calendar cal = Calendar.getInstance();
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
	int size = 0;
		
	query = "select count(status) from attendanceDB where _id=?;";
	pstm = conn.prepareStatement(query);
	pstm.setString(1,id);
	rset = pstm.executeQuery();
	if(!rset.next()){
		out.println("월간 출퇴근 현황이 아직 등록되지 않았습니다.");
		rset.close();
		pstm.close();
		conn.close();
		return;
	}else{
		size = rset.getInt(1);
		if(size == 0){
			out.println("월간 출퇴근 현황이 아직 등록되지 않았습니다.");
			rset.close();
			pstm.close();
			conn.close();
			return;
		}
	}
	
	String[][] attd_status = new String[2][size];	//출결 현황을 저장할 배열 선언, 지난 번 예약 시스템과 다른 점은 이전 기록을 보아야 한다는 것입니다!
	query = "select date, status from attendanceDB where _id=?;"; //날짜가 가장 가까운 날짜부터 출력! (우선은)
	pstm = conn.prepareStatement(query);
	pstm.setString(1,id);
	rset = pstm.executeQuery();
	int cnt = 0;
	while(rset.next()){
		attd_status[0][cnt] = rset.getString(1);
		status = rset.getInt(2);
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
			 case 9 : resultStatus = "체크 안 함";
					  break;
		}
		attd_status[1][cnt] = resultStatus;
		cnt++;
	}
	
	cal.add(cal.DATE, +1);					//현재 날짜에 +1을 해줍니다.
	
	//보여줄 연도, 달 받아오기. 파라미터 값이 숫자가 아니거나 null이면 현재 달로 보여줌.
	GregorianCalendar curDate = new GregorianCalendar();
	int year = 0;
	int month = 0; //원하는 달-1 값. 예)2월 = 1
	
	try{
		year = Integer.parseInt(request.getParameter("year"));
		month = Integer.parseInt(request.getParameter("month"));
		curDate.set(Calendar.YEAR, year); //보여줄 연도 setting
		curDate.set(Calendar.MONTH, month); //보여줄 달 setting
		curDate.set(Calendar.DAY_OF_MONTH, 1); //일자는 1일로 고정
	}catch(NumberFormatException nfe){
		year = curDate.get(Calendar.YEAR);
		month = curDate.get(Calendar.MONTH);
	}
	
	int firstDay = new GregorianCalendar(curDate.get(Calendar.YEAR), curDate.get(Calendar.MONTH), 1).get(Calendar.DAY_OF_WEEK); //해당 달의 시작하는 날 idx
	int lastDay = curDate.getActualMaximum(Calendar.DAY_OF_MONTH); //해당 달의 마지막 날
	
	//오늘 일자 구하기
	GregorianCalendar getToday = new GregorianCalendar();
	int todayYear = getToday.get(Calendar.YEAR);
	int todayMonth = getToday.get(Calendar.MONTH);
	int todayDate = getToday.get(Calendar.DAY_OF_MONTH)+1;
	//out.println("todayMonth : " + todayMonth + "month : " + month);	//todayMonth 는 고정적인 값(이번달), month가 매달 바뀌는 값
	
	//달력 구현
	int row = 7; //행
	int col = 5; //열
	int day = 1;
	
	out.println("<table class=mytable style='margin:auto;'>");
	out.println("	<tr>");
	out.println("		<td colspan="+row+" align=center><a href='"+traverseDate("downYear", year, month,id)+"'>");
	out.println("		<font style='text-decoration: none;'>〈 &nbsp;</font></a><font style='font-size: 18'>"+year+"</font>");
	out.println("		<a href='"+traverseDate("upYear", year, month,id)+"'><font style='text-decoration: none;'> &nbsp;〉</font></a>&nbsp;");
	out.println("		<a href='"+traverseDate("downMonth", year, month,id)+"'><font style='text-decoration: none;'>〈&nbsp; </font></a>");
	out.println("		<font style='font-size: 18'>"+(month+1)+"</font><a href='"+traverseDate("upMonth", year, month,id)+"'>");
	out.println("		<font style='text-decoration: none;'> &nbsp;〉</font></a></td>");
	out.println("	</tr>");
	out.println("	<tr align=center height=30>");
	out.println("		<th class=mytable bgcolor='#f8f8f8' valign=top><font color='red'><b>일</b></font></th>"); 
	out.println("		<th class=mytable bgcolor='#f8f8f8' valign=top><b>월</b></th>");
	out.println("		<th class=mytable bgcolor='#f8f8f8' valign=top><b>화</b></th>");
	out.println("		<th class=mytable bgcolor='#f8f8f8' valign=top><b>수</b></th>");
	out.println("		<th class=mytable bgcolor='#f8f8f8' valign=top><b>목</b></th>");
	out.println("		<th class=mytable bgcolor='#f8f8f8' valign=top><b>금</b></th>");
	out.println("		<th class=mytable bgcolor='#f8f8f8' valign=top><font color='blue'><b>토</b></font></td>");
	out.println("	</tr>");
	
	for(int i = 0; i < col; i++){
		out.println("<tr align=left height=110>");
		for(int j = 0; j < row; j++){
			out.println("<td class=mytable width=110 bgcolor='#f8f8f8' valign=top>");
			if(day <= lastDay){
				//첫 주 시작하는 날 전까지는 빈칸으로 채우기
				if(i == 0 && (j+1) < firstDay){
					out.println("&nbsp;");
					continue;
				}
				if(j == 0){
					out.println("<font color='red' style='text-decoration: none;'><b>" + day++ + "</b>");
					out.println("</font>" + printToday(todayYear, year, todayMonth, month, todayDate, day, attd_status, size));
				}else if(j == 6){
					out.println("<font color='blue' style='text-decoration: none;'><b>" + day++ + "</b>");
					out.println("</font>" + printToday(todayYear, year, todayMonth, month, todayDate, day, attd_status, size));
				}else {
					out.println("<font color='black' style='text-decoration: none;'><b>" + day++ + "</b>");
					out.println("</font>" + printToday(todayYear, year, todayMonth, month, todayDate, day, attd_status, size));
				}
				
			}else{
				out.println("&nbsp;");
			}
			out.println("</td>");
		}
		out.println("</tr>");
		
		//해당 달의 1일이 금요일이나 토요일로 시작해서 5줄로 출력이 불가능한 경우 한 줄 추가
		if(((i+1) == col) && (lastDay > (day-1))){
			col++;
		}
	}	//for문 끝
	
	out.println("</table>");
	
	rset.close();
	pstm.close();
	conn.close();
}catch(SQLException e){
	out.println("SQL에러입니다 == > "+e.toString());
}catch(Exception e){
	out.println("JAVA 에러입니다 == > "+e.toString());
}
%>
</table>
</body>
</html>