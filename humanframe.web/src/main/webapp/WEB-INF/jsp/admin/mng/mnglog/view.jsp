<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/taglibs.jsp" %>
<%@ page trimDirectiveWhitespaces="true" %>

<script>

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
			<div class="panel-actions">

			</div>
			<h2 class="panel-title">로그상세조회</h2>
		</header>
		<div class="panel-body">

			<div class="table-responsive">

				<table class="table">
					<colgroup>
						<col style="width:200px"/>
						<col />
						<col style="width:200px"/>
						<col />
					<col />
				</colgroup>
				<tbody>
					<tr>
						<th>메뉴번호</th>
						<td>${mngLogVO.menuNo }</td>
						<th>메뉴명 </th>
						<td>${mngLogVO.menuNm }</td>
					</tr>
					<tr>
						<th>관리자ID</th>
						<td>${mngLogVO.crtrId }</td>
						<th>관리자명</th>
						<td>${mngLogVO.crtrNm }</td>
					</tr>
					<tr>
						<th>접근URL</th>
						<td>${mngLogVO.url }</td>
						<th>생성일시</th>
						<td>${fn:substring(mngLogVO.creatDttm, 0, 16)}</td>
					</tr>
					<tr>
						<th>로그타입</th>
						<td colspan="3">${mngLogTy[mngLogVO.logTy]}</td>
					</tr>
					<tr>
						<th>로그내용</th>
						<td colspan="3">${mngLogVO.logTxt}</td>
					</tr>
				</tbody>
			</table>

		</div>
	</div>
	<footer class="panel-footer">
		<div class="row">
			<div class="col-md-6">
				<c:set var="pageParam" value="curPage=${param.curPage }&amp;searchKey=${param.searchKey}&amp;searchText=${param.searchText}" />
				<a href="./list?${pageParam}" class="btn btn-default">목록</a>
			</div>
			<%-- <div class="col-md-6 text-right">
                <cmsBtn2:btn btnTy="modify" path="${curPath}" mngrSession="${mngrSession }" modifyParam="?logNo=${mberVO.logNo}&amp;${pageParam}">수정</cmsBtn2:btn>
				</div>--%>
			</div>
		</footer>
	</section>
	</div>

</div>

