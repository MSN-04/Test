<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/taglibs.jsp" %>
<%@ page trimDirectiveWhitespaces="true" %>

	<script type="text/javascript">
	$(function(){
		f_reset();
	});
	function f_send(){
		var sj = $("#sj").val();
		var cn = $("#cn").val();
		var email = $("#email").val();

	    if(sj == ""){
	    	alert("제목을 입력해주세요");
	    	$("#sj").focus();
	        return;
	    }
	    if(email == ""){
	    	alert("이메일을 입력해주세요");
	    	$("#email").focus();
	    	return;
	    }
	    if(cn == ""){
	    	alert("문의내용을 입력해주세요");
	    	$("#cn").focus();
	    	return;
	    }

	    if(!f_checkInput()){
    		return
    	}

	    if(confirm("문의하시겠습니까?")){
	    	$("#frmPrjctInqry").submit();
    	}else{
    		return false;
    	}
	}

	function f_reset(){
		$("#frmPrjctInqry")[0].reset();
		$("#upload-name").html("");
	}

	function f_checkInput(){
		var email = $("#email").val();
		var regExp  = /^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*.[a-zA-Z]{2,3}$/i;
	    if(email.match(regExp) == null){
	    	alert("이메일 형식이 잘못되었습니다.");
	    	$("#email").focus();
	        return false;
	    }
	     return true;
	}
	function f_FileCheck(obj) {

		if(window.FileReader){ // modern browser
			var filename = obj.files[0].name;
		} else {// old IE
			var filename = $("#attachFile").val().split('/').pop().split('\\').pop(); // 파일명만 추출
		}
		$("#upload-name").html(filename);

		if(obj.value != ""){

			/* 첨부파일 사이즈 체크*/
			var uploadFileSize = 0;
			var limitSize = 1024;

			if($.browser.msie){
				var objFSO = new ActiveXObject("Scripting.FileSystemObject");
				var sPath = obj.value;
				var objFile = objFSO.getFile(sPath);
				uploadFileSize = objFile.size/ 1024;
			}else {
				uploadFileSize = (obj.files[0].size / 1024);
			}

			//메가바이트(MB)단위 변환
			uploadFileSize = (Math.round((uploadFileSize / 1024) * 100) / 100);

			if(limitSize != 0 && uploadFileSize > limitSize){
				alert("<spring:message code='errors.exceed.limit' arguments='" + uploadFileSize + ";" + limitSize + "' argumentSeparator=';'/>");
				obj.value = "";
				return false;
			}
			/* 첨부파일 사이즈 체크*/
		}

	}
	</script>

	<form name="frmPrjctInqry" id="frmPrjctInqry" method="post" enctype="multipart/form-data" action="/fnct/prjctInqry/action">
	<!-- <input type="hidden" id="delAttachFileNo" name="delAttachFileNo" value="" /> -->
	<input type="hidden" id="siteNo" name="siteNo" value="${curSiteVO.siteNo}" />
	<input type="hidden" id="siteNm" name="siteNm" value="${curSiteVO.siteNm}" />


	<div class="deemed">

	</div>
	<div id="project-question">
		<div class="popup-box">
			<h5>프로젝트 문의</h5>
			<div class="form">
				<fieldset>
					<legend>프로젝트 문의 작성 폼</legend>
					<label for="sj">제목</label> <input type="text" id="sj" name="sj"  class="w100">
					<hr>
					<label for="cmpnyNm">회사명</label> <input type="text" id="cmpnyNm" name="cmpnyNm" >
					<hr>
					<label for="url">URL</label> <input type="text" id="url" name="url">
					<hr>
					<label for="chargerNm">담당자</label> <input type="text" id="chargerNm" name="chargerNm">
					<hr>
					<label for="chargerDept">담당부서</label> <input type="text" id="chargerDept" name="chargerDept" >
					<hr>
					<label for="p-email">E-mail</label> <input type="text" id="email" name="email" >
					<hr>
					<label for="email">연락처</label> <input type="text" id="tel" name="tel" >
					<hr>
					<label for="p-budget">예산</label>
					<select id="budget" name="budget" title="예산" >
                  	 	<option value="">예산</option>
                  	 	<option value="1">4천만원 미만</option>
                  	 	<option value="2">4천~6천만원</option>
                  	 	<option value="3">6천~8천만원</option>
                  	 	<option value="4">8천~1억만원</option>
                  	 	<option value="5">1억~2억이상</option>
                  	 	<option value="6">미정</option>
					</select>
					<hr>
					<label for="etc">기타</label> <input type="text" id="etc" name="etc" >
					<hr>
					<label for="cn" class="cont">문의내용</label> <textarea id="cn" name="cn" cols="30" rows="10"></textarea>
					<hr>
					<label for="attachFile">파일첨부</label>
					<span class="file">
						<button class="file">Upload a file</button>
						<input type="file" id="attachFile" name="attachFile" onchange="f_FileCheck(this); return false;">
					</span>
					<label id="upload-name" style="width: 50%; text-align: left;" ></label>
					<br>
					<hr>
					<div class="btn">
						<button class="send" onclick="f_send(); return false;"><a href="#">SEND</a><span></span></button>
					</div>
				</fieldset>
			</div>

		</div>
		<a class="closebtn" onclick="f_reset(); return false;">
			<span class="icon menu6"><span></span><span></span></span>
		</a>

	</div>
	</form>
