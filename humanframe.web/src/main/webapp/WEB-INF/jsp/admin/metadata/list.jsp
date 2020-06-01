<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ include file="/common/taglibs.jsp" %>
		<script>

		function f_openAPI(){
			window.open("/metadata/list", "_blank", "");
		}

		$(function() {

		});
		</script>

	<!-- Start Breadcrumb -->
			<jsp:include page="/WEB-INF/jsp/admin/layout/breadcrumb.jsp">
				<jsp:param name="pageName" value="메타데이터"/>
			</jsp:include>
			<!-- End Breadcrumb -->

            <!-- start: page -->
			<div class="row">
				<section class="panel panel-featured panel-featured-primary">
					<header class="panel-heading">
						<h2 class="panel-title">메타데이터 목록</h2>
						<p class="panel-subtitle">총 ${listVO.totalCount}건</p>
					</header>
					<div class="panel-body">
						<div class="table-responsive">
							<form id="listFrm" name="listFrm" method="post">
							<table class="table table-bordered table-hover mb-none">
								<colgroup>
									<col style="width:80px" />
									<col style="width:250px" />
									<col/>
									<col style="width:100px" />
									<col style="width:100px" />
								</colgroup>
								<thead>
								<tr>
									<th style="text-align: center;">번호</th>
									<th style="text-align: center;">구분</th>
									<th style="text-align: center;">제목</th>
									<th style="text-align: center;">생성일</th>
									<th style="text-align: center;">수정일</th>
								</tr>
								</thead>
								<tbody>
								<c:forEach items="${listVO.listObject}" var="resultList" varStatus="status">
								<c:set var="pageParam" value="metadataNo=${resultList.metadataNo}&amp;curPage=${listVO.curPage}${!empty(listVO.urlParam)? '&amp;' : ''}${listVO.urlParam}" />
								<tr>
									<td style="text-align: center;">${resultList.metadataNo}</td>
									<td style="text-align: center;">${metaTyCode[resultList.dcType]}</td>
									<td><a href="./view?${pageParam}">${resultList.dcTitle}</a></td>
									<td style="text-align: center;">${resultList.dcDateCreated}</td>
									<td style="text-align: center;">${resultList.dcDateModified}</td>
								</tr>
								</c:forEach>
								</tbody>
							</table>

							</form>
						</div>
					</div>
					<footer class="panel-footer">
						<div class="row">
							<div class="col-sm-12">
								<cms:paging listVO="${listVO}" />
							</div>
						</div>
					</footer>
				</section>
			</div>
