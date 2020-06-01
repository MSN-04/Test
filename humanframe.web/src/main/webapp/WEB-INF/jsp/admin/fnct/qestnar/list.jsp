<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<%@ page trimDirectiveWhitespaces="true"%>

	<script type="text/javascript">
	function f_searchSrchSttus(sttus,useAt){
		$("#srchSttus").val(sttus);
		if(useAt != ''){
			$("#srchUseAt").val(useAt);
		}
		$("#searchFrm").submit();
	}
	</script>



		<!-- Start Breadcrumb -->
		<jsp:include page="/WEB-INF/jsp/admin/layout/breadcrumb.jsp">
			<jsp:param name="pageName" value="설문관리"/>
		</jsp:include>
		<!-- End Breadcrumb -->

           <!-- start: page -->
		<div class="row">
			<section class="panel panel-featured panel-featured-primary">
				<header class="panel-heading">
					<div class="panel-actions">
							<button class="btn btn-default dropdown-toggle" data-toggle="dropdown">
								<c:choose>
									<c:when test="${empty param.srchSttus}">전체 </c:when>
									<c:when test="${param.srchSttus eq 'YET' }">준비중 </c:when>
									<c:when test="${param.srchSttus eq 'ING' }">진행중 </c:when>
									<c:when test="${param.srchSttus eq 'END' }">마감 </c:when>
								</c:choose>
								<span class="caret"></span>
							</button>
							<ul class="dropdown-menu pull-right" role="menu" aria-labelledby="dLabel">
								<li><a tabindex="-1" href="#" onclick="f_searchSrchSttus('',''); return false;"><i class="fa fa-th-list"></i> 전체</a></li>
								<li><a tabindex="-1" href="#" onclick="f_searchSrchSttus('YET',''); return false;"><i class="fa fa-edit"></i> 준비중</a></li>
								<li><a tabindex="-1" href="#" onclick="f_searchSrchSttus('ING',''); return false;"><i class="fa fa-check-circle"></i> 진행중</a></li>
								<li><a tabindex="-1" href="#" onclick="f_searchSrchSttus('END',''); return false;"><i class="fa fa-ban"></i> 마감</a></li>
							</ul>

							<c:if test="${empty param.srchUseAt || param.srchUseAt eq 'Y' }">
								<button class="btn btn-default" title="사용 데이터" onclick="f_searchSrchSttus('','N'); return false;"><i class="fa fa-th-list"></i> 사용중</button>
							</c:if>
							<c:if test="${param.srchUseAt eq 'N' }">
								<button class="btn btn-default" title="사용안함" onclick="f_searchSrchSttus('','Y'); return false;"><i class="fa fa-trash"></i> 사용안함</button>
							</c:if>
					</div>

					<h2 class="panel-title">설문 목록</h2>
					<p class="panel-subtitle">총 ${listVO.totalCount}건</p>
				</header>
				<div class="panel-body">

                   <form id="searchFrm" name="searchFrm" class="form-horizontal form-bordered mb-md" method="get" action="./list" >
						<input type="hidden" id="srchSttus" name="srchSttus" value="${param.srchSttus}" />
						<input type="hidden" id="srchUseAt" name="srchUseAt" value="${param.srchUseAt}" />
						<div class="form-inline">
							<input type="text" id="srchWord" name="srchWord" value="${param.srchWord}" class="form-control" placeholder="설문명" title="설문명">
							<button type="submit" class="btn btn-default"><i class="fa fa-search"></i> 검색</button>
						</div>
					</form>

					<div class="table-responsive">
						<table class="table table-bordered table-hover mb-none">
							<colgroup>
								<col style="width: 50px;" />
								<col />
								<col style="width: 70px;" />
								<col style="width: 100px;" />
								<col style="width: 250px;" />
								<col style="width: 70px;" />
								<col style="width: 180px;" />
							</colgroup>
							<thead>
								<tr>
									<th class="text-center">번호</th>
									<th class="text-center">설문명</th>
									<th class="text-center">상태</th>
									<th class="text-center">작성자</th>
									<th class="text-center">설문기간</th>
									<th class="text-center"class="text-center">참여자수</th>
									<th class="text-center">관리</th>
								</tr>
							</thead>
							<tbody>
								<c:forEach items="${listVO.listObject}" var="resultList" varStatus="status">
								<c:set var="pageParam" value="qestnarNo=${resultList.qestnarNo}&amp;curPage=${listVO.curPage}${!empty(listVO.urlParam)? '&amp;' : ''}${listVO.urlParam}" />
								<tr>
									<td class="text-center">${listVO.startNo - status.index }</td>
									<td><a href="./form?${pageParam}">${resultList.sj}</a></td>
									<td class="text-center">
										<c:choose>
										<c:when test="${resultList.progrsSttus eq 'ING' }">진행중</c:when>
										<c:when test="${resultList.progrsSttus eq 'YET' }">준비중</c:when>
										<c:when test="${resultList.progrsSttus eq 'END' }">마감</c:when>
										</c:choose>
									</td>
									<td>${resultList.updusrNm}</td>
									<td class="text-center">${resultList.bgnDttm}~${resultList.endDttm}</td>
									<td class="text-center">${resultList.resultCnt}</td>
									<td class="text-center">
									<div class="btn-group-sm">
										<a href="./qestnList?qestnarNo=${resultList.qestnarNo}" class="btn btn-warning">질문관리</a>
										<a href="./result?qestnarNo=${resultList.qestnarNo}" class="btn btn-success">결과보기</a>
									</div>
									</td>
								</tr>
								</c:forEach>
								<c:if test="${empty listVO.listObject}">
								<tr>
									<td colspan="7" style="height: 50px; text-align: center; vertical-align: middle;"><spring:message code="data.value.noData"/></td>
								</tr>
								</c:if>
							</tbody>
						</table>
					</div>

				</div>
				<footer class="panel-footer">
					<div class="row">
						<div class="col-sm-7">
							<cms:paging listVO="${listVO}" />
						</div>
						<div class="col-sm-5">
							<div class="btns">
                               <cmsBtn2:btn btnTy="form" path="${curPath}" mngrSession="${mngrSession }" >등록</cmsBtn2:btn>
                               </div>
						</div>
					</div>
				</footer>
			</section>
		</div>
