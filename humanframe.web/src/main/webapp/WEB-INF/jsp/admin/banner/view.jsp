<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/taglibs.jsp" %>
<%@ page trimDirectiveWhitespaces="true" %>

			<script>
			function f_useAtChg(at){
				$.ajax({
					type : "post",
					url: './useAtChg',
					data: 'bannerNo=${bannerVO.bannerNo}&useAt='+at,
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
				<jsp:param name="pageName" value="배너관리"/>
			</jsp:include>
			<!-- End Breadcrumb -->

            <!-- start: page -->
			<div class="row">
				<div class="col-md-12">
				<section class="panel panel-featured panel-featured-primary">
					<header class="panel-heading">
						<div class="panel-actions">

						</div>
						<h2 class="panel-title">배너정보 조회</h2>
						<p class="panel-subtitle">
						</p>
					</header>
					<div class="panel-body">

						<div class="table-responsive">

							<table class="table">
								<colgroup>
									<col style="width:140px"/>
									<col />
								</colgroup>
								<tbody>
									<tr>
										<th>사이트 </th>
										<td>
											<select class="form-control" multiple="multiple" cssStyle="height:150px;" readonly="readonly">
												<c:forEach items="${bannerVO.siteList}" var="siteList">
												<option>${siteList.siteNm}</option>
												</c:forEach>
											</select>
										</td>
									</tr>
									<tr>
										<th>제목 </th>
										<td>${bannerVO.sj }
										</td>
									</tr>
									<tr>
										<th>부제목 </th>
										<td>${bannerVO.subtitl }
										</td>
									</tr>
									<tr>
										<th>내용 </th>
										<td>${bannerVO.sumry }
										</td>
									</tr>
									<tr>
										<th>배너구분 </th>
										<td>${bannerVO.bannerCodeNm }
										</td>
									</tr>
									<tr>
										<th>이미지 파일(PC)</th>
										<td>
											<c:forEach var="pcFileList" items="${bannerVO.pcFileList }" varStatus="status">
												<c:set var="imgParams" value="srvcId=${pcFileList.srvcId }&amp;upperNo=${pcFileList.upperNo }&amp;fileTy=${pcFileList.fileTy }&amp;fileNo=${pcFileList.fileNo }"/>
												<div class="thumbnail-gallery">
													<a class="img-thumbnail lightbox" href="/comm/getImage?${imgParams}&amp;thumbTy=L" data-plugin-options='{ "type":"image" }'>
														<img class="img-responsive" width="215" src="/comm/getImage?${imgParams}&amp;thumbTy=M">
														<span class="zoom">
															<i class="fa fa-search"></i>
														</span>
													</a>
													<p><span class="label label-default"><i class="fa fa-file-image-o"></i> file name</span> ${pcFileList.orginlFileNm}</p>
													<p><span class="label label-default"><i class="fa fa-balance-scale"></i> file size</span> ${cmsFn:fileSize(pcFileList.fileSize)}</p>
													<p><span class="label label-default"><i class="fa fa-download"></i> download</span> ${pcFileList.dwldCo}회 </p>
													<p><span class="label label-default"><i class="fa fa-blind"></i> file description</span> ${pcFileList.fileDc}</p>
													<a class="btn btn-default btn-xs" href="/comm/getFile?${imgParams}"><i class="fa fa-download"></i> 다운로드</a>
												</div>
<%-- 											<img src="/comm/getImage?srvcId=${pcFileList.srvcId }&amp;upperNo=${pcFileList.upperNo }&amp;fileTy=${pcFileList.fileTy }&amp;fileNo=${pcFileList.fileNo }" style="max-with:840px;"> --%>
<%-- 											<p class="help-block"><a href="/comm/getFile?srvcId=${pcFileList.srvcId }&amp;upperNo=${pcFileList.upperNo }&amp;fileTy=${pcFileList.fileTy }&amp;fileNo=${pcFileList.fileNo }">${pcFileList.orginlFileNm} (용량 : ${cmsFn:fileSize(pcFileList.fileSize)} , 다운로드 : ${pcFileList.dwldCo}회)</a></p> --%>
<%-- 											<p class="help-block"><span class="label label-info"><i class="fa fa-blind"></i> 대체문구</span> ${pcFileList.fileDc}</p> --%>
											</c:forEach>
										</td>
									</tr>
									<tr>
										<th>이미지 파일(태블릿)</th>
										<td>
											<c:forEach var="tabletFileList" items="${bannerVO.tabletFileList }" varStatus="status">
												<c:set var="imgParams" value="srvcId=${tabletFileList.srvcId }&amp;upperNo=${tabletFileList.upperNo }&amp;fileTy=${tabletFileList.fileTy }&amp;fileNo=${tabletFileList.fileNo }"/>
												<div class="thumbnail-gallery">
													<a class="img-thumbnail lightbox" href="/comm/getImage?${imgParams}&amp;thumbTy=L" data-plugin-options='{ "type":"image" }'>
														<img class="img-responsive" width="215" src="/comm/getImage?${imgParams}&amp;thumbTy=M">
														<span class="zoom">
															<i class="fa fa-search"></i>
														</span>
													</a>
													<p><span class="label label-default"><i class="fa fa-file-image-o"></i> file name</span> ${tabletFileList.orginlFileNm}</p>
													<p><span class="label label-default"><i class="fa fa-balance-scale"></i> file size</span> ${cmsFn:fileSize(tabletFileList.fileSize)}</p>
													<p><span class="label label-default"><i class="fa fa-download"></i> download</span> ${tabletFileList.dwldCo}회 </p>
													<p><span class="label label-default"><i class="fa fa-blind"></i> file description</span> ${tabletFileList.fileDc}</p>
													<a class="btn btn-default btn-xs" href="/comm/getFile?${imgParams}"><i class="fa fa-download"></i> 다운로드</a>
												</div>
<%-- 											<img src="/comm/getImage?srvcId=${tabletFileList.srvcId }&amp;upperNo=${tabletFileList.upperNo }&amp;fileTy=${tabletFileList.fileTy }&amp;fileNo=${tabletFileList.fileNo }"> --%>
<%-- 											<p class="help-block"><a href="/comm/getFile?srvcId=${tabletFileList.srvcId }&amp;upperNo=${tabletFileList.upperNo }&amp;fileTy=${tabletFileList.fileTy }&amp;fileNo=${tabletFileList.fileNo }">${tabletFileList.orginlFileNm} (용량 : ${cmsFn:fileSize(tabletFileList.fileSize)} , 다운로드 : ${tabletFileList.dwldCo}회)</a></p> --%>
<%-- 											<p class="help-block"><span class="label label-info"><i class="fa fa-blind"></i> 대체문구</span> ${tabletFileList.fileDc}</p> --%>
											</c:forEach>
										</td>
									</tr>
									<tr>
										<th>이미지 파일(모바일)</th>
										<td>
											<c:forEach var="mobileFileList" items="${bannerVO.mobileFileList }" varStatus="status">
												<c:set var="imgParams" value="srvcId=${mobileFileList.srvcId }&amp;upperNo=${mobileFileList.upperNo }&amp;fileTy=${mobileFileList.fileTy }&amp;fileNo=${mobileFileList.fileNo }"/>
												<div class="thumbnail-gallery">
													<a class="img-thumbnail lightbox" href="/comm/getImage?${imgParams}&amp;thumbTy=L" data-plugin-options='{ "type":"image" }'>
														<img class="img-responsive" width="215" src="/comm/getImage?${imgParams}&amp;thumbTy=M">
														<span class="zoom">
															<i class="fa fa-search"></i>
														</span>
													</a>
													<p><span class="label label-default"><i class="fa fa-file-image-o"></i> file name</span> ${mobileFileList.orginlFileNm}</p>
													<p><span class="label label-default"><i class="fa fa-balance-scale"></i> file size</span> ${cmsFn:fileSize(mobileFileList.fileSize)}</p>
													<p><span class="label label-default"><i class="fa fa-download"></i> download</span> ${mobileFileList.dwldCo}회 </p>
													<p><span class="label label-default"><i class="fa fa-blind"></i> file description</span> ${mobileFileList.fileDc}</p>
													<a class="btn btn-default btn-xs" href="/comm/getFile?${imgParams}"><i class="fa fa-download"></i> 다운로드</a>
												</div>
<%-- 											<img src="/comm/getImage?srvcId=${mobileFileList.srvcId }&amp;upperNo=${mobileFileList.upperNo }&amp;fileTy=${mobileFileList.fileTy }&amp;fileNo=${mobileFileList.fileNo }"> --%>
<%-- 											<p class="help-block"><a href="/comm/getFile?srvcId=${mobileFileList.srvcId }&amp;upperNo=${mobileFileList.upperNo }&amp;fileTy=${mobileFileList.fileTy }&amp;fileNo=${mobileFileList.fileNo }">${mobileFileList.orginlFileNm} (용량 : ${cmsFn:fileSize(mobileFileList.fileSize)} , 다운로드 : ${mobileFileList.dwldCo}회)</a></p> --%>
<%-- 											<p class="help-block"><span class="label label-info"><i class="fa fa-blind"></i> 대체문구</span> ${mobileFileList.fileDc}</p> --%>
											</c:forEach>
										</td>
									</tr>
									<tr>
										<th>링크 </th>
										<td>${bannerVO.linkUrl }
										</td>
									</tr>
									<tr>
										<th>링크 타겟 </th>
										<td>${linkTrgtTyCode[bannerVO.linkTrgt] }
										</td>
									</tr>
									<tr>
										<th>게시기간 </th>
										<td>${bannerVO.ntceBgnde } ~ ${bannerVO.ntceEndde }
										</td>
									</tr>
									<tr>
										<th>사용여부 </th>
										<td>${useAtCode[bannerVO.useAt] }
										</td>
									</tr>
								</tbody>
							</table>

						</div>
					</div>
					<footer class="panel-footer">
						<div class="row">
							<div class="col-md-6">
								<c:set var="pageParam" value="useAt=${param.useAt }&amp;curPage=${param.curPage }&amp;searchKey=${param.searchKey}&amp;searchText=${param.searchText}" />
								<a href="./list?${pageParam}" class="btn btn-default">목록</a>
							</div>
							<div class="col-md-6 text-right">
                                <cmsBtn2:btn btnTy="modify" path="${curPath}" mngrSession="${mngrSession }" modifyParam="?bannerNo=${bannerVO.bannerNo}&amp;${pageParam}">수정</cmsBtn2:btn>
								<c:if test="${bannerVO.useAt eq 'Y'}">
								<cmsBtn2:btn btnTy="use" path="${curPath}" mngrSession="${mngrSession }" script="f_useAtChg('N'); return false;" useAt="N" >사용안함</cmsBtn2:btn>
								</c:if>
								<c:if test="${bannerVO.useAt eq 'N'}">
								<cmsBtn2:btn btnTy="use" path="${curPath}" mngrSession="${mngrSession }" script="f_useAtChg('Y'); return false;" useAt="Y" >사용</cmsBtn2:btn>
								</c:if>
							</div>
						</div>
					</footer>
				</section>
				</div>

			</div>

