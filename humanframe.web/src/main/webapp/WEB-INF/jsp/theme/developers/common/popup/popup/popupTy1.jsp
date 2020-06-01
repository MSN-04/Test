<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp" %>
<%@ page trimDirectiveWhitespaces="true" %>
<c:set var="themeAssets" value="/humanframe/theme/${curSiteVO.siteSkn}/assets"/>
<!DOCTYPE html>
<html lang="${curSiteVO.langCodeId}" class="${curSiteVO.langCodeId}">
<head>
	<meta charset="UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no">
	<title>${popup.popupSj}</title>
	<!-- Vendor CSS -->
	<link rel="stylesheet" href="${themeAssets}/vendor/bootstrap/css/bootstrap.min.css">
	<!-- Theme CSS -->
	<link rel="stylesheet" href="${themeAssets}/css/theme.css">
	<link rel="stylesheet" href="${themeAssets}/css/theme-elements.css">
	
	<link rel="stylesheet" href="${themeAssets}/css/skins/default.css">
	<link rel="stylesheet" href="${themeAssets}/css/custom.css">
	<!-- Scripts -->
	<script src="${themeAssets}/vendor/jquery/jquery-2.2.2.min.js"></script>
	<script type="text/javascript">
	// popup ctrl
	$(function() {
		$(document).on('click', '.popup .btn', function (e) {
			e.preventDefault();
			var action = $(this).data("popupBtnAction");
			var targetId = $(this).data("popupId");
			var exday = 1;
			switch(action){
			case "snooze":
				var exdate = new Date();
				exdate.setDate(exdate.getDate() + exday);
				document.cookie = "popup_ctrl_"+targetId+"=N; expires="+exdate.toUTCString()+"; path=/";
			case "close":
				window.close();
				break;
			}
		});
	});
	</script>
	<style>
		body {
			margin : 0;
			overflow : hidden;
		}
	</style>
</head>
<body>
		<div id="popup-${popup.popupNo}" class="popup" style="
			position: fixed;
			width:	${popup.popupWidth}px;
			height:	${popup.popupHeight}px;
			top:	0px;
			left:	0px;
    		z-index: 9999;
		">
			<a href="${popup.linkUrl}" target="${popup.linkTrgt}">
				<img width="${popup.popupWidth}" height="${popup.popupHeight}" 
					src="/comm/getImage?srvcId=${popup.fileList[0].srvcId}&amp;upperNo=${popup.fileList[0].upperNo }&amp;fileTy=${popup.fileList[0].fileTy }&amp;fileNo=${popup.fileList[0].fileNo }" 
					alt="${popup.popupSj}" border="0"/>
			</a>
			<div class="btn-group btn-group-xs" style="position:absolute;right:1%;bottom:1%;">
				<a href="#" data-popup-id="${popup.popupNo}" data-popup-btn-action="snooze" class="btn btn-primary">하룻동안 열지 않음</a>
				<a href="#" data-popup-id="${popup.popupNo}" data-popup-btn-action="close" class="btn btn-warning">창닫기</a>
			</div>
		</div>
</body>
</html>