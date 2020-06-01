<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/taglibs.jsp" %>
<%@ page trimDirectiveWhitespaces="true" %>
		<%-- <link rel="stylesheet" type="text/css" href="${globalAdminAssets}/stylesheets/plugins/jquery.snippet.css">
		<script src="${globalAdminAssets}/javascripts/plugins/jquery.snippet.min.js"></script> --%>
		<script>
		function f_searchUseAt(at){
			$("#useAt").val(at);
			$("#searchFrm").submit();
		}

		function f_useAtChg(at){

			if($("input:checkbox[name=arrMediaNo]:checked").length == 0){
				alert("선택한 미디어가 없습니다.");
				return;
			}

			$("#listUseAt").val(at);
			$("#listFrm").attr("action", "./listAction");
			$("#listFrm").submit();
		}
		/* $(function() {
			$("#table-check1").selectRow({
				classname : 'grey'
			});

	        $("pre.styles").snippet("html",{
	            style:"typical",
	            menu:false
	        });
		}); */
		</script>

		<!-- Start Breadcrumb -->
		<jsp:include page="/WEB-INF/jsp/admin/layout/breadcrumb.jsp">
			<jsp:param name="pageName" value="미디어 관리"/>
		</jsp:include>
		<!-- End Breadcrumb -->


		<div class="row">
			<div class="col-md-12">
				<section class="panel panel-featured panel-featured-primary">
					<header class="panel-heading">
						<div class="panel-actions">
							<div class="btn-group">
								<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">With Selected <span class="caret"></span></button>
								<ul class="dropdown-menu" role="menu">
								<c:if test="${empty param.useAt || param.useAt eq 'Y' }">
									<li><a tabindex="-1" href="#listUpdate" onclick="f_useAtChg('N'); return false;"><i class="fa fa-trash"></i> 선택 삭제</a></li>
								</c:if>
								<c:if test="${param.useAt eq 'N' }">
									<li><a tabindex="-1" href="#listUpdate" onclick="f_useAtChg('Y'); return false;"><i class="fa fa-repeat"></i> 선택 복구</a></li>
								</c:if>
								</ul>
							</div>
							<c:if test="${empty param.useAt || param.useAt eq 'Y' }">
							<button class="btn btn-default" title="사용 데이터" onclick="f_searchUseAt('N'); return false;"><i class="fa fa-th-list"></i> 사용중</button>
							</c:if>
							<c:if test="${param.useAt eq 'N' }">
							<button class="btn btn-default" title="사용안함 데이터" onclick="f_searchUseAt('Y'); return false;"><i class="fa fa-trash"></i> 사용안함</button>
							</c:if>
						</div>
						<h2 class="panel-title">미디어관리 목록</h2>
						<p class="panel-subtitle">총 ${listVO.totalCount}건</p>
					</header>
					<div class="panel-body">
						<ul class="nav nav-tabs">
								<li <c:if test="${empty param.srchMediaCodeId}">class="active"</c:if>>
									<a href="./list" class="text-center">전체</a>
								</li>
							<c:if test="${!empty mediaCodeList }">
								<c:forEach items="${mediaCodeList}" var="mediaCodeList">
								<li <c:if test="${param.srchMediaCodeId eq mediaCodeList.codeId}">class="active"</c:if>>
									<a class="text-center" href="./list?srchMediaCodeId=${mediaCodeList.codeId}">${mediaCodeList.codeNm }</a>
								</li>
								</c:forEach>
							</c:if>
						</ul>

						<div class="tab-content">
								<form id="searchFrm" name="searchFrm" class="form-horizontal form-bordered mb-md" method="get" action="./list">
	                              	<input type="hidden" id="srchMediaCodeId" name="srchMediaCodeId" value="${param.srchMediaCodeId}" />
	                              	<input type="hidden" id="useAt" name="useAt" value="${param.useAt}" />
									<div class="form-group">
										<div class="form-inline ml-md">
											<select id="searchKey" name="searchKey" class="form-control">
			                              		<option value="mediaNm" <c:if test="${param.searchKey eq 'mediaNm' || param.searchKey eq ''}">selected="selected"</c:if>>미디어명</option>
			                              		<option value="sumry" <c:if test="${param.searchKey eq 'sumry'}">selected="selected"</c:if>>요약</option>
			                              		<option value="mediaNo" <c:if test="${param.searchKey eq 'mediaNo'}">selected="selected"</c:if>>미디어번호</option>
			                              	</select>
			                                <input type="text" id="searchText" name="searchText" value="${param.searchText}" class="form-control">
			                                <button type="submit" class="btn btn-default"><i class="fa fa-search"></i>검색</button>
		                                </div>
	                                </div>
	                             </form>

		                        <div class="table-responsive">

								<!-- Start Selectable Table Row -->
								<form id="listFrm" name="listFrm" method="post">
									<input type="hidden" id="listUseAt" name="listUseAt" value="" />
									<table class="table table-bordered table-hover mb-none" id="table-check1">
										<colgroup>
											<col style="width:50px;" />
											<col style="width:60px;" />
											<col style="width:180px;" />
											<col style="width:85px;" />
											<col />
											<col style="width:100px;" />
											<col style="width:100px;" />
										</colgroup>
										<thead>
											<tr>
												<th style="text-align: center;"><div class="control-group"><span class="checkbox-custom checkbox-text-primary">
												<input type="checkbox"  name="checkall" id="humanCheckall"/><label></label></span></div></th>
												<th style="text-align: center;">순번</th>
												<th style="text-align: center;">이미지(썸네일)</th>
												<th style="text-align: center;">분류</th>
												<th style="text-align: center;">미디어명</th>
												<th style="text-align: center;">등록일</th>
												<th style="text-align: center;">등록자</th>
											</tr>
										</thead>
										<tbody>
											<c:forEach items="${listVO.listObject}" var="resultList" varStatus="status">
											<c:set var="pageParam" value="mediaNo=${resultList.mediaNo}&amp;curPage=${listVO.curPage}${!empty(listVO.urlParam)? '&amp;' : ''}${listVO.urlParam}" />
											<tr>
												<td style="text-align: center;"><div class="control-group"><span class="checkbox-custom checkbox-text-primary">
												<input type="checkbox" data-style="checkbox" id="arrMediaNo${resultList.mediaNo }" name="arrMediaNo" value="${resultList.mediaNo }" />
												<label></label>
												</span></div></td>
												<td style="text-align: center;">${listVO.startNo - status.index }</td>
												<td style="text-align: center;">
														<a href="./view?${pageParam}">
														<c:if test="${fn:length(resultList.thumbFileList) > 0 }">
														<img src="/comm/getImage?srvcId=${resultList.thumbFileList[0].srvcId }&amp;upperNo=${resultList.thumbFileList[0].upperNo }&amp;fileTy=${resultList.thumbFileList[0].fileTy }&amp;fileNo=${resultList.thumbFileList[0].fileNo }"  alt="${resultList.mediaNm }" style="width:150px; height: 100px"/>
														</c:if>
														<c:if test="${fn:length(resultList.thumbFileList) == 0 && resultList.mediaCodeId eq 'IMAGE' }">
														<c:if test="${fn:length(resultList.mediaFileList) > 0 }">
				                                                 <img src="/comm/getImage?srvcId=${resultList.mediaFileList[0].srvcId }&amp;upperNo=${resultList.mediaFileList[0].upperNo }&amp;fileTy=${resultList.mediaFileList[0].fileTy }&amp;fileNo=${resultList.mediaFileList[0].fileNo }&amp;thumbTy=S" style="width:150px; height: 100px" />
				                                                 </c:if>
				                                                 <c:if test="${fn:length(resultList.mediaFileList) == 0 }">
				                                                 <img src="${globalAdminAssets}/images/no_image.jpeg" alt="no_thumb_image" style="width:150px; height: 100px" />
				                                                 </c:if>
														</c:if>
														<c:if test="${fn:length(resultList.thumbFileList) == 0 && resultList.mediaCodeId ne 'IMAGE' }">
														<img src="${globalAdminAssets}/images/no_image.jpeg" alt="no_thumb_image" style="width:150px; height: 100px" />
															<%-- <pre class="styles" style="padding:3px; max-height:140px; overflow:hidden; border-bottom:1px solid #ccc;  border-radius:4px;">
																	<c:out value="${resultList.mediaHtml }" escapeXml="true" />
															</pre> --%>
														</c:if>
														</a>
												</td>
												<td>${resultList.mediaCodeNm }<br />(${resultList.streMthTy})</td>
												<td><a href="./view?${pageParam}">${resultList.mediaNm }</a></td>
												<td>${fn:substring(resultList.creatDttm,0,10)}</td>
												<td>${resultList.crtrNm }</td>
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
								<!-- End Selectable Table Row -->
								</div>

							</div>


					</div>
					<!--탭내용-->
					<footer class="panel-footer">
						<div class="row">
							<div class="col-sm-7">
								<cms:paging listVO="${listVO}" />
							</div>
							<div class="col-md-5">
								<div class="btns">
									<c:set var="pageParam2" value="curPage=${listVO.curPage}${!empty(listVO.urlParam)? '&amp;' : ''}${listVO.urlParam}" />
						    		<cmsBtn2:btn btnTy="form" path="${curPath}" mngrSession="${mngrSession }"  modifyParam="?${pageParam2}">미디어등록</cmsBtn2:btn>
								</div>
							</div>
						</div>
					</footer>
				</section>
			</div>
		</div>
