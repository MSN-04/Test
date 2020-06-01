<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/taglibs.jsp" %>
<%@ page trimDirectiveWhitespaces="true" %>

	<script type="text/javascript">
	$(function() {

		$("form[name='privacyFrm']").validate({
		    ignore: "input[type='text']:hidden",
		    rules : {
		    	nm : {required : true}
    			, email : {required : true, email : true}
    			, telno : {required : true, isNumber : true}
    			, address : {required : true}
    			, consent : {required : true}
		    },
		    messages : {
		    	nm		: { required : "이름을 입력하세요."},
		    	email : { required : "이메일을 입력하세요.", email : "이메일 형식에 맞지 않습니다." },
		    	telno : { required : "전화번호를 입력하세요.", isNumber : "전화번호는 유효하지 않은 값입니다."},
		    	address : { required : "주소를 입력하세요."},
		    	consent : {required : "개인정보 수집 및 이용안내에 대한 동의를 체크 해주세요."}
		    },
		    errorElement: 'span',
		    errorClass: 'help-block error',
		    errorPlacement: function(error, element) {
		    	if(element.context.type == "radio"){
		    		error.insertAfter(element.parent().parent().find(':last'));
		    	}else{
	    			error.insertAfter(element.parent().find(':last'));
		    	}
			},
		    highlight:function(element, errorClass, validClass) {
		        $(element).addClass('error');
		    },
		    unhighlight: function(element, errorClass, validClass) {
		        $(element).removeClass('error');
		    },
		    submitHandler: function (frm) {
		    	if(confirm("입력하신 정보를 저장 하시겠습니까?")){
		    		if ("${sessionScope.HUMAN_MEMBER}" == "" && "${qestnarVO.qustnrTrget}" == "Y") {
	    				alert("회원 로그인 후 설문참여가 가능합니다.");
	    				location.href = "/member/login";
		    		} else if ("${sessionScope.HUMAN_AUTH}" == "" && "${sessionScope.HUMAN_MEMBER}" == ""  && "${qestnarVO.qustnrTrget}" == "N") {
	    				alert("회원 및 비회원 로그인 후 설문참여가 가능합니다.");
	    				location.href = "/member/login";
		    		} else {
		    			frm.submit();
		    		}
		    	}else{
		    		return false;
		    	}
		    }
		});
		jQuery.validator.addMethod("isNumber", function(value, element) {
	        var tel = /^((01[1|6|7|8|9])[1-9]+[0-9]{6,7})|(010[1-9][0-9]{7})$/;
	        var tel = /^(01[016789]{1}|02|0[3-9]{1}[0-9]{1})-?[0-9]{3,4}-?[0-9]{4}$/;
	        if(this.optional(element) || (tel.test(value))){
	        	trans_num = value.replace(/^(01[016789]{1}|02|0[3-9]{1}[0-9]{1})-?([0-9]{3,4})-?([0-9]{4})$/, "$1-$2-$3");
	        	$("#contactNumber").val(trans_num);
	        }
	        return this.optional(element) || (tel.test(value));
	    }, "잘못된 전화번호입니다. 숫자, - 를 포함한 숫자만 입력하세요. 예) 050-XXXX-XXXX");

	});

	function jusoPopup(){
		document.domain = "busan.go.kr";
	    var pop = window.open("/comm/searchAddress","pop","width=570,height=420, scrollbars=yes, resizable=yes");
	}

	function fn_jusoCallBack(roadFullAddr,roadAddrPart1,addrDetail,roadAddrPart2,engAddr, jibunAddr, zipNo){
		$('#address').val('('+zipNo+') '+roadAddrPart1+' '+roadAddrPart2 + ' ' + addrDetail);
	}
	</script>

