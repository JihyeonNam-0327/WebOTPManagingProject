<!DOCTYPE html>
<html>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" >
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*, javax.sql.*, java.io.*, java.util.Date, java.math.*, java.text.*" %>
<%@ page import="java.net.*, java.io.*" %>
<% request.setCharacterEncoding("utf-8");%>
<head>
<link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.3/css/bootstrap.min.css">
<script src="//code.jquery.com/jquery-3.2.1.slim.min.js"></script>
<script src="//cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"></script>
<script src="//maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.3/js/bootstrap.min.js"></script>
<script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.6.4/angular.min.js"></script>
<style>
input.ng-invalid {
    background-color: lightpink;
}
input.ng-valid {
    background-color: lightblue;
}
#checkPwd{
	color : red;
}
.form-group{
	width : 600px;
}
</style>
</head>
<body ng-app="myApp">
<h1 align=center>학생 등록</h1>
<br><br>
<form name="myForm" ng-controller="myCtrl">
<div class="form-group" style="margin:auto;">
* 모든 항목은 필수 입력 항목입니다.<br><br>
	<label>학과 : </label><br>
		<div>
			<select class="form-control" name="dept" id="dept" ng-model="selectedDept" ng-options="x for x in deptList">
			</select>
		</div>
</div>
<div class="form-group" style="margin:auto;">
	<label>이름 : </label><br>
	<input type="text" name="name" class="form-control input-lg " ng-model="user.Name" ng-required="true" ng-maxlength="20"/>
	<div ng-show="myForm.name.$error.maxlength" class="form-control alert alert-light" role="alert">이름 최대 20글자만 입력가능합니다.</div>
</div>
<div class="form-group" style="margin:auto;">
	<label>학번 : </label><br>
	<input type="number" class="form-control input-lg" name="_id" id="_id" ng-change="myFunc()" ng-model="myValue" ng-maxlength="10" required/>
	<div ng-show="myForm._id.$error.maxlength" class="form-control alert alert-light" role="alert">학번은 최대 10글자만 입력가능합니다.</div>
	<div class="form-control alert alert-light" role="alert" id="result_id_msg"></div>
</div>
<div class="form-group"  style="margin:auto;">
	<label>비밀번호 : </label><br>
	<input type="password" name="password" class="form-control input-lg" id="pwd" onkeyup="checkPwd()" ng-model="user.password" ng-required="true" ng-minlength="8"/>
	<div ng-show="myForm.password.$error.minlength"  class="form-control alert alert-light" role="alert">비밀번호는 최소 8글자 이상 입력해 주세요.</div>
</div>
<div class="form-group"  style="margin:auto;">
	<label>비밀번호 확인 : </label><br>
	<input type="password" class="form-control input-lg" name="pwd_check" id="pwd_check" onkeyup="checkPwd()" ng-model="user.passwordcheck" ng-required="true" ng-minlength="8"/>
	<div type="text" ng-show="myForm.pwd_check.$error.minlength" class="form-control alert alert-light" role="alert">비밀번호는 최소 8글자 이상 입력해 주세요.</div>
	<div class="form-control alert alert-light" role="alert" id="checkPwd"></div>
</div>
<div class="form-group" style="margin:auto;">
	<label>전화번호 : </label><br>
	<input type="phone" class="form-control input-lg" id="phone" name="phone">
	<div class="form-control alert alert-light" role="alert" id="checkPhone"></div>
</div>
<div class="form-group" style="margin:auto;">
	<label>Email : </label><br>
	<input type="email" name="email" ng-model="email" class="form-control input-lg" id="email" ng-maxlength="50" ng-required="true">
	<span style="color:red" ng-show="myForm.email.$dirty && myForm.email.$invalid">
	<div class="form-control alert alert-light" role="alert" ng-show="myForm.email.$error.required">이메일을 입력해 주세요.</div>
	<div class="form-control alert alert-light" role="alert" ng-show="myForm.email.$error.email">이메일 양식을 확인해 주세요.</div>
	<div class="form-control alert alert-light" role="alert" ng-show="myForm.email.$error.maxlength">이메일은 최대 50자까지만 입력가능합니다.</div>
	</span>
</div>
<br>

<div class="form-group" style="margin:auto;">
	<input type="button" value="등록하기" id="button2" class="btn btn-lg col-xs-6 btn-info"/>
	<input type="button" value="다시쓰기" id="button1" class="btn btn-lg col-xs-6 btn-warning"/>
</div>

