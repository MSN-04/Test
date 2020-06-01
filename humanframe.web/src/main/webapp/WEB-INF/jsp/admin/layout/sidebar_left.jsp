<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp" %>
<%@ page trimDirectiveWhitespaces="true" %>
			<!-- start: sidebar -->
				<aside id="sidebar-left" class="sidebar-left">

				    <div class="sidebar-header">
				        <div class="sidebar-title">
				            Navigation
				        </div>
				        <div class="sidebar-toggle hidden-xs" data-toggle-class="sidebar-left-collapsed" data-target="html" data-fire-event="sidebar-left-toggle">
				            <i class="fa fa-bars" aria-label="Toggle sidebar"></i>
				        </div>
				    </div>

				    <div class="nano">
				        <div class="nano-content">
				            <nav id="menu" class="nav-main" role="navigation">

				                <ul class="nav nav-main">
				                	<c:forEach var="_menuList" items="${_mngMenuList}" varStatus="status" begin="1">
				                	
									<%-- <c:if test="${_menuList.levelNo == 2 }">
										<c:set var="menuGroup" value="${_menuList.menuNo}" />
										<li class="nav-parent">
										<c:choose>
											<c:when test='${fn:startsWith(_menuList.menuUrl, "http")}'>
											<a href="${_menuList.menuUrl}" target="_blank"><i class="fa ${_menuList.icon}"></i> <span>${_menuList.menuNm}</span></a>
											</c:when>
											<c:otherwise>
											<a href="${_menuList.menuUrl}"><i class="fa ${_menuList.icon}"></i> <span>${_menuList.menuNm}</span></a>
											</c:otherwise>
										</c:choose>
										<c:if test="${_mngMenuList[status.index+1].levelNo == 2 || empty _mngMenuList[status.index+1].levelNo}"></li></c:if>
										<c:if test="${_mngMenuList[status.index+1].levelNo == 3}"><ul class="nav nav-children" id="menu_${menuGroup}"></c:if>
									</c:if>

									<c:if test="${_menuList.levelNo == 3 }">
										<c:if test="${_mngMenuList[status.index+1].levelNo <= 3 }"><li></c:if>
										<c:if test="${_mngMenuList[status.index+1].levelNo == 4 }"><li class="nav-parent"></c:if>
										<c:choose>
											<c:when test='${fn:startsWith(_menuList.menuUrl, "http")}'>
											<a href="${_menuList.menuUrl}" target="_blank"><i class="fa ${_menuList.icon}"></i> <span>${_menuList.menuNm}</span></a>
											</c:when>
											<c:otherwise>
											<a href="${_menuList.menuUrl}"><i class="fa ${_menuList.icon}"></i> <span>${_menuList.menuNm}</span></a>
											</c:otherwise>
										</c:choose>
										<c:if test="${_mngMenuList[status.index+1].levelNo == 2 || empty _mngMenuList[status.index+1].levelNo}"></li></ul></li></c:if>
	                    				<c:if test="${_mngMenuList[status.index+1].levelNo == 3 }"></li><li></c:if>
	                    				<c:if test="${_mngMenuList[status.index+1].levelNo == 4 }"><ul class="nav nav-children" id="item_${_menuList.menuNo}"><li></c:if>
									</c:if> --%>
									
									<c:if test="${_menuList.levelNo ge 2 }">
					                	<c:if test="${_menuList.levelNo == 2 }"><c:set var="menuGroup" value="${_menuList.menuNo}" /></c:if>
										<li <c:if test="${_menuList.levelNo ge 2 and _mngMenuList[status.index+1].levelNo gt _menuList.levelNo}">class="nav-parent"</c:if>>
										
					                	<c:choose>
											<c:when test='${fn:startsWith(_menuList.menuUrl, "http")}'>
											<a href="${_menuList.menuUrl}" target="_blank"><i class="fa ${_menuList.icon}"></i> <span>${_menuList.menuNm}</span></a>
											</c:when>
											<c:otherwise>
											<a href="${_menuList.menuUrl}"><i class="fa ${_menuList.icon}"></i> <span>${_menuList.menuNm}</span></a>
											</c:otherwise>
										</c:choose>
					                	
					                	<c:choose>
					                		<c:when test="${_mngMenuList[status.index+1].levelNo gt _menuList.levelNo }"><!-- 다음이 서브 메뉴일 경우 : UL생성 -->
												<ul class="nav nav-children" id="menu_${menuGroup}">
											</c:when>
											<c:when test="${_mngMenuList[status.index+1].levelNo lt _menuList.levelNo }"><!-- 다음이 상위 메뉴일 경우 : 닫기 -->
												<c:forEach begin="1" end="${_menuList.levelNo - _mngMenuList[status.index+1].levelNo}" step="1">
													</li></ul>
												</c:forEach>
												</li>
											</c:when>
											<c:when test="${not status.last}"><!-- 마지막메뉴가 아닐경우(동일 레벨) : 닫기 -->
												</li>
											</c:when>
											<c:otherwise><!-- 마지막 메뉴일 경우 : 닫기(~2레벨) -->
												<c:forEach begin="1" end="${_menuList.levelNo - 2}" step="1">
													</li></ul>
												</c:forEach>
												</li>
											</c:otherwise>
										</c:choose>
				                	</c:if>
				                	
									</c:forEach>

				                </ul>
				            </nav>

						</div>

				        <script>
				            // Maintain Scroll Position
				            if (typeof localStorage !== 'undefined') {
				                if (localStorage.getItem('sidebar-left-position') !== null) {
				                    var initialPosition = localStorage.getItem('sidebar-left-position'),
				                        sidebarLeft = document.querySelector('#sidebar-left .nano-content');

				                    sidebarLeft.scrollTop = initialPosition;
				                }
				            }

				            // 메뉴 하이라이팅
				            $(document).ready(function(){
				            	var navTarget = $("#menu.nav-main a[href*='"+$(location).attr("pathname").replace(/(form|view|list)$/gi, "") +"']");
				            	if(navTarget.length == 1) {
				            		navTarget.parents("li").addClass("nav-active");
				            		navTarget.closest("li").parents("li").addClass("nav-expanded");
				            	} else {
				            		// 예외 처리 구간...
				            		navTarget = $("#menu.nav-main a[href*='"+$(location).attr("pathname").replace(/menu\/form$/gi,"")+"']");
				            		if(navTarget.length == 1) {
					            		navTarget.parents("li").addClass("nav-active");
					            		navTarget.closest("li").parents("li").addClass("nav-expanded");
				            		}
				            	}
				            });
				        </script>


				    </div>

				</aside>
				<!-- end: sidebar -->