<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp" %>
<%@ page trimDirectiveWhitespaces="true" %>

		<div class="clearfix post-block" id="mnuChargerContainer">
			<h3 class="heading-primary">
				<i class="fa fa-info-circle"></i>Menu Charger Informations
			</h3>
			<ul class="list list-icons list-icons-sm list-icons-style-2 list-inline ml-xlg">
				<c:choose>
				<c:when test="${not empty article.chargerNm }">
				<li class="mr-md"><i class="fa fa-user"></i> ${article.chargerNm }</li>
				<li class="mr-md"><i class="fa fa-sitemap"></i> ${article.chargerDeptNm }</li>
				<li class="mr-md"><i class="fa fa-phone-square"></i> ${article.chargerTelno }</li>
				<li class="mr-md"><i class="fa fa-envelope"></i> ${article.chargerEmail }</li>
				</c:when>
				<c:otherwise>
				<li class="mr-md"><i class="fa fa-user"></i> ${curMenuVO.mnuChargerNm }</li>
				<li class="mr-md"><i class="fa fa-sitemap"></i> ${curMenuVO.mnuChargerOrgnztNm }</li>
				<li class="mr-md"><i class="fa fa-phone-square"></i> ${curMenuVO.mnuChargerTelno }</li>
				<li class="mr-md"><i class="fa fa-calendar-check-o"></i> ${curMenuVO.mnuChargerUpdtDt }</li>
				</c:otherwise>
				</c:choose>
			</ul>
		</div>