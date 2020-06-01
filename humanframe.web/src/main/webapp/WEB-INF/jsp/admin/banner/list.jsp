<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/taglibs.jsp" %>
<%@ page trimDirectiveWhitespaces="true" %>
<c:set var="changeOrdrMode" value="false"/>
<c:if test="${not empty param.siteNo and param.siteNo != 0 and not empty param.bannerCodeId and empty param.searchText and param.useAt ne 'N' and param.bannerCodeId ne 'EVENT'}">
	<c:set var="changeOrdrMode" value="true"/>
</c:if>
		<script>
		function f_searchUseAt(at){
			$("#useAt").val(at);
			$("#searchFrm").submit();
		}
		function f_useAtChg_atPost(at, sn){
			$.ajax({
				type : "post",
				url: './useAtChg',
				data: 'bannerNo='+sn+'&useAt='+at,
				dataType: 'text', //전송받을 데이터의 타입
				contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
				success: function(data) {
					if(data=="true"){
						alert("사용여부가 변경되었습니다.");
						location.reload();
					}else{
						alert("상태 변경에 실패하였습니다\n\n잠시후 다시 시도해 주시기 바랍니다.");
					}
				},
				error: function(data, status, err) {
					console.log('error forward : ' + data);
				}
			});
		}

		$(function(){
			<c:if test="${changeOrdrMode}">
			$(".changeOrdr").show();
			</c:if>
			$('#searchKey').on('change',function(){
				if($("#searchKey option:selected").val() == 'creatDt'){
					$('#searchText').datepicker({
						changeMonth: true
		                , changeYear: true
		                , dateFormat: 'yy-mm-dd'
		                , showButtonPanel: true
		                , showOn: "button"
		                , buttonImage: "${globalAdminAssets}/img/calendar.png"
		                , buttonImageOnly: true
					});
					<c:if test="${param.searchKey ne 'creatDt' or param.searchText eq ''}">
					$('#searchText').val($.datepicker.formatDate('yy-mm-dd', new Date()));
					</c:if>
					$('#searchText').attr("readonly","readonly");
				}else{
					$('#searchText').datepicker("destroy");
					$('#searchText').removeAttr("readonly");
				}
			});
			$('#searchKey').trigger('change');
		});

		var changeRow = function(bannerOrdr, upOrDown) {
	        params = {
	        		siteNo : "${param.siteNo}",
	        		bannerCodeId : "${param.bannerCodeId}",
	        		beforeOdr : bannerOrdr,
	                upOrDown : upOrDown
	        };
	        changeOrdr(params);
	    };

	    var changeOrdr = function(params) {
	        $.ajax({
	            url : '/admin/banner/changeBannerOrdr',
	            type : 'POST',
	            data : params,
	            cache : false,
	            success : function(data) {
	                window.location.href = '/admin/banner/list?siteNo=${param.siteNo}&bannerCodeId=${param.bannerCodeId}';
	            },
	            error : function(e) {
	                alert('순서 변경 중 오류 발생');
	            }
	        });
	    };

		</script>

			<!-- Start Breadcrumb -->
			<jsp:include page="/WEB-INF/jsp/admin/layout/breadcrumb.jsp">
				<jsp:param name="pageName" value="배너 관리"/>
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
						<h2 class="panel-title">배너 목록</h2>
						<p class="panel-subtitle">
							총 ${listVO.totalCount}건
						</p>
					</header>
					<div class="panel-body">

						<form id="searchFrm" name="searchFrm" class="mb-md" method="get" action="./list">
							<input type="hidden" id="useAt" name="useAt" value="${param.useAt}" />
							<div class="form-group form-inline">
								<select id="siteNo" name="siteNo" class="form-control">
									<option value="" <c:if test="${param.siteNo eq ''}">selected="selected"</c:if>>사이트 선택</option>
									<c:forEach items="${siteListAll}" var="siteListAll">
									<option value="${siteListAll.siteNo}" <c:if test="${param.siteNo eq siteListAll.siteNo}">selected="selected"</c:if>>${siteListAll.siteNm}</option>
									</c:forEach>
								</select>
								<select id="bannerCodeId" name="bannerCodeId" class="form-control">
									<option value="" <c:if test="${param.siteNo eq ''}">selected="selected"</c:if>>배너구분</option>
									<c:forEach items="${bannerTy}" var="banner">
									<option value="${banner.codeId}" <c:if test="${param.bannerCodeId eq banner.codeId}">selected="selected"</c:if>>${banner.codeNm}</option>
									</c:forEach>
								</select>
								<select id="searchKey" name="searchKey" class="form-control">
                               		<option value="sj" <c:if test="${param.searchKey eq 'sj' || param.searchKey eq ''}">selected="selected"</c:if>>제목</option>
                               		<option value="creatDt" <c:if test="${param.searchKey eq 'creatDt'}">selected="selected"</c:if>>등록일</option>
                               	</select>
                                   <input type="text" id="searchText" name="searchText" value="${param.searchText}" class="form-control">
                                   <button type="submit" class="btn btn-default" style="margin-left: 5px;"><i class="fa fa-search"></i> 검색</button>
							</div>
						</form>

						<!-- <div class="table-responsive"> -->
							<!-- Start Selectable Table Row -->
							<form id="listFrm" name="listFrm" method="post">
							<table class="table table-bordered table-hover mb-none">
								<colgroup>
									<col style="width:60px;" />
									<col style="width:200px;" />
									<col />
									<col style="width:80px;" />
									<col />
									<col style="width:170px;"/>
									<col style="width:80px;" class="changeOrdr" style="display:none;"/>
									<col style="width:60px;" />
								</colgroup>
								<thead>
									<tr>
										<th class="text-center">순번</th>
										<th class="text-center">이미지</th>
										<th class="text-center">사이트명</th>
										<th class="text-center">배너구분</th>
										<th class="text-center">제목</th>
										<th class="text-center">게시기간</th>
										<th class="text-center changeOrdr" style="display: none;">순서변경</th>
										<th class="text-center">관리</th>
									</tr>
								</thead>
								<tbody>
									<c:forEach items="${listVO.listObject}" var="resultList" varStatus="status">
									<c:set var="pageParam" value="bannerNo=${resultList.bannerNo}&amp;curPage=${listVO.curPage}${!empty(listVO.urlParam)? '&amp;' : ''}${listVO.urlParam}" />
									<tr>
										<td class="text-center">${listVO.startNo - status.index }</td>
										<td class="text-center">
											<c:forEach var="fileList" items="${resultList.pcFileList }" end="0">
											<img src="/comm/getImage?srvcId=${fileList.srvcId }&amp;upperNo=${fileList.upperNo }&amp;fileTy=${fileList.fileTy }&amp;fileNo=${fileList.fileNo }&amp;thumbTy=S" style="width:172px;">
											</c:forEach>
										</td>
										<c:set value="${fn:length(resultList.siteList)}" var="siteListCnt"/>
										<td>
											<c:if test="${siteListCnt >= 1}">${resultList.siteList[0].siteNm}
												<c:if test="${siteListCnt > 1}"> 외 ${siteListCnt - 1}개</c:if>
											</c:if>
										</td>
										<td class="text-center">${resultList.bannerCodeNm}</td>
										<td><a href="./view?${pageParam}">${resultList.sj }</a></td>
										<td class="text-center">
											<c:choose>
												<c:when test="${empty resultList.ntceBgnde and empty resultList.ntceEndde }">상시사용</c:when>
												<c:otherwise>
													<fmt:parseDate value="${resultList.ntceBgnde }" var="parsedNtceBgnde" pattern="yyyy-MM-dd" />
													<fmt:parseDate value="${resultList.ntceEndde }" var="parsedNtceEndde" pattern="yyyy-MM-dd" />
													<fmt:formatDate pattern="yyyy-MM-dd" value="${parsedNtceBgnde}" /> ~ <fmt:formatDate pattern="yyyy-MM-dd" value="${parsedNtceEndde}" />
												</c:otherwise>
											</c:choose>
										</td>
										<td class="text-center changeOrdr" style="display: none;">
											<div class="btn-group btn-group-vertical btn-group-sm">
											<c:if test="${!status.first}">
												<button class="btn" onclick="changeRow(${resultList.bannerOrdr}, 'up');return false;" title="순서 1단계 올리기"><i class="fa fa-arrow-up"></i></button>
											</c:if>
											<c:if test="${!status.last}">
												<button class="btn" onclick="changeRow(${resultList.bannerOrdr}, 'down');return false;" title="순서 1단계 내리기"><i class="fa fa-arrow-down"></i></button>
											</c:if>
											</div>
										</td>
										<td class="text-center">
											<div class="row">
											<div class="btn-group btn-group-sm">
												<a href="./form?bannerNo=${resultList.bannerNo}" class="btn btn-info" title="편집"><i class="fa fa-pencil"></i></a>
												<c:if test="${resultList.useAt eq 'Y'}">
												<a href="#remove" onclick="f_useAtChg_atPost('N', ${resultList.bannerNo})" class="btn btn-warning" title="사용안함"><i class="fa fa-eye-slash"></i></a>
												</c:if>
												<c:if test="${resultList.useAt eq 'N'}">
												<a href="#restore" onclick="f_useAtChg_atPost('Y', ${resultList.bannerNo})" class="btn btn-warning" title="사용중"><i class="fa fa-eye"></i></a>
												</c:if>
												<%-- <a href="#preview" onclick="f_preview_banner(${resultList.bannerNo})" class="btn btn-success" title="미리보기"><i class="icon icon-white icon-eye-open"></i></a> --%>
											</div>
											</div>
										</td>
									</tr>
									</c:forEach>
									<c:if test="${empty listVO.listObject}">
									<tr>
										<td colspan="${changeOrdrMode ? 8 : 7 }" style="height:50px; text-align:center; vertical-align:middle;">등록된 데이터가 없습니다.</td>
									</tr>
									</c:if>
								</tbody>
							</table>
							</form>
							<!-- End Selectable Table Row -->
						<!-- </div> -->


					</div>
					<footer class="panel-footer">
						<div class="row">
							<div class="col-sm-12 col-md-7">
								<cms:paging listVO="${listVO}" />
							</div>
							<div class="col-sm-12 col-md-5">
								<div class="btns">
	                                <!-- <a href="./form" class="btn btn-primary">사이트 등록</a> -->
	                                <cmsBtn2:btn btnTy="form" path="${curPath}" mngrSession="${mngrSession }" >배너 등록</cmsBtn2:btn>
                                </div>
							</div>
						</div>
					</footer>
				</section>
				</div>

			</div>