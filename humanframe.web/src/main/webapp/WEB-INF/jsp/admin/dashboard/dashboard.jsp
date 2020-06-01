<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ include file="/common/taglibs.jsp" %>

<script src="${globalAdminAssets}/vendor/flot/jquery.flot.js"></script>
<script src="${globalAdminAssets}/vendor/snap.svg/snap.svg.js"></script>
<script src="${globalAdminAssets}/vendor/liquid-meter/liquid.meter.js"></script>
<script>
$(document).ready(function(){

});
</script>

<!-- Start Breadcrumb -->
<jsp:include page="/WEB-INF/jsp/admin/layout/breadcrumb.jsp">
	<jsp:param name="pageName" value="Dashboard"/>
</jsp:include>
<!-- End Breadcrumb -->

<!-- start: page -->
<div class="row">
	<div class="col-md-12">
	<section class="panel panel-featured panel-featured-primary">
		<header class="panel-heading">
			<div class="panel-actions">
			</div>
			<h2 class="panel-title">게시판 & 콘텐츠 등록 현황</h2>
		</header>
		<div class="panel-body">
			<div class="table-responsive">
				<div class=" col-md-6 fl">
					<h3>- 게시판별 등록글</h3>
					<table class="table table-bordered table-hover mb-none" id="">
						<colgroup>
							<col style="width:20%;">
							<col style="width:10%;">
							<col style="width:10%;">
							<col style="width:10%;">
							<col style="width:10%;">
							<col style="width:10%;">
							<col style="width:10%;">
							<col style="width:10%;">
							<col style="width:10%;">
						</colgroup>
						<thead>
							<tr>								
								<th style="text-align: center;" colspan="9">구분</th>
							</tr>
							<tr>
								<td style="text-align: center;">합</td>
								<td style="text-align: center;">일반형</td>
								<td style="text-align: center;">답글형</td>
								<td style="text-align: center;">이미지</td>
								<td style="text-align: center;">동영상</td>
								<td style="text-align: center;">Q&A</td>
								<td style="text-align: center;">FAQ</td>
								<td style="text-align: center;">일정형</td>
								<td style="text-align: center;">링크형</td>
							</tr>
						</thead>
						<tbody>
							<c:forEach items="${bbsList}" var="bbsList" varStatus="index">
								<tr>									
									<td style="text-align: center;">${bbsList.ty1+bbsList.ty2+bbsList.ty3+bbsList.ty4+bbsList.ty5+bbsList.ty6+bbsList.ty7+bbsList.ty8}</td>
									<td style="text-align: center;">${bbsList.ty1}</td>
									<td style="text-align: center;">${bbsList.ty2}</td>
									<td style="text-align: center;">${bbsList.ty3}</td>
									<td style="text-align: center;">${bbsList.ty4}</td>
									<td style="text-align: center;">${bbsList.ty5}</td>
									<td style="text-align: center;">${bbsList.ty6}</td>
									<td style="text-align: center;">${bbsList.ty7}</td>
									<td style="text-align: center;">${bbsList.ty8}</td>
								</tr>
							</c:forEach>							
						</tbody>
					</table>
				</div>

				<div class=" col-md-6 fr">
					<h3>- 콘텐츠</h3>
					<table class="table table-bordered table-hover mb-none" id="">
						<colgroup>							
							<col style="width:40%;">
							<col style="width:30%;">
							<col style="width:30%;">
						</colgroup>
						<thead>							
							<tr>								
								<th style="text-align: center;">합</th>
								<th style="text-align: center;">발행</th>
								<th style="text-align: center;">작성중</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach items="${conList}" var="conList" varStatus="index">
								<tr>								
									<td style="text-align: center;">${conList.pblcateSttusTyT+conList.pblcateSttusTyP}</td>
									<td style="text-align: center;">${conList.pblcateSttusTyT}</td>
									<td style="text-align: center;">${conList.pblcateSttusTyP}</td>
								</tr>
							</c:forEach>				
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</section>
	</div>

</div>



