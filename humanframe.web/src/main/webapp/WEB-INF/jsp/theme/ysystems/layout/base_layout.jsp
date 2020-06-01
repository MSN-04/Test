<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ include file="/common/taglibs.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<title>Ysystems</title>
	<title>와이시스템즈</title>

	<meta charset="UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0">
	<meta name="title" content="">
	<script type="text/javascript" src="${themeAssets}/js/jquery-1.11.3.min.js"></script>
	<script type="text/javascript" src="${themeAssets}/js/jssor.slider.min.js"></script>
	<script type="text/javascript" src="${themeAssets}/js/jssor_memory.js"></script>
	<script type="text/javascript" src="${themeAssets}/js/jssor_client.js"></script>
	<script type="text/javascript" src="${themeAssets}/js/jquery.scrollTo-min.js"></script>
	<script type="text/javascript" src="${themeAssets}/js/ui.js"></script>
	<link rel="stylesheet" href="${themeAssets}/style/roboto.css">
	<link rel="stylesheet" href="${themeAssets}/style/style.css">
	<meta name="naver-site-verification" content="92c361aad6f71b3c6eded6e7aa9809d0cb9e2d57"/>
	<meta name="description" content="오픈플랫폼과 열린정부 3.0의 리더그룹! 와이시스템즈">
</head>

<body>
	<tiles:insertAttribute name="header"/>
	<main>
	<tiles:insertAttribute name="content"/>
	</main>
	<tiles:insertAttribute name="footer"/>

	<jsp:include page="../index/include/prjctInqryform.jsp" />
</body>
</html>



