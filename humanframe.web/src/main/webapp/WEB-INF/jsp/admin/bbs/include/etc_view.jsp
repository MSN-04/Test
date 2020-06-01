<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ include file="/common/taglibs.jsp" %>
<% pageContext.setAttribute("crcn", "\r\n");%>
	<c:if test="${bbsSettingVO.etcIemAt eq 'Y'}">
		<c:forEach items="${boardEtcDataList}" var="list" varStatus="status">
		<c:if test="${list.useAt eq 'Y'}">
		<tr>
			<th>${list.etcIemNm}<br/>(기타필드${list.etcIemNo})</th>
			<td><c:out value="${fn:replace(list.etcInputIem, crcn, '<br />')}" escapeXml="false"/></td>
		</tr>
		</c:if>
		</c:forEach>
	</c:if>