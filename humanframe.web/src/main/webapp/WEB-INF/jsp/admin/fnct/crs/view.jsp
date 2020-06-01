<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/taglibs.jsp" %>
<%@ page trimDirectiveWhitespaces="true" %>
<% pageContext.setAttribute("LF", "\n"); %>
	<c:set var="pageParam" value="useAt=${param.useAt }&amp;curPage=${param.curPage }&amp;srchText=${param.srchText}&amp;srchKey=${param.srchKey}&amp;srchPart=${param.srchPart}&amp;srchStatus=${param.srchStatus}&amp;srchStartDt=${param.srchStartDt}&amp;srchEndDt=${param.srchEndDt}" />
		<script>
		function f_useAtChg(at){
			$.ajax({
				type : "post",
				url: './useAtChg',
				data: 'crsNo=${crsVO.crsNo}&useAt='+at,
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
				<jsp:param name="pageName" value="CSR 게시판"/>
			</jsp:include>
			<!-- End Breadcrumb -->

            <!-- start: page -->
			<div class="row">
				<section class="panel panel-featured panel-featured-primary">
					<header class="panel-heading">
						<div class="panel-actions">
							<a href="#" class="panel-action panel-action-toggle" data-panel-toggle></a>
						</div>
						<h2 class="panel-title">CSR 등록/수정</h2>
					</header>
					<div class="panel-body">
						<table class="table table-bordered mb-none">
							<colgroup>
								<col style="width:150px" />
								<col />
							</colgroup>
							<tbody>
								<tr>
									<th>제목 <span class="required">*</span></th>
									<td>${crsVO.sj}</td>
								</tr>
								<tr>
									<th>요청 URL <span class="required">*</span></th>
									<td>
										<c:choose>
											<c:when test="${not empty crsVO.linkUrl}">
												<c:set var="requesturl" value="${fn:split(fn:replace(crsVO.linkUrl, LF, '|'),'|')}" />
												<c:forEach var="url" items="${requesturl}" varStatus="status">
													<c:out value="${status.count}"/>. <c:out value="${url}" escapeXml="false"/>
													<a href="${url}" target="_blank" title="새창열기"><i class="icon iconfa-link"></i></a>
													<br>
												</c:forEach>
											</c:when>
											<c:otherwise>
												<strong>※ 요청 URL이 없습니다.</strong>
											</c:otherwise>
										</c:choose>
									</td>
								</tr>
								<tr>
									<th>파트 <span class="required">*</span></th>
									<td>${crsPartCode[crsVO.part]}</td>
								</tr>
								<tr>
									<th>첨부파일 <span class="required">*</span></th>
									<td>
										<c:forEach var="fileList" items="${crsVO.crsFileList}" varStatus="status">
											<span class="help-block" id="attachFileViewSpan${status.index+1}">
												<a href="/comm/getFile?srvcId=${fileList.srvcId }&amp;upperNo=${fileList.upperNo }&amp;fileTy=${fileList.fileTy }&amp;fileNo=${fileList.fileNo }">${fileList.orginlFileNm} (용량 : ${cmsFn:fileSize(fileList.fileSize)}, 다운로드 : ${fileList.dwldCo}회)</a>
											</span>
										</c:forEach>
									</td>
								</tr>
								<tr>
									<th>요청사항 <span class="required">*</span></th>
									<td>${crsVO.cn}</td>
								</tr>
								<tr>
									<th>작성일시</th>
									<td><fmt:formatDate pattern="yyyy-MM-dd hh:mm:ss" value="${crsVO.creatDttm}" /></td>
								</tr>
								<tr>
									<th>작성자</th>
									<td>
										${fn:replace(crsVO.allDeptNm, ' ' , '>')}&nbsp;${crsVO.crtrNm }
										<c:if test="${ not empty crsVO.telno}"> (${crsVO.telno })</c:if>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
					<footer class="panel-footer">
						<div class="row">
							<div class="col-sm-6">
								<a href="./list?${pageParam}" class="btn btn-default">목록</a>
							</div>
							<div class="col-sm-6 text-right">
								<a href="./form?crsNo=${crsVO.crsNo}&${pageParam}" class="btn btn-primary">수정</a>
								<a href="./answerForm?crsNo=${crsVO.crsNo}&${pageParam}" class="btn btn-success">답변</a>
								<c:if test="${crsVO.useAt eq 'Y'}">
								<a href="#f_useAtChg" onclick="f_useAtChg('N'); return false" class="btn btn-danger">사용안함</a>
								</c:if>
								<c:if test="${crsVO.useAt eq 'N'}">
								<a href="#f_useAtChg" onclick="f_useAtChg('Y'); return false;" class="btn btn-warning">사용</a>
								</c:if>
							</div>
						</div>
					</footer>
				</section>

				<c:if test="${crsVO.chargerUniqueId ne ''}">
				<section class="panel panel-featured panel-featured-primary">
					<header class="panel-heading">
						<div class="panel-actions">
							<a href="#" class="panel-action panel-action-toggle" data-panel-toggle></a>
						</div>
						<h2 class="panel-title">처리담당자 및 처리내용</h2>
					</header>
					<div class="panel-body">
						<div class="table-responsive">
							<table class="table table-bordered mb-none">
								<colgroup>
									<col style="width:150px" />
									<col />
									<col style="width:150px" />
									<col />
								</colgroup>
								<tbody>
									<tr>
										<th>처리담당자지정 <span class="required">*</span></th>
										<td colspan="3">
											<c:if test="${crsVO.progrsSttus eq '1'}">
											<div style="text-align: center !important;">
												<strong>※ 처리담당자가 지정되지 않았습니다.</strong>
											</div>
											</c:if>
											<%-- ${crsVO.chargerUniqueId} --%>
											<!-- 임시처리  -->
											<c:if test="${crsVO.chargerUniqueId eq 'TMPINFO_000000000001' }">윤커뮤니케이션즈</c:if>
											<c:if test="${crsVO.chargerUniqueId eq 'TMPINFO_000000000002' }">ETC</c:if>
										</td>
									</tr>
									<tr>
										<th>추가 처리담당자지정 <span class="required">*</span></th>
										<td colspan="3">
											<%-- ${crsVO.aditChargerUniqueId} --%>
											<!-- 임시처리  -->
											<c:if test="${crsVO.aditChargerUniqueId eq 'TMPINFO_000000000001' }">윤커뮤니케이션즈</c:if>
											<c:if test="${crsVO.aditChargerUniqueId eq 'TMPINFO_000000000002' }">ETC</c:if>
										</td>
									</tr>
									<tr>
										<th>진행상태 <span class="required">*</span></th>
										<td>
											${crsStatusCode[crsVO.progrsSttus]}
										</td>
										<th>처리일자 <span class="required">*</span></th>
										<td>
											${crsVO.processDt}
										</td>
									</tr>
									<tr>
										<th>첨부파일 <span class="required">*</span></th>
										<td colspan="3">
											<c:forEach var="fileList" items="${crsVO.crsFileList1}" varStatus="status">
												<span class="help-block" id="attachFileViewSpan${status.index+1}">
													<a href="/comm/getFile?srvcId=${fileList.srvcId }&amp;upperNo=${fileList.upperNo }&amp;fileTy=${fileList.fileTy }&amp;fileNo=${fileList.fileNo }">${fileList.orginlFileNm} (용량 : ${cmsFn:fileSize(fileList.fileSize)}, 다운로드 : ${fileList.dwldCo}회)</a>
												</span>
											</c:forEach>
										</td>
									</tr>
									<tr>
										<th>처리내용 <span class="required">*</span></th>
										<td colspan="3">
											${crsVO.processCn}
										</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					<footer class="panel-footer">
						<div class="row">
							<div class="col-sm-12 text-right">
							<a href="./answerForm?crsNo=${crsVO.crsNo}&${pageParam}" class="btn btn-primary">수정</a>
							</div>
						</div>
					</footer>
				</section>
				</c:if>
				<c:if test="${crsVO.progrsSttus eq '1'}">
				<div class="col-sm-12 text-center">
					<strong>※ 처리담당자가 지정되지 않았습니다.</strong>
				</div>
				</c:if>

			</div>