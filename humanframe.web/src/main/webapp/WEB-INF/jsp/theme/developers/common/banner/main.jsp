<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp" %>
<%@ page trimDirectiveWhitespaces="true" %>

	<c:if test="${not empty bannerList}">
	<c:forEach items="${bannerList}" var="banner" varStatus="status">
		<c:set var="bannerImgSrc" value="/comm/getImage?srvcId=${banner.pcFileList[0].srvcId }&amp;upperNo=${banner.pcFileList[0].upperNo }&amp;fileTy=${banner.pcFileList[0].fileTy }&amp;fileNo=${banner.pcFileList[0].fileNo }"/>
		<a href="${banner.linkUrl}" target="${banner.linkTrgt}"><img src="${bannerImgSrc}" data-thumb="${bannerImgSrc}" alt="${banner.sj}" /></a>
	</c:forEach>
	</c:if>