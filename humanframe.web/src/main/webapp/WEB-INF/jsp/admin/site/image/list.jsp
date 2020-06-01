<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ include file="/common/taglibs.jsp" %>

	<script type="text/javascript">
	$(document).ready(function(){
		if('${param.imageTy}' != null && '${param.imageTy}' != ""){
			$("#imageTy").val('${param.imageTy}');
		}
	});
	
	</script>
	
	<c:import url="/WEB-INF/jsp/admin/site/include/site_tab.jsp"/>
	<div class="col-md-6 padding-top-10">
		총 <strong>${listVO.totalCount}</strong>개
	</div>
	<div class="col-md-6 margin-bottom-10">
	<form name="frmListSearch" id="frmListSearch" method="get" action="imageList">
		<input type="hidden" name="siteNo" id="siteNo" value="${param.siteNo}" />
		<div class="float-right">
			<select name="imageTy" id="imageTy" class="form-control input-small input-inline">
				<option value="" selected>구분</option>
				<option value="1">메인이미지</option>
				<option value="2">알림이미지</option>
				<option value="3">배너이미지</option>
				<option value="4">바로가기이미지</option>
			</select>
			<input type="text" name="srchWord" id="srchWord" value="${param.srchWord}" class="form-control placeholder-no-fix input-small input-inline"  placeholder="검색어" />
			<button type="submit" class="btn default">검색 <i class="fa fa-search"></i></button>
		</div>
	</form>
	</div>

	<table class="table table-striped table-hover table-bordered text-align-center">
		<colgroup>
			<col style="width:50" >
			<col style="width:150" >
			<col />
			<col style="width:200" >
			<col style="width:80" >
		</colgroup>
		<thead>
		<tr>
			<th class="text-align-center">번호</th>
			<th class="text-align-center">구분</th>
			<th class="text-align-center">제목</th>
			<th class="text-align-center">게시기간</th>
			<th class="text-align-center">사용여부</th>
		</tr>
		</thead>
		<tbody>

		<c:if test="${listVO.totalCount == 0 }">
		<tr>
			<td colspan="5">등록된 이미지가 없습니다.</td>
		</tr>
		</c:if>
		<c:forEach items="${listVO.listObject}" var="image" varStatus="status">
		<tr>
			<td>${listVO.startNo - status.index }</td>
			<td>
				<c:choose>
					<c:when test="${image.imageTy eq 1 }">메인이미지</c:when>
					<c:when test="${image.imageTy eq 2 }">알림이미지</c:when>
					<c:when test="${image.imageTy eq 3 }">배너이미지</c:when>
					<c:when test="${image.imageTy eq 4 }">바로가기이미지</c:when>
				</c:choose>
			</td>
			<td class="text-align-left"><a href="./imageForm?siteNo=${param.siteNo}&amp;imageNo=${image.imageNo}">${image.imageSj}</a></td>
			<td>${ cmsFn:convertDate(image.bgnDttm, 'yyyy.MM.dd')} ~ ${cmsFn:convertDate(image.endDttm, 'yyyy.MM.dd')}</td>
			<td>${image.useAt}</td>
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
		<a href="imageForm?siteNo=${param.siteNo}" class="btn blue">메인이미지 등록</a>
	</div>