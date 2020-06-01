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
		 $('#srchStartDt, #srchEndDt').datepicker();
	});
	</script>


			<!-- Start Breadcrumb -->
			<jsp:include page="/WEB-INF/jsp/admin/layout/breadcrumb.jsp">
				<jsp:param name="pageName" value="CSR 게시판"/>
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
						<h2 class="panel-title">CSR 목록</h2>
						<p class="panel-subtitle">총 ${listVO.totalCount}건</p>
					</header>
					<div class="panel-body">
						<form id="searchFrm" name="searchFrm" class="form-horizontal form-bordered mb-md" method="get" action="./list">
						<input type="hidden" id="useAt" name="useAt" value="${param.useAt}" />
						<div class="form-group">
							<label class="col-md-2 control-label">작성일범위</label>
							<div class="col-md-6 form-inline">
								<input id="srchStartDt" name="srchStartDt" type="text" value="${param.srchStartDt}" size="10" class="form-control" readonly="readonly"> ~
								<input id="srchEndDt" name="srchEndDt" type="text" value="${param.srchEndDt}" size="10" class="form-control" readonly="readonly">
							</div>
						</div>
						<div class="form-group">
							<label class="col-md-2 control-label">분류</label>
							<div class="col-md-6 form-inline">
						    	<select id="srchStatus" name="srchStatus" class="form-control">
                             	 	<option value="">전체 진행상태</option>
                             	 	<c:forEach var="status" items="${crsStatusCode}">
									<option value="${status.key}" <c:if test="${status.key eq param.srchStatus}">selected="selected"</c:if>>${status.value}</option>
									</c:forEach>
								</select>
						    	<select id="srchPart" name="srchPart" class="form-control">
                              		<option value="">전체 파트</option>
                              	 	<c:forEach var="part" items="${crsPartCode}">
                                	<option value="${part.key}" <c:if test="${part.key eq param.srchPart}">selected="selected"</c:if>>${part.value}</option>
                               		</c:forEach>
								</select>
							</div>
						</div>
						<div class="form-group">
							<label class="col-md-2 control-label">키워드</label>
							<div class="col-md-6 form-inline">
								<select id="srchKey" name="srchKey" class="form-control">
                            		<option value="sj" <c:if test="${param.srchKey eq 'sj' || param.srchKey eq ''}">selected="selected"</c:if>>제목</option>
                            		<option value="cn" <c:if test="${param.srchKey eq 'cn'}">selected="selected"</c:if>>내용</option>
                            		<option value="ctrtNm" <c:if test="${param.srchKey eq 'ctrtNm'}">selected="selected"</c:if>>작성자</option>
                            	</select>
                                <input type="text" id="srchText" name="srchText" value="${param.srchText}" class="form-control" />
								<button type="submit" class="btn btn-default"><i class="fa fa-search"></i> 검색</button>
							</div>
						</div>

						</form>

						<div class="table-responsive">

						<form id="listFrm" name="listFrm" method="post">
						<table class="table table-bordered table-hover mb-none">
							<colgroup>
								<col style="width:80px;" />
								<col />
								<col style="width:150px;" />
								<col style="width:80px;" />
								<col style="width:130px;" />
								<col style="width:140px;" />
								<col style="width:130px;" />
							</colgroup>
							<thead>
								<tr>
									<th class="text-center">CSR번호</th>
									<th class="text-center">제목</th>
									<th class="text-center">파트</th>
									<th class="text-center">진행상황</th>
									<th class="text-center">작성자</th>
									<th class="text-center">작성일시</th>
									<th class="text-center">담당자</th>
								</tr>
							</thead>
							<tbody>
								<c:forEach items="${listVO.listObject}" var="resultList" varStatus="status">
								<c:set var="pageParam" value="crsNo=${resultList.crsNo}&amp;curPage=${listVO.curPage}${!empty(listVO.urlParam)? '&amp;' : ''}${listVO.urlParam}" />
								<tr>
									<td class="text-center">${resultList.crsNo}</td>
									<td><a href="./view?${pageParam}">${resultList.sj}</a></td>
									<td>${crsPartCode[resultList.part] }</td>
									<td>${crsStatusCode[resultList.progrsSttus]}</td>
									<td>${resultList.crtrNm}&nbsp;
										<button type="button" class="btn btn-primary btn-xs" data-toggle="popover" data-container="body" data-placement="right" data-content="${fn:replace(resultList.allDeptNm, ' ' , '>')} <c:if test="${ not empty resultList.telno}"> (${resultList.telno})</c:if>"><i class="fa fa-address-card-o"></i></button>
									</td>
									<td><fmt:formatDate pattern="yyyy-MM-dd hh:mm:ss" value="${resultList.creatDttm}" /></td>
									<td>
										<%-- ${resultList.chargerUniqueId} --%>
										<!-- 임시처리 -->
										<c:if test="${resultList.chargerUniqueId eq 'TMPINFO_000000000001' }">윤커뮤니케이션즈</c:if>
										<c:if test="${resultList.chargerUniqueId eq 'TMPINFO_000000000002' }">ETC</c:if>
										<c:if test="${resultList.aditChargerUniqueId eq 'TMPINFO_000000000001' }"><br />윤커뮤니케이션즈</c:if>
										<c:if test="${resultList.aditChargerUniqueId eq 'TMPINFO_000000000002' }"><br />ETC</c:if>
										<c:if test="${empty resultList.chargerUniqueId && empty resultList.aditChargerUniqueId}"><span>미정</span></c:if>
									</td>
								</tr>
								</c:forEach>
								<c:if test="${empty listVO.listObject}">
								<tr>
									<td colspan="7" style="height:50px; text-align:center; vertical-align:middle;">등록된 데이터가 없습니다.</td>
								</tr>
								</c:if>
							</tbody>
						</table>
						</form>

						</div>
					</div>
					<footer class="panel-footer">
						<div class="row">
							<div class="col-md-7">
								<cms:paging listVO="${listVO}" />
							</div>
							<div class="col-md-5">
								<div class="btns">
									<a href="./excelDownload?useAt=${param.useAt }&amp;srchText=${param.srchText}&amp;srchKey=${param.srchKey}&amp;srchPart=${param.srchPart}&amp;srchStatus=${param.srchStatus}&amp;srchStartDt=${param.srchStartDt}&amp;srchEndDt=${param.srchEndDt}" class="btn btn-success">Excel 다운로드</a>
				                    <a href="./form" class="btn btn-primary">등록</a>
			                    </div>
							</div>
						</div>
					</footer>
				</section>



			</div>
			<!-- end: page -->