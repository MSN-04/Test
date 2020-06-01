<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ include file="/common/taglibs.jsp" %>
<c:choose>
	<c:when test="${bbsSettingVO.bbsTy eq '8'}">
		<!-- Smart Editor -->
	    <script type="text/javascript" src="${globalAdminAssets}/smarteditor/js/HuskyEZCreator.js" charset="utf-8"></script>
	</c:when>
	<c:otherwise>
		<!-- Smart Editor -->
	    <script type="text/javascript" src="${globalAdminAssets}/smarteditor/js/HuskyEZCreator.js" charset="utf-8"></script>
	
	    <!-- Tag Editor -->
		<script type="text/javascript" src="${globalAdminAssets}/javascripts/plugins/tag-editor/jquery.caret.min.js"></script>
	    <script type="text/javascript" src="${globalAdminAssets}/javascripts/plugins/tag-editor/jquery.tag-editor.min.js"></script>
	    <link rel="stylesheet" type="text/css" href="${globalAdminAssets}/stylesheets/plugins/tag-editor/jquery.tag-editor.css">
		
		<!-- DatetimePicker -->
		<script type="text/javascript" src="${globalAdminAssets}/javascripts/plugins/jquery.datetimepicker.js"></script>
	    <link rel="stylesheet" type="text/css" href="${globalAdminAssets}/stylesheets/plugins/jquery.datetimepicker.css">	
	</c:otherwise>
</c:choose>