<%@ page language="java" contentType="application/vnd.ms-excel;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<%@ page trimDirectiveWhitespaces="true"%>
<%@ page import="humanframe.web.vo.QestnarVO" %>
<%@ page import="egovframework.rte.fdl.string.EgovDateUtil" %>
<%@ page import="humanframe.core.util.WebUtil" %>
<%
	// 엑셀 파일 정보 얻기
	QestnarVO qestnarVO = (QestnarVO) request.getAttribute("qestnarVO");
	String header = request.getHeader("User-Agent");

	// 엑셀 파일명 설정
	String fileName = "설문조사_"+qestnarVO.getSj()+"_"+EgovDateUtil.getCurrentDateAsString();

    WebUtil.setContentDisposition(fileName+".xls", request, response);
    response.setHeader("Content-Description", "JSP Generated Data");
    response.setHeader("Content-Transfer-Encoding", "binary");
    response.setHeader("Pragma", "no-cache");
    response.setHeader("Expires", "-1");
%>
<!DOCTYPE html>
<html>
	<meta charset="utf-8">
	<head>
	<style>
		table { border-collapse:collapse; }
		table th,  td { border:1px solid black; }
	</style>
	</head>
<body>
		<table>
		<colgroup>
			<col style="width:15%" >
			<col style="width:35%" >
			<col style="width:15%" >
			<col style="width:35%" >
		</colgroup>
		<tbody>
		<tr>
			<th class="text-align-center" colspan="2">설문명</th>
			<td class="text-align-left" colspan="3">${qestnarVO.sj }</td>
		</tr>
		<tr>
			<th class="text-align-center" colspan="2">설문기간</th>
			<td>${qestnarVO.bgnDttm} ~ ${qestnarVO.endDttm}</td>
			<th class="text-align-center">상태</th>
			<td><c:choose>
						<c:when test="${ qestnarVO.progrsSttus eq 'ING' }">진행중</c:when>
						<c:when test="${ qestnarVO.progrsSttus eq 'END' }">종료</c:when>
						<c:when test="${ qestnarVO.progrsSttus eq 'YET' }">준비중</c:when>
				</c:choose>
			</td>
		</tr>
		</tbody>
		</table>

		<br/>
		<br/>

		<c:set var="oldQestnNo" value="0"/>
		<c:set var="listNum" value="0"/>
		<c:set var="itemNum" value="0"/>

		<table style="margin-top:50px;">
			<colgroup>
				<col style="width:100" >
				<col style="width:150" >
				<col style="width:100"/>
				<col style="width:200" >
			</colgroup>
			<tbody>
	<c:choose>
		<c:when test="${ fn:length(listQesitm)==0 }">
				<tr>
					<td colspan="4" style="text-align:center">질문이 없습니다.</td>
				</tr>
		</c:when>
		<c:otherwise>

			<c:forEach var="qestn" items="${listQesitm}" varStatus="status">
				<c:if test="${ oldQestnNo ne qestn.qestnNo }">
				<c:set var="listNum" value="${listNum+1}"/>
				<c:set var="itemNum" value="0"/>
				<tr><td colspan="5">${listNum}. ${qestn.qestnText}</td></tr>
				</c:if>
				<tr>
					<c:choose>
					<c:when test="${qestn.fileNo ne null  }">
					<td height="66" width="95">
						<img width="64" height="64" class="media-object" src="http://bsadmin.busan.go.kr/comm/getFile?srvcId=QESTNARTM&amp;upperNo=${qestn.qesitmNo }&amp;fileTy=${qestn.fileTy }&amp;fileNo=${qestn.fileNo }" alt="${qestn.orginlFileNm}"/>
					</td>
					<td style="text-align:center">${qestn.qesitmText}</td>
					</c:when>
					<c:otherwise>
						<td style="text-align:center" colspan="2">${qestn.qesitmText}</td>
					</c:otherwise>
					</c:choose>
					<td style="text-align:center">${qestn.resultCnt}명</td>
					<td style="text-align:center" colspan="2">${qestn.qesitmPercent}%</td>
				</tr>
				<c:set var="oldQestnNo" value="${qestn.qestnNo}" />
				<c:set var="itemNum" value="${itemNum+1}"/>
			</c:forEach>
		</c:otherwise>
	</c:choose>

			</tbody>
		</table>
</body>
</html>