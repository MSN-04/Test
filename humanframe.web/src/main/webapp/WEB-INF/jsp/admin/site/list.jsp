<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/taglibs.jsp" %>
<%@ page trimDirectiveWhitespaces="true" %>
		<script>
		function fnSearchUseAt(at){
			$("#useAt").val(at);
			$("#searchFrm").submit();
		}

		function f_siteBundleUpload(){
			window.open("./popup/siteUploadForm", "siteBundleUp", "width=380, height=375");
		}

		function f_menuBundleUpload(){
			window.open("./menu/popup/menuUploadForm", "menuBundleUp", "width=380, height=375");
		}
		$(function() {
			//화면처리 안해도 됩니다
			/* if($(window).width() < 500){
				$(".table th:nth-child(4), .table td:nth-child(4)").hide();
				$(".table th:nth-child(5), .table td:nth-child(5)").hide();
				$(".table td:nth-child(6) a").html("<i class=\"iconfa-sitemap\"></i>");
				($(".table td:nth-child(1)").html() != 1)? $(".table td").attr("colspan", 5):$(".table td").attr("colspan", 1);
			}else{
				$(".table th:nth-child(4), .table td:nth-child(4)").show();
				$(".table th:nth-child(5), .table td:nth-child(5)").show();
				$(".table td:nth-child(6) a").html("<i class=\"iconfa-sitemap\"></i> 메뉴설정");
				($(".table td:nth-child(1)").html() != 1)? $(".table td").attr("colspan", 7):$(".table td").attr("colspan", 1);
			} */

			/* $(window).resize(function() {
				if($(this).width() < 500){
					$(".table th:nth-child(4), .table td:nth-child(4)").hide();
					$(".table th:nth-child(5), .table td:nth-child(5)").hide();
					$(".table td:nth-child(6) a").html("<i class=\"iconfa-sitemap\"></i>");
					($(".table td:nth-child(1)").html() != 1)? $(".table td").attr("colspan", 5):$(".table td").attr("colspan", 1);
				}else{
					$(".table th:nth-child(4), .table td:nth-child(4)").show();
					$(".table th:nth-child(5), .table td:nth-child(5)").show();
					$(".table td:nth-child(6) a").html("<i class=\"iconfa-sitemap\"></i> 메뉴설정");
					($(".table td:nth-child(1)").html() != 1)? $(".table td").attr("colspan", 7):$(".table td").attr("colspan", 1);
				}
			}); */
		});
		</script>


			<!-- Start Breadcrumb -->
			<jsp:include page="/WEB-INF/jsp/admin/layout/breadcrumb.jsp">
				<jsp:param name="pageName" value="사이트 관리"/>
			</jsp:include>
			<!-- End Breadcrumb -->

            <!-- start: page -->
			<div class="row">
				<div class="col-md-12">
				<section class="panel panel-featured panel-featured-primary">
					<header class="panel-heading">
						<div class="panel-actions">
							<c:if test="${empty param.useAt || param.useAt eq 'Y' }">
							<button class="btn btn-default" title="사용 데이터" onclick="fnSearchUseAt('N'); return false;"><i class="fa fa-th-list"></i> 사용중</button>
							</c:if>
							<c:if test="${param.useAt eq 'N' }">
							<button class="btn btn-default" title="사용안함 데이터" onclick="fnSearchUseAt('Y'); return false;"><i class="fa fa-trash"></i> 사용안함</button>
							</c:if>
						</div>
						<h2 class="panel-title">사이트 목록/메뉴 관리</h2>
						<p class="panel-subtitle">
							총 ${listVO.totalCount}건
						</p>
					</header>
					<div class="panel-body">

						<div class="form-group">
							<form id="searchFrm" name="searchFrm" class="form-inline" method="get" action="./list">
								<input type="hidden" id="useAt" name="useAt" value="${param.useAt}" />
								<select id="srchClCodeId" name="srchClCodeId" class="form-control">
									<option value="" <c:if test="${param.srchClCodeId eq ''}">selected="selected"</c:if>>사이트 종류</option>
									<c:forEach items="${clCodeList}" var="clCodeList">
									<option value="${clCodeList.codeId}" <c:if test="${param.srchClCodeId eq clCodeList.codeId}">selected="selected"</c:if>>${clCodeList.codeNm}</option>
									</c:forEach>
								</select>
								<select id="srchKey" name="srchKey" class="form-control">
									<option value="siteNm" <c:if test="${param.srchKey eq 'siteNm' || param.srchKey eq ''}">selected="selected"</c:if>>사이트명</option>
								</select>
								<input type="text" id="srchText" name="srchText" value="${param.srchText}" class="form-control">
								<button type="submit" class="btn btn-default"><i class="fa fa-search"></i> 검색</button>
							</form>
						</div>

						<div class="table-responsive">

						<!-- Start Selectable Table Row -->
						<form id="listFrm" name="listFrm" method="post">
						<table class="table table-bordered table-hover mb-none">
							<colgroup>
								<col style="width:60px;" />
								<col style="width:80px;" />
								<col style="width:150px;" />
								<col style="width:120px;" />
								<col />
								<col style="width:100px;" />
								<col style="width:120px;" />
							</colgroup>
							<thead>
								<tr>
									<th class="text-center">순번</th>
									<th class="center">분류</th>
									<th class="center">사이트명</th>
									<th class="center">언어</th>
									<th class="center">URL</th>
									<th class="center">스킨</th>
									<th class="center">관리</th>
								</tr>
							</thead>
							<tbody>
								<c:forEach items="${listVO.listObject}" var="resultList" varStatus="status">
								<c:set var="pageParam" value="siteNo=${resultList.siteNo}&amp;curPage=${listVO.curPage}${!empty(listVO.urlParam)? '&amp;' : ''}${listVO.urlParam}" />
								<tr>
									<td class="center">${listVO.startNo - status.index }</td>
									<td class="center">${resultList.clCodeNm}</td>
									<td><a href="./view?${pageParam}">${resultList.siteNm }</a></td>
									<td class="center ">${resultList.langCodeNm }</td>
									<td>
										<a href="http://${resultList.siteUrl}<c:if test="${resultList.firstUriDivYn eq 'Y'}">/${resultList.firstUri }</c:if>" target="_blank"> <i class="icon-share"></i></a>&nbsp;
										${resultList.siteUrl } <c:if test="${resultList.firstUriDivYn eq 'Y'}">/${resultList.firstUri }</c:if>
									</td>
									<td>${resultList.siteSkn }</td>
									<td class="actions center">
										<a href="./menu/form?${pageParam}" class="btn btn-default btn-xs"><i class="fa fa-pencil"></i> 메뉴 설정</a>
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
						<!-- End Selectable Table Row -->

						</div>

					<!--테이블-->


					</div>
					<footer class="panel-footer">
						<div class="row">
							<div class="col-sm-12 col-md-7">
								<cms:paging listVO="${listVO}" />
							</div>
							<div class="col-sm-12 col-md-5">
								<div class="btns">
									<div class="btn-group dropup">
										<button type="button" class="mb-xs mt-xs mr-xs btn btn-default dropdown-toggle" data-toggle="dropdown"><i class="fa fa-magic"></i> 일괄등록 <span class="caret"></span></button>
										<ul class="dropdown-menu" role="menu">
											<li><a href="#" onclick="f_siteBundleUpload();return false;"><i class="fa fa-home"></i> 사이트 일괄 등록</a></li>
											<li><a href="#" onclick="f_menuBundleUpload();return false;"><i class="fa fa-align-left"></i> 메뉴 일괄 등록</a></li>
										</ul>
									</div>
									<cmsBtn2:btn btnTy="form" path="${curPath}" mngrSession="${mngrSession }" >사이트 등록</cmsBtn2:btn>
                                </div>
							</div>
						</div>
					</footer>
				</section>
				</div>

			</div>

