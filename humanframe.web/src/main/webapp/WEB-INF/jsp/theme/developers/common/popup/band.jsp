<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp" %>
<%@ page trimDirectiveWhitespaces="true" %>

<c:if test="${not empty popupList}">
<c:forEach items="${popupList}" var="popup" varStatus="status">
<c:set var="popupTargetId" value="popup_ctrl_${popup.popupNo}"/>
<c:if test="${popup.popupTy eq '3' and empty cookie[popupTargetId]}">
<div id="popup-${popup.popupNo}" class="popup popup-band-top" style="
height:${popup.popupHeight}px;
background-color: rgba(0, 0, 0, 0);
background-repeat: no-repeat;
background-image: url(/comm/getImage?srvcId=${popup.fileList[0].srvcId}&amp;upperNo=${popup.fileList[0].upperNo }&amp;fileTy=${popup.fileList[0].fileTy }&amp;fileNo=${popup.fileList[0].fileNo });
background-size: cover;
background-position: center center;">
<div class="container"><div class="row">
<div class="col-md-12" style="height:${popup.popupHeight-22}px;" onclick="window.open('${popup.linkUrl}', '${popup.linkTrgt}')"></div>
<div class="col-md-12" style="height:22px;">
<div class="btn-group btn-group-xs" style="position:absolute;right:1%;bottom:1%;">
	<a href="#" data-popup-id="${popup.popupNo}" data-popup-btn-action="snooze" class="btn btn-primary">하룻동안 열지 않음</a>
	<a href="#" data-popup-id="${popup.popupNo}" data-popup-btn-action="close" class="btn btn-warning">창닫기</a>
</div>
</div></div></div>
</div>
</c:if>
</c:forEach>
</c:if>