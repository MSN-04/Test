<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page trimDirectiveWhitespaces="true" %>
<c:set var="globalAdminAssets" value="/humanframe/admin/assets" />
<c:if test="${!empty themeDir}">
<c:import url="${themeDir}/error/error.jsp"></c:import>
</c:if>
<c:if test="${empty themeDir}">
<!DOCTYPE html>
<!--[if lt IE 7]>      <html class="no-js lt-ie9 lt-ie8 lt-ie7"> <![endif]-->
<!--[if IE 7]>         <html class="no-js lt-ie9 lt-ie8"> <![endif]-->
<!--[if IE 8]>         <html class="no-js lt-ie9"> <![endif]-->
<!--[if gt IE 8]><!--> <html class="no-js"> <!--<![endif]-->
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>CMS 500 ERROR</title>
    <meta name="description" content="">
    <meta name="viewport" content="width=device-width">

    <link rel="stylesheet" type="text/css" href="${globalAdminAssets}/css/bootstrap.min.css">
    <link rel="stylesheet" type="text/css" href="${globalAdminAssets}/css/default.min.css">

	<script src="${globalAdminAssets}/js/jquery-1.10.2.min.js"></script>
    <script>
	$(document).ready(function() {
		var returnHome = window.setTimeout(function(){
			//location.href="/";
			//history.back(-1);
		}, 3000);
	});
	</script>
</head>
<body>
    <!-- Start Error Page Wrapper -->
    <div id="error-page-wrapper" style="padding-bottom:80px;">

        <div class="error-code">500</div>
        <div class="error-text">Internal Server Error.</div>
        <div class="error-text-help">CMS Error</div>

    </div>
    <!-- End Error Page Wrapper -->

</body>
</html>
</c:if>