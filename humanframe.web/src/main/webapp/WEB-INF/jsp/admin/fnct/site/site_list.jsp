<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/taglibs.jsp" %>
<%@ page trimDirectiveWhitespaces="true" %>
		<script>
		function fnSearchUseAt(at){
			$("#useAt").val(at);
			$("#searchFrm").submit();
		}

		$(function() {

		});
		</script>

			<!-- Start Breadcrumb -->
			<jsp:include page="/WEB-INF/jsp/admin/layout/breadcrumb.jsp">
				<jsp:param name="pageName" value="메인 관리"/>
			</jsp:include>
			<!-- End Breadcrumb -->

            <!-- start: page -->
			<div class="row">
				<div class="col-md-12">
				<section class="panel panel-featured panel-featured-primary">
					<header class="panel-heading">
						<div class="panel-actions">
							<c:if test="${empty param.useAt || param.useAt eq 'Y' }">
							<button class="btn btn-default" title="사용 데이터" onclick="fnSearchUseAt('N'); return false;"><i class="fa fa-th-list"></i> 사용중</button>
							</c:if>
							<c:if test="${param.useAt eq 'N' }">
							<button class="btn btn-default" title="사용안함 데이터" onclick="fnSearchUseAt('Y'); return false;"><i class="fa fa-trash"></i> 사용안함</button>
							</c:if>
						</div>
						<h2 class="panel-title">메인관리 목록</h2>
						<p class="panel-subtitle">총 ${listVO.totalCount}건</p>
					</header>
					<div class="panel-body">

						<form id="searchFrm" name="searchFrm" class="form-horizontal form-bordered mb-md" method="get" action="./siteList">
							<input type="hidden" id="useAt" name="useAt" value="${param.useAt}" />
							<div class="form-inline">
								<select id="srchKey" name="srchKey" class="form-control">
									<option value="siteNm" <c:if test="${param.srchKey eq 'siteNm' || param.srchKey eq ''}">selected="selected"</c:if>>사이트명</option>
									<option value="siteUrl" <c:if test="${param.srchKey eq 'siteUrl'}">selected="selected"</c:if>>URL</option>
								</select>
								<input type="text" id="srchText" name="srchText" value="${param.srchText}" class="form-control">
								<button type="submit" class="btn btn-default"><i class="fa fa-search"></i> 검색</button>
							</div>
						</form>


						<div class="table-responsive">

						<!-- Start Selectable Table Row -->
						<form id="listFrm" name="listFrm" method="post">
						<table class="table table-bordered table-hover mb-none">
							<colgroup>
								<col style="width:60px;" />
								<col />
								<col style="width:300px;" />
								<col style="width:150px;" />
							</colgroup>
							<thead>
								<tr>
									<th class="text-center">순번</th>
									<th class="text-center">사이트명</th>
									<th class="text-center">URL</th>
									<th class="text-center">관리</th>
								</tr>
							</thead>
							<tbody>
								<c:forEach items="${listVO.listObject}" var="resultList" varStatus="status">
								<c:set var="pageParam" value="siteNo=${resultList.siteNo}" />
								<tr>
									<td class="center">${listVO.startNo - status.index }</td>
									<td>${resultList.siteNm}</td>
									<td>${resultList.siteUrl } <c:if test="${resultList.firstUriDivYn eq 'Y'}">/${resultList.firstUri }</c:if></td>
									<td class="actions center">
										<a href="./list?${pageParam}" class="btn btn-default btn-xs"><i class="fa fa-pencil"></i> 메인관리</a>
										<!--
										<a href="./popupList?${pageParam}" class="btn btn-success"><i class="iconfa-volume-up"></i> 팝업관리</a>
										<a href="./bannerList?${pageParam}" class="btn btn-warning"><i class="iconfa-external-link"></i> 배너관리</a>
										-->
									</td>
								</tr>
								</c:forEach>
								<c:if test="${empty listVO.listObject}">
								<tr>
									<td colspan="4" style="height:50px; text-align:center; vertical-align:middle;">등록된 데이터가 없습니다.</td>
								</tr>
								</c:if>
							</tbody>
						</table>
						</form>
						<!-- End Selectable Table Row -->

						</div>

					</div><!-- //div.panel-body -->
					<footer class="panel-footer">
						<div class="row">
							<div class="col-md-12">
								<cms:paging listVO="${listVO}" />
							</div>
						</div>
					</footer>
				</section>
				</div>

			</div>
