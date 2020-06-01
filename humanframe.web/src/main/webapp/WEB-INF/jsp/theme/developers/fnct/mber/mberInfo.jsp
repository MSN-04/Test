<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/taglibs.jsp" %>
<%@ page trimDirectiveWhitespaces="true" %>

<script>

function f_withdraw(){
	//탈퇴
	if(confirm("탈퇴시 모든 개인정보가 삭제됩니다.\n삭제하시겠습니까?")){
		$('#frmMberInfo > #crud2').val("DELETE");
		$("#frmMberInfo").submit();
	}
}

function f_checkPw(){

	var str = $("#password").val();

	var pattern1 = /[0-9]/;
	var pattern2 = /[a-zA-Z]/;
	var pattern3 = /[~!@#$%^&*()_+|<>?:{}]/;

	if(!pattern1.test(str) || !pattern2.test(str) || !pattern3.test(str) || str.length < 8) {
		alert("비밀번호는 8자리 이상 문자, 숫자, 특수문자로 구성하여야 합니다.");
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

	$.validator.addMethod("mberIdCheck", function (value, element, params) {
		var mngrIdCheck = $("#mberIdCheck").val();
		if(mngrIdCheck == "Y"){
			return true;
		}else{
			return false;
		}
    }, $.validator.format("{0}"));

	$("form[name=frmPassword]").validate({
		ignore: "input[type='text']:hidden",
		rules: {
			nowPassword:{ required: true, minlength: 4, maxlength:20 },
			password:{ required: true, minlength: 8, maxlength:20 },
			rePassword:{ required: false, equalTo: "#password" },
		},
		messages: {
			nowPassword:{ required: "현재 비밀번호를 입력해 주십시요", minlength: jQuery.validator.format("{0}자 이상 입력해 주십시요"), maxlength: jQuery.validator.format("{0}자 이하로 입력해 주십시요")},
			password:{ required: "새 비밀번호를 입력해 주십시요", minlength: jQuery.validator.format("{0}자 이상 입력해 주십시요"), maxlength: jQuery.validator.format("{0}자 이하로 입력해 주십시요")},
			rePassword:{ required: "새 비밀번호 확인을 입력해 주십시요", equalTo: "새 비밀번호가 일치하지 않습니다." },
		},
	  	submitHandler: function (frm) {
	  		if(f_checkPw()){
	  			frm.submit();
	  		}
		}
	});

	$("form[name=frmMberInfo]").validate({
		ignore: "input[type='text']:hidden",
		rules: {
			mberNm: { required: true}
		},
		messages: {
			mberNm: { required: "이름을 입력해 주십시오"}
		},
		submitHandler: function (frm) {
			frm.submit();
		}
	});


});

</script>

<div class="row">
	<div class="col-md-12">
		<div class="col-sm-6">
			<div class="featured-box featured-box-primary align-left mt-xlg">
				<div class="box-content">
					<h4 class="heading-primary text-uppercase mb-md">회원정보</h4>
						<form action="./changePasswd" id="frmPassword" name="frmPassword" method="post">
							<input type="hidden" id="crud1" name="crud" value="${mberVO.crud}">
							<input type="hidden" id="uniqueId1" name="uniqueId" value="${mberVO.uniqueId}">
							<div class="row">
								<div class="form-group">
									<div class="col-md-12">
										<label>ID </label>
										<div class ="row">
											<div class="col-md-8">
												<input id="mberId" name="mberId" type="text" maxlength="20" value="${mberVO.mberId}" autocomplete="off" class="form-control input-lg" readonly="readonly">
											</div>
										</div>
									</div>
								</div>
							</div>
							<div class="row">
								<div class="form-group">
									<div class="col-md-12">
										<label>Password *</label>
										<input id="nowPassword" name="nowPassword"  type="password" autocomplete="off" maxlength="40" value="" class="form-control input-lg">
									</div>
								</div>
							</div>
							<div class="row">
								<div class="form-group">
									<div class="col-md-6">
										<label>Change Password *</label>
										<input id="password" name="password"  type="password" autocomplete="off" maxlength="40" value="" class="form-control input-lg">
									</div>
									<div class="col-md-6">
										<label>Re-enter Change Password *</label>
										<input id="rePassword" name="rePassword" type="password" autocomplete="off" maxlength="40" value="" class="form-control input-lg">
									</div>
								</div>
							</div>
							<div class="row">
								<div class="col-md-12">
									<input type="submit" value="비밀번호변경" class="btn btn-primary pull-right mb-xl" data-loading-text="Loading...">
								</div>
							</div>
						</form>
						<div class="row">
							<hr class="tall">
						</div>

						<h4 class="heading-primary text-uppercase mb-md">회원부가정보</h4>
						<form action="./registerAction" id="frmMberInfo" name="frmMberInfo" method="post">
							<input type="hidden" id="mberId2" name="mberId" value="${mberVO.mberId}">
							<input type="hidden" id="crud2" name="crud" value="${mberVO.crud}">
							<input type="hidden" id="uniqueId2" name="uniqueId" value="${mberVO.uniqueId}">
							<div class="row">
								<div class="form-group">
									<div class="col-md-12">
											<label>이름 *</label>
											<input id="mberNm" name="mberNm"  type="text" maxlength="100" value="${mberVO.mberNm}" class="form-control input-lg">
									</div>
								</div>
							</div>
							<div class="row">
								<div class="form-group">
									<div class="col-md-6">
										<label>연락처</label>
										<input id="telno" name="telno" type="text" maxlength="100" autocomplete="off" value="${mberVO.telno}" class="form-control input-lg">
									</div>
									<div class="col-md-6">
										<label>email</label>
										<input id="email" name="email" type="email" maxlength="100" autocomplete="off" value="${mberVO.email}" class="form-control input-lg">
									</div>
								</div>
							</div>
							<div class="row">
								<div class="col-md-6">
									<input type="button" value="회원탈퇴" class="btn btn-danger pull-lift mb-xl" onclick="f_withdraw(); return false;">
								</div>
								<div class="col-md-6">
									<input type="submit" value="회원정보수정" class="btn btn-primary pull-right mb-xl" data-loading-text="Loading...">
								</div>
							</div>
						</form>
				</div>
			</div>
		</div>
	</div>
</div>
