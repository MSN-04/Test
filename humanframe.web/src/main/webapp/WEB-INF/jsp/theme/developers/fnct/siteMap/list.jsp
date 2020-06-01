<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/taglibs.jsp" %>
<%@ page trimDirectiveWhitespaces="true" %>
	<!-- content -->
	<div class="row">
		<div class="col-md-12">
		
			<ul class="nav nav-list mb-xl">
			<c:forEach var="menu" items="${siteMapList}" varStatus="status">
				
				<li data-menu-no="${menu.menuNo}" data-level-no="${menu.levelNo}">
				
					<a	<c:choose>
						<c:when test="${menu.menuTy eq 1 and menu.subMainUseAt eq 'N'}">
							href="<c:if test="${!fn:startsWith(menu.linkUrl, 'http://') and !fn:startsWith(menu.linkUrl, 'https://')}">${baseUri}/</c:if>${menu.linkUrl}"
							target="${menu.linkTrgt}"
							<c:if test="${menu.linkTrgt eq '_blank'}">title="새창"</c:if>
						</c:when>
						<c:otherwise>
							href="${baseUri}/${menu.menuUri}"
						</c:otherwise>
						</c:choose>
						>
						${menu.menuNm}
					</a>
			
				<c:choose>
				<c:when test="${siteMapList[status.index+1].levelNo gt menu.levelNo }"><%-- 다음 메뉴가 서브메뉴라면 UL그룹을 새로 생성 --%>
					<ul>
				</c:when>
				<c:when test="${siteMapList[status.index+1].levelNo lt menu.levelNo }"><%-- 다음 메뉴가 상위메뉴라면 메뉴 레벨을 비교하여 차이값만큼 Close --%>
					<c:forEach begin="1" end="${menu.levelNo - siteMapList[status.index+1].levelNo}" step="1">
						</li></ul>
					</c:forEach>
					</li>
				</c:when>
				<c:when test="${not status.last}"><%-- 다음메뉴와 레벨이 동일하고 마지막 메뉴가 아니라면 li만 닫음 --%>
					</li>
				</c:when>
				<c:otherwise><%-- 이번이 마지막 메뉴이면 기본메뉴레벨(2)까지 close --%>
					<c:forEach begin="1" end="${menu.levelNo - 2}" step="1">
						</li></ul>
					</c:forEach>
					</li>
				</c:otherwise>
				</c:choose>

			</c:forEach>
			</ul>
			

		</div>

	</div>
