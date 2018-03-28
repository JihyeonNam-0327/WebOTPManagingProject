<!DOCTYPE html>
<html>
<%@ page contentType="text/html; charset=utf-8" language="java" %>
<%@ page import="java.util.*, java.text.*" %>
<%@ page import="java.sql.*, javax.sql.*, java.net.*, java.io.*" %>
<% request.setCharacterEncoding("utf-8");%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" >
<head>
<!--a링크 밑줄 및 다녀온 표시 안나게 하는 css 추가-->
<style type='text/css'>
td{font-size:12; text-align:center;}
table{align:center;}
a:no-uline { text-decoration:none; }
a:link{color:black; text-decoration:none;}
a:visited {text-decoration:none;}
a:hover{text-decoration:none;}
a:active {text-decoration:none;}
</style>
</HEAD>
<body bgcolor='#f8f8f8'>
<center>
<table cellpadding=0 cellspacing=0 border=0>
	<tr>
		<td width=200><a href='main.jsp' target=main ><img src=logo.jpg width=170 border=0></a>
		</td>			
		<td width=720 style='text-align:left;'>
		<a href='setting.jsp' target=main style='a.no-uline { text-decoration:none; }'>
		| 입/퇴실 시간 설정 
		</a>
		<a href='memberManage.jsp' target=main>
		 | 학생 관리 
		</a>
		<a href='manage.jsp' target=main>
		 | 일일 출퇴근 현황 
		</a>
		<a href='manageMonth.jsp' target=main>
		 | 월간 출퇴근 현황 
		</a>
		<a href='test.jsp' target=main>
		 | 바코드 테스트 | 
		</a>
		<%
		String loginOK=null;
		//login값이 없는지, login_ok 키의 value값이 yes가 맞는지 확인합니다.
		loginOK = (String)session.getAttribute("login_ok");
		if(loginOK==null || !loginOK.equals("yes")){	//일반인
		}else{	//로그인 한 경우
		%>
		<a href='logout.jsp' target='main'>
		<button>로그아웃</button>	
		</a>
		<%
		}
		%>
		</td>
	</tr>
</table>
</center>		
</body>
</HTML>