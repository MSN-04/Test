<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ include file="/common/taglibs.jsp" %>

<script src="${themeAssets}/script/map.js"></script>
<c:if test="${provider eq 'GOOGLE'}">
	<script src="http://maps.google.com/maps/api/js?key=${apikey}"></script>
</c:if>
<c:if test="${provider eq 'NAVER'}">
	<script type="text/javascript" src="https://openapi.map.naver.com/openapi/v3/maps.js?clientId=${apikey}"></script>
</c:if>
<c:if test="${provider eq 'DAUM'}">
	<script type="text/javascript" src="//apis.daum.net/maps/maps3.js?apikey=${apikey}"></script>
</c:if>

<div id="mapDiv" class="google-map mt-none mb-lg" style="height: 580px; "></div>

<%--
1. 지도에 대한 선택은 프로젝트에 따라 변경될수 있음 (구글맵, 네이버맵, 다음맵 등)
2. 좌표체계를 이용하는 로직만 이해한다면 응용가능할 것으로 판단
3. 상세페이지 또한 지도위에 레이어로 할지 상세페이지로 링크로 할지 등은 프로젝트 기획에 따라 추가작업이 필요
 --%>
<script>
$(function(){

	var provider = "${provider}";
	var makerlist = [];
	<c:forEach items="${articles}" var="article" varStatus="status">
	  var html = "<div style=\"width:750px;padding:5px;\"><strong><a href=\"${curMenuVO.menuUri}/${article.uriWrd}\">${article.cntntsSj}</a></strong><br />${article.sumry}<br />장소 : ${article.adres}</div>"
	  var list =  {"lat": parseFloat("${article.adresLo}"), "lng":  parseFloat("${article.adresLa}"), "html": html}
	  makerlist.push(list);
	</c:forEach>

	var option = {
			"image" : "${themeAssets}/img/pin.png"
		  , "makerList" : makerlist
	}

	if(makerlist.length > 0){
		init(provider, "mapDiv", makerlist[0].lat,  makerlist[0].lng, option);
	} else {
		init(provider, "mapDiv", 37.5623816919, 126.9755613438, option);
	}

});
</script>
