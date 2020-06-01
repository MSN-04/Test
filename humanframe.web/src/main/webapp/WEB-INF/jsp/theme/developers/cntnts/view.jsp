<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ include file="/common/taglibs.jsp" %>
<style>
	${article.cnCss}
</style>

<!-- start article -->
<c:choose>
	<c:when test="${!empty article}">
		<div class="blog-posts single-post">
			<article class="post post-large blog-single-post">

			<!-- 롤링이미지 -->
			<c:if test="${!empty article.relateImageList && article.relateImageAt eq 'Y'}">
				<div class="owl-carousel owl-theme mb-none" data-plugin-options='{"items": 1, "autoplay": true, "autoplayTimeout": 3000}' style="width: 70%; margin: 0 auto;">
				<c:forEach items="${article.relateImageList}" var="relateList" varStatus="relate_status">
						<c:set var="fileInfo" value="${relateList.mediaVO.mediaFileList[0]}" />
						<img src="/comm/getImage?srvcId=${fileInfo.srvcId}&upperNo=${fileInfo.upperNo}&fileTy=${fileInfo.fileTy}&fileNo=${fileInfo.fileNo}" alt="" width="100%" height="350px"/>
				</c:forEach>
				</div>
			</c:if>
			<!-- 콘텐츠 본문 -->
			<div class="post-content">
				<h2>${article.cntntsSj}</h2>
				<div class="post-meta">
					<span><i class="fa fa-calendar"></i> ${article.pblcateDe} </span>
					<span><i class="fa fa-user"></i> By <a href="#">${article.chargerNm}</a> </span>
					<span><i class="fa fa-tag"></i>
					<c:forEach items="${fn:split(article.tag, '|')}" var="hashTagValue">
						<a href="#">${hashTagValue}</a>&nbsp;
					</c:forEach>
					</span>
				</div>
				${article.cn}
			</div>
			<!-- 정보누리 -->
			<c:if test="${!empty article.lic}">
			<div class="post-block">
				<img width="200" src="${themeAssets}/img/lic/lic_${article.lic}.jpg" alt="<spring:message code='ui.license.${article.lic}.details' />" />
				<spring:message code='ui.license.${article.lic}.details' />
			</div>
			</c:if>
			
			<!-- 댓글 -->
			<c:choose>
			<c:when test="${curMenuVO.menuNo eq 176 }"><%-- 2018 추석선물 --%>
				<jsp:include page="../common/cm_respond.jsp" />
			</c:when>
			<c:when test="${curMenuVO.menuNo eq 121 }"><%-- 2018 설선물 --%>
				<jsp:include page="../common/cm_respond.jsp" />
			</c:when>
			<c:when test="${article.cmUseAt eq 'Y'}">
				<jsp:include page="../common/cm.jsp">
					<jsp:param name="mapngAt" value="cntnts" />
				</jsp:include>
			</c:when>
			</c:choose>
			</article>
		</div>
	</c:when>
	<c:otherwise>
		<section class="page-not-found">
			<div class="row">
				<div class="col-md-6 col-md-offset-1">
					<div class="page-not-found-main">
						<h2>404 <i class="fa fa-file"></i></h2>
						<p>We're sorry, but the page you were looking for doesn't exist.</p>
					</div>
				</div>
				<div class="col-md-4">
					<h4 class="heading-primary">Here are some useful links</h4>
					<ul class="nav nav-list">
						<li><a href="#">Home</a></li>
						<li><a href="#">About Us</a></li>
						<li><a href="#">FAQ's</a></li>
						<li><a href="#">Sitemap</a></li>
					</ul>
				</div>
			</div>
		</section>
	</c:otherwise>
</c:choose>
<!-- end article -->