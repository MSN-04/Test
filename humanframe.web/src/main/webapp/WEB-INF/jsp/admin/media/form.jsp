<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/taglibs.jsp" %>
<%@ page trimDirectiveWhitespaces="true" %>
<!-- BEGIN Jcrop PLUGINS -->
	<script type="text/javascript" src="${globalAdminAssets}/javascripts/custom/human_jcrop.js" ></script>
	<script type="text/javascript" src="${globalAdminAssets}/javascripts/custom/jquery.Jcrop.min.js" ></script>
	<link rel="stylesheet" type="text/css" href="${globalAdminAssets}/stylesheets/jcrop/jquery.Jcrop.min.css" />

	 <!-- Smart Editor -->
    <script type="text/javascript" src="${globalAdminAssets}/smarteditor/js/HuskyEZCreator.js" charset="utf-8"></script>



			<!-- Start Main Content -->
            <div id="main-content">
                <p>&nbsp;</p>

                <!-- Start Breadcrumb -->
				<jsp:include page="/WEB-INF/jsp/admin/layout/breadcrumb.jsp">
					<jsp:param name="pageName" value="미디어 관리"/>
				</jsp:include>
				<!-- End Breadcrumb -->

                <%@ include file="include/form.jsp" %>

                <br />
            </div><!-- End Main Content -->