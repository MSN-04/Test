<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page trimDirectiveWhitespaces="true" %>
<c:set var="globalAdminAssets" value="/humanframe/admin/assets" />
<c:if test="${!empty themeDir}">
<c:import url="${themeDir}/error/error.jsp"></c:import>
</c:if>
<c:if test="${empty themeDir}">

<!DOCTYPE html>
<html lang="ko" class="ko">
<head>

	<meta charset="UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <meta name="description" content="">
    <meta name="keywords" content="">

    <!-- Fonts -->
    <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700,800%7CShadows+Into+Light" rel="stylesheet" type="text/css">

	<!-- Vendor CSS -->
	<link rel="stylesheet" href="/humanframe/theme/developers/assets/vendor/bootstrap/css/bootstrap.min.css">
	<link rel="stylesheet" href="/humanframe/theme/developers/assets/vendor/font-awesome/css/font-awesome.min.css">
	<link rel="stylesheet" href="/humanframe/theme/developers/assets/vendor/simple-line-icons/css/simple-line-icons.min.css">
	<link rel="stylesheet" href="/humanframe/theme/developers/assets/vendor/owl.carousel/assets/owl.carousel.min.css">
	<link rel="stylesheet" href="/humanframe/theme/developers/assets/vendor/owl.carousel/assets/owl.theme.default.min.css">
	<link rel="stylesheet" href="/humanframe/theme/developers/assets/vendor/magnific-popup/magnific-popup.min.css">

	<!-- Theme CSS -->
	<link rel="stylesheet" href="/humanframe/theme/developers/assets/css/theme.css">
	<link rel="stylesheet" href="/humanframe/theme/developers/assets/css/theme-elements.css">
	<link rel="stylesheet" href="/humanframe/theme/developers/assets/css/theme-blog.css">
	<link rel="stylesheet" href="/humanframe/theme/developers/assets/css/theme-shop.css">
	<link rel="stylesheet" href="/humanframe/theme/developers/assets/css/theme-animate.css">
	
	<!-- Admin Extension CSS -->
	<link rel="stylesheet" href="/humanframe/theme/developers/assets/admin/css/theme-admin-extension.css">

	<link rel="stylesheet" href="/humanframe/theme/developers/assets/css/skins/default.css">
	<link rel="stylesheet" href="/humanframe/theme/developers/assets/css/custom.css">
	<!-- Scripts -->
	<script src="/humanframe/theme/developers/assets/vendor/jquery/jquery-2.2.2.min.js"></script>

	<!-- jQuery Validate -->
	<script src="/humanframe/theme/developers/assets/vendor/jquery.validate/jquery.validate.min.js"></script>
	<script src="/humanframe/theme/developers/assets/vendor/jquery.validate/localization/messages_ko.js"></script>
	<title>403</title>

</head>

<body>
<div class="body">
    
	<div role="main" class="main">
		<div class="container">
			<section class="page-not-found">
				<div class="row">
					<div class="col-md-12">
						<div class="page-not-found-main text-center">
							<h2>403 <i class="fa fa-file"></i></h2>
							<p>The page or resource you were trying to reach is absolutely forbidden for some reason.</p>
						</div>
					</div>
				</div>
			</section>
		</div>
	</div>
	
	
</div>
</body>
</html>
</c:if>