<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ include file="/common/taglibs.jsp" %>

	<script type="text/javascript">
	$( document ).ready( function() {
	});

	function f_Delete(useAt){
		$("#crud").val("DELETE");
		$("#useAt").val(useAt);
		document.frmSiteMain.action = "action";
		document.frmSiteMain.submit();
	}
	</script>


			<!-- Start Breadcrumb -->
			<jsp:include page="/WEB-INF/jsp/admin/layout/breadcrumb.jsp">
				<jsp:param name="pageName" value="메인 관리"/>
			</jsp:include>
			<!-- End Breadcrumb -->

            <!-- start: page -->
			<div class="row">
				<div class="col-md-12">
				<section class="panel panel-featured panel-featured-primary">

				<f:form name="frmSiteMain" id="frmSiteMain" modelAttribute="siteMainVO" method="post" action="./action" enctype="multipart/form-data">
					<f:hidden path="crud" />
					<f:hidden path="siteNo" />
					<f:hidden path="siteMainNo" />
					<f:hidden path="useAt" />
					<input type="hidden" id="delAttachFileNo" name="delAttachFileNo" value="" />

					<header class="panel-heading">
						<div class="panel-actions">

						</div>
						<h2 class="panel-title">메인 상세</h2>
						<p class="panel-subtitle"></p>
					</header>
					<div class="panel-body">

						<table class="table">
							<colgroup>
								<col style="width:100px"/>
								<col />
							</colgroup>
							<tbody>
								<tr>
									<th>메인분류 <span class="required">*</span></th>
									<td>${siteMainVO.nttClNm}</td>
								</tr>
								<tr>
									<th>제목</th>
									<td>${siteMainVO.nttSj}</td>
								</tr>
								<tr>
									<th>부제목</th>
									<td>${siteMainVO.nttSubSj}</td>
								</tr>
								<tr>
									<th>내용</th>
									<td>${siteMainVO.nttCn}</td>
								</tr>
								<tr>
									<th>작성일</th>
									<td>${siteMainVO.writngDe}</td>
								</tr>
								<tr>
									<th>이미지 파일</th>
									<td><c:forEach var="fileList" items="${siteMainVO.fileList }" varStatus="status">
											<c:set var="imgParams" value="srvcId=${fileList.srvcId }&amp;upperNo=${fileList.upperNo }&amp;fileTy=${fileList.fileTy }&amp;fileNo=${fileList.fileNo }"/>
											<div class="thumbnail-gallery">
												<a class="img-thumbnail lightbox" href="/comm/getImage?${imgParams}&amp;thumbTy=L" data-plugin-options='{ "type":"image" }'>
													<img class="img-responsive" width="215" src="/comm/getImage?${imgParams}&amp;thumbTy=M">
													<span class="zoom">
														<i class="fa fa-search"></i>
													</span>
												</a>
												<p><span class="label label-default"><i class="fa fa-file-image-o"></i> file name</span> ${fileList.orginlFileNm}</p>
												<p><span class="label label-default"><i class="fa fa-balance-scale"></i> file size</span> ${cmsFn:fileSize(fileList.fileSize)}</p>
												<p><span class="label label-default"><i class="fa fa-download"></i> download</span> ${fileList.dwldCo}회 </p>
												<p><span class="label label-default"><i class="fa fa-blind"></i> file description</span> ${fileList.fileDc}</p>
												<a class="btn btn-default btn-xs" href="/comm/getFile?${imgParams}"><i class="fa fa-download"></i> 다운로드</a>
											</div>
<%-- 										<img src="/comm/getImage?srvcId=${fileList.srvcId }&amp;upperNo=${fileList.upperNo }&amp;fileTy=${fileList.fileTy }&amp;fileNo=${fileList.fileNo }&amp;thumbTy=S" style="max-with:840px;"> --%>
<%-- 										<p class="help-block"><a href="/comm/getFile?srvcId=${fileList.srvcId }&amp;upperNo=${fileList.upperNo }&amp;fileTy=${fileList.fileTy }&amp;fileNo=${fileList.fileNo }">${fileList.orginlFileNm} (용량 : ${cmsFn:fileSize(fileList.fileSize)} , 다운로드 : ${fileList.dwldCo}회)</a></p> --%>
<%-- 										<p class="help-block"><span class="label label-info"><i class="fa fa-blind"></i> 대체문구</span> ${fileList.fileDc}</p> --%>
										</c:forEach>
									</td>
								</tr>
								<tr>
									<th>링크URL</th>
									<td>${siteMainVO.linkUrl}</td>
								</tr>
								<tr>
									<th>링크 타겟</th>
									<td>${linkTrgtTyCode[siteMainVO.linkTrgt]}</td>
								</tr>
								<tr>
									<th>게시기간 </th>
									<td>
									<c:choose>
										<c:when test="${empty siteMainVO.bgnDttm and empty siteMainVO.endDttm }">
										상시
										</c:when>
										<c:otherwise>
										${siteMainVO.bgnDttm } ~ ${siteMainVO.endDttm }
										</c:otherwise>
									</c:choose>
									</td>
								</tr>
								<tr>
									<th>사용여부</th>
									<td>${useAtCode[siteMainVO.useAt]}</td>
								</tr>
								<tr>
									<th>게시순서</th>
									<td>${siteMainVO.siteSeq}</td>
								</tr>
							</tbody>
						</table>
					</div>
					<footer class="panel-footer">
						<div class="row">
							<div class="col-sm-6">
								<c:set var="pageParam" value="siteNo=${param.siteNo}&useAt=${param.useAt}" />
								<a href="./list?${pageParam}" class="btn btn-default">목록</a>
							</div>
							<div class="col-sm-6 text-right">
								<cmsBtn2:btn btnTy="modify" path="${curPath}" mngrSession="${mngrSession }" modifyParam="?siteMainNo=${siteMainVO.siteMainNo}&siteNo=${siteMainVO.siteNo}">수정</cmsBtn2:btn>
								<c:if test="${siteMainVO.useAt eq 'Y'}">
									<cmsBtn2:btn btnTy="delete" path="${curPath}" mngrSession="${mngrSession }" script="f_Delete('N'); return false;">사용안함</cmsBtn2:btn>
								</c:if>
								<c:if test="${siteMainVO.useAt eq 'N'}">
									<button class="btn btn-success" id="delBtn" onclick="f_Delete('Y'); return false;">사용</button>
								</c:if>
							</div>
						</div>
					</footer>

				</f:form>
				</section>
				</div>
			</div>