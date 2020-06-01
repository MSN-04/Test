<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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
	
	<script type="text/javascript" src="${globalAdminAssets}/rsa/jsbn.js"></script>
	<script type="text/javascript" src="${globalAdminAssets}/rsa/rsa.js"></script>
	<script type="text/javascript" src="${globalAdminAssets}/rsa/prng4.js"></script>
	<script type="text/javascript" src="${globalAdminAssets}/rsa/rng.js"></script>

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
					<h2 class="title text-uppercase text-weight-bold m-none"><i class="fa fa-user mr-xs"></i> Login</h2>
				</div>
				<div class="panel-body">
					<form name="frmLogin" id="frmLogin" action="/admin/loginAction" method="post">
					<%-- <input type="hidden" id="rsaPublicKeyModulus" value="${publicKeyModulus}">
					<input type="hidden" id="rsaPublicKeyExponent" value="${publicKeyExponent}"> --%>
					<input type="hidden" id="encPw" name="encPw" value="">
					
					<input type="hidden" id="dupInfo" name="dupInfo" value="" />
						<div class="form-group mb-lg">
							<label>아이디</label>
							<div class="input-group input-group-icon">
								<input id="loginId" name="loginId" type="text" maxlength="40" class="form-control input-lg" autocomplete="off"/>
								<span class="input-group-addon">
									<span class="icon icon-lg">
										<i class="fa fa-user"></i>
									</span>
								</span>
							</div>
						</div>

						<div class="form-group mb-lg">
							<div class="clearfix">
								<label class="pull-left">패스워드</label>
							</div>
							<div class="input-group input-group-icon">
								<input id="loginPassword" name="loginPassword" type="password" autocomplete="off" maxlength="40" class="form-control input-lg" />
								<span class="input-group-addon">
									<span class="icon icon-lg">
										<i class="fa fa-lock"></i>
									</span>
								</span>
							</div>
						</div>

						<div class="row">
							<div class="col-sm-8">
								<div class="checkbox-custom checkbox-default">
									<input id="saveId" name="saveId" type="checkbox" value="Y" />
									<label for="saveId">아이디 저장</label>
								</div>
							</div>
							<div class="col-sm-4 text-right">
								<button type="submit" class="btn btn-primary hidden-xs">Login</button>
								<button type="submit" class="btn btn-primary btn-block btn-lg visible-xs mt-lg">Login</button>
							</div>
						</div>

 						<span class="mt-lg mb-lg line-thru text-center text-uppercase">
							<span>or</span>
						</span>
						<p class="text-center"><a href="/admin/loginMngrReq">담당자 계정 신청</a>	</p>
					</form>
				</div>
			</div>
		</div>

	</section>
	<!-- end: page -->

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

	function f_dupInfo(){
		//window.open("gpin인증서", "gpin", "");
		//return받아서 채워준후 action

		if($("#dupInfo").val() == ""){
			alert("인증서를 선택하세요\n테스트중(재시도시 로그인됨)");
			$("#dupInfo").val("test");
		}else{
			$("#frmLogin").validate().cancelSubmit = true;
			$("#frmLogin").submit();
		}
	}

	function gpkiPop(){
	   alert("공인인증서 사용시 연결");
	   return false;
		//var pop = window.open("${globalsitedomain}/comm/gpki/request","pop","width=390,height=460, scrollbars=no, resizable=yes, location=no, toolbar=no");
	}

	function gpkiCallBack(dupInfo){
		$("#dupInfo").val(dupInfo);
		$("#frmLogin").validate().cancelSubmit = true;
		$("#frmLogin").submit();
	}
	
	function fnRsaEnc(value, rsaPublicKeyModulus, rsaPpublicKeyExponent) {
	    var rsa = new RSAKey();
	    rsa.setPublic(rsaPublicKeyModulus, rsaPpublicKeyExponent);
	    var encValue = rsa.encrypt(value);
	    return encValue;
	}

	$(function() {

    	$.cookie("menuNo", null, {path:"/"});

    	<c:if test="${!empty saveId}">
		$("#userId").val("${saveId}");
		$("#saveId").prop("checked", true);
		</c:if>

    	$("form[name='frmLogin']").validate({
		    ignore: "input[type='text']:hidden",
		    rules : {
		    	loginId		: { required : true},
		    	loginPassword	: { required : true}
		    },
		    messages : {
		    	loginId		: { required : "아이디를 입력하세요"},
		    	loginPassword	: { required : "비밀번호를 입력하세요"},
		    },
		    errorElement: 'span',
		    errorClass: 'help-block error',
		    highlight:function(element, errorClass, validClass) {
		        $(element).addClass('error');
		    },
		    unhighlight: function(element, errorClass, validClass) {
		        $(element).removeClass('error');
		    },
		    submitHandler: function (frm) {
		    	/* var rsaPublicKeyModulus = document.getElementById("rsaPublicKeyModulus").value;
		    	var rsaPublicKeyExponent = document.getElementById("rsaPublicKeyExponent").value;
		    	var encPassword = fnRsaEnc(document.getElementById("loginPassword").value, rsaPublicKeyModulus, rsaPublicKeyExponent);		    
		    	$("#encPw").val(encPassword);	 */			
		    	frm.submit();
		    }
		});
    });
    </script>
</body>
</html>
