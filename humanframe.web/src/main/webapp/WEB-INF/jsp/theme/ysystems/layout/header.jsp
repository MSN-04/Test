<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ include file="/common/taglibs.jsp" %>

	<script type="text/javascript">
	function f_goMenu(menu){

	}
	</script>

	<header>
		<div class="ci-ysystems"><a href="#">와이시스템즈</a></div>
		<nav>
			<ul>
				<li><a href="#home" >HOME</a></li>
				<li><a href="#services">SERVICES</a></li>
				<li><a href="#overview">OVERVIEW</a></li>
				<li><a href="#recruit">RECRUIT</a></li>
				<li><a href="#contact">CONTACT</a></li>

				<%-- <li ><a href="#home" id="menu-home">Home</a></li>
				<c:forEach var="menuList" items="${curSiteMenuList}" varStatus="status" begin="1">
					<li><a href="#${menuList.menuUri}" >${menuList.menuNm}</a></li>
				</c:forEach> --%>

			</ul>
			<a href="#" class="project-question"><i class="icon-mailto"></i>프로젝트 문의</a>
		</nav>
	</header>
