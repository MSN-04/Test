\<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ include file="/common/taglibs.jsp" %>
<c:set var="globalAdminAssets" value="/humanframe/admin/assets" />
<!doctype html>
<html lang="kr" class="fixed">
<head>
	<!-- Basic -->
    <meta charset="utf-8">

	<!-- Mobile Metas -->
	<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />

	<!-- Vendor CSS -->
	<link rel="stylesheet" href="${globalAdminAssets}/vendor/bootstrap/css/bootstrap.css" />

	<link rel="stylesheet" href="${globalAdminAssets}/vendor/font-awesome/css/font-awesome.css" />
	<link rel="stylesheet" href="${globalAdminAssets}/vendor/magnific-popup/magnific-popup.css" />
	<link rel="stylesheet" href="${globalAdminAssets}/vendor/bootstrap-datepicker/css/bootstrap-datepicker3.css" />

	<!-- Theme CSS -->
	<link rel="stylesheet" href="${globalAdminAssets}/stylesheets/theme.css" />

	<!-- Skin CSS -->
	<link rel="stylesheet" href="${globalAdminAssets}/stylesheets/skins/default.css" />

	<!-- Theme Custom CSS -->
	<link rel="stylesheet" href="${globalAdminAssets}/stylesheets/theme-custom.css">

	<!-- Head Libs -->
	<script src="${globalAdminAssets}/vendor/modernizr/modernizr.js"></script>
	
	
	<!-- Vendor -->
	<script src="${globalAdminAssets}/vendor/jquery/jquery.js"></script>
	<script src="${globalAdminAssets}/vendor/jquery-browser-mobile/jquery.browser.mobile.js"></script>
	<script src="${globalAdminAssets}/vendor/bootstrap/js/bootstrap.js"></script>
	<script src="${globalAdminAssets}/vendor/nanoscroller/nanoscroller.js"></script>
	<script src="${globalAdminAssets}/vendor/bootstrap-datepicker/js/bootstrap-datepicker.js"></script>
	<script src="${globalAdminAssets}/vendor/magnific-popup/jquery.magnific-popup.js"></script>
	<script src="${globalAdminAssets}/vendor/jquery-placeholder/jquery-placeholder.js"></script>

	<script src="${globalAdminAssets}/vendor/jquery.validate.min.js"></script>
	<script src="${globalAdminAssets}/vendor/jquery-cookie/jquery-cookie.js"></script>


	<!-- Theme Base, Components and Settings -->
	<script src="${globalAdminAssets}/javascripts/theme.js"></script>

	<!-- Theme Custom -->
	<script src="${globalAdminAssets}/javascripts/theme.custom.js"></script>

	<!-- Theme Initialization Files -->
	<script src="${globalAdminAssets}/javascripts/theme.init.js"></script>

	<!-- Custom -->
 	<script src="${globalAdminAssets}/javascripts/custom/human.custom.class.js"></script>
 	<script src="${globalAdminAssets}/javascripts/custom/human.function.js"></script>
 	<script src="${globalAdminAssets}/javascripts/custom/human.call.cms.func.js"></script>
 	<script src="${globalAdminAssets}/javascripts/custom/jquery.validation.rule.js"></script>
 	<script>

 	//아이디 중복확인
	function f_mngrIdCheck(){
		if ($("#mngrId").val() != ""){
			if(f_checkId()){
				$.ajax({
					type : "post",
					url: '/admin/ajax/mngrIdCheck',
					data: 'mngrId=' + $("#mngrId").val(),
					dataType: 'text', //전송받을 데이터의 타입
					contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
					success: function(data) {
						if(data=="true"){
							$("#mngrIdCheck").val("Y");
							$("#mngrIdCheck-error").remove();
							alert("사용할수 있는 아이디 입니다.");
						}else{
							$("#mngrIdCheck").val("N");
							alert("이미 사용중인 아이디 입니다.");
						}
					},
					error: function(data, status, err) {
					}
				});
			}
		}else{
			alert("사용하실 아이디를 입력해 주십시요.");
		}
	}

	//직원검색>>부서코드|부서명|직원코드|직원명이 들어갈 id를 지정
	function f_empSrch(){
		var target ="deptCode|deptNm|empCode|mngrNm";
		window.open("/admin/ajax/popup/empList?se=R&target="+target, "popEmp", "width=780, height=525");
	}

	function f_empSrch_callback(){
		 $("#deptNm-error").remove();
	}

	function f_checkId(){
		 var RegEx = /([a-z0-9]){5,25}$/;

	     if(!RegEx.test( $("#mngrId").val())) {
	         alert("아이디는 5~20자의 영문소문자,숫자만 사용가능합니다.");
	         $("#mberId").focus();
	         return false;
	     }
	     return true;
	}



	$(function() {
		 $("#mngrId").keyup(function(){
		    	$('#mngrIdCheck').val('N');
		 });

		$.validator.addMethod("mngrIdCheck", function (value, element, params) {
			var mngrIdCheck = $("#mngrIdCheck").val()
			if(mngrIdCheck == "Y"){
				return true;
			}else{
				return false;
			}
	    }, $.validator.format("{0}"));
		
		$.validator.addMethod("passwordCk",  function( value, element ) {
			return this.optional(element) ||  /^.*(?=.*\d)(?=.*[a-zA-Z])(?=.*[!@#$%^&+=]).*$/.test(value);
		});

		$("form[name=frmMngr]").validate({
			ignore: "input[type='text']:hidden",
			rules: {
				deptNm:{ required: true },
				mngrId: { required: true},
				mngrIdCheck: { required: true,  mngrIdCheck : true},
				mngrPassword:{ required: true, passwordCk : true, minlength: 8, maxlength:20 },
				mngrPassword1:{ required: true, equalTo: "#mngrPassword" }
			},
			messages: {
				deptNm: { required: "담당자를 선택해 주십시요"},
				mngrId: { required: "아이디를 입력해 주십시요"},
				mngrIdCheck: { required: "아이디 중복확인을해 주십시요",  mngrIdCheck : "아이디 중복확인을해 주십시요"},
				mngrPassword:{ required: "비밀번호를 입력해 주십시요", passwordCk : "비밀번호는 영문자, 숫자, 특수문자 조합을 입력해야 합니다.",
							   minlength: jQuery.validator.format("{0}자 이상 입력해 주십시요"), maxlength: jQuery.validator.format("{0}자 이하로 입력해 주십시요")},
				mngrPassword1:{ required: "비밀번호 확인을 입력해 주십시요", equalTo: "비밀번호가 일치하지 않습니다." }
			},
			submitHandler: function (frm) {
				// 아이디,패스워드 유효성체크
				frm.submit();
			}
		});
		
		
    });
    </script>
	
	
	
 	<title>홍익인간 CMS</title>

</head>
<body style="background-color:#c7c7c7;">

    <!-- start: page -->
	<section class="body-sign">
		<div class="center-sign">
			<a href="/" class="logo pull-left">
				<img src="${globalAdminAssets}/images/top_logo.png" alt="Humanframe" style="margin-top: 25px;"/>
			</a>

			<div class="panel panel-sign">
				<div class="panel-title-sign mt-xl text-right">
					<h2 class="title text-uppercase text-weight-bold m-none"><i class="fa fa-user mr-xs"></i> 계정신청</h2>
				</div>
				<div class="panel-body">
					<form name="frmMngr" id="frmMngr" action="/admin/loginMngrReqAction" method="post">
						<div class="form-group">
							<label>아이디</label>
							<input type="text" id="mngrId" name="mngrId" class="form-control input-lg" autocomplete="off"/>
							<button class="mb-xs mt-xs mr-xs btn btn-warning btn-sm btn-block" id="mngrId_checker" onclick="f_mngrIdCheck(); return false;">중복확인</button>
							<input type="hidden" id="mngrIdCheck" name="mngrIdCheck" value="N"	/>
						</div>
						<div class="form-group mb-lg">
							<label>부서</label>
							<input type="hidden" id="deptCode" name="deptCode" />
							<input type="text" id="deptNm" name="deptNm" class="form-control input-lg" readonly="readonly" value="${mngrVO.deptNm }"/>
							<button class="mb-xs mt-xs mr-xs btn btn-warning btn-sm btn-block" id="dept_checker" onclick="f_empSrch(); return false;">직원검색</button>
						</div>
						<div class="form-group mb-lg">
							<label>이름</label>
							<input type="hidden" id="empCode" name="empCode" />
							<input type="text" id="mngrNm" name="mngrNm" class="form-control input-lg" readonly="readonly" />
						</div>
						<div class="form-group mb-none">
							<div class="row">
								<div class="col-sm-6 mb-lg">
									<label>패스워드</label>
									<input type="password" id="mngrPassword" name="mngrPassword" class="form-control input-lg" autocomplete="off"/>
								</div>
								<div class="col-sm-6 mb-lg">
									<label>패스워드 확인</label>
									<input type="password" name="mngrPassword1" id="mngrPassword1" class="form-control input-lg" autocomplete="off"/>
								</div>

							</div>
						</div>
						<div class="row">
							<div class="col-sm-8">
								<div class="checkbox-custom checkbox-default">
									<!-- <input id="AgreeTerms" name="agreeterms" type="checkbox"/>
									<label for="AgreeTerms">I agree with <a href="#">terms of use</a></label> -->
								</div>
							</div>
							<div class="col-sm-4 text-right">
								<button type="submit" class="btn btn-primary hidden-xs">계정 신청</button>
	                    		<double-submit:preventer/>
							</div>
							<small>주의사항)<br>아이디는 5~25자의 영문소문자, 숫자만 사용가능합니다.
							<br>패스워드는 8~20자의 영문소문자,숫자,특수문자 #?!@$%^&*- 모두 포함해야합니다.</small>
						</div>

						<span class="mt-lg mb-lg line-thru text-center text-uppercase" >
							<span>or</span>
						</span>
						<p class="text-center">Already have an account? <a href="/admin/login">로그인페이지 GO!</a></p>
					</form>
				</div>
			</div>
		</div>
		</section>


	
</body>
</html>
