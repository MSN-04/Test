<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ include file="/common/taglibs.jsp" %>

	<script>
	function f_searchUseAt(at){
		$("#useAt").val(at);
		$("#searchFrm").submit();
	}
	function f_searchPblicteSttusTy(at) {
		$("#srchPblcateSttus").val(at);
		$("#searchFrm").submit();
	}
	function f_useAtChg(at){
		$("#listUseAt").val(at);
		$("#listFrm").attr("action", "./listAction");
		$("#listFrm").submit();
	}
	function f_viewMenu(id, menu){
		$(".td_"+ id).css("display", "");
		$("#btn_"+ id).css("display", "none");
	}

	$(document).ready(function (){
		f_createMenuSelectbox("selectSiteMenu", "srchSiteMenu", "${param.srchSiteMenu}");
	});


	</script>

	<!-- Start Breadcrumb -->
	<jsp:include page="/WEB-INF/jsp/admin/layout/breadcrumb.jsp">
		<jsp:param name="pageName" value="콘텐츠관리"/>
	</jsp:include>
	<!-- End Breadcrumb -->

	<!-- start: page -->
	<div class="row">
		<section class="panel panel-featured panel-featured-primary">
			<header class="panel-heading">
				<div class="panel-actions">
						<div class="btn-group">
							<button class="btn btn-default dropdown-toggle" data-toggle="dropdown">
								<c:choose>
									<c:when test="${empty param.srchPblcateSttus}">전체 </c:when>
									<c:when test="${param.srchPblcateSttus eq 'P' }">발행 </c:when>
									<c:when test="${param.srchPblcateSttus eq 'T' }">작성중 </c:when>
								</c:choose>
								<span class="caret"></span>
							</button>
							<ul class="dropdown-menu" role="menu">
								<li><a href="#listUpdate" onclick="f_searchPblicteSttusTy(''); return false;"><i class="fa fa-list"></i> 전체</a></li>
								<li><a href="#listUpdate" onclick="f_searchPblicteSttusTy('P'); return false;"><i class="fa fa-check-circle"></i> 발행</a></li>
								<!-- <li><a href="#listUpdate" onclick="f_searchPblicteSttusTy('W'); return false;"><i class="fa fa-list"></i> 발행대기</a></li> -->
								<li><a href="#listUpdate" onclick="f_searchPblicteSttusTy('T'); return false;"><i class="fa fa-edit"></i> 작성중</a></li>
							</ul>
						</div>

						<c:if test="${empty param.useAt || param.useAt eq 'Y' }">
							<button class="btn btn-default" title="사용 데이터" onclick="f_searchUseAt('N'); return false;"><i class="fa fa-th-list"></i> 사용중</button>
						</c:if>
						<c:if test="${param.useAt eq 'N' }">
							<button class="btn btn-default" title="삭제" onclick="f_searchUseAt('Y'); return false;"><i class="fa fa-trash"></i> 사용안함</button>
						</c:if>
				</div>
				<h2 class="panel-title">콘텐츠관리 목록</h2>
				<p class="panel-subtitle">총 ${listVO.totalCount}건</p>
			</header>
			<div class="panel-body">
				<form id="searchFrm" name="searchFrm" class="form-horizontal form-bordered mb-md" method="get" action="./list">
					<input type="hidden" id="useAt" name="useAt" value="${param.useAt}" />
					<input type="hidden" id="srchPblcateSttus" name="srchPblcateSttus" value="${param.srchPblcateSttus}" />
					<div class="form-group">
						<div class="form-inline ml-md">
						<select id="selectSiteMenu" name="selectSiteMenu" class="form-control">
							<option value="">전체(사용중인메뉴)</option>
						</select>
						</div>
					</div>
					<div class="form-group">
						<div class="form-inline ml-md">
							<select id="srchKey" name="srchKey" class="form-control">
		               			<option value="srchCntntsSj"  <c:if test="${param.srchKey eq 'srchCrtrNm' || param.searchKey eq ''}">selected="selected"</c:if>>콘텐츠명</option>
		               			<option value="srchCrtrNm"    <c:if test="${param.srchKey eq 'srchCrtrNm'}">selected="selected"</c:if>>생성자</option>
		               			<option value="srchChargerNm" <c:if test="${param.srchKey eq 'srchChargerNm'}">selected="selected"</c:if>>담당자</option>
	                       	</select>
	                       	<input type="text" id="srchWord" name="srchWord" value="${param.srchWord}" class="form-control" placeholder="검색어">
	                        <button type="submit" class="btn btn-default"><i class="fa fa-search"></i> 검색</button>
						</div>
					</div>
				</form>

				<div class="table-responsive">

				<form id="listFrm" name="listFrm" method="post">
					<input type="hidden" name="srchSiteMenu" value="${param.srchSiteMenu}" />
					<table class="table table-bordered table-hover mb-none">
						<colgroup>
							<col style="width:50px" />
							<col style="width:80px" />
							<col/>
							<col/>
							<col style="width:100px" />
							<col style="width:120px" />
							<col style="width:100px" />
							<col style="width:100px" />
						</colgroup>
						<thead>
						<tr>
							<th style="text-align: center;">번호</th>
							<th style="text-align: center;">발행상태</th>
							<th style="text-align: center;">콘텐츠명</th>
							<th style="text-align: center;">사용중인메뉴</th>
							<th style="text-align: center;">발행일</th>
							<th style="text-align: center;">담당자</th>
							<th style="text-align: center;">생성자</th>
							<th style="text-align: center;">생성일</th>
						</tr>
						</thead>
						<tbody>
							<c:forEach items="${listVO.listObject}" var="resultList" varStatus="status">
							<c:set var="pageParam" value="cntntsNo=${resultList.cntntsNo}&amp;curPage=${listVO.curPage}${!empty(listVO.urlParam)? '&amp;' : ''}${listVO.urlParam}" />
							<tr>
								<td style="text-align: center;">${listVO.startNo - status.index }</td>
								<td style="text-align: center;">${pblcateSttusTyCode[resultList.pblcateSttusTy]}</td>
								<td class="text-align-left"><a href="./view?${pageParam}">${resultList.cntntsSj}</a></td>
								<td >
									<c:forEach items="${resultList.useMenuList }" var="menuList" varStatus="status">
										<c:if test="${status.index == 0}">
											<small><i class="fa fa-home"></i> ${menuList.menuNm}</small>
										</c:if>
										<c:if test="${status.index != 0}">
											<small class="td_${resultList.cntntsNo}" style="display: none;"><br><i class="fa fa-home"></i> ${menuList.menuNm}</small>
										</c:if>
									</c:forEach>
									<c:if test="${fn:length(resultList.useMenuList) > 1}">
										&nbsp;<button id="btn_${resultList.cntntsNo}" class="btn btn-info btn-xs" onclick="f_viewMenu('${resultList.cntntsNo}'); return false;">+</button>
									</c:if>
								</td>
								<td style="text-align: center;">${resultList.pblcateDe}</td>
								<td>
									<c:if test="${!empty resultList.chargerNm }">
									 ${resultList.chargerNm}&nbsp;
									 <button type="button" class="btn btn-primary btn-xs" data-toggle="popover" data-container="body" data-placement="right" data-content="${fn:replace(resultList.chargerDeptNm, ' ' , '>')} <c:if test="${ not empty resultList.chargerTelno}"> (${resultList.chargerTelno})</c:if>"><i class="fa fa-address-card-o"></i></button>
									</c:if>
								<td style="text-align: center;">${resultList.crtrNm}</td>
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
					<div class="col-md-5">
						<div class="btns">
							<c:set var="pageParam2" value="curPage=${listVO.curPage}${!empty(listVO.urlParam)? '&amp;' : ''}${listVO.urlParam}" />
				    		<cmsBtn2:btn btnTy="form" path="${curPath}" mngrSession="${mngrSession }"  modifyParam="?${pageParam2}">콘텐츠등록</cmsBtn2:btn>
						</div>
					</div>
				</div>
			</footer>
		</section>
		</div>
	<!-- end: page -->
