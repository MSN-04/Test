<%@ page language="java" contentType="application/vnd.ms-excel;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<%@ page trimDirectiveWhitespaces="true"%>
<%@ page import="egovframework.rte.fdl.string.EgovDateUtil" %>
<%@ page import="humanframe.core.util.WebUtil" %>
<%
	// 엑셀 파일 정보 얻기
	String header = request.getHeader("User-Agent");

	// 엑셀 파일명 설정
	String fileName = "검토위원후보자목록_"+EgovDateUtil.getCurrentDateAsString();

/*     WebUtil.setContentDisposition(fileName+".xls", request, response); */
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
		<table class="table">
			<colgroup>
			</colgroup>
			<thead>
				<tr>
					<th>번호</th>
					<th>신청분야</th>
					<th>성명</th>
					<th>세부전문분야</th>
					<th>직장명</th>
					<th>사무실전화</th>
					<th>휴대폰</th>
					<th>전자메일</th>
					<th>차량번호</th>
					<th>수당입금금액명</th>
					<th>계좌번호</th>
					<th>생년월일</th>
					<th>최종학력</th>
					<th>학위구분</th>
					<th>자격증보유현황</th>
					<th>직장주소</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach items="${listVO.listObject}" var="resultList" varStatus="status">
				<tr>
					<td>${listVO.startNo - status.index}</td>
					<td>${resultList.etcData1}</td>
				 	<td>${resultList.wrter}</td>
					<td>${resultList.etcData3}</td>
					<td>${resultList.etcData4}</td>
					<td>${resultList.etcData5}</td>
					<td>${resultList.etcData6}</td>
					<td>${resultList.etcData7}</td>
					<td>${resultList.etcData8}</td>
					<td>${resultList.etcData9}</td>
					<td>${resultList.etcData10}</td>
					<td>${resultList.etcData11}</td>
					<td>${resultList.etcData12}</td>
					<td>${resultList.etcData13}</td>
					<td>${resultList.etcData14}</td>
					<td>${resultList.etcData15}</td> 
				</tr>
				</c:forEach>
				<c:if test="${empty listVO.listObject}">
				<tr>
					<td colspan="3" style="height:50px; text-align:center; vertical-align:middle;">등록된 데이터가 없습니다.</td>
				</tr>
				</c:if>

			</tbody>

		</table>
	</body>

</html>