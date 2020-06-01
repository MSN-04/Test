<%@ page language="java" contentType="application/vnd.ms-excel;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ page import="egovframework.rte.fdl.string.EgovDateUtil" %>
<%@ page import="java.net.URLEncoder, java.io.UnsupportedEncodingException" %>
<%
	// 엑셀 파일 정보 얻기
	String header = request.getHeader("User-Agent");

	// 엑셀 파일명 설정
	StringBuffer name = new StringBuffer();

	name.append(EgovDateUtil.getCurrentDateAsString());
	name.append("_메뉴통계");

	String docName = "";
	try {
		docName = URLEncoder.encode(name.toString(), "UTF-8").replaceAll("\\+", "%20");
	} catch (UnsupportedEncodingException e) {
		docName = "_naming_error";
	}

	response.setHeader("Content-Disposition", "attachment; filename=" + docName + ".xls;");
    response.setHeader("Content-Description", "JSP Generated Data");
    response.setHeader("Content-Transfer-Encoding", "binary;");
    response.setHeader("Pragma", "no-cache;");
    response.setHeader("Expires", "-1;");
%>
<!DOCTYPE html>
<html>
	<meta charset="utf-8">
	<head>
	</head>
<body >
		<!-- Start Main Content -->
		<table>
			<colgroup>
				<col style="width:50px" />
				<col style="width:100px" />
				<col/>
				<col/>
				<col style="width:100px" />
				<col style="width:100px" />
			</colgroup>
			<thead>
				<tr>
					<th style="text-align: center;">번호</th>
					<th style="text-align: center;">통계일자</th>
					<th style="text-align: center;">사이트명</th>
					<th style="text-align: center;">메뉴명</th>
					<th style="text-align: center;">순방문자수</th>
					<th style="text-align: center;">페이지뷰</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach items="${listVO}" var="resultList" varStatus="status">
				<tr>
					<td>${status.count}</td>
					<td>
						<c:if test="${!empty resultList.statsYyyy}">
							${resultList.statsYyyy}
						</c:if>
						<c:if test="${!empty resultList.statsMm}">
							-${resultList.statsMm}
						</c:if>
						<c:if test="${!empty resultList.statsDd}">
							-${resultList.statsDd}
						</c:if>
						<c:if test="${empty resultList.statsYyyy && empty resultList.statsMm && empty resultList.statsDd }">
						전체
						</c:if>
					</td>
					<td>${resultList.siteNm}</td>
					<td>${resultList.menuNm}</td>
					<td>${resultList.uv}</td>
					<td>${resultList.pv}</td>
				</tr>
				</c:forEach>

				<c:if test="${empty listVO}">
				<tr>
					<td colspan="6" style="height:50px; text-align:center; vertical-align:middle;">등록된 데이터가 없습니다.</td>
				</tr>
				</c:if>
			</tbody>
		</table>
	</body>
</html>