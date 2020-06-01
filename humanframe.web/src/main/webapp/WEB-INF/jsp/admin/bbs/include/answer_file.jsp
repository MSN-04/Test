<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ include file="/common/taglibs.jsp" %>

	<script type="text/javascript">
	function C_AdminDeleteFile(fileNo) {
		var bbsNo = $("#bbsNo").val();
		var nttNo = $("#nttNo").val();
		$.ajax({
			type : "POST",
			url : "/ajax/board/deleteFile.json",
			data : {
				"bbsNo" : bbsNo,
				"nttNo" : nttNo,
				"fileNo" : fileNo,
				"qestnAnswerSe" : "A"
			},
			success: function(result) {
				
				if( result.error ) {
					alert(result.errorMsg);
					return;
				}
				
				alert("파일이 삭제되었습니다");
				location.reload();
			}
		});
	}
	
	function f_FileCheck(obj) {
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
	</script>

	<c:if test="${cmsFn:isAuthor(bbsSettingVO.mngrAuthor, '_upload', session['admin'] )}">
		<c:if test="${bbsSettingVO.atchmnflAt == 'Y'}">
		<table class="table table-bordered table-th-bgcolor-eee">
		<colgroup>
			<col style="width:6%" />
			<col style="width:4%" />
			<col style="width:90%" />
		</colgroup>
		<tbody>
			<c:forEach begin="0" end="${bbsSettingVO.atchmnflCo-1}" varStatus="stuts">
			<c:set var="fileRowCount" value="2" />
			<c:if test="${not empty nttVO.answerFileList[stuts.index]}">
				<c:set var="fileRowCount" value="3" />
			</c:if>
			<c:forEach var="fileObject" items="${nttVO.viewExcludeObject['answerFileList']}">
			<tr>
				<th rowspan="${fileRowCount}">${fileObject.key} ${stuts.count}</th>
				<th class="mid" rowspan="${fileRowCount-1}" style="border-bottom:1px solid #ddd !important;">파일</th>
				<td class="mid">
					<input type="file" id="flUpload" name="atchFile_${stuts.count}" style="width:300px;" onchange="f_FileCheck(this);" class="form-control"/>
				</td>
			</tr>
			</c:forEach>
			<c:if test="${not empty nttVO.answerFileList[stuts.index]}">
			<tr>
				<td>
					<c:set var="file" value="${nttVO.answerFileList[stuts.index]}" />
						<input type="hidden" name="fileNo" value="${file.fileNo}" />
						<input type="hidden" name="filePath" value="${file.filePath}" />
						<input type="hidden" name="streFileNm" value="${file.streFileNm}" />
					<span id="fileNm${stuts.count}" >${file.orgninlFileNm}</span> 
					<a href="javascript:C_AdminDeleteFile(${file.fileNo})" class="button"><span class="btn btn-info">삭제</span></a>
				</td>
			</tr>
			</c:if>
			<tr>
				<th>설명</th>
				<td><input type="text" name="atchFileAlt" style="width:300px;" value="${file.fileInfo}" class="form-control" /></td>
			</tr>
				<c:set var="file" value="${null}" />
			</c:forEach>
		</tbody>
		</table>
		</c:if>
	</c:if>