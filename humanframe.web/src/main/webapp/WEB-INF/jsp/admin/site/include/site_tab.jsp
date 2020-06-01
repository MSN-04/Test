<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ include file="/common/taglibs.jsp" %>

<%
	String siteNo = request.getParameter("siteNo");
%>
<div class="tabbable-custom">
	<ul class="nav nav-tabs">
		<li <c:if test="${tabKind=='main'}">class="active"</c:if>>
			<a href="/admin/site/main/form?siteNo=${siteVO.siteNo}">메인페이지 관리</a>
		</li>
		<li <c:if test="${tabKind=='image'}">class="active"</c:if>>
			<a href="/admin/site/main/imageList?siteNo=${siteVO.siteNo }">메인이미지 관리</a>
		</li>
		<li <c:if test="${tabKind=='popup'}">class="active"</c:if>>
			<a href="/admin/site/main/popupList?siteNo=${siteVO.siteNo }">팝업 관리</a>
		</li>
		<% if(siteNo.equals("2")) {%>
		<li <c:if test="${tabKind=='popularSrchwrd'}">class="active"</c:if>>
			<a href="/admin/fnct/popularSrchwrd/list?siteNo=${siteVO.siteNo}">메인 인기검색어</a>
		</li>
		<li <c:if test="${tabKind=='mainLink'}">class="active"</c:if>>
			<a href="/admin/fnct/mainLink/list?siteNo=${siteVO.siteNo}">알려드립니다</a>
		</li>
		<li <c:if test="${tabKind=='stepQestn'}">class="active"</c:if>>
			<a href="/admin/fnct/stepQestn/list?siteNo=2">3단계 질문</a>
		</li>
		<% } %>
	</ul>
	
</div>

