<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/taglibs.jsp" %>
<%@ page trimDirectiveWhitespaces="true" %>
<c:set var="changeOrdrMode" value="false"/>
<c:if test="${not empty param.siteNo and param.siteNo != 0 and not empty param.bannerCodeId and empty param.searchText and param.useAt ne 'N' and param.bannerCodeId ne 'EVENT'}">
	<c:set var="changeOrdrMode" value="true"/>
</c:if>
<script>
function f_searchUseAt(at){
	$("#useAt").val(at);
	$("#searchFrm").submit();
}
</script>

<!-- Start Breadcrumb -->
<jsp:include page="/WEB-INF/jsp/admin/layout/breadcrumb.jsp">
	<jsp:param name="pageName" value="로그관리"/>
</jsp:include>
<!-- End Breadcrumb -->

<!-- start: page -->
<div class="row">
	<div class="col-md-12">
	<section class="panel panel-featured panel-featured-primary">
		<header class="panel-heading">
			<h2 class="panel-title">로그관리 목록</h2>
			<p class="panel-subtitle">
				총 ${listVO.totalCount}건
			</p>
		</header>
		<div class="panel-body">

			<form id="searchFrm" name="searchFrm" class="mb-md" method="get" action="./list">
				<div class="form-group form-inline">
					<select id="searchKey" name="searchKey" class="form-control">
                		<option value="menuNm" <c:if test="${param.searchKey eq 'menuNm' || param.searchKey eq ''}">selected="selected"</c:if>>메뉴명</option>
                		<option value="crtrId" <c:if test="${param.searchKey eq 'crtrId'}">selected="selected"</c:if>>관리자ID</option>
                		<option value="crtrNm" <c:if test="${param.searchKey eq 'crtrNm'}">selected="selected"</c:if>>관리자명</option>
                	</select>
                    <input type="text" id="searchText" name="searchText" value="${param.searchText}" class="form-control">
                    <button type="submit" class="btn btn-default"><i class="fa fa-search"></i>검색</button>
				</div>
			</form>

			<div class="table-responsive">
				<!-- Start Selectable Table Row -->
				<form id="listFrm" name="listFrm" method="post">
				<table class="table table-bordered table-hover mb-none">
					<colgroup>
						<col style="width:100px;" />
						<col style="width:150px;" />
						<col />
						<col style="width:150px;" />
						<col style="width:150px;" />
						<col style="width:150px;" />
					</colgroup>
					<thead>
						<tr>
							<th style="text-align: center;">순번</th>
							<th style="text-align: center;">메뉴명</th>
							<th style="text-align: center;">로그타입</th>
							<th style="text-align: center;">관리자ID</th>
							<th style="text-align: center;">관리자명</th>
							<th style="text-align: center;">등록일</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach items="${listVO.listObject}" var="resultList" varStatus="status">
							<c:set var="pageParam" value="logNo=${resultList.logNo}&amp;curPage=${listVO.curPage}${!empty(listVO.urlParam)? '&amp;' : ''}${listVO.urlParam}" />
							<tr>
								<td style="text-align: center;">${listVO.startNo - status.index }</td>
								<td style="text-align: center;">${resultList.menuNm}</td>
								<td><a href="./view?${pageParam}">${mngLogTy[resultList.logTy]}</a></td>
								<td style="text-align: center;">${resultList.crtrId}</td>
								<td style="text-align: center;">${resultList.crtrNm}</td>
								<td style="text-align: center;">${fn:substring(resultList.creatDttm, 0, 10)}</td>
							</tr>
							</c:forEach>
						<c:if test="${empty listVO.listObject}">
						<tr>
							<td colspan="6" style="height:50px; text-align:center; vertical-align:middle;">조회된 데이터가 없습니다.</td>
						</tr>
						</c:if>
					</tbody>
				</table>
				</form>
				<!-- End Selectable Table Row -->
			</div>

		</div>
		<footer class="panel-footer">
			<div class="row">
				<div class="col-sm-12 col-md-7">
					<cms:paging listVO="${listVO}" />
				</div>
			</div>
		</footer>
	</section>
	</div>

</div>