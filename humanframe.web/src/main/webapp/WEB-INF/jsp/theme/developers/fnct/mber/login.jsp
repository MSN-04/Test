<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/taglibs.jsp" %>
<%@ page trimDirectiveWhitespaces="true" %>

	<script>
	  // 쿠키 생성
    function setCookie(cName, cValue, cDay){
        var expire = new Date();
        expire.setDate(expire.getDate() + cDay);
        cookies = cName + '=' + escape(cValue) + '; path=/ ';
        if(typeof cDay != 'undefined') cookies += ';expires=' + expire.toGMTString() + ';';
        document.cookie = cookies;
    }

    // 쿠키 가져오기
    function getCookie(cName) {
        cName = cName + '=';
        var cookieData = document.cookie;
        var start = cookieData.indexOf(cName);
        var cValue = '';
        if(start != -1){
            start += cName.length;
            var end = cookieData.indexOf(';', start);
            if(end == -1)end = cookieData.length;
            cValue = cookieData.substring(start, end);
        }
        return unescape(cValue);
    }

    function fn_saveId(){
    	if($("input:checkbox[name='rememberme']").is(":checked")){
    		 setCookie("mberSaveId", $("#mberId").val(), 30);
    	} else {
    		setCookie("mberSaveId", '', -1);
    	}
    }

    function fn_setSaveId(){
    	if( getCookie("mberSaveId") != ""){
    		$("#mberId").val(getCookie("mberSaveId"));
			$("#rememberme").prop("checked", true);
   		}
    }

	$(function() {

		fn_setSaveId();

    	$("form[name='frmLogin']").validate({
		    ignore: "input[type='text']:hidden",
		    rules : {
		    	mberId		: { required : true},
		    	password	: { required : true}
		    },
		    messages : {
		    	mberId		: { required : "아이디를 입력하세요"},
		    	password	: { required : "비밀번호를 입력하세요"},
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
		    	fn_saveId();
		    	frm.submit();
		    }
		});
    });
     </script>

<div class="row">
	<div class="col-md-12">

		<div class="featured-boxes">
			<div class="row">
				<div class="col-sm-12"  style="width: 50%;" >
					<div class="featured-box featured-box-primary align-left mt-xlg">
						<div class="box-content">
							<h4 class="heading-primary text-uppercase mb-md">LOGIN</h4>
							<form action="./loginAction" id="frmLogin" name="frmLogin" method="post">
								<div class="row">
									<div class="form-group">
										<div class="col-md-12">
											<label>ID</label>
											<input id="mberId" name="mberId"  type="text" value="" class="form-control input-lg" autocomplete="off">
										</div>
									</div>
								</div>
								<div class="row">
									<div class="form-group">
										<div class="col-md-12">
											<!-- <a class="pull-right" href="#">(Lost Password?)</a> -->
											<label>Password</label>
											<input id="password" name="password" type="password" value="" class="form-control input-lg" autocomplete="off">
										</div>
									</div>
								</div>
								<div class="row">
									<div class="col-md-6">
										<span class="remember-box checkbox">
											<label for="rememberme">
												<input type="checkbox" id="rememberme" name="rememberme" >Remember Me
											</label>
										</span>
									</div>
									<div class="col-md-6">
										<input type="submit" value="Login" class="btn btn-primary pull-right mb-xl" data-loading-text="Loading...">
									</div>
								</div>
							</form>
						</div>
					</div>
				</div>
			</div>

		</div>
	</div>
</div>