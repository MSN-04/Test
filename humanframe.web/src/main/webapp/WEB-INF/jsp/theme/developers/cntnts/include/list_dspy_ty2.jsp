<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ include file="/common/taglibs.jsp" %>

		<div class="blog-posts">
			<c:forEach items="${articles}" var="article" varStatus="status">
				<article class="post post-medium">
					<div class="row">
						<c:if test="${!empty article.fileList}">
							<div class="col-md-5">
								<div class="post-image">
									<div class="img-thumbnail">
									<c:forEach var="fileList" items="${article.fileList }" varStatus="status">
										<img class="img-responsive" src="/comm/getImage?srvcId=${fileList.srvcId }&amp;upperNo=${fileList.upperNo }&amp;fileTy=${fileList.fileTy }&amp;fileNo=${fileList.fileNo }">
									</c:forEach>
									</div>
								</div>
							</div>
							<div class="col-md-7">
								<div class="post-content">
									<h2><a href="${curMenuVO.menuUri}/${article.uriWrd}">${article.cntntsSj}</a></h2>
									<p style="word-break:break-all">${article.sumry}</p>
								</div>
							</div>
						</c:if>

						<c:if test="${empty article.fileList}">
							<div class="col-md-12">
								<div class="post-content">
									<h2><a href="${curMenuVO.menuUri}/${article.uriWrd}">${article.cntntsSj}</a></h2>
									<p style="word-break:break-all">${article.sumry}</p>
								</div>
							</div>
						</c:if>
					</div>
					<!-- row -->
					<div class="row">
						<div class="col-md-12">
							<div class="post-meta">
								<span><i class="fa fa-calendar"></i> ${article.pblcateDe} </span>
								<span><i class="fa fa-user"></i> By <a href="#">${article.chargerNm}</a> </span>
								<a href="${curMenuVO.menuUri}/${article.uriWrd}" class="btn btn-xs btn-primary pull-right"><spring:message code='ui.details' /></a>
							</div>
						</div>
					</div>

				</article>
			</c:forEach>

			<!-- paging -->
			<div class="row">
				<div class="col-md-12">
					<cms:paging listVO="${listVO}"
						firstIcon="<i class='fa fa-angle-double-left'></i>"
						prevIcon="<i class='fa fa-angle-left'></i>"
						nextIcon="<i class='fa fa-angle-right'></i>"
						lastIcon="<i class='fa fa-angle-double-right'></i>"
						cssClass="pagination pull-right"/>
				</div>
			</div>
			<!-- //paging -->

		</div>
		<!-- //blog-posts -->