<br>
</form>
<script>
angular.module('myApp', [])
.controller('myCtrl', ['$scope', function($scope) {
    
    $scope.myFunc = function() {
        var id = $('#_id').val();
		// ajax 실행
		$.ajax({
			type : 'POST',
			url : 'memberIDcheck.jsp',
			data:
			{
				id: id
			},
			success : function(data) {
				var check = $(data).find("result").text();
				if(check == "1") {
					$("#result_id_msg").html("이미 등록된 학번입니다.").css("color","red");
					$('#_id').css("background-color","lightpink");
				} else {
					$("#result_id_msg").html("사용 가능한 학번입니다.").css("color","black");
					$('#_id').css("background-color","lightblue");
				}
				//console.log(data);
			}
		});
    };
	
	$scope.deptList = ["데이터융합SW과", "임베디드시스템과", "생명의료시스템과"];
	
}]);

function checkPwd(){
  var f1 = document.forms[0];
  var pw1 = f1.pwd.value;
  var pw2 = f1.pwd_check.value;
  
  if(pw1==''||pw2==''){
		  document.getElementById('checkPwd').style.color = "black";
		  document.getElementById('checkPwd').innerHTML = "암호를 입력해 주세요."; 
		  $('#pwd').css("background-color","lightpink");
		  $('#pwd_check').css("background-color","lightpink");
  }else{
	   if(pw1!=pw2){
		  document.getElementById('checkPwd').style.color = "red";
		  document.getElementById('checkPwd').innerHTML = "동일한 암호를 입력하세요."; 
		  $('#pwd').css("background-color","lightpink");
		  $('#pwd_check').css("background-color","lightpink");
	   }else{
		  document.getElementById('checkPwd').style.color = "black";
		  document.getElementById('checkPwd').innerHTML = "암호를 확인했습니다.";  
		  $('#pwd').css("background-color","lightblue");
		  $('#pwd_check').css("background-color","lightblue");
	   }
  }
}

$(function(){
 
    $("#phone").on('keydown', function(e){
       // 숫자만 입력받기
        var trans_num = $(this).val().replace(/-/gi,'');
	var k = e.keyCode;
	
	if(trans_num.length >= 11 && ((k >= 48 && k <=126) || (k >= 12592 && k <= 12687 || k==32 || k==229 || (k>=45032 && k<=55203)) ))
	{
  	    e.preventDefault();
	}
    }).on('blur', function(){ // 포커스를 잃었을때 실행합니다.
        if($(this).val() == '') return;
 
        // 기존 번호에서 - 를 삭제합니다.
        var trans_num = $(this).val().replace(/-/gi,'');
      
        // 입력값이 있을때만 실행합니다.
        if(trans_num != null && trans_num != '')
        {
            // 총 핸드폰 자리수는 11글자이거나, 10자여야 합니다.
            if(trans_num.length==11 || trans_num.length==10) 
            {   
                // 유효성 체크
                var regExp_ctn = /^(01[016789]{1}|02|0[3-9]{1}[0-9]{1})([0-9]{3,4})([0-9]{4})$/;
                if(regExp_ctn.test(trans_num))
                {
                    // 유효성 체크에 성공하면 하이픈을 넣고 값을 바꿔줍니다.
                    trans_num = trans_num.replace(/^(01[016789]{1}|02|0[3-9]{1}[0-9]{1})-?([0-9]{3,4})-?([0-9]{4})$/, "$1-$2-$3");                  
                    $(this).val(trans_num);
					$('#phone').css("background-color","lightblue");
					document.getElementById('checkPhone').innerHTML = "";  
                }
                else
                {
					document.getElementById('checkPhone').style.color = "red";
					document.getElementById('checkPhone').innerHTML = "유효하지 않은 전화번호 입니다. 다시 입력해 주세요.";  
					$('#phone').css("background-color","lightpink");
					$(this).val("");
                    $(this).focus();
                }
            }
            else 
            {
				document.getElementById('checkPhone').style.color = "red";
				document.getElementById('checkPhone').innerHTML = "유효하지 않은 전화번호 입니다. 다시 입력해 주세요.";  
				$('#phone').css("background-color","lightpink");
				$(this).val("");
                $(this).focus();
            }
      }
  });  
});

$("#button1").click(function() {
	$(".form-control").val(null);
});

$("#button2").click(function() {
	var dept = $("#dept option:selected").text();
	var id = $("#_id").val();
	var name = $("#name").val();
	var password = $("#pwd").val();
	var status_id = $("#result_id_msg").text();
	var status_pw = $("#checkPwd").text();
	var phone = $("#phone").val();
	var email = $("#email").val();
	phone = phone.replace(/-/gi, "");

	if(status_id != "사용 가능한 학번입니다." || status_pw != "암호를 확인했습니다." || name == "" 
	  || phone.length < 10 || email == "" || id.length > 10 || dept == "" || password.length < 8 ){
		alert("회원가입 양식에 맞추어 작성해 주세요. \n혹시 빈 칸이 있는 지 확인해 보세요.");
		return;
	}else{
		myForm.action = "memberRegistrationDo.jsp";
		myForm.method = "post";
		myForm.submit();
	}
});
</script>
</body>
</html>