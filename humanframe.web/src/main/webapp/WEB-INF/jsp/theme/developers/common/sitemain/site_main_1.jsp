<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ include file="/common/taglibs.jsp" %>

	<c:if test="${not empty mainList}">
	<c:forEach items="${mainList}" var="main">
		<fmt:parseDate var="pblcateDe" value="${main.writngDe}" pattern="yyyy-MM-dd" />
				<div class="col-md-4">
					<div class="recent-posts">
						<article class="post">
							<c:if test="${not empty main.fileList }">
							<div class="pull-left mr-lg mb-sm">
								<div>
									<img alt="" class="img-responsive img-rounded" src="/comm/getImage?srvcId=${main.fileList[0].srvcId}&amp;upperNo=${main.fileList[0].upperNo}&amp;fileTy=${main.fileList[0].fileTy}&amp;fileNo=${main.fileList[0].fileNo}" alt="${main.fileList[0].fileDc }">
								</div>
							</div>
							</c:if>
							<div class="date">
								<span class="day"><fmt:formatDate value="${pblcateDe}" pattern="d"/></span>
								<span class="month"><fmt:formatDate value="${pblcateDe}" pattern="MMM"/></span>
							</div>
							<h4><a href="${main.linkUrl}" target="${main.linkTrgt}">${main.nttSj}</a></h4>
							<p>
								${main.nttCn }
							</p>
							<%--
							<div class="post-meta">
								<span><i class="fa fa-calendar"></i> January 10, 2016 </span>
								<span><i class="fa fa-user"></i> By <a href="#">John Doe</a> </span>
								<span><i class="fa fa-tag"></i> <a href="#">Duis</a>, <a href="#">News</a> </span>
								<span><i class="fa fa-comments"></i> <a href="#">12 Comments</a></span>
								<hr class="solid">
								<a href="blog-post.html" class="btn btn-xs btn-primary pull-right mb-lg">Read more...</a>
							</div>
							 --%>
						</article>
					</div>
				</div>
	</c:forEach>
	</c:if>