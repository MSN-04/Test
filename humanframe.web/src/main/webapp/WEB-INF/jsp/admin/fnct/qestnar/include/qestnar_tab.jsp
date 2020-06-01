<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" 		uri="http://java.sun.com/jsp/jstl/core" %>

	<ul class="nav nav-tabs">
		<%-- <li <c:if test="${param.tabKind=='qestnar'}">class="active"</c:if>>
			<a href="./form?qestnarNo=${qestnarVO.qestnarNo}">설문관리</a>
		</li> --%>
		<li <c:if test="${param.tabKind=='qestn'}">class="active"</c:if>>
			<a href="./qestnList?qestnarNo=${qestnarVO.qestnarNo}">질문관리</a>
		</li>
		<li <c:if test="${param.tabKind=='result'}">class="active"</c:if>>
			<a href="./result?qestnarNo=${qestnarVO.qestnarNo}">결과보기</a>
		</li>
		<li <c:if test="${param.tabKind=='personal'}">class="active"</c:if>>
			<a href="./personal?qestnarNo=${qestnarVO.qestnarNo}">개인별 설문관리</a>
		</li>
	</ul>

