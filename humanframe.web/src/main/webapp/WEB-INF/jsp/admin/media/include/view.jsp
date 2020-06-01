<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/taglibs.jsp" %>
<%@ page trimDirectiveWhitespaces="true" %>

<%-- 		<link rel="stylesheet" type="text/css" href="${globalAdminAssets}/css/plugins/jquery.snippet.css">
		<script src="${globalAdminAssets}/js/plugins/jquery.snippet.min.js"></script>
		<script>
		$(function() {
	        $("pre.styles").snippet("html",{
	            style:"typical",
	            menu:false
	        });
		});
		</script> --%>


            <!-- start: page -->
			<div class="row">
				<div class="col-md-12">
				<section class="panel panel-featured panel-featured-primary">
					<header class="panel-heading">
						<h2 class="panel-title">미디어관리 상세</h2>
					</header>
					<div class="panel-body">
						<div class="panel-group" id="accordion">
						<div class="panel panel-accordion">
							<div class="panel-heading">
								<h4 class="panel-title">
									<a class="accordion-toggle" >
										<i class="fa fa-edit"></i> 기본정보
									</a>
								</h4>
							</div>
							<div id="collapseOne" >
								<div class="panel-body p-none">
									<table class="table m-none">
										<colgroup>
											<col style="width:200px"/>
											<col />
										</colgroup>
										<tbody>
											<tr>
												<th>미디어 분류</th>
												<td>${mediaVO.mediaCodeNm}</td>
											</tr>
											<tr>
												<th>미디어 명 (한국어)</th>
												<td>${mediaVO.mediaNm}</td>
											</tr>
											<tr>
												<th>대체텍스트 (한국어)</th>
												<td>${mediaVO.sumry}</td>
											</tr>

											<c:forEach var="mediaLang" items="${mediaVO.mediaLangList }" varStatus="status">
											<tr style="background-color:#fcf8e3;">
												<th>미디어 명 (${mediaLang.langCodeNm })</th>
												<td>${mediaLang.mediaNm}</td>
											</tr>
											<tr style="background-color:#fcf8e3;">
												<th>대체텍스트 (${mediaLang.langCodeNm })</th>
												<td>${mediaLang.sumry}</td>
											</tr>
											</c:forEach>

											<c:if test="${fn:length(mediaVO.thumbFileList) > 0 }">
											<tr>
												<th>미디어 썸네일</th>
												<td>
													<c:if test="${fn:toLowerCase(mediaVO.cpyrhtTy) eq '' }">
														<c:forEach var="thumbFile" items="${mediaVO.thumbFileList }" varStatus="status">
														<img src="/comm/getImage?srvcId=${thumbFile.srvcId }&amp;upperNo=${thumbFile.upperNo }&amp;fileTy=${thumbFile.fileTy }&amp;fileNo=${thumbFile.fileNo }"  alt="${mediaVO.mediaNm }" style="width:150px;" />
														</c:forEach>
													</c:if>
													<c:if test="${fn:toLowerCase(mediaVO.cpyrhtTy) ne '' }">
														<c:forEach var="thumbFile" items="${mediaVO.thumbFileList }" varStatus="status">
														<img src="/comm/getImage?srvcId=${thumbFile.srvcId }&amp;upperNo=${thumbFile.upperNo }&amp;fileTy=${thumbFile.fileTy }&amp;fileNo=${thumbFile.fileNo }&amp;thumbTy=W"  alt="${mediaVO.mediaNm }" style="width:150px;" />
														</c:forEach>
													</c:if>
												</td>
											</tr>
											</c:if>
											<tr>
												<th>저장 방법</th>
												<td>
													<c:if test="${mediaVO.streMthTy eq 'FILE'}">파일</c:if>
													<c:if test="${mediaVO.streMthTy eq 'HTML'}">HTML</c:if>
												</td>
											</tr>
											<tr <c:if test="${mediaVO.streMthTy eq 'HTML'}">style="display:none;"</c:if>>
												<th>미디어 파일</th>
												<td>
												<c:if test="${fn:toLowerCase(mediaVO.cpyrhtTy) eq '' }">
													<c:forEach var="mediaFile" items="${mediaVO.mediaFileList }" varStatus="status">
													<c:choose>
														<c:when test="${mediaFile.fileExtsn eq 'jpg' || mediaFile.fileExtsn eq 'gif' || mediaFile.fileExtsn eq 'png' }">
														<img src="/comm/getImage?srvcId=${mediaFile.srvcId }&amp;upperNo=${mediaFile.upperNo }&amp;fileTy=${mediaFile.fileTy }&amp;fileNo=${mediaFile.fileNo }"  alt="${mediaVO.mediaNm }" style="max-width:800px;" />
														</c:when>
														<c:otherwise>
														<a href="/comm/getFile?srvcId=${mediaFile.srvcId }&amp;upperNo=${mediaFile.upperNo }&amp;fileTy=${mediaFile.fileTy }&amp;fileNo=${mediaFile.fileNo }">${mediaVO.mediaNm }</a>
														</c:otherwise>
													</c:choose>
													</c:forEach>
												</c:if>
												<c:if test="${fn:toLowerCase(mediaVO.cpyrhtTy) ne '' }">
													<c:forEach var="mediaFile" items="${mediaVO.mediaFileList }" varStatus="status">
													<c:choose>
														<c:when test="${mediaFile.fileExtsn eq 'jpg' || mediaFile.fileExtsn eq 'gif' || mediaFile.fileExtsn eq 'png' }">
														<img src="/comm/getImage?srvcId=${mediaFile.srvcId }&amp;upperNo=${mediaFile.upperNo }&amp;fileTy=${mediaFile.fileTy }&amp;fileNo=${mediaFile.fileNo }&amp;thumbTy=W"  alt="${mediaVO.mediaNm }" style="max-width:800px;" />
														</c:when>
														<c:otherwise>
														<a href="/comm/getFile?srvcId=${mediaFile.srvcId }&amp;upperNo=${mediaFile.upperNo }&amp;fileTy=${mediaFile.fileTy }&amp;fileNo=${mediaFile.fileNo }&amp;thumbTy=W">${mediaVO.mediaNm }</a>
														</c:otherwise>
													</c:choose>
													</c:forEach>
												</c:if>
												</td>
											</tr>

											<tr <c:if test="${mediaVO.streMthTy eq 'FILE'}">style="display:none;"</c:if>>
												<th>미디어 HTML</th>
												<td>
												<blockquote class="primary rounded b-thin" style="background: #f6f6f6;">
													<c:out value="${mediaVO.mediaHtml }" escapeXml="true" />
												</blockquote>
												<div style="padding-top:10px;">
													${mediaVO.mediaHtml }
												</div>
												</td>
											</tr>
											<tr>
												<th>CCL/공공누리</th>
												<td>
													<cms:lic licTy="${mediaVO.cpyrhtTy}" title="${mediaVO.mediaNm}" publisher="${mediaVO.chargerOrgnztNm}" />
												</td>
											</tr>
											<tr>
												<th>URI</th>
												<td>${mediaVO.uriWrd}</td>
											</tr>
											<tr>
												<th>통합검색 노출여부</th>
												<td>
													<c:if test="${mediaVO.srchAt eq 'Y'}">사용</c:if>
													<c:if test="${mediaVO.srchAt eq 'N'}">사용안함</c:if>
												</td>
											</tr>
											<tr>
												<th>사용여부</th>
												<td>
													<c:if test="${mediaVO.useAt eq 'Y'}">사용</c:if>
													<c:if test="${mediaVO.useAt eq 'N'}">사용안함</c:if>
												</td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>
						</div>
						<div class="panel panel-accordion">
							<div class="panel-heading">
								<h4 class="panel-title">
									<a class="accordion-toggle" data-toggle="collapse" href="#collapseTwo" >
										<i class="fa fa-file-text"></i> 메타정보
									</a>
								</h4>
							</div>
							<div id="collapseTwo" class="accordion-body collapse">
								<div class="panel-body p-none">
									<table class="table m-none">
										<colgroup>
											<col style="width:200px"/>
											<col />
										</colgroup>
										<tbody>
											<tr>
												<th>정보원</th>
												<td>
													${mediaVO.source}
												</td>
											</tr>
											<tr>
												<th>관련자료</th>
												<td>${mediaVO.relationMap}</td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>
						</div>
						</div>
					</div>

					<footer class="panel-footer">
						<div class="row">
							<div class="col-sm-7">
								<c:set var="pageParam" value="curPage=${param.curPage }&amp;searchKey=${param.searchKey}&amp;searchText=${param.searchText}&amp;srchMediaCodeId=${param.srchMediaCodeId}&amp;useAt=${param.useAt }&amp;targetId=${param.targetId}" />
								<a href="./list?${pageParam}" class="btn btn-default">목록</a>
							</div>
							<div class="col-sm-5 text-right">
								<cmsBtn2:btn btnTy="modify" path="${curPath}" mngrSession="${mngrSession }" modifyParam="?mediaNo=${mediaVO.mediaNo}&amp;${pageParam}">수정</cmsBtn2:btn>
			                 </div>
						</div>
					</footer>
				</section>
				</div>
			</div>
