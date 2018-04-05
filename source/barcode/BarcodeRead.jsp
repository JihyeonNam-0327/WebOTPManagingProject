<!DOCTYPE HTML>
<html>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" >
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*, javax.sql.*, java.io.*, java.util.Date, java.math.*, java.text.*" %>
<%@ page import="java.net.*, java.io.*" %>
<link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.3/css/bootstrap.min.css">
<script src="//code.jquery.com/jquery-3.2.1.slim.min.js"></script>
<script src="//cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"></script>
<script src="//maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.3/js/bootstrap.min.js"></script>
<script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.6.4/angular.min.js"></script>
<head>
</head>
<body ng-app="myApp">
<h1 align=center>출석 체크</h1>
<br>
<form name="myForm" ng-controller="myCtrl" align=center>
<div class="form-group center-block">
	<label>바코드 : </label> 
	<input type="number" id="barcode" ng-change="myFunc()" ng-model="myValue" autofocus>
</div>
<input type="submit" value="인증" id="button1">
</form>
<center><div id="content"></div></center>
<p style='text-align:center;' id="resultMessage"></p>
<script type="text/javascript">
angular.module('myApp', [])
.controller('myCtrl', ['$scope', function($scope) {
    
    $scope.myFunc = function() {

		var code = $('#barcode').val();
		
		// ajax 실행
		$.ajax({
			type : 'POST',
			url : 'BarcodeCheck.jsp',
			data:
			{
				"code" : code
			},
			success : function(data) {

				//re는 0 = 아무일안일어남, 1 = 정상 입실함, 2 = 정상 퇴실함.
				var check = $(data).find("result").text();
				var name = $(data).find("name").text();
				var dept = $(data).find("dept").text();
				var id = $(data).find("studentid").text();
				var date = $(data).find("date").text();
								
				if(check == "1") {
					$("#resultMessage").text("정상적으로 출근 처리 되었습니다.").css("color","red");
					$('#content').text(dept+" "+name+ "(" +id+ ") 님이 " +date+ " 에 체크했습니다.");
				}else if(check == "2"){
					$("#resultMessage").text("정상적으로 퇴근 처리 되었습니다.").css("color","red");
					$('#content').text(dept+" "+name+ "(" +id+ ") 님이 " +date+ " 에 체크했습니다.");
				}else if(check == "3"){
					$("#resultMessage").text("하지만 인증 가능한 시간이 아닙니다.").css("color","black");
					$('#content').text(dept+" "+name+ "(" +id+ ") 님이 " +date+ " 에 체크했습니다.");
				}else if(check == "0"){
					$("#resultMessage").text("해당 바코드가 유효하지 않습니다.").css("color","blue");
				}else{
					$("#resultMessage").text("해당 바코드가 유효하지 않습니다.").css("color","blue");
				}
				
				$('#barcode').val('');
				$("#barcode").focus();
			}
		});
    };
}]);

</script>
</body>
</html>