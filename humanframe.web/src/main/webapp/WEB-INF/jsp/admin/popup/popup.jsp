<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true" %>
<%@ include file="/common/taglibs.jsp" %>
<c:choose>
<c:when test="${param.popupTy eq '1' }">
<html>
<head>
	<title>${popup.popupSj}</title>
	<script type="text/javascript">
	//set cookie
	function setCookie(name, value, expiredays)
	{
	    var todayDate = new Date();
	    todayDate.setDate(todayDate.getDate() + expiredays);
	    document.cookie = name + "=" + escape(value) + "; path=/; expires=" + todayDate.toGMTString() + ";";
	}
	function closeWin(popupId, popupVal, div){
		if(div=="today"){
			setCookie(popupId,popupVal,1);
			window.close();
		}
		window.close();
	}
	</script>
	<style>
		body {
			margin : 0;
			overflow : hidden;
		}
	</style>
</head>
<body>

		<c:set var="pLinkBgn" value='' /><c:set var="pLinkEnd" value='' />
		<c:choose>
		<c:when test="${ !empty popup.linkUrl and popup.linkUrl ne '' }">
			<c:set var="pLinkBgn" value='<a href="${ popup.linkUrl }" target="${popup.linkTrgt}">' /><c:set var="pLinkEnd" value='</a>'/>
		</c:when>
		</c:choose>
		<div id="popup${popup.popupNo}" style="position:relative;">
			${pLinkBgn}
			<img width="${popup.popupWidth}" height="${popup.popupHeight}" src="/comm/getImage?srvcId=${popup.fileList[0].srvcId}&upperNo=${popup.fileList[0].upperNo}&fileTy=${popup.fileList[0].fileTy}&fileNo=${popup.fileList[0].fileNo }" alt="${popup.popupSj} 팝업 이미지" border="0"/>
			${pLinkEnd}
			<div style="position:absolute;right:1px;bottom:1px;">
				<c:if test="${ popup.stopViewAt eq 'Y' }">
				<a href="#" onclick="closeWin('popup${popup.popupNo}','${popup.popupNo}','today');return false;">하룻동안 열지 않음</a>
				</c:if>
				<a href="#" onclick="closeWin('','','');return false;">창닫기</a>
			</div>
		</div>
</body>
</html>
</c:when>
<c:when test="${param.popupTy eq '2' }">
<c:set var="pLinkBgn" value='' /><c:set var="pLinkEnd" value='' />
<c:choose>
<c:when test="${ !empty popup.linkUrl and popup.linkUrl ne '' }">
	<c:set var="pLinkBgn" value='<a href="${ popup.linkUrl }" target="${popup.linkTrgt}">' /><c:set var="pLinkEnd" value='</a>'/>
</c:when>
</c:choose>
<div id="popup${popup.popupNo}" class="pop-layer">
	${pLinkBgn}
	<img width="${popup.popupWidth}" height="${popup.popupHeight}" src="/comm/getImage?srvcId=${popup.fileList[0].srvcId}&upperNo=${popup.fileList[0].upperNo}&fileTy=${popup.fileList[0].fileTy}&fileNo=${popup.fileList[0].fileNo }" alt="${popup.popupSj} 팝업 이미지" border="0"/>
	${pLinkEnd}
	<div class="btn-group btn-group-xs" style="position:absolute;right:1px;bottom:1px;">
		<c:if test="${ popup.stopViewAt eq 'Y' }">
		<a href="#" class="btn btn-primary" >하룻동안 열지 않음</a>
		</c:if>
		<a href="#" class="btn btn-warning" >창닫기</a>
	</div>
</div>
</c:when>
<c:when test="${param.popupTy eq '3' }">
<c:set var="pLinkBgn" value='' /><c:set var="pLinkEnd" value='' />
<c:choose>
<c:when test="${ !empty popup.linkUrl and popup.linkUrl ne '' }">
	<c:set var="pLinkBgn" value='<a href="${ popup.linkUrl }" target="${popup.linkTrgt}">' /><c:set var="pLinkEnd" value='</a>'/>
</c:when>
</c:choose>
<div id="popup${popup.popupNo}" class="pop-layer top">
	${pLinkBgn}
	<img src="/comm/getImage?srvcId=${popup.fileList[0].srvcId}&upperNo=${popup.fileList[0].upperNo}&fileTy=${popup.fileList[0].fileTy}&fileNo=${popup.fileList[0].fileNo }" alt="${popup.popupSj} 팝업 이미지" border="0"/>
	${pLinkEnd}
	<div class="btn-group btn-group-xs" style="position:absolute;right:1px;bottom:1px;">
		<c:if test="${ popup.stopViewAt eq 'Y' }">
		<a href="#" class="btn btn-primary" >하룻동안 열지 않음</a>
		</c:if>
		<a href="#" class="btn btn-warning" >창닫기</a>
	</div>
</div>
</c:when>
</c:choose>