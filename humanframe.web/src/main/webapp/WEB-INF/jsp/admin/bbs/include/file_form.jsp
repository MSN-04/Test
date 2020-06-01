<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ include file="/common/taglibs.jsp" %>

	<script type="text/javascript">
	function delFile(fileNo, type, spanNo){
		if(confirm("삭제하시겠습니까?")){
			if(type == "ATTACH"){
				if($("#delAttachFileNo").val()==""){
					$("#delAttachFileNo").val(fileNo);
				}else{
					$("#delAttachFileNo").val($("#delAttachFileNo").val()+","+fileNo);
				}
				$("#attachFileViewSpan"+fileNo).remove();
				$("#attachFileInputSpan"+spanNo).show();
			}
			else{
				$("#delThumbFileNo").val(fileNo);
				$("#thumbFileViewSpan" + spanNo).remove();
				$("#thumbFileDiv").show();
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

	function f_ThumbnailFileChk(fileObj){
		if(fileObj.value != ""){

			var file = fileObj.value;
			var fileExt = file.substring(file.lastIndexOf('.') + 1, file.length).toLowerCase();
			var reg = /gif|jpg|png|bmp/i;

			if(reg.test(fileExt) == false)
			{
				alert("썸네일이미지는 확장자가 gif, jpg, png, bmp로 된\n파일만 첨부 가능합니다.");
				fileObj.value = "";
				return false;
				return false;
			}
			return true;
		}
	}
	</script>

	<c:if test="${cmsFn:isAuthor(bbsSettingVO.mngrAuthor, '_upload', session['admin'] )}">
		<c:if test="${bbsSettingVO.atchmnflAt eq 'Y'}">
			<c:if test="${bbsSettingVO.atchmnflCo > 0 }">
				<c:if test="${bbsSettingVO.bbsTy eq '4' }">
				<c:forEach var="thumbFileObj" items="${nttVO.viewExcludeObject['thumbFile']}">
				<tr>
					<th>${thumbFileObj.key}<span class="required">*</span></th>
					<td>
						<c:if test="${not empty nttVO.thumbFile.fileNo}">
						<span class="help-block" id="thumbFileViewSpan${nttVO.thumbFile.fileNo}">
							<img src="/comm/getImage?srvcId=${nttVO.thumbFile.srvcId}&amp;upperNo=${nttVO.thumbFile.upperNo}&amp;fileTy=${nttVO.thumbFile.fileTy }&amp;fileNo=${nttVO.thumbFile.fileNo}&amp;thumbTy=S" alt="썸네일 이미지" />
							<a href="#delFile" onclick="delFile('${nttVO.thumbFile.fileNo}', '${nttVO.thumbFile.fileTy }', '${nttVO.thumbFile.fileNo}'); return false;"><i class="fa fa-trash"></i></a>
						</span>
						</c:if>

						<div id="thumbFileDiv" <c:if test="${not empty nttVO.thumbFile.fileNo}">style="display: none;"</c:if>>
							<span class="help-block"  id="thumbFileInputSpan">
								<input type="file" id="thumbnailFile" name="thumbnailFile" title="${thumbFileObj.key}" onchange="f_ThumbnailFileChk(this)" class="form-control"/>
							</span>
						</div>
					</td>
				</tr>
				</c:forEach>
				</c:if>

				<c:forEach var="bbsFileListObj" items="${nttVO.viewExcludeObject['bbsFileList']}">
				<tr class="file-upload-tr">
					<th>${bbsFileListObj.key}</th>
					<td>
						<c:forEach var="fileList" items="${nttVO.bbsFileList}" varStatus="status">
						<span class="help-block" id="attachFileViewSpan${fileList.fileNo}">
							<a href="/comm/getFile?srvcId=${fileList.srvcId }&amp;upperNo=${fileList.upperNo }&amp;fileTy=${fileList.fileTy }&amp;fileNo=${fileList.fileNo }">${fileList.orginlFileNm} (용량 : ${cmsFn:fileSize(fileList.fileSize)}, 다운로드 : ${fileList.dwldCo}회)</a>
							<a href="#delFile" onclick="delFile('${fileList.fileNo}', 'ATTACH', '${status.index}'); return false;"><i class="fa fa-trash"></i></a>
						</span>
						</c:forEach>

						<div id="attachFileDiv">
						<c:forEach begin="0" end="${bbsSettingVO.atchmnflCo-1}" varStatus="status">
						<span class="help-block"  id="attachFileInputSpan${status.index}" <c:if test="${status.index < fn:length(nttVO.bbsFileList) }">style="display:none;"</c:if>>
							<input type="file" id="attachFile${status.index}" name="attachFile${status.index}" onchange="f_FileCheck(this);" class="form-control" />
						</span>
						</c:forEach>
						</div>
					</td>
				</tr>
				</c:forEach>
			</c:if>
		</c:if>

		<!-- 썸네일 -->
		<c:if test="${(bbsSettingVO.bbsTy eq '1' || bbsSettingVO.bbsTy eq '2') && bbsSettingVO.thumbAt eq 'Y'}">
			<c:forEach var="thumbFileObj" items="${nttVO.viewExcludeObject['thumbFile']}">
				<tr>
					<th>${thumbFileObj.key}</th>
					<td>
						<c:if test="${not empty nttVO.thumbFile.fileNo}">
						<span class="help-block" id="thumbFileViewSpan${nttVO.thumbFile.fileNo}">
							<img src="/comm/getImage?srvcId=${nttVO.thumbFile.srvcId}&amp;upperNo=${nttVO.thumbFile.upperNo}&amp;fileTy=${nttVO.thumbFile.fileTy }&amp;fileNo=${nttVO.thumbFile.fileNo}&amp;thumbTy=S" alt="썸네일 이미지" />
							<a href="#delFile" onclick="delFile('${nttVO.thumbFile.fileNo}', '${nttVO.thumbFile.fileTy }', '${nttVO.thumbFile.fileNo}'); return false;"><i class="fa fa-trash"></i></a>
						</span>
						</c:if>

						<div id="thumbFileDiv" <c:if test="${not empty nttVO.thumbFile.fileNo}">style="display: none;"</c:if>>
							<span class="help-block"  id="thumbFileInputSpan">
								<input type="file" id="thumbnailFile" name="thumbnailFile" title="${thumbFileObj.key}" onchange="f_ThumbnailFileChk(this)" class="form-control"/>
							</span>
						</div>
					</td>
				</tr>
			</c:forEach>
		</c:if>
	</c:if>