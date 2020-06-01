<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ include file="/common/taglibs.jsp" %>

	<!-- Smart Editor -->
    <script type="text/javascript" src="${globalAdminAssets}/smarteditor/js/HuskyEZCreator.js" charset="utf-8"></script>

	<script type="text/javascript">
	$(document).ready(function(){
		$('input[name="answerDe"]').datepicker();

		<c:if test="${bbsSettingVO.editrUseAt == 'Y'}">
		smEditor.init("answer");
		</c:if>
	});

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
		    	  answrr : { required : true}
		    	, answerDe : {required : true}
		    },
		    messages : {
		    	  answrr : { required : "<spring:message arguments='" + $("#answrr").prop("title") + "' code='errors.required'/>"}
		    	, answerDe : { required : "<spring:message arguments='" + $("#answerDe").prop("title") + "' code='errors.required'/>"}
		    },
		    submitHandler: function (frm) {
		    	if(confirm("<spring:message code='action.confirm.save'/>")){
		    		<c:if test="${bbsSettingVO.editrUseAt == 'Y'}">
		    		smEditor.submit("answer");// 에디터 값 적용
		    		</c:if>
		    		frm.submit();
		    	}else{
		    		return false;
		    	}
		    }
		});
	});

	function delFile(fileNo, type, spanNo){
		if(confirm("삭제하시겠습니까?")){
			if(type == "ANSWERATTACH"){
				if($("#delAnswerAttachFileNo").val()==""){
					$("#delAnswerAttachFileNo").val(fileNo);
				}else{
					$("#delAnswerAttachFileNo").val($("#delAnswerAttachFileNo").val()+","+fileNo);
				}
				$("#answerAttachFileViewSpan"+fileNo).remove();
				$("#answerAttachFileInputSpan"+spanNo).show();
			}
		}
	}

	function f_FileCheck(obj) {
		if(obj.value != ""){
			<c:if test="${fn:length(bbsSettingVO.atchmnflExtsn) > 0}">
			/* 첨부파일 확장자 체크*/
			var atchmnflExtsnArr = new Array();
			<c:forEach items="${bbsSettingVO.atchmnflExtsn}" var="atchmnflExtsn">
			atchmnflExtsnArr.push("${atchmnflExtsn}");
			</c:forEach>

			var file = obj.value;
			var fileExt = file.substring(file.lastIndexOf('.') + 1, file.length).toLowerCase();
			var isFileExt = false;

			for (var i = 0; i < atchmnflExtsnArr.length; i++) {
				if (atchmnflExtsnArr[i] == fileExt) {
					isFileExt = true;
					break;
				}
			}

			if (!isFileExt) {
				alert("<spring:message code='errors.ext.limit' arguments='" + atchmnflExtsnArr + "' />");
				obj.value = "";
				return false;
			}
			/* 첨부파일 확장자 체크*/
			</c:if>

			/* 첨부파일 사이즈 체크*/
			var uploadFileSize = 0;
			var limitSize = <c:out value="${bbsSettingVO.atchmnflSize}" default="0"/>;

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

	function f_insertMedia(insertHtml){
		smEditor.setVal("answer", insertHtml);
	}
	</script>

		<!-- Start Breadcrumb -->
		<jsp:include page="/WEB-INF/jsp/admin/layout/breadcrumb.jsp">
			<jsp:param name="pageName" value="게시판 관리"/>
		</jsp:include>
		<!-- End Breadcrumb -->

		<!-- start: page -->
		<div class="row">
			<div class="col-md-12">
			<f:form modelAttribute="nttVO" method="post" name="frmNtt" id="frmNtt" enctype="multipart/form-data" action="./action" cssClass="form-horizontal form-bordered mb-md">
			<f:hidden path="crud" />
			<f:hidden path="bbsNo" />
			<f:hidden path="nttNo" />
			<input type="hidden" id="delAnswerAttachFileNo" name="delAnswerAttachFileNo" value="" />

			<section class="panel panel-featured panel-featured-primary">
				<header class="panel-heading">
					<div class="panel-actions">

					</div>
					<h2 class="panel-title">[${bbsSettingVO.bbsSj}] 게시판 <small>답변 등록/수정</small></h2>
					<p class="panel-subtitle">
					</p>
				</header>
				<div class="panel-body">
					<!-- Start Selectable Table Row -->
					<table class="table table-bordered mb-none">
						<colgroup>
							<col style="width:130px"/>
							<col />
						</colgroup>
						<tbody class="cn-wrapper">
							<c:forEach var="viewObj" items="${nttVO.viewObject}" varStatus="status">
							<c:choose>

								<c:when test="${viewObj.key eq 'ctgryNm' }"><!-- 카테고리 -->
								<c:if test="${nttVO.ctgryNo > 0 and bbsSettingVO.ctgryUseAt == 'Y'}">
									<c:forEach var="viewDtl" items="${viewObj.value }">
									<tr>
										<th>${viewDtl.key }</th>
										<td>${viewDtl.value}</td>
									</tr>
									</c:forEach>
								</c:if>
								</c:when>

								<c:when test="${viewObj.key eq 'secretAt' }"><!-- 공개여부 -->
									<c:forEach var="viewDtl" items="${viewObj.value }">
									<tr>
										<th>${viewDtl.key }</th>
										<td>${secretTyCode[viewDtl.value]}</td>
									</tr>
									</c:forEach>
								</c:when>

								<c:when test="${viewObj.key eq 'confmAt' }"><!-- 승인여부 -->
									<c:forEach var="viewDtl" items="${viewObj.value }">
									<tr>
										<th>${viewDtl.key }</th>
										<td>${confmTyCode[viewDtl.value]}</td>
									</tr>
									</c:forEach>
								</c:when>

								<c:when test="${viewObj.key eq 'sttusTy' }"><!-- CCL여부 -->
									<c:forEach var="viewDtl" items="${viewObj.value }">
									<tr>
										<th>${viewDtl.key }</th>
										<td>${sttusTyCode[viewDtl.value]}</td>
									</tr>
									</c:forEach>
								</c:when>

								<c:otherwise>
									<c:forEach var="viewDtl" items="${viewObj.value}">
									<tr>
										<th>${viewDtl.key}</th>
										<td>${viewDtl.value}</td>
									</tr>
									</c:forEach>
								</c:otherwise>
							</c:choose>
							</c:forEach>

							<!-- 기타필드 -->
							<c:import url="/WEB-INF/jsp/admin/bbs/include/etc_view.jsp"/>

							<!-- 첨부파일 -->
							<c:if test="${not empty nttVO.qestnFileList}">
							<c:forEach var="qestnFileListObj" items="${nttVO.viewExcludeObject['qestnFileList']}">
							<tr>
								<th>${qestnFileListObj.key}</th>
								<td>
									<c:forEach var="qestnFileList" items="${nttVO.qestnFileList}" varStatus="status">
									<a href="/comm/getFile?srvcId=${qestnFileList.srvcId }&amp;upperNo=${qestnFileList.upperNo }&amp;fileTy=${qestnFileList.fileTy }&amp;fileNo=${qestnFileList.fileNo }">${qestnFileList.orginlFileNm} (용량 : ${cmsFn:fileSize(qestnFileList.fileSize)}, 다운로드 : ${qestnFileList.dwldCo}회)</a><br/>
									</c:forEach>
								</td>
							</tr>
							</c:forEach>
							</c:if>
						</tbody>
					</table>
					<!-- End Selectable Table Row -->
				</div>
				<footer class="panel-footer"></footer>
			</section>

			<section class="panel panel-featured panel-featured-primary">
				<header class="panel-heading">
					<div class="panel-actions">

					</div>
					<h2 class="panel-title">답변 등록</h2>
					<p class="panel-subtitle">

					</p>
				</header>
				<div class="panel-body">
					<!-- Start Selectable Table Row -->
					<table class="table table-bordered mb-none">
						<colgroup>
							<col style="width:130"/>
							<col />
						</colgroup>
						<tbody>
							<!-- 답변자 -->
							<c:forEach var="answrrObj" items="${nttVO.viewExcludeObject['answrr']}">
							<tr>
								<th>${answrrObj.key}<span class="required">*</span></th>
								<td><f:input path="answrr" cssClass="form-control" placeholder="${answrrObj.key} 입력" title="${answrrObj.key}" /></td>
							</tr>
							</c:forEach>

							<!-- 답변일 -->
							<c:forEach var="answerDeObj" items="${nttVO.viewExcludeObject['answerDe']}">
							<tr>
								<th>${answerDeObj.key}<span class="required">*</span></th>
								<td>
									<div class="control-group form-inline">
										<f:input path="answerDe" cssClass="form-control mx-sm-3" readonly="true" placeholder="${answerDeObj.key} 입력" title="${answerDeObj.key}"/>
									</div>
								</td>
							</tr>
							</c:forEach>

							<!-- 답변 내용 -->
							<c:forEach var="answerObj" items="${nttVO.viewExcludeObject['answer']}">
							<tr>
								<th>${answerObj.key}</th>
								<td>
									<c:if test="${bbsSettingVO.editrUseAt eq 'Y'}">
									<a style="margin-bottom:5px;" class="btn btn-default" href="/admin/media/popup/list?targetId=cn" target="_blank" onclick="window.open(this.href, 'mediaPopup', 'width=800, height=910'); return false;" >미디어 삽입</a>
									</c:if>
									<f:textarea path="answer" class="form-control" style="width:100%;height:200px;" title="${answerObj.key}"/>
								</td>
							</tr>
							</c:forEach>

							<!-- 첨부파일(답변) -->
							<c:forEach var="answerFileListObj" items="${nttVO.viewExcludeObject['answerFileList']}">
							<c:if test="${bbsSettingVO.atchmnflCo != 0}">
							<tr>
								<th>${answerFileListObj.key}</th>
								<td>
									<c:forEach var="fileList" items="${nttVO.answerFileList}" varStatus="status">
									<span class="help-block" id="answerAttachFileViewSpan${fileList.fileNo}">
										<a href="/comm/getFile?srvcId=${fileList.srvcId }&amp;upperNo=${fileList.upperNo }&amp;fileTy=${fileList.fileTy }&amp;fileNo=${fileList.fileNo }">${fileList.orginlFileNm} (용량 : ${cmsFn:fileSize(fileList.fileSize)}, 다운로드 : ${fileList.dwldCo}회)</a>
										<a href="#delFile" onclick="delFile('${fileList.fileNo}', 'ANSWERATTACH', '${status.index}'); return false;"><i class="fa fa-trash"></i></a>
									</span>
									</c:forEach>

									<div id="answerAttachFileDiv">
									<c:forEach begin="0" end="${bbsSettingVO.atchmnflCo-1}" varStatus="status">
									<span class="help-block" id="answerAttachFileInputSpan${status.index}" <c:if test="${status.index < fn:length(nttVO.answerFileList) }">style="display:none;"</c:if>>
										<input type="file" id="answerAttachFile${status.index}" name="answerAttachFile${status.index}" onchange="fileCheck(this);" class="form-control" />
									</span>
									</c:forEach>
									</div>
								</td>
							</tr>
							</c:if>
							</c:forEach>
						</tbody>
					</table>
					<!-- End Selectable Table Row -->
				</div>
				<footer class="panel-footer">
					<div class="row">
						<div class="col-sm-7">
							<c:set var="pageParam" value="bbsSvcNo=${param.bbsSvcNo }&amp;useAt=${param.useAt }&amp;curPage=${param.curPage }&amp;srchCtgryNo=${param.srchCtgryNo}&amp;srchKey=${param.srchKey}&amp;srchText=${param.srchText}" />
							<a href="./list?bbsNo=${nttVO.bbsNo}&curPage=${param.pageNo}" class="btn btn-default">목록</a>
						</div>
						<div class="col-sm-5">
							<div class="btns">
								<button class="btn btn-primary answer-save">저장</button>
							</div>
						</div>
					</div>
				</footer>
			</section>
			</f:form>
			</div>

		</div>