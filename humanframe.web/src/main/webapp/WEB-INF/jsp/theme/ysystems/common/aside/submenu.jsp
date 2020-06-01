<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp" %>
<%@ page trimDirectiveWhitespaces="true" %>

	<h4 class="heading-primary">${curSubMenuList[0].menuNm}</h4>
	<ul class="nav nav-list mb-xl show-bg-active">
	<c:forEach var="subMenuList" items="${curSubMenuList}" varStatus="status" begin="1">
		<c:if test="${subMenuList.levelNo == 2}">
		<li>
		</c:if>
		<c:choose>
			<c:when test="${subMenuList.menuTy eq '1' && subMenuList.subMainUseAt eq 'N' }">
				<a href="<c:if test='${!fn:startsWith(subMenuList.linkUrl, "http://")}'>${baseUri}/</c:if>${subMenuList.linkUrl}" target="${subMenuList.linkTrgt}">
			</c:when>
			<c:otherwise>
				<a href="${baseUri}/${subMenuList.menuUri}">
			</c:otherwise>
		</c:choose>
			${subMenuList.menuNm}</a>
		<c:if test="${subMenuList.levelNo == 2 }">
			<c:if test="${curSubMenuList[status.index+1].levelNo == 2 || status.last}"></li></c:if>
			<c:if test="${curSubMenuList[status.index+1].levelNo == 3}"><ul><li></c:if>
		</c:if>
		<c:if test="${subMenuList.levelNo == 3 }">
			<c:if test="${curSubMenuList[status.index+1].levelNo == 2 || status.last}"></li></ul></li></c:if>
			<c:if test="${curSubMenuList[status.index+1].levelNo == 3}"></li><li></c:if>
		</c:if>
	</c:forEach>
	</ul>


