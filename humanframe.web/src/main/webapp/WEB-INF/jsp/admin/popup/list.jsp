<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/taglibs.jsp" %>
<%@ page trimDirectiveWhitespaces="true" %>
		<script>
		function f_searchUseAt(at){
			$("#useAt").val(at);
			$("#searchFrm").submit();
		}
		function f_useAtChg_atPost(at, sn){
			$.ajax({
				type : "post",
				url: './useAtChg',
				data: 'popupNo='+sn+'&useAt='+at,
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


		function f_preview_popup (sn, top, left, width, heigth, ty) {
			if(ty=='1'){
				var feature = "top=" + top + ", left=" + left + ", width=" + width + ", height=" + heigth + ",status=no,toolbar=no,scrollbars=no,location=no,resizable=no";
				window.open("./popup?popupNo="+sn+"&popupTy="+ty, "popMenu", feature);
			}
			else if(ty=='2') {
				if($("#popup"+sn).length > 0){
					console.log("popup #"+sn +" create error");
					return false;
				}
				$.ajax({
					type : "post"
					, url: './popup'
					, data: 'popupNo='+sn+'&popupTy='+ty
					, dataType: 'text'
					, contentType: 'application/x-www-form-urlencoded; charset=UTF-8'
					, success: function(data) {
						$(".popupPreview").append(data);
						var $el = $("#popup"+sn);
						var $elWidth = ~~($el.outerWidth()),
							$elHeight = ~~($el.outerHeight()),
							docWidth = $(document).width(),
							docHeight = $(document).height();

				        if ($elHeight < docHeight || $elWidth < docWidth) {
				        	// 화면의 중앙에 레이어를 띄운다.
				            $el.css({
				                marginTop: -$elHeight /2,
				                marginLeft: -$elWidth/2
				            })
// 				            $el.css({
// 				                top: top,
// 				                left: left
// 				                zIndex: 9999
// 				                position: 'fixed'
// 				            })
				        } else {
				            $el.css({top: 0, left: 0});
				        }
				        $el.find('.btn').click(function(){
				        	$el.fadeOut(function(){
				        		$(this).remove();
				        	});
				        });
				        $el.fadeIn();
					}
					, error: function(data, status, err) {
						console.log('error forard: ' + data);
					}
				})
			}
			else if(ty=='3'){
				if($("#popup"+sn).length > 0){
					console.log("popup #"+sn +" create error");
					return false;
				}
				$.ajax({
					type : "post"
					, url: './popup'
					, data: 'popupNo='+sn+'&popupTy='+ty
					, dataType: 'text'
					, contentType: 'application/x-www-form-urlencoded; charset=UTF-8'
					, success: function(data) {
						$(".popupPreview").html(data);
						var $el = $("#popup"+sn);
			            $el.css({
			                top: 0,
			                left: 0,
			                zIndex: 9999,
			                position: 'fixed'
			            });
				        $el.find('.btn').click(function(){
				        	$el.fadeOut(function(){
				        		$(this).remove();
				        	});
				        });
				        $el.fadeIn();
					}
					, error: function(data, status, err) {
						console.log('error forard: ' + data);
					}
				})
			}
		}
		$(function() {
			$(document).on('click', '.popup-modal-dismiss', function (e) {
				e.preventDefault();
				$.magnificPopup.close();
			});
		});
		</script>

			<!-- Start Breadcrumb -->
			<jsp:include page="/WEB-INF/jsp/admin/layout/breadcrumb.jsp">
				<jsp:param name="pageName" value="팝업 관리"/>
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
						<h2 class="panel-title">팝업 목록</h2>
						<p class="panel-subtitle">
							총 ${listVO.totalCount}건
						</p>
					</header>
					<div class="panel-body">

						<div class="form-group">
							<form id="searchFrm" name="searchFrm" class="form-inline" method="get" action="./list">
							<input type="hidden" id="useAt" name="useAt" value="${param.useAt}" />
							<select id="siteNo" name="siteNo" class="form-control">
								<option value="" <c:if test="${param.siteNo eq ''}">selected="selected"</c:if>>사이트 선택</option>
								<c:forEach items="${siteListAll}" var="siteListAll">
								<option value="${siteListAll.siteNo}" <c:if test="${param.siteNo eq siteListAll.siteNo}">selected="selected"</c:if>>${siteListAll.siteNm}</option>
								</c:forEach>
							</select>
							<%--
							<select id="popupTy" name="popupTy" class="form-control">
								<option value="" <c:if test="${param.popupTy eq ''}">selected="selected"</c:if>>팝업 종류 선택</option>
								<c:forEach items="${popupTyList}" var="popupTy">
								<option value="${popupTy.codeId }" <c:if test="${param.popupTy eq popupTy.codeId}">selected="selected"</c:if>>${popupTy.codeNm}</option>
								</c:forEach>
							</select>
							 --%>
							<select id="popupTy" name="popupTy" class="form-control">
								<option value="" <c:if test="${param.popupTy eq ''}">selected="selected"</c:if>>팝업 종류 선택</option>
								<c:forEach items="${popupTy}" var="popup">
								<option value="${popup.key }" <c:if test="${param.popupTy eq popup.key}">selected="selected"</c:if>>${popup.value}</option>
								</c:forEach>
							</select>
							<select id="searchKey" name="searchKey" class="form-control">
								<option value="popupSj" <c:if test="${param.searchKey eq 'popupSj' || param.searchKey eq ''}">selected="selected"</c:if>>제목</option>
							</select>
							<input type="text" id="searchText" name="searchText" value="${param.searchText}" class="form-control">
							<button type="submit" class="btn btn-default"><i class="fa fa-search"></i> 검색</button>
							</form>
						</div>

						<div class="table-responsive">
							<!-- Start Selectable Table Row -->
							<form id="listFrm" name="listFrm" method="post">
							<table class="table table-bordered table-hover mb-none">
								<colgroup>
									<col style="width:60px;" />
									<col style="width:200px;" />
									<col />
									<col style="width:80px;" />
									<col />
									<col style="width:175px;" />
									<col style="width:120px;" />
								</colgroup>
								<thead>
									<tr>
										<th class="text-center">순번</th>
										<th class="text-center">이미지</th>
										<th class="text-center">사이트명</th>
										<th class="text-center">팝업 종류</th>
										<th class="text-center">제목</th>
										<th class="text-center">게시기간</th>
										<th class="text-center">관리</th>
									</tr>
								</thead>
								<tbody>
									<c:forEach items="${listVO.listObject}" var="resultList" varStatus="status">
									<c:set var="pageParam" value="popupNo=${resultList.popupNo}&amp;curPage=${listVO.curPage}${!empty(listVO.urlParam)? '&amp;' : ''}${listVO.urlParam}" />
									<tr>
										<td class="text-center">${listVO.startNo - status.index }</td>
										<td>
											<c:forEach var="fileList" items="${resultList.fileList }" end="0" varStatus="status">
											<img src="/comm/getImage?srvcId=${fileList.srvcId }&amp;upperNo=${fileList.upperNo }&amp;fileTy=${fileList.fileTy }&amp;fileNo=${fileList.fileNo }&amp;thumbTy=S">
											</c:forEach>
										</td>
										<td>${resultList.siteNm}</td>
										<td class="text-center">${popupTy[resultList.popupTy]}</td>
										<td><a href="./view?${pageParam}">${resultList.popupSj }</a></td>
										<td  class="text-center">
											<fmt:parseDate value="${resultList.bgnDttm }" var="parsedNtceBgnde" pattern="yyyy-MM-dd" />
											<fmt:parseDate value="${resultList.endDttm }" var="parsedNtceEndde" pattern="yyyy-MM-dd" />
											<fmt:formatDate pattern="yyyy-MM-dd" value="${parsedNtceBgnde}" /> ~ <fmt:formatDate pattern="yyyy-MM-dd" value="${parsedNtceEndde}" />
										</td>
										<td class="text-center">
											<div class="btn-group btn-group-sm">
												<a href="./form?popupNo=${resultList.popupNo}" class="btn btn-info" title="편집"><i class="fa fa-pencil"></i></a>
												<c:if test="${resultList.useAt eq 'Y'}">
												<a href="#remove" onclick="f_useAtChg_atPost('N', ${resultList.popupNo})" class="btn btn-warning" title="사용안함"><i class="fa fa-eye-slash"></i></a>
												</c:if>
												<c:if test="${resultList.useAt eq 'N'}">
												<a href="#restore" onclick="f_useAtChg_atPost('Y', ${resultList.popupNo})" class="btn btn-warning" title="사용안함 해제"><i class="fa fa-eye"></i></a>
												</c:if>
												<a href="#preview" onclick="f_preview_popup(${resultList.popupNo},${resultList.popupTop},${resultList.popupLeft},${resultList.popupWidth},${resultList.popupHeight},${resultList.popupTy})" class="btn btn-success" title="미리보기"><i class="fa fa-binoculars"></i></a>
												<%-- <a href="./popup?popupNo=${resultList.popupNo}" class="btn btn-success" title="미리보기"><i class="icon icon-white icon-eye-open"></i></a> --%>
											</div>
										</td>
									</tr>
									</c:forEach>
									<c:if test="${empty listVO.listObject}">
									<tr>
										<td colspan="6" style="height:50px; text-align:center; vertical-align:middle;">등록된 데이터가 없습니다.</td>
									</tr>
									</c:if>
								</tbody>
							</table>
							</form>
							<!-- End Selectable Table Row -->
						</div>
					</div>
					<footer class="panel-footer">
						<div class="row">
							<div class="col-sm-6">
								<cms:paging listVO="${listVO}" />
							</div>
							<div class="col-sm-6">
								<div class="btns">
								<cmsBtn2:btn btnTy="form" path="${curPath}" mngrSession="${mngrSession }" >팝업 등록</cmsBtn2:btn>
								</div>
							</div>
						</div>
					</footer>
				</section>
				</div>

				<div class="popupPreview"></div>

			</div>
