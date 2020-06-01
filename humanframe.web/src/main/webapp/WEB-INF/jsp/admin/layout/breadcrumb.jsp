<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp" %>
<%@ page trimDirectiveWhitespaces="true" %>

				<header class="page-header">
					<h2>${param.pageName}</h2>

					<div class="right-wrapper pull-right">
<!-- 						<ol class="breadcrumbs">
							<li>
								<a href="/admin/">
									<i class="fa fa-home"></i>
								</a>
							</li>
							<li><span>Layouts</span></li>
							<li><span>Light Sidebar</span></li>
						</ol>
 -->
 						<!--왼쪽슬라이드 오픈시 스케쥴 리스트호출 : sidebar_right.jsp -->
						<a class="sidebar-right-toggle" data-open="sidebar-right" onclick="f_callSchdulList(); return false;">
							<i class="fa fa-chevron-left" ></i>
						</a>
					</div>
				</header>