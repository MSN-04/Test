
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
	String fileName = "개인별_설문조사_"+qestnarVO.getSj()+"_"+EgovDateUtil.getCurrentDateAsString();

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

		<table style="margin-top:50px;">
			<colgroup>
			<col style="width: 80px;" />
			<col />
			<col style="width: 200px;" />
			<col style="width: 200px;" />
			<col style="width: 200px;" />
			<col style="width: 200px;" />
			<col style="width: 200px;" />
			<col style="width: 200px;" />
			<col style="width: 200px;" />
		</colgroup>
		<thead>
			<tr>
				<th>번호</th>
				<th>구분(uniqueId)</th>
				<th>성명</th>
				<th>주소</th>
				<th>국가</th>
				<th>국적</th>
				<th>이메일</th>
				<th>전화번호</th>
				<th>참여일</th>
			</tr>
		</thead>
		<tbody>

			<c:choose>
				<c:when test="${ fn:length(listVO.listObject)==0 }">
					<tr>
						<td colspan="9" style="text-align: center">질문이 없습니다.</td>
					</tr>
				</c:when>
				<c:otherwise>
					<c:forEach items="${listVO.listObject}" var="resultList"
						varStatus="status">
						<c:set var="pageParam"
							value="qestnarNo=${param.qestnarNo}&amp;crtrUniqueId=${resultList.crtrUniqueId}&amp;curPage=${listVO.curPage}${!empty(listVO.urlParam)? '&amp;' : ''}${listVO.urlParam}" />
						<tr>
							<td>${listVO.startNo - status.index}</td>
							<td>${resultList.crtrUniqueId}</td>
							<td>${resultList.nm}</td>
							<td>${resultList.address}</td>
							<td>${empty resultList.countryKo ? resultList.country : resultList.countryKo}</td>
							<td>${empty resultList.nationalityKo ? resultList.nationality : resultList.nationalityKo}</td>
							<td>${resultList.email}</td>
							<td>${resultList.telno}</td>
							<td>${resultList.creatDttm}</td>
						</tr>
					</c:forEach>
				</c:otherwise>
			</c:choose>

		</tbody>
		</table>
</body>
</html>