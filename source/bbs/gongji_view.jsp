<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<%@ page import="java.sql.*, javax.sql.*, java.io.*, java.util.Date, java.math.*, java.text.*" %>
<%@ page import="java.net.*, java.io.*" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<!-- 합쳐지고 최소화된 최신 CSS -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">
<!-- 부가적인 테마 -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap-theme.min.css">
<!-- 합쳐지고 최소화된 최신 자바스크립트 -->
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>
<script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
<title>게시글 보기</title>
<script>
    $(document).ready(function(){
        
        //게시글 삭제
        $("#btnDelete").click(function(){
			document.form1.action = "gongji_delete.jsp";
			document.form1.submit();
        });
        
        //게시글 수정
        $("#btnUpdete").click(function(){
            //var title = document.form1.title.value; ==> name속성으로 처리할 경우
            //var content = document.form1.content.value;
            //아래는 id속성으로 처리한 경우
            var title = $("#title").val();
            var content = $("#content").val();
            if(title == ""){
                alert("제목을 입력하세요");
                document.form1.title.focus();
                return;
            }
            if(content == ""){
                alert("내용을 입력하세요");
                document.form1.content.focus();
                return;
            }
            
            document.form1.action="gongji_update.jsp"
            // 폼에 입력한 데이터를 서버로 전송
            document.form1.submit();
        });
        
        //목록으로 돌아가기
        $("#btnBack").click(function(){
        	location.href ="gongji_list.jsp";
        });

    });
</script>
<!-- OnsenUI 적용(css 2, js) -->
<link rel="stylesheet" href="https://unpkg.com/onsenui/css/onsenui.css">
<link rel="stylesheet" href="https://unpkg.com/onsenui/css/onsen-css-components.min.css">
<script src="https://unpkg.com/onsenui/js/onsenui.min.js"></script>
</head>
<body>
<%
request.setCharacterEncoding("utf-8");
String key_num = "";
key_num = request.getParameter("key"); //글 번호

String writtenDate = "";
String title = "";
String content = "";

try{
	Class.forName("com.mysql.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/iamhpd7","iamhpd7","ctc@kopo");
	ResultSet rset = null;
	String query = null;
	PreparedStatement pstm = null;
	
	query = "select date,title,content from gongji where id=?;";
	pstm = conn.prepareStatement(query);
	pstm.setString(1,key_num);
	rset = pstm.executeQuery();
	while(rset.next()){
		writtenDate = rset.getString(1);
		title = rset.getString(2);
		content = rset.getString(3);
	}
	
	rset.close();
	pstm.close();
	conn.close();
}catch(SQLException e){
	out.println("SQLe " + e.toString());
	out.println("<h2 align=center>공지사항 테이블이 존재하지 않습니다.</h2>");
	
}catch(Exception e){
	out.println("Exception " + e.toString());
}
%>
<div style="width:device-width; height:100%; overflow:scroll; -webkit-overflow-scrolling:touch;">
	<ons-toolbar fixed-style>
	      <div class="left">
	        <ons-back-button id="btnBack">게시판으로</ons-back-button>
	      </div>
	      <div class="center">게시글 보기</div>
	</ons-toolbar>
<br><br><br><br>
<form name="form1" method="post">
    <table class="table">
        <tr>
	        <td width="80">작성일자</td>
	        <td><%=writtenDate%></td>
        </tr>
    <tr>
    <td>제목</td>
    <td><input class="form-control" name="title" id="title" size="80" value="<%=title%>" placeholder="제목을 입력해주세요"></td>
    </tr>
    <tr>
    <td>내용</td>
    <td><textarea class="form-control" name="content" id="content" rows="15" cols="80" placeholder="내용을 입력해주세요"><%=content%></textarea></td>
    </tr>
    <tr>
    <td colspan=2>
        <!-- 게시물번호를 hidden으로 처리 -->
        <input type="hidden" name="id" value="<%=key_num%>">
        <button class="btn btn-default pull-right" type="button" id="btnUpdete">수정</button>
        <button class="btn btn-default pull-right" type="button" id="btnDelete">삭제</button>
    </td>
    </tr>
    </table>
</form>
<br><br><br>
</body>
</html>