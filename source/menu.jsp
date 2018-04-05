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
a:no-uline { text-decoration:none;
color:black; }
a:link{color:black; text-decoration:none;}
a:visited {text-decoration:none;
color:black;}
a:hover{text-decoration:none;
color:black;}
a:active {text-decoration:none;
color:black;}
</style>
</HEAD>
<body bgcolor='#ffffff'>
<center>
<table cellpadding=0 cellspacing=0 border=0>
	<tr>
		<td width=80><center><a href='main.jsp' target=main ><img src="img/logo.jpg" width=80 border=0></a>
		</center></td>			
		<td width=760 style='text-align:left;'>
		<a href='setting.jsp' target=main>
		&nbsp;&nbsp; 입/퇴실 시간 설정 &nbsp;&nbsp;
		</a>
		<a href='memberManage.jsp' target=main>
		 학생 관리 &nbsp;&nbsp;
		</a>
		<a href='manage.jsp' target=main>
		 일일 출결 현황 &nbsp;&nbsp;
		</a>
		<a href='manageMonth.jsp' target=main>
		 월간 출결 현황 &nbsp;&nbsp;
		</a>
		<a href='barcode/BarcodeRead.jsp' target=main>
		 입/퇴실 체크  &nbsp;&nbsp;
		</a>
		<a href='logout.jsp' target='main'>
		 로그아웃 
		</a>
		</td>
	</tr>
</table>
</center>		
</body>
</HTML>