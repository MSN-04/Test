<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ include file="/common/taglibs.jsp" %>
	<c:set var="asideOptStr" value="${fn:join(curMenuVO.asideOpt, ',')}" />

	<c:if test="${fn:indexOf(asideOptStr, 'A') > -1}">
		<c:import url="../common/aside/submenu.jsp"></c:import>
	</c:if>

	<c:if test="${fn:indexOf(asideOptStr, 'Z') > -1}">
		<hr />
		<%-- <jsp:include page="/comm/aside/banner" flush="true" /> --%>
	</c:if>