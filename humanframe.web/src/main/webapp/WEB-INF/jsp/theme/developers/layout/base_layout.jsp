<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ include file="/common/taglibs.jsp" %>
<!DOCTYPE html>
<html lang="${curSiteVO.langCodeId}" class="${curSiteVO.langCodeId}">
<head>

	<meta charset="UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <meta name="description" content="">
    <meta name="keywords" content="">

    <!-- Fonts -->
    <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700,800%7CShadows+Into+Light" rel="stylesheet" type="text/css">

	<!-- Vendor CSS -->
	<link rel="stylesheet" href="${themeAssets}/vendor/bootstrap/css/bootstrap.min.css">
	<link rel="stylesheet" href="${themeAssets}/vendor/font-awesome/css/font-awesome.min.css">
	<link rel="stylesheet" href="${themeAssets}/vendor/simple-line-icons/css/simple-line-icons.min.css">
	<link rel="stylesheet" href="${themeAssets}/vendor/owl.carousel/assets/owl.carousel.min.css">
	<link rel="stylesheet" href="${themeAssets}/vendor/owl.carousel/assets/owl.theme.default.min.css">
	<link rel="stylesheet" href="${themeAssets}/vendor/magnific-popup/magnific-popup.min.css">

	<!-- Theme CSS -->
	<link rel="stylesheet" href="${themeAssets}/css/theme.css">
	<link rel="stylesheet" href="${themeAssets}/css/theme-elements.css">
	<link rel="stylesheet" href="${themeAssets}/css/theme-blog.css">
	<link rel="stylesheet" href="${themeAssets}/css/theme-shop.css">
	<link rel="stylesheet" href="${themeAssets}/css/theme-animate.css">
	
	<!-- Admin Extension CSS -->
	<link rel="stylesheet" href="${themeAssets}/admin/css/theme-admin-extension.css">

	<link rel="stylesheet" href="${themeAssets}/css/skins/default.css">
	<link rel="stylesheet" href="${themeAssets}/css/custom.css">
	<c:if test="${not empty bbsSkinVO.cssDocbase}">
	<link rel="stylesheet" href="${globalAssets}/bbs/skin/style/${bbsSkinVO.cssDocbase}">
	</c:if>
	<!-- Scripts -->
	<script src="${themeAssets}/vendor/jquery/jquery-2.2.2.min.js"></script>

	<!-- jQuery Validate -->
	<script src="${themeAssets}/vendor/jquery.validate/jquery.validate.min.js"></script>
	<c:if test="${curSiteVO.langCodeId ne 'en'}">
	<script src="${themeAssets}/vendor/jquery.validate/localization/messages_${curSiteVO.langCodeId}.js"></script>
	</c:if>

	<title>${curMenuVO.menuNm} : ${curSiteVO.siteNm}</title>

</head>
<body class="loading-overlay-showing" data-loading-overlay>
<div class="loading-overlay">
	<div class="loader"></div>
</div>
<c:if test="${curMenuVO.upperMenuNo eq 0 and fn:length(popupList) gt 0}">
<c:import url="../common/popup/band.jsp"/>
</c:if>

<div class="body">

	<!-- start:header -->
	<tiles:insertAttribute name="header"/>
	<!-- end:header -->

	<!-- start:content -->

	<div role="main" class="main">

		<section class="page-header">
			<div class="container">
				<div class="row">
					<div class="col-md-12">
						<ul class="breadcrumb">
						<c:set var="breadCrumbList" value="${fn:split(curMenuVO.menuNmPath, '>')}" />
						<c:forEach var="breadCrumb" items="${breadCrumbList}" begin="0" varStatus="status" >
							<c:if test="${!status.last}">
							<li ${status.last?'class="active"':''}>${breadCrumb}</li>
							</c:if>
						</c:forEach>
						</ul>
					</div>
				</div>
				<div class="row">
					<div class="col-md-12">
						<h1>${curMenuVO.menuNm }</h1>
					</div>
				</div>
			</div>
		</section>

		<div class="container">
			<div class="row">
				<c:if test="${!empty curMenuVO.asideOpt}">
				<div class="col-md-9">
				<tiles:insertAttribute name="content"/>
				</div>

				<div class="col-md-3">
				<tiles:insertAttribute name="aside"/>
				</div>
				</c:if>
				<c:if test="${empty curMenuVO.asideOpt}">
				<div class="col-md-12">
				<tiles:insertAttribute name="content"/>
				</div>
				</c:if>

				<%-- <div class="col-md-12">
				<tiles:insertAttribute name="content"/>
				</div> --%>
			</div>
			<%--TODO  --%>
			<c:if test="${curSiteVO.cmUseAt eq 'Y' and curMenuVO.cmUseAt eq 'Y'}">
				<c:import url="../common/cm.jsp">
<%-- 					<c:param name="mapngAt" value="menu" /> --%>
				</c:import>
			</c:if>
			<c:if test="${curSiteVO.stsfdgUseAt eq 'Y' and curMenuVO.stsfdgUseAt eq 'Y'}">
				<c:import url="../common/stsfdg.jsp"></c:import>
			</c:if>
			<c:if test="${curSiteVO.mnuChargerUseAt eq 'Y' and curMenuVO.mnuChargerUseAt eq 'Y' and (
				not empty curMenuVO.mnuChargerNm or not empty article.chargerNm )}">
				<c:import url="../common/mnuCharger.jsp"></c:import>
			</c:if>
		</div>
	</div>
	<!-- end:content -->

	<!-- start:footer -->
	<tiles:insertAttribute name="footer"/>
	<!-- end:footer -->
	
	<c:if test="${curMenuVO.upperMenuNo eq 0 and fn:length(popupList) gt 0}">
	<c:import url="../common/popup/layer.jsp"/>
	<c:import url="../common/popup/newWindow.jsp"/>
	</c:if>

</div>

<script src="${themeAssets}/vendor/bootstrap/js/bootstrap.min.js"></script>
<script src="${themeAssets}/vendor/owl.carousel/owl.carousel.min.js"></script>
<script src="${themeAssets}/vendor/magnific-popup/jquery.magnific-popup.min.js"></script>
<script src="${themeAssets}/vendor/jquery.gmap/jquery.gmap.min.js"></script>

<script src="${themeAssets}/script/theme.js"></script>
<script src="${themeAssets}/script/theme.init.js"></script>
<script src="${themeAssets}/script/common.js"></script>

<c:if test="${!empty curSiteVO.googleKey }">
<!-- Google Analytics -->
<script>
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

  ga('create', '${curSiteVO.googleKey}', 'auto');
  ga('send', 'pageview');
</script>
</c:if>
<c:if test="${!empty curSiteVO.naverKey }">
<!-- Naver Analytics -->
<script type="text/javascript" src="http://wcs.naver.net/wcslog.js"></script>
<script type="text/javascript">
if(!wcs_add) var wcs_add = {};
wcs_add["wa"] = "${curSiteVO.naverKey}";
wcs_do();
</script>
</c:if>
</body>
</html>