<%@ page language="java" contentType="application/vnd.ms-excel;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<%@ page trimDirectiveWhitespaces="true"%>
<%@ page import="egovframework.rte.fdl.string.EgovDateUtil" %>
<%@ page import="humanframe.core.util.WebUtil" %>
<%
	// 엑셀 파일 정보 얻기
	String header = request.getHeader("User-Agent");

	// 엑셀 파일명 설정
	String fileName = "CSR요청사항내역_"+EgovDateUtil.getCurrentDateAsString();

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
	<table class="table table-hover">
		<colgroup>
			<col style="width:100px;" />
			<col style="width:800px;" />
			<col style="width:150px;" />
			<col style="width:80px;" />
			<col style="width:100px;" />
			<col style="width:100px;" />
			<col style="width:130px;" />
		</colgroup>
		<thead>
			<tr>
				<th>CRS번호</th>
				<th>제목</th>
				<th>파트</th>
				<th>진행상황</th>
				<th>작성자</th>
				<th>작성일</th>
				<th>담당자</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach items="${listVO}" var="resultList" varStatus="status">
			<c:set var="pageParam" value="crsNo=${resultList.crsNo}" />
			<tr>
				<td>${resultList.crsNo}</td>
				<td><a href="${fn:replace(urlPath,'excelDownload','view')}?${pageParam}">${resultList.sj}</a></td>
				<td>${crsPartCode[resultList.part] }</td>
				<td>${crsStatusCode[resultList.progrsSttus]}</td>
				<td>${resultList.crtrNm}</td>
				<td><fmt:formatDate pattern="yyyy-MM-dd" value="${resultList.creatDttm}" /></td>
				<td>
					<%-- ${resultList.chargerUniqueId} --%>
					<!-- 임시처리 -->
					<c:if test="${resultList.chargerUniqueId eq 'TMPINFO_000000000001' }">윤커뮤니케이션즈</c:if>
					<c:if test="${resultList.chargerUniqueId eq 'TMPINFO_000000000002' }">ETC</c:if>
					<c:if test="${resultList.aditChargerUniqueId eq 'TMPINFO_000000000001' }"><br />윤커뮤니케이션즈</c:if>
					<c:if test="${resultList.aditChargerUniqueId eq 'TMPINFO_000000000002' }"><br />ETC</c:if>
					<c:if test="${empty resultList.chargerUniqueId && empty resultList.aditChargerUniqueId}"><span>미정</span></c:if>
				</td>
			</tr>
			</c:forEach>
			<c:if test="${fn:length(listVO) <= 0}">
			<tr>
				<td colspan="7" style="height:50px; text-align:center; vertical-align:middle;">등록된 데이터가 없습니다.</td>
			</tr>
			</c:if>
		</tbody>
	</table>
	</body>
</html>
