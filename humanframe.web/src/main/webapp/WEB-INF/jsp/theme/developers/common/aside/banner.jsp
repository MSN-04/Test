<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp" %>
<%@ page trimDirectiveWhitespaces="true" %>

	<c:if test="${not empty bannerList}">
	<ul class="simple-post-list">
	<c:forEach items="${bannerList}" var="banner" varStatus="status">
		<li>
			<c:if test="${!empty banner.fileList}">
			<div class="post-image" style="margin:0;">
				<div class="img-thumbnail">
					<a href="${banner.linkUrl}" target="${banner.linkTrgt}"><img alt="${banner.sj}"
						src="/comm/getImage?srvcId=${banner.fileList[0].srvcId }&amp;upperNo=${banner.fileList[0].upperNo }&amp;fileTy=${banner.fileList[0].fileTy }&amp;fileNo=${banner.fileList[0].fileNo }" style="width:100%;" /></a>
				</div>
			</div>
			</c:if>
			<%-- <div class="post-info">
				<a href="${banner.linkUrl}" target="${banner.linkTrgt}"><span>${banner.sj}</span></a>
			</div> --%>
		</li>

	</c:forEach>
	</ul>
	</c:if>