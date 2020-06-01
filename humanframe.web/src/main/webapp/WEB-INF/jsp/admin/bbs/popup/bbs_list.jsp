<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ include file="/common/taglibs.jsp" %>
	<script type="text/javascript">
	$(document).ready(function(){
		$("#table-check1").selectRow({
			classname : 'grey'
		});

		$("#groupBbsNo option", opener.document).each(function(){
			$('<input>').attr('type', 'hidden').attr('name', 'excludeSiteNo').attr('value', $(this).val()).appendTo($("#searchFrm"));
		 });
	});

	function fn_selectBbs(){
		if($("input[name=arrUniqueId]:checked").length == 0){
			alert("선택된 건이 없습니다.");
		}
		else{
			$("input[name=arrUniqueId]:checked").each(function() {
				var $bbsSj = $(this).closest('tr').find('td:eq(4)').text();
				var $siteNtceNo = $(this).closest('tr').find('td:eq(5)').find("#siteNtceNo option:selected");
				var $ctgryNo = $(this).closest('tr').find('td:eq(6)').find("#ctgryNo option:selected");
				var bbsNo = $(this).val();
				var siteNtceNo = ($siteNtceNo.val() == undefined ? "" : $siteNtceNo.val());
				var ctgryNo = ($ctgryNo.val() == undefined ? "" : $ctgryNo.val());
				params = {
						bbsNo : bbsNo
					  , bbsSj : $(this).closest('tr').find('td:eq(4)').text()
					  , siteNtceNo : siteNtceNo
					  , siteNtceNm : $siteNtceNo.text()
					  , ctgryNo : ($ctgryNo.val() == undefined ? "" : $ctgryNo.val())
					  , ctgryNm : $ctgryNo.text()
					  , uniqueId : "arrUniqueId" + bbsNo + "_" + siteNtceNo + "_" + ctgryNo
		        };
				opener.fn_addBbs(params);
			});
			window.close();
		}
	}
	</script>

	<!-- Start Main Content -->
	<div style="padding:0 10px;">
                <!-- Start Main Content -->
                <div class="row-fluid">
                    <div class="span12">
						<div class="widget dark">
							<div class="widget-head">
								<span class="title">게시판 리스트</span>
							</div>
							<div class="widget-content no-padding">
								<div class="widget-content-inner">
									<div class="span12" style="padding:10px;">
		                                <form id="searchFrm" name="searchFrm" class="form-search" method="post" action="./bbsList">
		                                	<input type="hidden" name="bbsTy" id="bbsTy" value="${param.bbsTy}" />
		                                	<select id="srchSiteNo" name="srchSiteNo" class="input-medium">
												<option value="">전체(사용중 사이트)</option>
		                                    	<c:forEach items="${siteList}" var="siteList">
												<option value="${siteList.siteNo}" <c:if test="${param.srchSiteNo eq siteList.siteNo}">selected="selected"</c:if>>${siteList.siteNm}</option>
		                                    	</c:forEach>
		                                	</select>
		                                	<select id="srchKey" name="srchKey" class="input-small">
		                                		<option value="siteNm">게시판명</option>
		                                	</select>
		                                    <input type="text" id="srchText" name="srchText" value="${param.srchText}" class="input-medium search-query">
		                                    <button type="submit" class="btn">Search</button>
		                                </form>
		                            </div>

									<!-- Start Selectable Table Row -->
									<form id="listFrm" name="listFrm" method="post">
									<input type="hidden" id="listUseAt" name="listUseAt" value="" />
									<table class="table table-hover" id="table-check1">
										<colgroup>
											<col style="width:50px;" />
											<col style="width:70px;" />
											<col style="width:80px;" />
											<col style="width:250px;"/>
											<col />
											<col style="width:180px;"/>
											<col style="width:180px;"/>
										</colgroup>
										<thead>
											<tr>
												<th><input type="checkbox" data-style="checkbox" /></th>
												<th>순번</th>
												<th>분류</th>
												<th>사용메뉴</th>
												<th>게시판명</th>
												<th>사이트구분</th>
												<th>게시글 카테고리</th>
											</tr>
										</thead>
										<tbody>
											<c:forEach items="${listVO.listObject}" var="resultList" varStatus="status">
											<c:set var="pageParam" value="siteNo=${resultList.siteNo}&amp;curPage=${listVO.curPage}${!empty(listVO.urlParam)? '&amp;' : ''}${listVO.urlParam}" />
											<tr>
												<td><input type="checkbox" data-style="checkbox" id="arrUniqueId" name="arrUniqueId" value="${resultList.bbsNo}" /></td>
												<td>${listVO.startNo - status.index}</td>
												<td>${bbsTyCode[resultList.bbsTy]}</td>
												<td>
													<c:forEach items="${resultList.useMenuList }" var="menuList" varStatus="status">
														${menuList.menuNm}<c:if test="${!status.last}"><br/></c:if>
													</c:forEach>
												</td>
												<td>${resultList.bbsSj}</td>
												<td>
													<c:if test="${resultList.unityBbsUseAt eq 'Y'}">
														<select id="siteNtceNo">
															<option value="">전체</option>
															<c:forEach items="${resultList.unityBbsSiteList}" var="siteList">
															<option value="${siteList.siteNo}">${siteList.siteNm}</option>
															</c:forEach>
														</select>
													</c:if>
												</td>
												<td>
													<c:if test="${resultList.ctgryUseAt eq 'Y'}">
														<select id="ctgryNo">
															<option value="">전체</option>
															<c:forEach items="${resultList.ctgryList}" var="ctgryList">
															<option value="${ctgryList.ctgryNo}">${ctgryList.ctgryNm}</option>
															</c:forEach>
														</select>
													</c:if>
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
									<!-- End Selectable Table Row -->

									<div class="form-actions">

										<div class="pagination">
										<c:if test="${not empty listVO}"><cms:paging listVO="${listVO}"  /></c:if>
										</div>

										<div class="btns">
			                                <button onclick="fn_selectBbs()" class="btn btn-primary">선택</button>
		                                </div>
	                                </div>
	                            </div>
							</div>
						</div>
                    </div>
                </div><!-- End -->
                <br />
            </div><!-- End Main Content -->