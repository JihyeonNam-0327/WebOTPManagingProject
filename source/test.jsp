<!DOCTYPE HTML>
<html>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" >
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*, javax.sql.*, java.io.*, java.util.Date, java.math.*, java.text.*" %>
<%@ page import="java.net.*, java.io.*" %>
<% request.setCharacterEncoding("utf-8");%>
<%
//세션을 체크해서 없다면 로그인창으로 보냅니다. 그리고 로그인이 되면 자기 자신에게 와야하므로 
//자기 자신의 url을 써주어야 합니다. 여기에선 login_check.jsp
	String loginOK="";
	String jumpURL="login.jsp?jump=login_check.jsp";
	String id = request.getParameter("id");
	String checkID = (String) session.getAttribute("login_ok");
	//login값이 없는지, login_ok 키의 value값이 yes가 맞는지 확인합니다.
	loginOK = (String)session.getAttribute("login_ok");
	if(loginOK==null || !loginOK.equals(checkID)){
		response.sendRedirect(jumpURL);
		return;
	}
	
%>
<script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
<head>
<script type="text/javascript">
function call(){
	top.document.location.reload(); // 페이지 새로고침 함수(프레임이 나뉘어져 있어도 모든 프레임 새로고침)
}

var xhr = null;

function getXMLHttpRequest(){
 if(window.ActiveXObject){
  try{
   return new ActiveXObject("Msxml2.XMLHTTP");
  }
  catch(e1){
   try{
    return new ActiveXObject("Microsoft.XMLHTTP");
   }
   catch (e2){
    return null;
   }
  }
 }
 else if(window.XMLHttpRequest){
  return new XMLHttpRequest();
 }
 else
 {
  return null;
 }
}

function requestHello(URL){
 param=f._id.value;
 if(param == ''){
	 alert("'OPT 발급 요청하기' 버튼을 눌러주세요.");
	 return;
 }
 URL = URL + "?_id=" + encodeURIComponent(param);
 xhr = getXMLHttpRequest();
 xhr.onreadystatechange = responseHello; // 콜백 함수 설정
 xhr.open("GET", URL, true);
 xhr.send(null);
}

function responseHello()
{
 if(xhr.readyState==4)
 {
  if(xhr.status == 200)
  {
   var str = xhr.responseText;
   document.getElementById("message").innerHTML = str;
   //alert("success");
  }
  else
  {
   alert("Fail : " + xhr.status);
  }
 }
}

$(document).ready(function(){
	$('#button1').click(function(){
		var id = $('#_id').val();
		var code = $('#message').text();
		code = code.trim();
		if(id == '' || code == ''){
			alert("'OPT 발급 요청하기' 버튼을 눌러주세요.");
			return;
		}
		// ajax 실행
		$.ajax({
			type : 'POST',
			url : 'checkOTP.jsp',
			data:
			{
				"id" : id,
				"code" : code
			},
			success : function(data) {
				//re는 0 = 아무일안일어남, 1 = 정상 입실함, 2 = 정상 퇴실함.
				var check = $(data).find("result").text();
				if(check == "1") {
					$("#resultMessage").html("정상적으로 입실 처리 되었습니다.").css("color","red");
				}else if(check == "2"){
					$("#resultMessage").html("정상적으로 퇴실 처리 되었습니다.").css("color","black");
				}else{
					$("#resultMessage").html("인증 가능한 시간이 아닙니다.").css("color","black");
				}
				console.log(data);
			}
		});
	});
});
</script>
</head>
<body>
<h1>바코드 테스트</h1>
<form name="f">
학번 : <input type="text" name="_id" id="_id" value="<%=checkID%>" maxlength=10 readonly>
<input type="button" value="OTP 발급 요청하기" onclick="requestHello('getOTP.jsp')">
<div id="message" name="message"></div>
<br>
바코드 인증하기 : 
<input type="button" value="인증" id="button1">
<br>
인증 결과 =>
<div id="resultMessage"></div>
</form>
</body>
</html>