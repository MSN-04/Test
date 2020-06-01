<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ include file="/common/taglibs.jsp" %>
<!doctype html>
<html class="fixed header-dark sidebar-light sidebar-left-sm">
<head>
	<!-- Basic -->
	<meta charset="UTF-8">

	<title>CMS 관리자 - 홍익인간</title>

	<!-- Mobile Metas -->
	<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />

	<!-- Vendor CSS -->
	<link rel="stylesheet" href="${globalAdminAssets}/vendor/bootstrap/css/bootstrap.css" />

	<link rel="stylesheet" href="${globalAdminAssets}/vendor/font-awesome/css/font-awesome.css" />
	<link rel="stylesheet" href="${globalAdminAssets}/vendor/magnific-popup/magnific-popup.css" />
	<link rel="stylesheet" href="${globalAdminAssets}/vendor/bootstrap-datepicker/css/bootstrap-datepicker3.css" />

	<!-- Specific Page Vendor CSS -->
	<link rel="stylesheet" href="${globalAdminAssets}/vendor/jquery-ui/jquery-ui.css" />
	<link rel="stylesheet" href="${globalAdminAssets}/vendor/jquery-ui/jquery-ui.theme.css" />
	<link rel="stylesheet" href="${globalAdminAssets}/vendor/bootstrap-multiselect/bootstrap-multiselect.css" />
	<link rel="stylesheet" href="${globalAdminAssets}/vendor/morris.js/morris.css" />

	<!-- Theme CSS -->
	<link rel="stylesheet" href="${globalAdminAssets}/stylesheets/theme.css" />

	<!-- Skin CSS -->
	<link rel="stylesheet" href="${globalAdminAssets}/stylesheets/skins/default.css" />

	<!-- Theme Custom CSS -->
	<link rel="stylesheet" href="${globalAdminAssets}/stylesheets/theme-custom.css">

	<!-- Head Libs -->
	<script src="${globalAdminAssets}/vendor/modernizr/modernizr.js"></script>

	<!-- Vendor -->
	<script src="${globalAdminAssets}/vendor/jquery/jquery.js"></script>
	<script src="${globalAdminAssets}/vendor/jquery-browser-mobile/jquery.browser.mobile.js"></script>
	<script src="${globalAdminAssets}/vendor/jquery-placeholder/jquery-placeholder.js"></script>
	<script src="${globalAdminAssets}/vendor/jquery.validate.min.js"></script>
	<script src="${globalAdminAssets}/vendor/bootstrap/js/bootstrap.js"></script>
	<script src="${globalAdminAssets}/vendor/bootstrap-datepicker/js/bootstrap-datepicker.js"></script>
	<script src="${globalAdminAssets}/vendor/nanoscroller/nanoscroller.js"></script>
	<script src="${globalAdminAssets}/vendor/magnific-popup/jquery.magnific-popup.js"></script>


</head>
<body>
	<section role="main">
		<div class="row">
			<div class="col-md-12">
				<tiles:insertAttribute name="content"/>
			</div>
		</div>
	</section>

	<!-- Theme Base, Components and Settings -->
	<script src="${globalAdminAssets}/javascripts/theme.js"></script>

	<!-- Theme Custom -->
	<script src="${globalAdminAssets}/javascripts/theme.custom.js"></script>

	<!-- Theme Initialization Files -->
	<script src="${globalAdminAssets}/javascripts/theme.init.js"></script>

</body>
</html>