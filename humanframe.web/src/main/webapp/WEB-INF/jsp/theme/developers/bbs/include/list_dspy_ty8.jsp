<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/taglibs.jsp" %>
<%@ page trimDirectiveWhitespaces="true" %>
<c:choose>
<c:when test="${listVO.totalCount == 0 }">
	<spring:message code='data.value.noData' />
</c:when>
<c:otherwise>
	<div class="toggle toggle-primary mt-lg">
	<c:forEach items="${listVO.listOutptObject}" var="listOutpt" varStatus="status">
		<c:set var="mapShow" value="${listOutpt.mapShow}"/>
		<c:set var="mapHide" value="${listOutpt.mapHide}"/>
		<a href="${currUri}/${mapHide.nttNo}" target="_blank">
		<section class="toggle">
			<label>${mapShow.sj}</label>
		</section>
		</a>
	</c:forEach>
	</div>
</c:otherwise>
</c:choose>