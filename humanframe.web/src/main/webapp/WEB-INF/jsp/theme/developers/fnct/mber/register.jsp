<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/taglibs.jsp" %>
<%@ page trimDirectiveWhitespaces="true" %>

<script>

//아이디 중복확인
function f_mberIdDupCheck(){
	if ($("#mberId").val() != ""){
		if(!f_checkId()) {return}
		$.ajax({
			type : "post",
			url: './mberIdCheck',
			data: 'mberId=' + $("#mberId").val(),
			dataType: 'text', //전송받을 데이터의 타입
			contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
			success: function(data) {
				if(data=="true"){
					$("#mberIdCheck").val("Y");
					alert("사용할수 있는 아이디 입니다.");
				}else{
					$("#mberIdCheck").val("N");
					alert("이미 사용중인 아이디 입니다.");
				}
			},
			error: function(data, status, err) {
			}
		});
	}else{
		alert("사용하실 아이디를 입력해 주십시요.");
	}
}

function f_checkId(){
	 var RegEx = /([a-z0-9]){5,25}$/;

     if(!RegEx.test( $("#mberId").val())) {
    	 alert("아이디는 5~25자의 영문소문자,숫자만 사용가능합니다.");
         $("#mberId").focus();
         return false;
     }
     return true;
}
function f_checkPw(){

	var str = $("#password").val();

	//var pattern1 = /[0-9]/;	// 숫자
	//var pattern2 = /[a-zA-Z]/;	// 문자
	//var pattern3 = /[~!@#$%^&*()_+|<>?:{}]/; // 특수문자
	var RegEx = /^(?=.*?[a-zA-Z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,25}$/;

	if(!RegEx.test(str)) {
		alert("패스워드는 5~20자의 영문소문자,숫자,특수문자 #?!@$%^&*- 모두 포함해야합니다.");
		 $("#password").focus();
		return false;
	}
 	if(str.search(/\s/) != -1) {
  	    alert('비밀번호에 공백을 사용하실 수 없습니다.');
		return false;
	}
    if(/(\w)\1\1\1/.test(str)){
        alert('비밀번호에 같은 문자를 4번 이상 사용하실 수 없습니다.');
        return false;
    }
    if($("#password").val().search($("#mberId").val())>-1){
        alert('ID가 포함된 비밀번호는 사용하실 수 없습니다.');
        return false;
    }
     return true;
}


$(function() {

	 $("#mberId").keyup(function(){
	    	$('#mberIdCheck').val('N');
	 });

	$.validator.addMethod("mberIdCheck", function (value, element, params) {
		var mngrIdCheck = $("#mberIdCheck").val();
		if(mngrIdCheck == "Y"){
			return true;
		}else{
			return false;
		}
	}, $.validator.format("{0}"));
	
	$.validator.addMethod("passwordCk",  function( value, element ) {
		return this.optional(element) ||  /^.*(?=.*\d)(?=.*[a-zA-Z])(?=.*[!@#$%^&+=]).*$/.test(value);
	});

	$("form[name=frmRegister]").validate({
		ignore: "input[type='text']:hidden",
	 	rules: {
			mberId     : { required:true, minlength: 5, maxlength:25},
			mberIdCheck: { required:true,  mberIdCheck:true},
			password   : { required:true, minlength: 8, maxlength:25, passwordCk : true},
			rePassword : { required:false, equalTo:"#password" },
			mberNm     : { required:true}
		},
		messages: {
			mberId     : { required: "아이디를 입력해 주십시요", minlength: jQuery.validator.format("{0}자 이상 입력해 주십시요"), maxlength: jQuery.validator.format("{0}자 이하로 입력해 주십시요")},
			mberIdCheck: { required: "아이디 중복확인을해 주십시요", mberIdCheck : "아이디 중복확인을해 주십시요"},
			password   : { required: "비밀번호를 입력해 주십시요", minlength: jQuery.validator.format("{0}자 이상 입력해 주십시요"), 
						   maxlength: jQuery.validator.format("{0}자 이하로 입력해 주십시요"), passwordCk : "비밀번호는 영문자, 숫자, 특수문자 조합을 입력해야 합니다."},
			rePassword : { required: "비밀번호 확인을 입력해 주십시요", equalTo: "비밀번호가 일치하지 않습니다." },
			mberNm     : { required: "이름을 입력해 주십시오"}
		},
		submitHandler: function (frm) {
			// 아이디 유효성체크
			if(f_checkId()){
				frm.submit();
			}
		}
	});
});

</script>

<div class="row">
	<div class="col-md-12">
		<div class="col-sm-11">
			<div class="featured-box featured-box-primary align-left mt-xlg">
				<div class="box-content">
					<h4 class="heading-primary text-uppercase mb-md">회원가입</h4>
					<form action="./registerAction" id="frmRegister" name="frmRegister" method="post">
						<input type="hidden" id="crud" name="crud" value="${crud}">
						<input type="hidden" id="mberIdCheck" name="mberIdCheck" value="N">
						<div class="row">
							<div class="form-group">
								<div class="col-md-12">
									<label>ID *</label>
									<div class ="row">
										<div class="col-md-9">
											<input id="mberId" name="mberId" type="text" maxlength="20" value="" class="form-control input-lg" autocomplete="off">
										</div>
										<div class="col-md-2">
											<span class="btn btn-info btn-lg" onclick="f_mberIdDupCheck(); return false;">중복체크</span>
										</div>
									</div>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="form-group">
								<div class="col-md-6">
									<label>Password *</label>
									<input id="password" name="password"  type="password" maxlength="40" value="" class="form-control input-lg" autocomplete="off">
								</div>
								<div class="col-md-6">
									<label>Re-enter Password *</label>
									<input id="rePassword" name="rePassword" type="password" maxlength="40" value="" class="form-control input-lg" autocomplete="off">
								</div>
							</div>
						</div>
						<div class="row">
							<small><br>주의사항)<br>아이디는 5~25자의 영문소문자, 숫자만 사용가능합니다.
							<br>패스워드는 5~25자의 영문소문자,숫자,특수문자 #?!@$%^&*- 모두 포함해야합니다.</small>
							<hr class="tall">
						</div>
						<h4 class="heading-primary text-uppercase mb-md">회원부가정보</h4>
						<div class="row">
							<div class="form-group">
								<div class="col-md-12">
										<label>이름 *</label>
										<input id="mberNm" name="mberNm"  type="text" maxlength="100" value="" class="form-control input-lg" autocomplete="off">
								</div>
							</div>
						</div>
						<div class="row">
							<div class="form-group">
								<div class="col-md-6">
									<label>연락처</label>
									<input id="telno" name="telno" type="text" maxlength="100" value="" class="form-control input-lg" autocomplete="off">
								</div>
								<div class="col-md-6">
									<label>email</label>
									<input id="email" name="email" type="email" maxlength="100" value="" class="form-control input-lg" autocomplete="off">
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-md-12">
								<input type="submit" value="Register" class="btn btn-primary pull-right mb-xl" data-loading-text="Loading...">
							</div>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
</div>
