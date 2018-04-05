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
<title>게시글 목록</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
<script>
    $(document).ready(function(){
        $("#btnWrite").click(function(){
            // 페이지 주소 변경(이동)
            location.href = "gongji_write.jsp";
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

try{
	Class.forName("com.mysql.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/iamhpd7","iamhpd7","ctc@kopo");
	ResultSet rset = null;
	String query = null;
	PreparedStatement pstm = null;
		
	int replyNumber = 0;
	int bono = 0;
	
		/*페이지*/		
		
		int cnt = 15;		
		int fromRecord = 1;				//무조건 1번째 레코드부터 들어온다는 가정하에 시작!
		int updateStudent = 0;
		int totalRecord = 0;
		int blockSize = 10;				//페이지 그룹 크기
		int nowPage = 0;
		int startPage = 0;
		int endPage = 0;
		int totalPage = 0;
		int nowPageGroup = 0;
		int pageGroup = 0;
		int nextPage = 0;
		int prevPage = 0;
		int firstPage = 0;
		int lastPage = 0;		
		int startRecord = 0;
		int endRecord = 0;
		int LineCount =1;				//첫번째 들어오는 값을 1로 처리하고 계산
	
		//ResultSet의 재사용!!!!!!!!! DB에 접속할 수 있는 접속 Connect가 제한되어있으므로 한 개로만 써야한다!
		query = "select count(*) from gongji;";
		pstm = conn.prepareStatement(query);
		rset = pstm.executeQuery();
		while(rset.next()){
			totalRecord = rset.getInt(1);
		}
	
		/*2.페이징 처리를 위한 계산작업*/	
		
		//todo:파라미터 저장
		String str1 = request.getParameter("from");
		String str2 = request.getParameter("cnt");
		
		//todo:레코드 유효여부 파악
		if(str1 != null){
			fromRecord = Integer.parseInt(str1);
			if(fromRecord > totalRecord){
				fromRecord = totalRecord; 			  //총레코드보다 초과시 총레코드와 같게
			}
			if(fromRecord < 1){
				fromRecord = 1;							  // 1페이지 아래의 요청을 받았을 때도 초기값으로 저장
			}			
		}
				
		//todo:Count 유효여부 파악
		if(str2 != null){
			cnt = Integer.parseInt(str2);
			if(cnt < 1){
				cnt = 10;		//count가 1보다 작을시 10으로 초기값
			}
		}
		
		//todo:페이지처리 파트★★
		nowPage = fromRecord / cnt + ( fromRecord % cnt > 0 ? 1:0 );						//현재 페이지
		totalPage = totalRecord / cnt + ( totalRecord % cnt > 0 ? 1:0 );						//총 페이지 수 저장

		pageGroup = totalPage / blockSize + ( totalPage % blockSize > 0 ? 1:0 );	 		//페이지 그룹 갯수
		nowPageGroup = nowPage / blockSize + ( nowPage % blockSize > 0 ? 1:0 );	//현재 페이지가 속하는 페이지 그룹 계산
		
		endPage = nowPageGroup * blockSize;   													//페이지그룹의 마지막페이지
		startPage = endPage - (blockSize-1);     													//페이지그룹의 시작페이지
		if(endPage>totalPage){   
			endPage = totalPage;  					//마지막페이지가 총페이지보다 많을 경우 총페이지까지만
		}		
		
		nextPage = startPage + blockSize;
		if(nextPage > totalPage){
			nextPage = totalPage;						//마지막 그룹에서 다시 다음페이지 요청시 끝페이지 표시
		}
		
		prevPage = startPage - blockSize;
		if(prevPage < 1){
			prevPage = 1;									//1페이지 이전으로 가려고 할때 1페이지만 표시
		}
		
		firstPage = 1;						//첫번째 페이지
		lastPage = totalPage;			//마지막 페이지
		
		endRecord = nowPage * cnt;					//현재 페이지의 끝 레코드
		startRecord = endRecord - (cnt - 1);		//현재 페이지의 시작 레코드				
	
	
	//테이블 출력
	
	%>
	
<div style="width:device-width; height:100%; overflow:scroll; -webkit-overflow-scrolling:touch;">
<ons-toolbar fixed-style>
     <div class="center">폴리텍 익명 게시판</div>
     
     <div class="right">
     	 <ons-toolbar-button id="btnWrite" >글쓰기</ons-toolbar-button>
     </div>
</ons-toolbar>
<br><br><br><br>
<table class="table table-bordered table-hover">
<thead>
    <tr>
        <th class="text-center" width=50><span class='text-success'>번호</span></th>
        <th class="text-center" width=300><span class='text-success'>제목</span></th>
        <th class="text-center" width=110><span class='text-success'>작성일</span></th>
    </tr>
</thead>
<tbody>
    
	<%
	query = "select id, title, date from gongji order by id DESC limit " + (startRecord-1) + "," + cnt + ";";
	pstm = conn.prepareStatement(query);
	rset = pstm.executeQuery();
	while(rset.next()){
	
		String db_title = rset.getString(2);
				db_title = db_title.replaceAll(" "   ,"&nbsp;");
				db_title = db_title.replaceAll("\""   ,"&quot;");
				db_title = db_title.replaceAll("<"   ,"&lt;");
				db_title = db_title.replaceAll(">"   ,"&gt;");
		bono = rset.getInt(1);
		out.println("<tr><td class='text-center'>");
		out.println(bono);
		out.println("</td>");
		out.println("<td align=left>");
		out.println("<a href='gongji_view.jsp?key="+rset.getInt(1)+"'>");
		out.println(db_title);	//공지사항 제목
		out.println("<span style='color:red;'></span>");
		out.println("</a>");
		out.println("</td>");
		out.println("<td class='text-center'>");
		String date_format = rset.getString(3);
					int index = date_format.indexOf(".");
					date_format = date_format.substring(0, index);
					out.println(date_format); //저장된 날짜
		out.println("</td>");
		out.println("</tr>");
		out.println("</tbody>");
		
	}
	%>
</table>

	<%
	/*4.페이지 번호 출력 파트*/
	out.println("<div align=center><a href='gongji_list.jsp?from=" + ((firstPage*cnt)-(cnt-1)) + "&cnt=" + cnt + "' style=text-decoration:none> <<  </a>");	//고정 : 항상 첫 페이지로 이동합니다.
	out.println("<a href='gongji_list.jsp?from=" + ((prevPage*cnt)-(cnt-1)) + "&cnt=" + cnt + "' style=text-decoration:none>&lt</a>");	//이전 페이지로 이동합니다.
	for (int i = startPage; i <= endPage; i++) {
			if(nowPage==i){		//현재 페이지 빨간색으로 폰트 강조!
				out.println("<a href='gongji_list.jsp?from=" + (((i-1)*cnt)+1) + "&cnt=" + cnt + "' ><b><u>" + i + "</b></u></a>");
			}else{
				out.println("<a href='gongji_list.jsp?from=" + (((i-1)*cnt)+1) + "&cnt=" + cnt + "' style=text-decoration:none>" + i + "</a>");
			}
		}
	out.println("<a href='gongji_list.jsp?from=" + ((nextPage*cnt) - (cnt-1)) + "&cnt=" + cnt + "' style=text-decoration:none>&gt</a>");			//다음 페이지로 이동합니다.
	out.println("<a href='gongji_list.jsp?from=" + ((lastPage*cnt) - (cnt-1)) + "&cnt=" + cnt + "' style=text-decoration:none> >> </a></div>");	//고정 : 항상 마지막 페이지로 이동합니다.
	
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
</div>
<br>
<br>
<br>
<br>
<br>
<br>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
</body>
</html>