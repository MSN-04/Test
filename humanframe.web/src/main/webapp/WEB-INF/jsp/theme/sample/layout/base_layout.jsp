<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ include file="/common/taglibs.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <title>메인샘플</title>
    <meta charset="UTF-8" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0" />
	<link rel="stylesheet" type="text/css" href="${themeAssets}/style/base.css" />
	<link rel="stylesheet" type="text/css" href="${themeAssets}/style/main.css" />
	<link rel="stylesheet" type="text/css" href="${themeAssets}/style/owl.carousel.min.css" />
	<link rel="stylesheet" type="text/css" href="${themeAssets}/style/theme.css" />
	<script src="${themeAssets}/script/jquery-1.12.4.min.js"></script>
	<script src="${themeAssets}/script/owl.carousel.min.js"></script>
	<!--[if lt IE 9]>
	<script src="${themeAssets}/script/html5shiv.min.js"></script>
	<![endif]-->
	<script>
		$(document).ready(function(){		
			if($('.slide-element-inner .item').length > 1){				
				var quickSlide = $('.slide-element-inner.owl-carousel');
				quickSlide.owlCarousel({                
					margin:0,
					nav:false,
					loop:false,			   
					autoplay:false,
					items:1
				})
			}
		})
	</script>
</head>
<body>
	<div class="wrapper-element">
		<header>
			<tiles:insertAttribute name="header"/>
		</header>
		<main>
			<tiles:insertAttribute name="content"/>
		</main>
		<tiles:insertAttribute name="footer"/>
	</div>
</body>
</html>