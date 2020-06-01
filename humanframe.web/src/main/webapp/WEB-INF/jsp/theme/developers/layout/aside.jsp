<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ include file="/common/taglibs.jsp" %>

							<aside class="sidebar">
								<c:if test="${!empty asidePage }">
								<c:import url="../common/aside/${asidePage}.jsp"></c:import>
								</c:if>
								<c:if test="${empty asidePage }">
								<c:import url="../common/aside/aside.jsp"></c:import>
								</c:if>
							</aside>