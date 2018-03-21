<!DOCTYPE HTML>
<html>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" >
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*, javax.sql.*, java.io.*, java.util.Date, java.math.*, java.text.*" %>
<script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
<head>
<script type="text/javascript">
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
</script>
</head>
<body>
<form name="f">
학번 : <input type="text" name="_id">
<input type="button" value="OTP 요청하기" onclick="requestHello('getOTP.jsp')">
</form>
<div id="message"></div>
</form>
</body>
</html>