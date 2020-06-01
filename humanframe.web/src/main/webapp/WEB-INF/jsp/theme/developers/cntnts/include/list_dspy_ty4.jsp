<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ include file="/common/taglibs.jsp" %>
		<%--
		1. TAB형태의 콘텐츠 리스트
		--%>
		<div class="tabs">
			<ul class="nav nav-tabs nav-justified">
				<c:forEach items="${articles}" var="article" varStatus="status">
				<li id="tap_${article.uriWrd}" class="<c:if test="${status.first}"> active</c:if>">
					<a href="#${article.uriWrd}" data-toggle="tab" class="text-center"><i class="fa fa-star"></i> ${article.cntntsSj}</a>
				</li>
				</c:forEach>
			</ul>
			<div class="tab-content">
				<c:forEach items="${articles}" var="article" varStatus="status">
				<c:set var="cmUseAt">
					<c:choose>
						<c:when test="${status.first }">N</c:when>
						<c:otherwise>Y</c:otherwise>
					</c:choose>
				</c:set>
				<div id="${article.uriWrd}" class="tab-pane<c:if test="${status.first}"> active</c:if>" data-cm-use-at="${cmUseAt}">
					<p>${article.cntntsSj}</p>
					<!-- 롤링이미지 -->
					<c:if test="${!empty article.relateImageList && article.relateImageAt eq 'Y'}">
						<div class="owl-carousel owl-theme mb-none" data-plugin-options='{"items": 1, "autoplay": true, "autoplayTimeout": 3000}' style="width: 70%; margin: 0 auto;">
						<c:forEach items="${article.relateImageList}" var="relateList" varStatus="relate_status">
							<c:set var="fileInfo" value="${relateList.mediaVO.mediaFileList[0]}" />
							<img src="/comm/getImage?srvcId=${fileInfo.srvcId}&upperNo=${fileInfo.upperNo}&fileTy=${fileInfo.fileTy}&fileNo=${fileInfo.fileNo}" alt="" width="100%" height="350px"/>
						</c:forEach>
						</div>
					</c:if>
					<!-- 본문 -->
					<p>${article.cn}</p>
				</div>
				</c:forEach>
<%-- 				<c:if test="${article.cmUseAt eq 'Y'}"> --%>
				<div id="tab-comments" class="hidden">
				<jsp:include page="../../common/cm.jsp">
					<jsp:param name="mapngAt" value="cntnts" />
					<jsp:param name="cntntsNo" value="${articles[0].cntntsNo}" />
				</jsp:include>
				</div>
<%-- 				</c:if> --%>
			</div>
		</div>

<script>
$(function(){
	if(null !="${previewUriWrd}" && "" != "${previewUriWrd}"){
		$("[class*=active]").removeClass("active");
		$("#tap_" + "${previewUriWrd}").addClass("active");
		$("#" + "${previewUriWrd}").addClass("active");
	}
	//tab 변경 시 cm 재설정
	$("a[data-toggle='tab']").on("show.bs.tab",function(e){//shown.bs.tab
		var tgt = $(this).attr("href").replace("#","");
		$(".post-leave-comment input[name='cntntsNo']").val(tgt);
		resetCmList();
		resetCmFrm();
		if($(".tab-content .tab-pane#"+tgt).data('cmUseAt')=="Y"){
			$("#tab-comments").removeClass('hidden');
			getCmList('new');
		}else{
			$("#tab-comments").addClass('hidden');
		}
	});
});
</script>