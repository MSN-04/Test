<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ include file="/common/taglibs.jsp" %>
	<script>
	function f_searchUseAt(at){
		$("#useAt").val(at);
		$("#searchFrm").submit();
	}
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
							<button class="btn btn-default" title="사용 데이터" onclick="f_searchUseAt('N'); return false;"><i class="fa fa-th-list"></i> 사용중</button>
							</c:if>
							<c:if test="${param.useAt eq 'N' }">
							<button class="btn btn-default" title="사용안함 데이터" onclick="f_searchUseAt('Y'); return false;"><i class="fa fa-trash"></i> 사용안함</button>
							</c:if>
						</div>
						<h2 class="panel-title">메인관리 상세목록</h2>
						<p class="panel-subtitle">총 ${listVO.totalCount}건</p>
					</header>
					<div class="panel-body">

						<form id="searchFrm" name="searchFrm" class="form-horizontal form-bordered mb-md" method="get" action="./list">
                      		<input type="hidden" name="siteNo" id="siteNo" value="${param.siteNo}"/>
                      		<input type="hidden" name="useAt" id="useAt" value="${param.useAt}"/>
							<div class="form-inline">
								<select id="srchMainTy" name="srchMainTy" class="form-control">
									<option value="">메인유형 선택</option>
                                   	<c:forEach items="${siteMainCodeTy}" var="sitemain">
									<option value="${sitemain.codeId}" <c:if test="${param.srchMainTy eq sitemain.codeId}">selected="selected"</c:if>>${sitemain.codeNm}</option>
                                   	</c:forEach>
								</select>
								<input type="text" id="srchWord" name="srchWord" value="${param.srchWord}" class="form-control search-query" placeholder="제목">
								<button type="submit" class="btn btn-default"><i class="fa fa-search"></i> 검색</button>
							</div>
						</form>

						<div class="table-responsive">

						<!-- Start Selectable Table Row -->
						<form id="listFrm" name="listFrm" method="post">
						<table class="table table-bordered table-hover mb-none">
							<colgroup>
								<col style="width:60px" />
								<col style="width:150px" />
								<col style="width:200px" />
								<col/>
								<col style="width:100px" />
								<col style="width:70px" />
							</colgroup>
							<thead>
								<tr>
									<th style="text-align: center;">번호</th>
									<th style="text-align: center;">메인유형</th>
									<th style="text-align: center;">이미지</th>
									<th style="text-align: center;">제목</th>
									<th style="text-align: center;">작성일</th>
									<th style="text-align: center;">게시순서</th>
								</tr>
							</thead>
							<tbody>
								<c:forEach items="${listVO.listObject}" var="resultList" varStatus="status">
								<c:set var="pageParam" value="${!empty(listVO.urlParam)? '&amp;' : ''}${listVO.urlParam}" />
								<tr>
									<td class="center">
										<c:set var="listNum" value="${listVO.totalCount - ((listVO.curPage - 1) * listVO.cntPerPage) - status.count + 1}"/>
										${listNum}
									</td>
									<td>${resultList.nttClNm}</td>
									<td>
										<c:forEach var="fileList" items="${resultList.fileList }" end="0">
										<img src="/comm/getImage?srvcId=${fileList.srvcId }&amp;upperNo=${fileList.upperNo }&amp;fileTy=${fileList.fileTy }&amp;fileNo=${fileList.fileNo }&amp;thumbTy=S">
										</c:forEach>
									</td>
									<td class="text-left"><a href="./view?siteNo=${resultList.siteNo}&siteMainNo=${resultList.siteMainNo}&useAt=${param.useAt}">${resultList.nttSj}</a></td>
									<td style="text-align: center;">${resultList.writngDe}</td>
									<td style="text-align: center;">${resultList.siteSeq}</td>
								</tr>
								</c:forEach>
								<c:if test="${empty listVO.listObject}">
								<tr>
									<td colspan="6" style="height:50px; text-align:center; vertical-align:middle;">등록된 데이터가 없습니다.</td>
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
							<div class="col-sm-12 col-md-5">
								<div class="btns">
	                                <!--<cmsBtn2:btn btnTy="form" path="${curPath}" mngrSession="${mngrSession }" >추가</cmsBtn2:btn>-->
						    		<a href="./form?siteNo=${param.siteNo}" class="btn btn-primary">추가</a>
                                </div>
							</div>
						</div>
					</footer>
				</section>
				</div>

			</div>
