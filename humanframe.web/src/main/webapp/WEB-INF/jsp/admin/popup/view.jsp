<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/taglibs.jsp" %>
<%@ page trimDirectiveWhitespaces="true" %>

			<script>
			function f_useAtChg(at){
				$.ajax({
					type : "post",
					url: './useAtChg',
					data: 'popupNo=${popupVO.popupNo}&useAt='+at,
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

			$(function() {
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
						</div>
						<h2 class="panel-title">팝업 정보 조회</h2>
						<p class="panel-subtitle">
						</p>
					</header>
					<div class="panel-body">
						<table class="table">
							<colgroup>
								<col style="width:100"/>
								<col />
							</colgroup>
							<tbody>
								<tr>
									<th>사이트 </th>
									<td>${popupVO.siteNm }
									</td>
								</tr>
								<tr>
									<th>팝업 종류 </th>
									<td>${popupTy[popupVO.popupTy] }
									</td>
								</tr>
								<tr>
									<th>제목 </th>
									<td>${popupVO.popupSj }
									</td>
								</tr>
								<tr>
									<th>팝업창 위치</th>
									<td>
										<span <c:if test="${popupVO.popupTy eq 3}">class='text-muted' style='text-decoration: line-through;'</c:if>>
										TOP : ${popupVO.popupTop}
										LEFT : ${popupVO.popupLeft}
										</span>
									</td>
								</tr>
								<tr>
									<th>팝업창 사이즈</th>
									<td>
										<span <c:if test="${popupVO.popupTy eq 3}">class='text-muted' style='text-decoration: line-through;'</c:if>>
										가로 : ${popupVO.popupWidth}
										</span>
										세로 : ${popupVO.popupHeight}
										<c:if test="${popupVO.popupTy eq 3}">
										<p class="mb-none mt-xs">
										 <i class="fa fa-info-circle"></i> <code>띠배너</code>는 세로 값을 띠배너의 높이 값으로 사용합니다.
										</p>
										</c:if>
									</td>
								</tr>
<!-- 										<tr> -->
<!-- 											<th>띠배너 높이</th> -->
<%-- 											<td>${popupVO.popupHeight}</td> --%>
<!-- 										</tr> -->
								<tr>
									<th>이미지 파일</th>
									<td>
										<c:forEach var="fileList" items="${popupVO.fileList }" varStatus="status">
										<div class="thumbnail-gallery">
											<a class="img-thumbnail lightbox" href="/comm/getImage?srvcId=${fileList.srvcId }&amp;upperNo=${fileList.upperNo }&amp;fileTy=${fileList.fileTy }&amp;fileNo=${fileList.fileNo }&amp;thumbTy=L" data-plugin-options='{ "type":"image" }'>
												<img class="img-responsive" width="215" src="/comm/getImage?srvcId=${fileList.srvcId }&amp;upperNo=${fileList.upperNo }&amp;fileTy=${fileList.fileTy }&amp;fileNo=${fileList.fileNo }&amp;thumbTy=M">
												<span class="zoom">
													<i class="fa fa-search"></i>
												</span>
											</a>
											<p><span class="label label-default"><i class="fa fa-file-image-o"></i> file name</span> ${fileList.orginlFileNm}</p>
											<p><span class="label label-default"><i class="fa fa-balance-scale"></i> file size</span> ${cmsFn:fileSize(fileList.fileSize)}</p>
											<p><span class="label label-default"><i class="fa fa-download"></i> download</span> ${fileList.dwldCo}회 </p>
											<p><span class="label label-default"><i class="fa fa-blind"></i> file description</span> ${fileList.fileDc}</p>
											<a class="btn btn-default btn-xs" href="/comm/getFile?srvcId=${fileList.srvcId }&amp;upperNo=${fileList.upperNo }&amp;fileTy=${fileList.fileTy }&amp;fileNo=${fileList.fileNo }"><i class="fa fa-download"></i> 다운로드</a>
										</div>
<%-- 												<a href="/comm/getFile?srvcId=${fileList.srvcId }&amp;upperNo=${fileList.upperNo }&amp;fileTy=${fileList.fileTy }&amp;fileNo=${fileList.fileNo }">${fileList.orginlFileNm} (용량 : ${cmsFn:fileSize(fileList.fileSize)} , 다운로드 : ${fileList.dwldCo}회)</a><br /> --%>
										</c:forEach>
									</td>
								</tr>
								<tr>
									<th>링크 </th>
									<td>${popupVO.linkUrl }
									</td>
								</tr>
								<tr>
									<th>링크 타겟 </th>
									<td>${linkTrgtTyCode[popupVO.linkTrgt] }
									</td>
								</tr>
								<tr>
									<th>게시기간 </th>
									<td>${popupVO.bgnDttm } ~ ${popupVO.endDttm }
									</td>
								</tr>
								<tr>
									<th>그만보기 설정 여부 </th>
									<td>${useAtCode[popupVO.stopViewAt] }
									</td>
								</tr>
								<tr>
									<th>사용여부 </th>
									<td>${useAtCode[popupVO.useAt] }
									</td>
								</tr>
							</tbody>
						</table>
					</div>
					<footer class="panel-footer">
						<div class="row">
							<div class="col-sm-6">
								<c:set var="pageParam" value="useAt=${param.useAt }&amp;curPage=${param.curPage }&amp;searchKey=${param.searchKey}&amp;searchText=${param.searchText}" />
								<a href="./list?${pageParam}" class="btn btn-default">목록</a>
							</div>
							<div class="col-sm-6 text-right">
								<a href="./form?popupNo=${popupVO.popupNo}" class="btn btn-primary" title="수정"> 수정</a>
								<c:if test="${popupVO.useAt eq 'Y'}">
								<cmsBtn2:btn btnTy="use" path="${curPath}" mngrSession="${mngrSession }" script="f_useAtChg('N'); return false;" useAt="N" >
									 사용안함
								</cmsBtn2:btn>
								</c:if>
								<c:if test="${popupVO.useAt eq 'N'}">
								<cmsBtn2:btn btnTy="use" path="${curPath}" mngrSession="${mngrSession }" script="f_useAtChg('Y'); return false;" useAt="Y" >
									 사용
								</cmsBtn2:btn>
								</c:if>

							</div>
						</div>
					</footer>
				</section>
				</div>

			</div>
