<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ include file="/common/taglibs.jsp" %>

	<script type="text/javascript">
	function delFile(fileNo, type, spanNo){
		if(confirm("삭제하시겠습니까?")){
			if(type == "QESTNATTACH"){
				if($("#delQestnAttachFileNo").val()==""){
					$("#delQestnAttachFileNo").val(fileNo);
				}else{
					$("#delQestnAttachFileNo").val($("#delQestnAttachFileNo").val()+","+fileNo);
				}
				$("#qestnAttachFileViewSpan"+fileNo).remove();
				$("#qestnAttachFileInputSpan"+spanNo).show();
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
	</script>

	<c:if test="${cmsFn:isAuthor(bbsSettingVO.mngrAuthor, '_upload', session['admin'] )}">
		<c:if test="${bbsSettingVO.atchmnflAt eq 'Y'}">
			<c:if test="${bbsSettingVO.atchmnflCo > 0 }">

				<c:choose>
					<c:when test="${nttVO.crud eq 'CREATE' or nttVO.crud eq 'UPDATE'}">
						<c:forEach var="qestnFileListObj" items="${nttVO.viewExcludeObject['qestnFileList']}">
						<tr>
							<th>${qestnFileListObj.key}</th>
							<td>
								<c:forEach var="fileList" items="${nttVO.qestnFileList}" varStatus="status">
								<span class="help-block" id="qestnAttachFileViewSpan${fileList.fileNo}">
									<a href="/comm/getFile?srvcId=${fileList.srvcId }&amp;upperNo=${fileList.upperNo }&amp;fileTy=${fileList.fileTy }&amp;fileNo=${fileList.fileNo }">${fileList.orginlFileNm} (용량 : ${cmsFn:fileSize(fileList.fileSize)}, 다운로드 : ${fileList.dwldCo}회)</a>
									<a href="#delFile" onclick="delFile('${fileList.fileNo}', 'QESTNATTACH', '${status.index}'); return false;"><i class="iconfugue16-cross"></i></a>
								</span>
								</c:forEach>

								<div id="qestnAttachFileDiv">
								<c:forEach begin="0" end="${bbsSettingVO.atchmnflCo-1}" varStatus="status">
								<span class="help-block"  id="qestnAttachFileInputSpan${status.index}" <c:if test="${status.index < fn:length(nttVO.qestnFileList) }">style="display:none;"</c:if>>
									<input type="file" id="qestnAttachFile${status.index}" name="qestnAttachFile${status.index}" onchange="fileCheck(this);" />
								</span>
								</c:forEach>
								</div>
							</td>
						</tr>
						</c:forEach>
					</c:when>
				</c:choose>
			</c:if>
		</c:if>
	</c:if>