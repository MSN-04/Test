<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/taglibs.jsp" %>
<%@ page trimDirectiveWhitespaces="true" %>
		<script>
		function f_searchUseAt(at){
			$("#useAt").val(at);
			$("#searchFrm").submit();
		}
		function f_useAtChg(at){
			$("#listUseAt").val(at);
			$("#listFrm").attr("action", "./action");
			$("#listFrm").submit();
		}

		$(function() {

		});
		</script>


			<!-- Start Breadcrumb -->
			<jsp:include page="/WEB-INF/jsp/admin/layout/breadcrumb.jsp">
				<jsp:param name="pageName" value="프로젝트문의"/>
			</jsp:include>
			<!-- End Breadcrumb -->

            <!-- start: page -->
			<div class="row">
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

						<h2 class="panel-title">프로젝트문의 목록</h2>
						<p class="panel-subtitle">총 ${listVO.totalCount}건</p>
					</header>
					<div class="panel-body">

	                    <form id="searchFrm" name="searchFrm" class="form-horizontal form-bordered mb-md" method="get" action="./list">
	                    	<input type="hidden" id="useAt" name="useAt" value="${param.useAt}" />
	                    	<div class="form-group">
	                    		<div class="form-inline ml-md">
						    	<select id="srchStatus" name="srchStatus" class="form-control">
                             	 	<option value="">전체 진행상태</option>
                             	 	<c:forEach var="status" items="${statusCode}">
									<option value="${status.key}" <c:if test="${status.key eq param.srchStatus}">selected="selected"</c:if>>${status.value}</option>
									</c:forEach>
								</select>
								<select id="searchKey" name="searchKey" class="form-control">
                            		<option value="sj" <c:if test="${param.searchKey eq 'sj' || param.srchKey eq ''}">selected="selected"</c:if>>제목</option>
                            		<option value="cn" <c:if test="${param.searchKey eq 'cn'}">selected="selected"</c:if>>내용</option>
                            	</select>
		                        <input type="text" id="searchText" name="searchText" value="${param.searchText}" class="form-control" placeholder="검색어">
		                        <button type="submit" class="btn btn-default"><i class="fa fa-search"></i> 검색</button>
							</div>
							</div>
	                    </form>

						<div class="table-responsive">

							<form id="listFrm" name="listFrm" method="post">
							<table class="table table-bordered table-hover mb-none">
								<colgroup>
									<col style="width:60px;" />
									<col style="width:100px;" />
									<col style="width:100px;" />
									<col />
									<col style="width:100px;" />
									<col style="width:150px;" />
									<col style="width:100px;" />
									<col style="width:100px;" />
								</colgroup>
								<thead>
									<tr>
										<th style="text-align: center;">순번</th>
										<th style="text-align: center;">진행상태</th>
										<th style="text-align: center;">사이트</th>
										<th style="text-align: center;">제목</th>
										<th style="text-align: center;">회사명</th>
										<th style="text-align: center;">e-mail</th>
										<th style="text-align: center;">예산</th>
										<th style="text-align: center;">등록일</th>
									</tr>
								</thead>
								<tbody>
									<c:forEach items="${listVO.listObject}" var="resultList" varStatus="status">
									<c:set var="pageParam" value="inqryNo=${resultList.inqryNo}&amp;curPage=${listVO.curPage}${!empty(listVO.urlParam)? '&amp;' : ''}${listVO.urlParam}" />
									<tr>
										<td style="text-align: center;">${listVO.startNo - status.index }</td>
										<td style="text-align: center;">${statusCode[resultList.processSttus]}</td>
										<td style="text-align: center;">${resultList.siteNm }</td>
										<td><a href="./view?${pageParam}">${resultList.sj }</a></td>
										<td>${resultList.cmpnyNm}</td>
										<td>${resultList.email}</td>
										<td>${bugetTy[resultList.budget]}</td>
										<td style="text-align: center;">${resultList.creatDttm}</td>
									</tr>
									</c:forEach>
									<c:if test="${empty listVO.listObject}">
									<tr>
										<td colspan="8" style="height:50px; text-align:center; vertical-align:middle;">등록된 데이터가 없습니다.</td>
									</tr>
									</c:if>
								</tbody>
							</table>
							</form>

						</div>

					</div>
					<footer class="panel-footer">
						<div class="row">
							<div class="col-sm-7">
								<cms:paging listVO="${listVO}" />
							</div>
							<div class="col-sm-5">
								<div class="btns">
                                <%-- <cmsBtn2:btn btnTy="form" path="${curPath}" mngrSession="${mngrSession }" >문의 추가</cmsBtn2:btn> --%>
                                </div>
							</div>
						</div>
					</footer>
				</section>
			</div>