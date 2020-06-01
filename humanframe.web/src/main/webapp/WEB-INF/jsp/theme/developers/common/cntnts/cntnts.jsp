<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp" %>
<%@ page trimDirectiveWhitespaces="true" %>

	<c:if test="${not empty cntntsList}">
	<c:forEach items="${cntntsList}" var="cntnts" varStatus="status">
		<c:set var="plainCn" value="${fn:trim(cmsFn:removeHtmlTag(cntnts.cn)) }"/>
		<c:set var="cntntsUri">
			${firstUri}${cntnts.menuUri}<c:if test="${cntnts.postListTy eq '2' }">/${cntnts.uriWrd }</c:if>
		</c:set>
		<fmt:parseDate var="pblcateDe" value="${cntnts.pblcateDe}" pattern="yyyy-MM-dd" />

							<div>
								<div class="recent-posts">
									<article class="post">
										<div class="date">
											<span class="day"><fmt:formatDate value="${pblcateDe}" pattern="d"/></span>
											<span class="month"><fmt:formatDate value="${pblcateDe}" pattern="MMM"/></span>
										</div>
										<h4><a href="${cntntsUri}">${cntnts.cntntsSj }</a></h4>
										<p>
											<c:choose>
											<c:when test="${fn:length(plainCn) gt 200}">
												${fn:substring(plainCn, 0, 200)}
												&nbsp;...&nbsp;
												<a href="${cntntsUri}" class="read-more pull-right">read more <i class="fa fa-angle-right"></i></a>
											</c:when>
											<c:otherwise>
												${plainCn}
											</c:otherwise>
											</c:choose>
										</p>
									</article>
								</div>
							</div>
	</c:forEach>
	</c:if>