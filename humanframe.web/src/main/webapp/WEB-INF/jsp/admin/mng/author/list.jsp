<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/taglibs.jsp" %>
<%@ page trimDirectiveWhitespaces="true" %>
		<script>
		$(function() {

		});
		</script>

			<!-- Start Breadcrumb -->
			<jsp:include page="/WEB-INF/jsp/admin/layout/breadcrumb.jsp">
				<jsp:param name="pageName" value="권한그룹 관리"/>
			</jsp:include>
			<!-- End Breadcrumb -->

            <!-- start: page -->
			<div class="row">
				<div class="col-md-12">
				<section class="panel panel-featured panel-featured-primary">
					<header class="panel-heading">
						<h2 class="panel-title">권한그룹 목록</h2>
						<p class="panel-subtitle">
							총 ${listVO.totalCount}건
						</p>
					</header>
					<div class="panel-body">
						<form id="srchFrm" name="srchFrm" class="form-horizontal form-bordered mb-md" method="get" action="./list">
						<div class="form-group">
							<div class="form-inline ml-md">
								<select id="srchKey" name="srchKey" class="form-control">
                               		<option value="authorNm" <c:if test="${param.srchKey eq 'authorNm' || param.srchKey eq ''}">selected="selected"</c:if>>권한그룹명</option>
                               	</select>
                                <input type="text" id="srchText" name="srchText" value="${param.srchText}" class="form-control">
                                <button type="submit" class="btn btn-default"><i class="fa fa-search"></i> 검색</button>
                        	</div>
						</div>
                        </form>
						<div class="table-responsive">

							<!-- Start Selectable Table Row -->
							<form id="listFrm" name="listFrm" method="post">
							<table class="table table-bordered table-hover mb-none">
								<colgroup>
									<col style="width:60px;" />
									<col />
									<col style="width:150px;" />
								</colgroup>
								<thead>
									<tr>
										<th style="text-align: center;">순번</th>
										<th style="text-align: center;">권한그룹명</th>
										<th style="text-align: center;">등록일</th>
									</tr>
								</thead>
								<tbody>
									<c:forEach items="${listVO.listObject}" var="resultList" varStatus="status">
									<c:set var="pageParam" value="authorNo=${resultList.authorNo}&amp;curPage=${listVO.curPage}${!empty(listVO.urlParam)? '&amp;' : ''}${listVO.urlParam}" />
									<tr>
										<td style="text-align: center;">${listVO.startNo - status.index }</td>
										<td><a href="./view?${pageParam}">${resultList.authorNm }</a></td>
										<td style="text-align: center;"><fmt:formatDate pattern="yyyy-MM-dd" value="${resultList.creatDt }" /></td>
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


						</div>
					</div>
					<footer class="panel-footer">
						<div class="row">
							<div class="col-sm-7">
								<cms:paging listVO="${listVO}" />
							</div>
							<div class="col-sm-5">
								<div class="btns">
								<cmsBtn2:btn btnTy="form" path="${curPath}" mngrSession="${mngrSession }" >권한그룹 등록</cmsBtn2:btn>
								</div>
							</div>
						</div>
					</footer>
				</section>
				</div>

			</div>
