<!DOCTYPE html>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" >
<html>
<%@ page language="java" import="java.text.DateFormat, java.util.Date" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // 마지막 방문일을 저장하고 있는 쿠키를 저장할 객체
    Cookie lastDate = null;
    // 화면에 출력할 메시지를 저장할 문자열 변수
    String msg = "";
    // 마지막 방문일을 저장하고 있는 쿠키가 존재하는지를 판별할 변수
    boolean found = false;
    // 현재 시간을 저장
    String newValue = "" + System.currentTimeMillis();
    // 쿠키를 얻는다.
    Cookie[] cookies = request.getCookies();
	
    // 마지막 방문 일을 정하고 있는 쿠키를 검색
    if (cookies != null) {
        for (int i = 0; i < cookies.length; i++) {
            lastDate = cookies[i];
            if (lastDate.getName().equals("lastdateCookie")) {
                found = true;
                break;
            }
        }
    }
    
    // 처음 방문일 경우 새 쿠키 생성
    if (!found) {    // if (found = false)
        msg = "처음 방문하셨습니다.";
        // 쿠키 객체를 생성
        lastDate = new Cookie("lastdateCookie", newValue);
        // 쿠키 속성값을 설정
        lastDate.setMaxAge(365*24*60*60);    // 365일
        lastDate.setPath("/");
        // 쿠키를 추가
        response.addCookie(lastDate);
    }
    
    else {    // 이미 방문한 적이 있는 클라이언트라면
        // 이전 방문시간을 알아내어 long형 변수 conv에 저장
        long conv = new Long(lastDate.getValue()).longValue();
        // 방문시간을 출력할 수 있도록 msg 변수에 저장
        Date date = new Date(conv);
        String year = date.getYear() + 1900 + "년";
        String month = date.getMonth() + 1 + "월";
        String day = date.getDate() + "일";
        String hour = date.getHours() + "시";
        String minute = date.getMinutes() + "분";
		String seconds = date.getSeconds() + "초";
        msg = "최근 방문일은 ("+year+" "+month+" "+day+" "+hour+" "+minute+" "+seconds+") 입니다.";
        // 쿠키에 새 값을 추가
        lastDate.setValue(newValue);
        // 쿠키를 추가
        response.addCookie(lastDate);
    }
%>
<HEAD>
<style>
.img{
    position: relative;
    background-image: url(./img/background.jpg);
    height: 50vh;
    background-size: cover;
}
.img-cover{									/*이미지 커버는 이미지의 선명도를 낮추고 어둡게 만들기 위해 추가합니다.*/
   position: absolute;						/*폰트 컬러가 흰색이므로 어두운 컬러의 커버를 이미지 위에 한 번 씌웁니다.*/
   height: 100%;
   width: 100%;
   background-color: rgba(51, 204, 255, 0.4);                                                               
   z-index:1;								/*z-index는 로딩 순서입니다.*/
}
.img .content{								/*이미지 위에 글자를 올리기 위해 추가한 css입니다.*/
	position: absolute;
	top:50%;
	left:50%;
	transform: translate(-50%, -50%);
	font-size:13pt;
	color: white;
	z-index: 2;								/*z-index 순위를 낮게 함으로써 이미지를 먼저 불러오고*/
	text-align: center;						/*글자를 이미지 위로 올립니다.*/
	font-family: 'Archivo Black', sans-serif;
	padding: 30px;
	border:0px;
}
</style>
</HEAD>
<body>
    <div class="img">
        <div class="content"></div>
        <div class="img-cover"></div>
    </div>
	<br><br><br>
			<center><font align=center style='color:black; font-size:14pt;'>한국폴리텍대학 융합기술교육원<br>
			출석 체크 관리 시스템</font>
			<br><br><br><br>
			
			</center>
</body>
</HTML>