<form id="privacyFrm" name="privacyFrm" method="post" action="${baseUri }/${curMenuVO.menuUri }/apply">
	<div class="panel-body">
		<div class="featured-box featured-box-primary align-left mt-xlg">
			<div class="box-content shop">
				<input type="hidden" name="qestnarNo" value="${param.qestnarNo}" />
				<input type="hidden" name="qustnrTrget" value="${qestnarVO.qustnrTrget}" />
				<div class="form-group">
					<h4 class="form-data-subject">${qestnarVO.sj }</h4>
				</div>
				<div class="form-group">
					<dl class="form-data-info">
						<dt><span>설문기간</span></dt>
						<dd>${qestnarVO.bgnDttm} ~ ${qestnarVO.endDttm}</dd>
					</dl>
				</div>
				<div class="form-group">
					<dl class="form-data-info">
						<dt><span><label for="nm">성명<span class="nbTxtTbRequired">*<span class="hidden">필수입력사항</span></span></label></span></dt>
						<dd><input type="text" id="nm" name="nm" class="form-control" title="성명" value="${mberVO.mberNm}"/></dd>
						<dt><span><label for="email">이메일<span class="nbTxtTbRequired">*<span class="hidden">필수입력사항</span></span></label></span></dt>
						<dd><input type="text" id="email" name="email" class="form-control" placeholder="예) tester@busan.go.kr" title="E-mail" value="${mberVO.email}"/></dd>
					</dl>
				</div>
				<div class="form-group">
					<dl class="form-data-info">
						<dt><span><label for="telno">전화번호<span class="nbTxtTbRequired">*<span class="hidden">필수입력사항</span></span></label></span></dt>
						<dd><input type="text" id="telno" name="telno" class="form-control" placeholder="예) 02-123-4567" title="전화번호"  value="${mberVO.telno}" /></dd>
					</dl>
				</div>
				<%--
				<div class="form-group">
					<dl class="form-data-info">
						 <dt><span><label for="address">주소<span class="nbTxtTbRequired">*<span class="hidden">필수입력사항</span></span></label></span></dt>
						<dd>
							<input type="text" id="address" name="address" class="form-control" title="주소" value="${mberVO.adres}" />
							<!-- <a href="javascript:void();" class="btnTypeM btnColorType2" onclick="javascript:jusoPopup(); return false;"><strong>주소검색</strong></a> -->
						</dd>
					</dl>
				</div> --%>
				<div class="form-group">
					<dl class="form-data-content" id="trContent">
						<dt><span>내용</span></dt>
						<dd>
							1. 개인정보의 수집&middot;이용 목적<br/>&nbsp;- 설문조사 추첨 이외의 다른 어떤 용도로도 사용되지 않습니다.<br/>
							2. 수집항목<br/>&nbsp;- 필수항목 : 참여자 아이디, 성명, 연락처<br/>&nbsp;- 선택항목 : 해당 없음<br/>
							3. 개인정보의 보유 및 이용기간 : 2주<br/>4. 동의거부 권리알림<br/>&nbsp;- 동의거부 시 설문조사에 참여하실 수 없습니다.
						</dd>
					</dl>
				</div>

				<div class="form-group">
					<p class="copyright"><input type="checkbox" id="consent" name="consent" value="Y"/>&nbsp;위 개인정보 수집 및 이용에 동의 합니다.</p>
				</div>

			</div>
		</div>
	</div>

	<div class="col-md-6" style="float: right; text-align: right;">
		<p>
		<a href="./list?srchSttus=${param.srchSttus}" class="btn btn-default mr-xs mb-sm" title="<spring:message code='button.list' />"><spring:message code='button.list' /></a>
		<c:if test="${qestnarVO.progrsSttus eq 'ING' }">
			<button class="btn btn-primary mr-xs mb-sm">저장하기</button>
			<%-- <a href="#none" class="btn btn-primary mr-xs mb-sm" onclick="f_moveParam('${param.qestnarNo}','${qestnarVO.qustnrTrget}');return false;">설문 참여하기</a> --%>
			<!--<a href="#none" class="btn btn-primary mr-xs mb-sm" onclick="f_auth();return false;">설문 참여하기</a> -->
		</c:if>
		</p>
	</div>

</form>
