<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp" %>
<%@ page trimDirectiveWhitespaces="true" %>
<head>
	<c:choose>
		<c:when test="${not empty globalAssets}">
		<script src="${globalAssets}/vendor/jquery/jquery.min.js"></script>
		</c:when>
		<c:when test="${not empty globalAdminAssets}">
		<script src="${globalAdminAssets}/js/jquery-1.10.2.min.js"></script>
		</c:when>
	</c:choose>

    <script>
	$(document).ready(function() {
		alert("${alertMsg}");
		<c:choose>
			<c:when test="${not empty goUrl}">
			location.href = "${goUrl}";
			</c:when>
			<c:otherwise>
			history.back();
			</c:otherwise>
		</c:choose>
	});
	</script>
</head>
</html>