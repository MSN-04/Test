<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/taglibs.jsp" %>
<%@ page trimDirectiveWhitespaces="true" %>

			<script>
			function f_useAtChg(at){
				$.ajax({
					type : "post",
					url: './useAtChg',
					data: 'inqryNo=${prjctInqryVO.inqryNo}&useAt='+at,
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
				<jsp:param name="pageName" value="프로젝트 문의"/>
			</jsp:include>
			<!-- End Breadcrumb -->

            <!-- start: page -->
			<div class="row">
				<div class="col-sm-12">
				<section class="panel panel-featured panel-featured-primary">
					<header class="panel-heading">
						<div class="panel-actions">

						</div>
						<h2 class="panel-title">프로젝트 문의 상세</h2>
					</header>
					<div class="panel-body">
						<div class="table-responsive">
							<table class="table table-bordered mb-none">
								<colgroup>
									<col style="width:120px"/>
									<col />
									<col style="width:120px"/>
									<col />
								</colgroup>
								<tbody>
									<tr>
										<th>제목<span class="required">*</span></th>
										<td colspan="3">${prjctInqryVO.sj}</td>
									</tr>
									<tr>
										<th>사이트</th>
										<td>${prjctInqryVO.siteNm}</td>
										<th>등록일</th>
										<td>${prjctInqryVO.creatDttm}</td>
									</tr>
									<tr>
										<th>회사명</th>
										<td>${prjctInqryVO.cmpnyNm}</td>
										<th>URL</th>
										<td>${prjctInqryVO.url}</td>
									</tr>
									<tr>
										<th>담당자</th>
										<td>${prjctInqryVO.chargerNm}</td>
										<th>담당부서</th>
										<td>${prjctInqryVO.chargerDept}</td>
									</tr>
									<tr>
										<th>E-mail<span class="required">*</span></th>
										<td>${prjctInqryVO.email}</td>
										<th>연락처</th>
										<td>${prjctInqryVO.tel}</td>
									</tr>
									<tr>
										<th>예산</th>
										<td>${bugetTy[prjctInqryVO.budget]}</td>
										<th>기타</th>
										<td>${prjctInqryVO.etc} 원</td>
									</tr>
									<tr>
										<th>파일첨부</th>
										<td colspan="3">
											<c:forEach var="fileList" items="${prjctInqryVO.fileList }" varStatus="status">
											<img src="/comm/getImage?thumbTy=S&amp;srvcId=${fileList.srvcId }&amp;upperNo=${fileList.upperNo }&amp;fileTy=${fileList.fileTy }&amp;fileNo=${fileList.fileNo }"><br />
											<a href="/comm/getFile?srvcId=${fileList.srvcId }&amp;upperNo=${fileList.upperNo }&amp;fileTy=${fileList.fileTy }&amp;fileNo=${fileList.fileNo }">${fileList.orginlFileNm} (용량 : ${cmsFn:fileSize(fileList.fileSize)} , 다운로드 : ${fileList.dwldCo}회)</a><br />
											</c:forEach>
										</td>
									</tr>
									<tr>
										<th>문의내용<span class="required">*</span></th>
										<td colspan="3">${prjctInqryVO.cn}</td>
									</tr>
								</tbody>
						</table>
						</div>
					</div>
				</section>


				<section class="panel panel-featured panel-featured-primary">
					<header class="panel-heading">
						<div class="panel-actions">

						</div>
						<h2 class="panel-title">프로젝트 문의 처리 상세</h2>
					</header>
					<div class="panel-body">
						<div class="table-responsive">
						<table class="table table-bordered mb-none">
								<colgroup>
									<col style="width:120px"/>
									<col />
									<col style="width:120px"/>
									<col />
								</colgroup>
								<tbody>
								<tr>
									<th>처리상태</th>
									<td>${statusCode[prjctInqryVO.processSttus]}</td>
									<th>처리일</th>
									<td>${prjctInqryVO.processDt}</td>
								</tr>
								<tr>
									<th>수정자</th>
									<td>${prjctInqryVO.updusrNm}<c:if test="${prjctInqryVO.updusrId ne null}">(${prjctInqryVO.updusrId})</c:if></td>
									<th>수정일</th>
									<td>${prjctInqryVO.updtDttm}</td>
								</tr>
								<tr>
									<th>처리내용</th>
									<td colspan="3">${prjctInqryVO.processCn}</td>
								</tr>
								</tbody>
						</table>
						</div>
					</div>
					<footer class="panel-footer">
						<div class="row">
							<div class="col-sm-6">
								<c:set var="pageParam" value="useAt=${param.useAt }&amp;curPage=${param.curPage }&amp;searchKey=${param.searchKey}&amp;searchText=${param.searchText}&amp;srchStatus=${param.srchStatus}" />
								<a href="./list?${pageParam}" class="btn btn-default">목록</a>
							</div>
							<div class="col-sm-6 text-right">
                                <cmsBtn2:btn btnTy="modify" path="${curPath}" mngrSession="${mngrSession }" modifyParam="?inqryNo=${prjctInqryVO.inqryNo}&amp;${pageParam}">수정</cmsBtn2:btn>
								<c:if test="${prjctInqryVO.useAt eq 'Y'}">
								<cmsBtn2:btn btnTy="use" path="${curPath}" mngrSession="${mngrSession }" script="f_useAtChg('N'); return false;" useAt="N" >사용안함</cmsBtn2:btn>
								</c:if>
								<c:if test="${prjctInqryVO.useAt eq 'N'}">
								<cmsBtn2:btn btnTy="use" path="${curPath}" mngrSession="${mngrSession }" script="f_useAtChg('Y'); return false;" useAt="Y" >사용</cmsBtn2:btn>
								</c:if>
							</div>
						</div>
					</footer>
				</section>


				</div>
			</div>