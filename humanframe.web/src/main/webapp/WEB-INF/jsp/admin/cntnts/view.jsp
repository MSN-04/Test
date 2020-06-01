<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ include file="/common/taglibs.jsp" %>
	<style>
	${cntntsVO.cnCss}
	</style>

	<script>
	function f_useAtChg(at){
		$.ajax({
			type : "post",
			url: './useAtChg',
			data: 'cntntsNo=${cntntsVO.cntntsNo}&useAt='+at,
			dataType: 'text', //전송받을 데이터의 타입
			contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
			success: function(data) {
				if(data =="true"){
					alert("상태 변경되었습니다.");
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

	function f_delete(){
		if(confirm("모든 정보가 삭제되어 복구가 불가능합니다.\n정말 삭제하시겠습니까?")){
			$("#frmCntnts").attr("enctype", "multipart/form-data");
			$("#frmCntnts").attr("action", "./action?crud=DELETE&cntntsNo=${cntntsVO.cntntsNo}");
			$("#frmCntnts").submit();
		}
	}
	//미리보기
	function f_preview(menuNo){
		var data = {
				"menuNo" : menuNo
			  , "uriWrd" :'${cntntsVO.uriWrd}'
		}

		$.ajax({
			type : "post",
			url: './getSiteMenuUrl',
			data: data,
			dataType: 'text', //전송받을 데이터의 타입
			contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
			success: function(targetURI) {
				if(targetURI == "noMenu"){
					alert("해당메뉴는 접근할수없습니다. 배포되었는지 확인해주세요");
				} else if(targetURI == "noSite"){
					alert("해당사이트는 접근할수없습니다. 배포되었는지 확인해주세요");
				}else {
					window.open(targetURI, '_blank', 'width=1000, height=1000, resizable=yes, scrollbars=yes');
				}
			},
			error: function(data, status, err) {
				console.log('error forward : ' + data);
			}
		});
	}
	</script>

	<!-- Start Breadcrumb -->
	<jsp:include page="/WEB-INF/jsp/admin/layout/breadcrumb.jsp">
		<jsp:param name="pageName" value="콘텐츠관리"/>
	</jsp:include>
	<!-- End Breadcrumb -->

	<!-- start: page -->
	<div class="row">
	<div class="col-sm-9">

		<section class="panel panel-featured panel-featured-primary">
			<header class="panel-heading">
				<h2 class="panel-title">콘텐츠관리 상세</h2>
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
								<col style="width:100px"/>
								<col />
							</colgroup>
							<tbody>
								<tr>
									<th>제목</th>
									<td>${cntntsVO.cntntsSj}</td>
								</tr>
								<tr>
									<th>URI</th>
									<td>${cntntsVO.uriWrd}</td>
								</tr>
								<tr>
									<th>내용</th>
									<td class="cn-wrapper">${cntntsVO.cn}</td>
								</tr>
								<tr>
									<th>추가 CSS</th>
									<td>${cntntsVO.cnCss}</td>
								</tr>
								<tr>
									<th>발행상태</th>
									<td>${pblcateSttusTyCode[cntntsVO.pblcateSttusTy]}</td>
								</tr>
								<tr>
									<th>발행일</th>
									<td>${cntntsVO.pblcateDe}</td>
								</tr>
								<tr>
									<th>담당자</th>
									<td>${cntntsVO.chargerDeptNm} / ${cntntsVO.chargerNm}
										<c:if test="${!empty cntntsVO.chargerTelno }"> (${cntntsVO.chargerTelno})</c:if>
										<c:if test="${!empty cntntsVO.chargerEmail }"> (${cntntsVO.chargerEmail})</c:if>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
			</div>
			<div class="panel panel-accordion">
				<div class="panel-heading" data-plugin-toggle>
					<h4 class="panel-title">
						<a class="accordion-toggle" data-toggle="collapse"  href="#collapseTwo" >
							<i class="fa fa-plus-square"></i> 부가 정보
						</a>
					</h4>
				</div>
				<div id="collapseTwo" class="accordion-body collapse">
					<div class="panel-body p-none">
						<table class="table m-none">
							<colgroup>
								<col style="width:100px"/>
								<col />
							</colgroup>
							<tbody>
								<tr>
									<th>썸네일</th>
									<td>
									<c:forEach var="fileList" items="${cntntsVO.fileList }" varStatus="status">
										<img src="/comm/getImage?thumbTy=S&amp;srvcId=${fileList.srvcId }&amp;upperNo=${fileList.upperNo }&amp;fileTy=${fileList.fileTy }&amp;fileNo=${fileList.fileNo }"><br />
										<a href="/comm/getFile?srvcId=${fileList.srvcId }&amp;upperNo=${fileList.upperNo }&amp;fileTy=${fileList.fileTy }&amp;fileNo=${fileList.fileNo }">${fileList.orginlFileNm} (용량 : ${cmsFn:fileSize(fileList.fileSize)} , 다운로드 : ${fileList.dwldCo}회)</a><br />
									</c:forEach>
									</td>
								</tr>
								<tr>
									<th>언어</th>
									<td>${cntntsVO.langCodeNm}</td>
								</tr>
								<tr>
									<th>요약글</th>
									<td style="word-break:break-all">${cntntsVO.sumry}</td>
								</tr>
								<tr>
									<th>일정정보</th>
									<td>${cntntsVO.fxBgnde} ~ ${cntntsVO.fxEndde}</td>
								</tr>
								<tr>
									<th>위치정보</th>
									<td>${cntntsVO.adres}<br />(위도:${cntntsVO.adresLa}, 경도:${cntntsVO.adresLo})
									</td>
								</tr>
								<tr>
									<th>CCL/공공누리</th>
									<td>${cntntsVO.licNm}</td>
								</tr>
								<tr>
									<th>검색허용</th>
									<td>${atCode[cntntsVO.searchAt]}</td>
								</tr>
								<tr>
									<th>해시태그</th>
									<td>
										<c:forEach items="${fn:split(cntntsVO.tag, '|')}" var="hashTagValue">
											<a href="#">${hashTagValue}</a>&nbsp;&nbsp;
										</c:forEach>
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
						<a class="accordion-toggle" data-toggle="collapse" href="#collapseThree">
							<i class="fa fa-file-image-o"></i> 롤링 이미지
						</a>
					</h4>
				</div>
				<div id="collapseThree" class="accordion-body collapse">
					<div class="panel-body p-none">
						<table class="table m-none">
							<colgroup>
								<col style="width:100px"/>
								<col />
							</colgroup>
							<tbody>
								<tr>
									<th>이미지 사용</th>
									<td>${atCode[cntntsVO.relateImageAt]}</td>
								</tr>
								<tr>
								<td colspan="2">
									<div id="rolling_td" class="row mg-files" data-sort-destination data-sort-id="media-gallery">
									<c:forEach items="${cntntsVO.relateImageList}" var="relateList" varStatus="relate_status">
										<c:set var="id" value="${relateList.mediaNo}_${relateList.fileNo}" />
										<c:set var="fileInfo" value="${relateList.mediaVO.mediaFileList[0]}" />
										<div id="item_${id}" class="isotope-item document col-sm-6 col-md-6 col-lg-3" >
											<div class="thumbnail">
												<div class="thumb-preview">
													<img src="/comm/getImage?srvcId=${fileInfo.srvcId}&upperNo=${fileInfo.upperNo}&fileTy=${fileInfo.fileTy}&fileNo=${fileInfo.fileNo}&thumbTy=S"  style="width:100%;height:140px;" class="img-responsive" alt="">
													<div class="mg-thumb-options">
														<div class="mg-toolbar" style="height: 20px; padding-top: 2px">
															<div class="mg-group pull-left">
																<span id="desc_${id}">${relateList.reprsntAt eq 'Y' ? '<i class="fa fa-heart"></i> 대표이미지' : ''}</span>
															</div>
														</div>
													</div>
												</div>
											</div>
										</div>
									</c:forEach>
									</div>
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
						<a class="accordion-toggle" data-toggle="collapse" href="#collapseFour">
							<i class="fa fa-file-text"></i> 메타더이터 정보
						</a>
					</h4>
				</div>
				<div id="collapseFour" class="accordion-body collapse">
					<div class="panel-body p-none">
						<table class="table m-none">
							<colgroup>
								<col style="width:100px"/>
								<col />
							</colgroup>
							<tbody>
								<tr>
									<th>유형</th>
									<td>${cntntsVO.typeNm}
									</td>
								</tr>
								<tr>
									<th>정보원</th>
									<td>${cntntsVO.source}
									</td>
								</tr>
								<tr>
									<th>발행자</th>
									<td>${cntntsVO.publisher}
									</td>
								</tr>
								<tr>
									<th>기여자</th>
									<td>${cntntsVO.contributor}</td>
								</tr>
								<tr>
									<th>관련자료</th>
									<td>${cntntsVO.relationMap}
									</td>
								</tr>

							</tbody>
						</table>
					</div>
				</div>
			</div>
		</div>
		<footer class="panel-footer">
			<div class="row">
				<div class="col-sm-7">
					<c:set var="pageParam" value="useAt=${param.useAt }&amp;curPage=${param.curPage }&amp;srchWord=${param.srchWord}&amp;srchPblcateSttus=${param.srchPblcateSttus}&amp;srchSiteMenu=${param.srchSiteMenu}&amp;srchKey=${parm.srchKey}&amp;srchWord=${parm.srchWord}" />
					<a href="./list?${pageParam}" class="btn btn-default">목록</a>
				</div>
				<div class="col-sm-5 text-right">
					<c:if test="${cntntsVO.useAt eq 'Y'}">
					<cmsBtn2:btn btnTy="modify" path="${curPath}" mngrSession="${mngrSession }" modifyParam="?cntntsNo=${cntntsVO.cntntsNo}&amp;${pageParam}">수정</cmsBtn2:btn>
					<cmsBtn2:btn btnTy="use" path="${curPath}" mngrSession="${mngrSession }" script="f_useAtChg('N'); return false;" useAt="N" >사용안함</cmsBtn2:btn>
					</c:if>
					<c:if test="${cntntsVO.useAt eq 'N'}">
					<cmsBtn2:btn btnTy="use" path="${curPath}" mngrSession="${mngrSession }" script="f_useAtChg('Y'); return false;" useAt="Y" >사용</cmsBtn2:btn>					
					</c:if>
                 </div>
			</div>
		</footer>
		</div>
	</section>
	</div>

	<div class="col-sm-3">
	<section class="panel panel-featured panel-featured-primary">
		<header class="panel-heading">
			<h2 class="panel-title">메뉴 연결</h2>
		</header>
		<div class="panel-body">
			<table class="table table-hover mb-none">
				<c:if test="${empty siteMenuList }">
				<tr class="emptyTr">
					<td>연결된 메뉴가 없습니다.</td>
				</tr>
				</c:if>
				<c:forEach var="menuList" items="${siteMenuList}" varStatus="menuStatus">
				<tr>
					<td>
					<code><small>${menuList.siteNm}</small></code>
					<a href="#preview" onclick="f_preview(${menuList.menuNo});" class="mb-xs mt-xs mr-xs btn btn-xs btn-success" title="미리보기">
					<i class="fa fa-eye" style="vertical-align: text-bottom"></i><!--  미리보기 --></a>
					<br />
					${fn:replace(menuList.menuNmPath, '>Home', '홈')}
					</td>
				</tr>
				</c:forEach>
			</table>
		</div>
		<footer class="panel-footer">
		</footer>
	</section>
	</div>
	</div>
