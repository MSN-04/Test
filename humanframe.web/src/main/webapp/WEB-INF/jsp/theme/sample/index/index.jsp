<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ include file="/common/taglibs.jsp" %>
<div class="left-element">
	<ul class="new-list">
		<c:forEach items="${mainListA}" var="mainListA" varStatus="status">
		<li>
			<a href="${mainListA.linkUrl}" target="${mainListA.linkTrgt}">
				<div class="title">${mainListA.nttSj}</div>
				<div class="cont-element">
					<div class="img">
						<img src="/comm/getImage?srvcId=SITEMAIN&amp;upperNo=${mainListA.siteMainNo }&amp;fileTy=ATTACH&amp;fileNo=${mainListA.fileNo }&amp;thumbTy=S" width="90px;" height="60px;">
					</div>
					<span class="small-text"><span class="border-color1">${mainListA.nttSubSj}</span></span>
					${mainListA.nttCn}
				</div>
			</a>
		</li>
		</c:forEach>
		<c:forEach items="${mainListB}" var="mainListB" varStatus="status">
		<li>
			<a href="${mainListB.linkUrl}" target="${mainListB.linkTrgt}">
				<div class="title">${mainListB.nttSj}</div>
				<div class="cont-element">
					<div class="img"><img src="/comm/getImage?srvcId=SITEMAIN&amp;upperNo=${mainListB.siteMainNo }&amp;fileTy=ATTACH&amp;fileNo=${mainListB.fileNo }&amp;thumbTy=S" width="90px;" height="60px;"></div>
					<c:if test="${mainListB.nttSubSj != null && mainListB.nttSubSj != ''}">
					<span class="small-text"><span class="border-color1">${mainListB.nttSubSj}</span></span>
					</c:if>
					${mainListB.nttCn}
				</div>
			</a>
		</li>		
		</c:forEach>
	</ul>
</div>
<div class="right-element">
	<div class="slide-element">
		<div class="slide-element-inner owl-carousel">						
			<c:forEach items="${mainListC}" var="mainListC" varStatus="status">
			<div class="item">
				<a href="${mainListC.linkUrl}" target="${mainListC.linkTrgt}">
					<img src="/comm/getImage?srvcId=SITEMAIN&amp;upperNo=${mainListC.siteMainNo }&amp;fileTy=ATTACH&amp;fileNo=${mainListC.fileNo }">
					<div class="text-element">
						<p class="large-text">${mainListC.nttSj}</p>
						<p class="small-text">
							<span>${mainListC.nttSubSj}</span>
							${mainListC.nttCn}
						</p>
					</div>
				</a>
			</div>			
			</c:forEach>
		</div>
	</div>
	<ul class="photo-list">
		<c:forEach items="${mainListD}" var="mainListD" varStatus="status">
		<li>
			<a href="${mainListD.linkUrl}" target="${mainListD.linkTrgt}">
				<img src="/comm/getImage?srvcId=SITEMAIN&amp;upperNo=${mainListD.siteMainNo }&amp;fileTy=ATTACH&amp;fileNo=${mainListD.fileNo }">
				<span>${mainListD.nttSj}</span>
			</a>
		</li>		
		</c:forEach>
	</ul>
</div>