<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/taglibs.jsp" %>
<%@ page trimDirectiveWhitespaces="true" %>
	<script type="text/javascript">
	$(function(){
		$("#frmNtt").validate({
			onkeyup: false,
			onclick: false,
			onfocusout: false,
			showErrors:function(errorMap, errorList){
                if(!$.isEmptyObject(errorList)){
                    alert(errorList[0].message);
                    return;
                }
            },
		    rules : {
		    	  sj : {required : true}
		    	, cn : {required : true}
		    },
		    messages : {
		    	  sj : { required : "<spring:message arguments='" + $("#sj").prop("title") + "' code='errors.required'/>"}
		    	, cn : { required : "<spring:message arguments='" + $("#cn").prop("title") + "' code='errors.required'/>"}
		    },
		    submitHandler: function (frm) {

		    	if(grecaptcha.getResponse() == ""){
		    		alert("<spring:message code='alert.author.captcha.check' />");
		    		return;
		    	}

		    	if(confirm("<spring:message code='action.confirm.save'/>")){
		    		frm.submit();
		    	}else{
		    		return false;
		    	}
		    }
		});

	});

	function delFile(fileNo, type){
		if( confirm("<spring:message code='action.confirm.delete' />") ) {
			if(type == "ATTACH"){
				if($("#delAttachFileNo").val()==""){
					$("#delAttachFileNo").val(fileNo);
				}else{
					$("#delAttachFileNo").val($("#delAttachFileNo").val()+","+fileNo);
				}
				$("#attachFileViewSpan"+fileNo).remove();
				$("#attachFileInputSpan").show();
			}
		}
	}

	function f_FileCheck(obj) {

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

	<f:form name="frmSample" id="frmSample" modelAttribute="sampleVO" method="post" enctype="multipart/form-data" action="./action">
		<f:hidden path="crud" />
		<f:hidden path="sampleNo" />
		<input type="hidden" id="delAttachFileNo" name="delAttachFileNo" value="" />
	<div class="panel-body">

				<div class="form-group">
					<label class="col-md-3 control-label" for="sj">제목<span class="required">*</span></label>
					<div class="col-md-6">
						<f:input path="sj" cssClass="form-control" placeholder="제목" title="제목" />
					</div>
				</div>

				<div class="form-group">
					<label class="col-md-3 control-label" for="wrter">작성자<span class="required">*</span></label>
					<div class="col-md-6">
						<input type="text" id="wrter" name="wrter" value="${sampleVO.crtrNm}" >
					</div>
				</div>

				<div class="form-group">
					<label class="col-md-3 control-label" for="useAt">사용여부<span class="required">*</span></label>
					<div class="col-md-3">
						<f:radiobuttons path="useAt" items="${useAtCode}"/>
					</div>
				</div>

				<div class="form-group">
					<label class="col-md-3 control-label" for="cn">내용</label>
					<div class="col-md-6">
						<f:textarea path="cn" style="width:100%;height:200px;" placeholder="내용" title="내용"/>
					</div>
				</div>

		<%-- 첨부파일 --%>
			<div class="form-group">
				<label class="col-md-3 control-label" for="inputPlaceholder">첨부파일</label>
				<div class="col-md-6">
					<c:forEach var="fileList" items="${sampleVO.sampleFileList}" varStatus="status">
					<span class="help-block" id="attachFileViewSpan${fileList.fileNo}">
						<a href="/comm/getFile?srvcId=${fileList.srvcId }&amp;upperNo=${fileList.upperNo }&amp;fileTy=${fileList.fileTy }&amp;fileNo=${fileList.fileNo }">
						${fileList.orginlFileNm}(<spring:message code='board.file.size' /> : ${cmsFn:fileSize(fileList.fileSize)}, <spring:message code='button.download' /> :${fileList.dwldCo}<spring:message code='ui.count' />)
						</a>
						<a href="#delFile" onclick="delFile('${fileList.fileNo}', 'ATTACH'); return false;"><i class="fa fa-times"></i></a>
					</span>
					</c:forEach>

					<span class="help-block"  id="attachFileInputSpan" <c:if test="${0 < fn:length(sampleVO.sampleFileList) }">style="display:none;"</c:if>>
						<input type="file" id="attachFile" name="attachFile" onchange="fileCheck(this);" />
					</span>
				</div>
			</div>
	</div>

	<%-- 버튼 --%>
	<div class="col-md-6" style="float: right; text-align: right;">
		<p>
			<button class="btn btn-primary mr-xs mb-sm save" title="<spring:message code='button.save' />"><spring:message code='button.save' /></button>
			<a href="${baseUri}/${curMenuVO.menuUri}" class="btn btn-default mr-xs mb-sm" title="<spring:message code='button.reset' />"><spring:message code='button.reset' /></a>
		</p>
	</div>
	</f:form>