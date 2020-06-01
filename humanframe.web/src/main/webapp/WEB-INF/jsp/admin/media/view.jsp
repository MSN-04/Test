<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/taglibs.jsp" %>
<%@ page trimDirectiveWhitespaces="true" %>

			<!-- Start Main Content -->
            <div id="main-content">
                <p>&nbsp;</p>

                <!-- Start Breadcrumb -->
				<jsp:include page="/WEB-INF/jsp/admin/layout/breadcrumb.jsp">
					<jsp:param name="pageName" value="미디어 관리"/>
				</jsp:include>
				<!-- End Breadcrumb -->
                

				<%@ include file="include/view.jsp" %>

                <br />
            </div><!-- End Main Content -->