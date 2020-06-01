<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ include file="/common/taglibs.jsp" %>
	<script>
	function f_searchUseAt(at){
		$("#useAt").val(at);
		$("#searchFrm").submit();
	}
	$(function() {

	});
	</script>

			<!-- Start Breadcrumb -->
			<jsp:include page="/WEB-INF/jsp/admin/layout/breadcrumb.jsp">
				<jsp:param name="pageName" value="CMS관리자"/>
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
						<h2 class="panel-title">관리자 목록</h2>
						<p class="panel-subtitle">
							총 ${listVO.totalCount}건
						</p>
					</header>
					<div class="panel-body">

						<div class="form-group">
                    		<div class="form-inline">

		                        <form id="searchFrm" name="searchFrm" class="form-search" method="get" action="./list" class="form-horizontal form-bordered mb-md">
								<input type="hidden" id="useAt" name="useAt" value="${param.useAt}" />

								<select id="srchAuthTy" name="srchAuthTy" class="form-control">
                               		<c:set var="isSelected" value="${ (empty param.srchAuthTy  or param.srchAuthTy eq '') ? ' selected=\"selected\"' : '' }" />
									<option value=""${isSelected}>권한</option>
									<c:forEach var="item" items="${authorTyCode}">
									<c:set var="isSelected" value="${ (item.key eq param.srchAuthTy) ? ' selected=\"selected\"' : '' }" />
									<option value="${item.key}"${isSelected}>${item.value}</option>
									</c:forEach>
                               	</select>
                               	<select id="srchType" name="srchType" class="form-control">
									<option value="mngrNm"<c:out value="${ param.srchType eq 'mngrNm' ? ' selected=\"selected\"' : '' }" />>관리자명</option>
                               		<option value="deptNm"<c:out value="${ param.srchType eq 'depthNM' ? ' selected=\"selected\"' : '' }" />>부서명</option>
									<option value="mngrId"<c:out value="${ param.srchType eq 'mngrId' ? ' selected=\"selected\"' : '' }" />>아이디</option>
                               	</select>
                                   <input type="text" id="srchWord" name="srchWord" value="${param.srchWord}" class="form-control">
                                   <button type="submit" class="btn btn-default"><i class="fa fa-search"></i> 검색</button>
								</form>
                            </div>
						</div>



						<div class="table-responsive">
							<form id="listFrm" name="listFrm" method="post">
							<input type="hidden" id="listUseAt" name="listUseAt" value="" />
							<table class="table table-bordered table-hover mb-none">
								<colgroup>
									<col style="width:60px;" />
									<col style="width:180px;"/>
									<col />
									<col style="width:100px;"/>
									<col style="width:100px;"/>
									<col style="width:70px;" />
									<col style="width:120px;" />
									<col style="width:100px;" />
								</colgroup>
								<thead>
									<tr>
										<th style="text-align: center;">순번</th>
										<th style="text-align: center;">아이디</th>
										<th style="text-align: center;">부서명</th>
										<th style="text-align: center;">관리자명</th>
										<th style="text-align: center;">전화번호</th>
										<th style="text-align: center;">승인여부</th>
										<th style="text-align: center;">권한</th>
										<th style="text-align: center;">등록일</th>
									</tr>
								</thead>
								<tbody>
									<c:forEach items="${listVO.listObject}" var="resultList" varStatus="status">
									<c:set var="pageParam" value="mngrId=${resultList.mngrId}&amp;curPage=${listVO.curPage}${!empty(listVO.urlParam)? '&amp;' : ''}${listVO.urlParam}" />
									<tr>
										<td style="text-align: center;">${listVO.startNo - status.index }</td>
										<td><a href="form?${pageParam}">${resultList.mngrId}</a></td>
										<td>${resultList.deptNm}</td>
										<td>${resultList.mngrNm}</td>
										<td>${resultList.telno}</td>
										<td style="text-align: center;">${confmTyCode[resultList.confmTy]}</td>
										<td style="text-align: center;">${resultList.authorNm}</td>
										<td style="text-align: center;"><fmt:formatDate value="${resultList.creatDttm}" pattern="yyyy-MM-dd"/></td>
									</tr>
									</c:forEach>
									<c:if test="${empty listVO.listObject}">
									<tr>
										<td colspan="8" class="text-center pt-xlg pb-xlg">등록된 데이터가 없습니다.</td>
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
									<c:set var="pageParam" value="curPage=${listVO.curPage}${!empty(listVO.urlParam)? '&amp;' : ''}${listVO.urlParam}" />
	                                <cmsBtn2:btn btnTy="form" path="${curPath}" mngrSession="${mngrSession }" >관리자 등록</cmsBtn2:btn>
                                </div>
							</div>
						</div>
					</footer>
				</section>
				</div>

			</div>
