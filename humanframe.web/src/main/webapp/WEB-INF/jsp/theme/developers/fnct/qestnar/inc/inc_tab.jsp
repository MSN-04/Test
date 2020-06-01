<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


	<ul class="nav nav-tabs nav-justified">
		<c:choose>
			<c:when test="${ param.srchSttus eq 'END' }">
				<li><a href="${curUri}?srchSttus=ING">설문조사</a></li>
				<li class="active">
					<a href="${curUri}?srchSttus=END" class="active">지난 설문조사</a>
				</li>
			</c:when>
			<c:otherwise>
				<li class="active">
					<a href="${curUri}?srchSttus=ING" class="active">설문조사</a>
				</li>
				<li><a href="${curUri}?srchSttus=END">지난 설문조사</a></li>
			</c:otherwise>
		</c:choose>
	</ul>
