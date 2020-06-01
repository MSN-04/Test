<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ include file="/common/taglibs.jsp" %>

    		<header id="header" style="background-color:#ccc;" data-plugin-options='{"stickyEnabled": true, "stickyEnableOnBoxed": true, "stickyEnableOnMobile": true, "stickyStartAt": 57, "stickySetTop": "-57px"}'>
				<div class="header-body">
					<div class="header-container container">
						<div class="header-row">
							<div class="header-column">
								<div class="header-logo">
									<a href="${baseUri}/index">
										yooncoms R&D
									</a>
								</div>
							</div>
							<div class="header-column">
								<div class="header-row">
									<div class="header-search hidden-xs">
										<form id="searchForm" action="page-search-results.html" method="get">
											<!-- <div class="input-group">
												<input type="text" class="form-control" name="q" id="q" placeholder="Search..." required>
												<span class="input-group-btn">
													<button class="btn btn-default" type="submit"><i class="fa fa-search"></i></button>
												</span>
											</div> -->
										</form>
									</div>
									<nav class="header-nav-top">
										<ul class="nav nav-pills">
											<c:choose>
												<c:when test="${HUMAN_MEMBER ne null }">
													<li>
														<span class="ws-nowrap"><i class="fa fa-user"></i>${HUMAN_MEMBER.mberId}님 방갑습니다</span>
													</li>
													<li class="hidden-xs">
														<a href="/member/logout"><i class="fa fa-angle-right"></i> LOGOUT</a>
													</li>
													<li class="hidden-xs">
														<a href="/member/mberInfo"><i class="fa fa-angle-right"></i> 회원정보</a>
													</li>
												</c:when>
												<c:otherwise>
													<li class="hidden-xs">
														<a href="/member/login"><i class="fa fa-angle-right"></i> LOGIN</a>
													</li>
													<li class="hidden-xs">
														<a href="/member/register"><i class="fa fa-angle-right"></i> 회원가입</a>
													</li>
												</c:otherwise>
											</c:choose>
										</ul>
									</nav>
								</div>
								<div class="header-row">
									<div class="header-nav">
										<button class="btn header-btn-collapse-nav" data-toggle="collapse" data-target=".header-nav-main">
											<i class="fa fa-bars"></i>
										</button>
										<div class="header-nav-main header-nav-main-effect-1 header-nav-main-sub-effect-1 collapse">
											<nav>
												<ul class="nav nav-pills" id="mainNav">
													<c:forEach var="menuList" items="${curSiteMenuList}" varStatus="status" begin="1">
														<li class="
															<c:if test="${menuList.levelNo eq 2}">
																dropdown
																<c:if test="${curMenuVO.menuNo eq menuList.menuNo}">
																active
																</c:if>
															</c:if>
															<c:if test="${menuList.levelNo gt 2 and curSiteMenuList[status.index+1].levelNo gt menuList.levelNo}">
																dropdown-submenu
															</c:if>
														">
															<a	<c:if test="${menuList.levelNo eq 2 and curSiteMenuList[status.index+1].levelNo gt menuList.levelNo}">class="dropdown-toggle"</c:if>
																<c:choose>
																<c:when test="${menuList.menuTy eq 1 and menuList.subMainUseAt eq 'N'}">
																	href="<c:if test="${!fn:startsWith(menuList.linkUrl, 'http://') and !fn:startsWith(menuList.linkUrl, 'https://')}">${baseUri}/</c:if>${menuList.linkUrl}"
																	target="${menuList.linkTrgt}"
																	<c:if test="${menuList.linkTrgt eq '_blank'}">title="새창"</c:if>
																</c:when>
																<c:otherwise>
																	href="${baseUri}/${menuList.menuUri}"
																</c:otherwise>
																</c:choose>
																>
																${menuList.menuNm}
															</a>
														<c:choose>
														<c:when test="${curSiteMenuList[status.index+1].levelNo gt menuList.levelNo }"><!-- 다음 메뉴가 서브메뉴라면 UL그룹을 새로 생성 -->
															<ul class="dropdown-menu">
														</c:when>
														<c:when test="${curSiteMenuList[status.index+1].levelNo lt menuList.levelNo }"><!-- 다음 메뉴가 상위메뉴라면 메뉴 레벨을 비교하여 차이값만큼 Close -->
															<c:forEach begin="1" end="${menuList.levelNo - curSiteMenuList[status.index+1].levelNo}" step="1">
																</li></ul>
															</c:forEach>
															</li>
														</c:when>
														<c:when test="${not status.last}"><!-- 다음메뉴와 레벨이 동일하고 마지막 메뉴가 아니라면 li만 닫음 -->
															</li>
														</c:when>
														<c:otherwise><!-- 이번이 마지막 메뉴이면 기본메뉴레벨(2)까지 close -->
															<c:forEach begin="1" end="${menuList.levelNo - 2}" step="1">
																</li></ul>
															</c:forEach>
															</li>
														</c:otherwise>
														</c:choose>

													</c:forEach>
												</ul>
											</nav>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</header>