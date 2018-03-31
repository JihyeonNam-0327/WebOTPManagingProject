<!DOCTYPE HTML>
<html>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" >
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*, javax.sql.*, java.io.*, java.util.Date, java.math.*, java.text.*" %>
<%@ page import="java.net.*, java.io.*" %>
<!-- 바코드 체크 화면으로 바꿀 것! TODO : 바코드 읽었을 때 그때그때 출결 현황을 Ajax+Angular 로 보여줄 것 -->
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
					$("#resultMessage").html("정상적으로 퇴실 처리 되었습니다.").css("color","red");
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
<h1>바코드 체크 테스트</h1>
<form name="f">
학번 : <input type="number" name="_id" id="_id" placeholder="학번 10자리 입력" required>
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