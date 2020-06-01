<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ include file="/common/taglibs.jsp" %>
	<c:if test="${bbsSettingVO.atchmnflAt eq 'Y'}">
	<c:forEach var="viewExcludeObj" items="${nttVO.viewExcludeObject['bbsFileList']}">
	<tr class="file-upload-tr">
		<th>${viewExcludeObj.key }</th>
		<td>
			<c:forEach var="bbsFileList" items="${nttVO.bbsFileList}" varStatus="status">
			<a href="/comm/getFile?srvcId=${bbsFileList.srvcId }&amp;upperNo=${bbsFileList.upperNo }&amp;fileTy=${bbsFileList.fileTy }&amp;fileNo=${bbsFileList.fileNo }">${bbsFileList.orginlFileNm} (용량 : ${cmsFn:fileSize(bbsFileList.fileSize)}, 다운로드 : ${bbsFileList.dwldCo}회)</a>
			<!-- <button class="btn btn-mini" onclick="">미리보기</button> -->
			<!-- <a href="javascript:f_filePreivew('${bbsFileList.srvcId }', '${bbsFileList.upperNo }', '${bbsFileList.fileTy }', '${bbsFileList.fileNo }');" class="btn btn-mini"><spring:message code='button.preview' /></a> -->
			<br/>
			</c:forEach>
		</td>
	</tr>
	</c:forEach>
	</c:if>