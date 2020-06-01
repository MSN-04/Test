<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ include file="/common/taglibs.jsp" %>

	<c:import url="/WEB-INF/jsp/admin/site/include/site_tab.jsp"/>
	<div class="col-md-6 padding-top-10">
		총 <strong>${listVO.totalCount}</strong>개
	</div>
	<div class="col-md-6 margin-bottom-10">
	<form name="frmListSearch" id="frmListSearch" method="get" action="popupList">
		<input type="hidden" name="siteNo" id="siteNo" value="${param.siteNo}" />
		<div class="float-right">
			<input type="text" name="srchWord" id="srchWord" value="${param.srchWord}" class="form-control placeholder-no-fix input-small input-inline"  placeholder="검색어" />
			<button type="submit" class="btn default">검색 <i class="fa fa-search"></i></button>
		</div>
	</form>
	</div>

	<table class="table table-striped table-hover table-bordered text-align-center">
		<colgroup>
			<col style="width:50" >
			<col />
			<col style="width:300" >
			<col style="width:80" >
		</colgroup>
		<thead>
		<tr>
			<th class="text-align-center">번호</th>
			<th class="text-align-center">제목</th>
			<th class="text-align-center">게시기간</th>
			<th class="text-align-center">사용여부</th>
		</tr>
		</thead>
		<tbody>

		<c:if test="${listVO.totalCount == 0 }">
		<tr>
			<td colspan="4">등록된 팝업이 없습니다.</td>
		</tr>
		</c:if>
		<c:forEach items="${listVO.listObject}" var="popup" varStatus="status">
		<c:set var="listNum" value="${listVO.totalCount - ((listVO.curPage - 1) * listVO.cntPerPage) - status.count + 1}"/>
		<tr>
			<td>${listVO.startNo - status.index }</td>
			<td class="text-align-left"><a href="./popupForm?siteNo=${param.siteNo}&amp;popupNo=${popup.popupNo}">${popup.popupSj}</a></td>
			<td>${ fn:substring(popup.bgnDttm, 0,16) } ~ ${ fn:substring(popup.endDttm, 0, 16)}</td>
			<td><c:choose>
					<c:when test="${popup.useAt eq 'Y'}">사용</c:when>
					<c:otherwise>미사용</c:otherwise>
					</c:choose>
			</td>
		</tr>
		</c:forEach>
		</tbody>
	</table>

	<!-- 페이징 영역 -->
	<div class="float-left">
		<cms:paging listVO="${listVO}" />
	</div>

	<!-- 버튼 영역 -->
	<div class="float-right">
		<c:if test="${HUMAN_ADMIN.authTy == 1 || HUMAN_ADMIN.authTy == 2 }">
		<a href="/admin/site/list?curPage=${param.pageNo}" class="btn default float-left">사이트 목록</a>&nbsp;
		</c:if>
		<a href="popupForm?siteNo=${param.siteNo}" class="btn blue">메인팝업 등록</a>
	</div>