<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp" %>
<%@ page trimDirectiveWhitespaces="true" %>

<c:if test="${not empty popupList}">
<div class="popup popup-layer" id="popupLayer">
<c:forEach items="${popupList}" var="popup" varStatus="status">
	<c:set var="popupTargetId" value="popup_ctrl_${popup.popupNo}"/>
	<c:if test="${popup.popupTy eq '2' and empty cookie[popupTargetId]}">
			
		<div id="popup-${popup.popupNo}" style="
			position: fixed;
			width:	${popup.popupWidth+10}px;
			height:	${popup.popupHeight+10}px;
			top:	${popup.popupTop}px;
			left:	${popup.popupLeft}px;
    		border: 5px solid #3571B5;
    		background-color: #3571B5;
    		border-radius: 5px;
    		z-index: 9999;
		">
			<a href="${popup.linkUrl}" target="${popup.linkTrgt}">
				<img width="${popup.popupWidth}" height="${popup.popupHeight}" 
					src="/comm/getImage?srvcId=${popup.fileList[0].srvcId}&amp;upperNo=${popup.fileList[0].upperNo }&amp;fileTy=${popup.fileList[0].fileTy }&amp;fileNo=${popup.fileList[0].fileNo }" 
					alt="${popup.popupSj}" border="0" style="border-radius:5px;"/>
			</a>
			<div class="btn-group btn-group-xs" style="position:absolute;right:1%;bottom:1%;">
				<a href="#" data-popup-id="${popup.popupNo}" data-popup-btn-action="snooze" class="btn btn-primary">하룻동안 열지 않음</a>
				<a href="#" data-popup-id="${popup.popupNo}" data-popup-btn-action="close" class="btn btn-warning">창닫기</a>
			</div>
		</div>
	
	</c:if>
</c:forEach>
</div>
</c:if>