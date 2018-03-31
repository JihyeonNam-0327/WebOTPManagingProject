<!DOCTYPE HTML>
<%@ page contentType="text/html; charset=utf-8" language="java" %>
<%@ page import="java.util.*, java.text.*" %>
<%@ page import="java.sql.*, javax.sql.*, java.net.*, java.io.*" %>
<% request.setCharacterEncoding("utf-8");%>
<html>
<head>
<script type="text/javascript"> 
function goReplace(url){
	window.location.href=url;
}
</script>
</head> 
<body>
<%
//세션을 체크해서 없다면 로그인창으로 보냅니다. 그리고 로그인이 되면 자기 자신에게 와야하므로 
//자기 자신의 url을 써주어야 합니다. 여기에선 login_check.jsp
	String id = request.getParameter("id");
	String checkID = "";
	checkID = (String)session.getAttribute("login_ok");
	String loginOK=null;
	//login값이 없는지, login_ok 키의 value값이 yes가 맞는지 확인합니다.
	loginOK = (String)session.getAttribute("login_ok");
	
	String jumpURL="login.jsp?jump=login_id_pw_check.jsp";
	String goBack = request.getParameter("goBack");
	
	if(loginOK==null||!loginOK.equals(checkID)){
		response.sendRedirect(jumpURL);
		return;
	}
%>
<script>alert("뭘까이건"+<%=goBack%>);goReplace(<%=goBack%>);</script>
</body>
</html>