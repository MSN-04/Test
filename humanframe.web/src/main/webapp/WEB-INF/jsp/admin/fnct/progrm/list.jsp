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
			$("#listFrm").attr("action", "./listAction");
			$("#listFrm").submit();
		}

		$(function() {

		});
		</script>


			<!-- Start Breadcrumb -->
			<jsp:include page="/WEB-INF/jsp/admin/layout/breadcrumb.jsp">
				<jsp:param name="pageName" value="프로그램 관리"/>
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

						<h2 class="panel-title">프로그램 목록</h2>
						<p class="panel-subtitle">총 ${listVO.totalCount}건</p>
					</header>
					<div class="panel-body">

	                    <form id="searchFrm" name="searchFrm" class="form-horizontal form-bordered mb-md" method="get" action="./list">
	                    	<input type="hidden" id="useAt" name="useAt" value="${param.useAt}" />
	                    	<div class="form-group">
	                    		<div class="form-inline ml-md">
			                        <input type="text" id="srchText" name="srchText" value="${param.srchText}" class="form-control" placeholder="프로그램명">
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
									<col />
									<col style="width:200px;" />
									<col style="width:180px;" />
								</colgroup>
								<thead>
									<tr>
										<th style="text-align: center;">순번</th>
										<th style="text-align: center;">사용</th>
										<th style="text-align: center;">프로그램명</th>
										<th style="text-align: center;">서비스URL</th>
										<th style="text-align: center;">등록일</th>
									</tr>
								</thead>
								<tbody>
									<c:forEach items="${listVO.listObject}" var="resultList" varStatus="status">
									<c:set var="pageParam" value="fnctNo=${resultList.fnctNo}&amp;curPage=${listVO.curPage}${!empty(listVO.urlParam)? '&amp;' : ''}${listVO.urlParam}" />
									<tr>
										<td style="text-align: center;">${listVO.startNo - status.index }</td>
										<td style="text-align: center;">${useAtCode[resultList.useAt] }</td>
										<td><a href="./view?${pageParam}">${resultList.fnctNm }</a></td>
										<td>${resultList.svcUrl}</td>
										<td>
											<fmt:formatDate pattern="yyyy-MM-dd" value="${resultList.creatDttm}" />
										</td>
									</tr>
									</c:forEach>
									<c:if test="${empty listVO.listObject}">
									<tr>
										<td colspan="5" style="height:50px; text-align:center; vertical-align:middle;">등록된 데이터가 없습니다.</td>
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
                                <cmsBtn2:btn btnTy="form" path="${curPath}" mngrSession="${mngrSession }" >프로그램 추가</cmsBtn2:btn>
                                </div>
							</div>
						</div>
					</footer>
				</section>
			</div>