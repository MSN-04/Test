<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ include file="/common/taglibs.jsp" %>
	<script type="text/javascript">
	//게시판 검색 팝업
	function f_openBoardWin(mth) {
		//게시판 설정값(boardSetting)을 위해서 bbsNo유지, nttNo 페이징 처리시 삭제 방지를 위해서 org_처리
		var url = "./winBbsNttMove?mth="+mth+"&bbsNo=${nttVO.bbsNo}&orgNttNo=${nttVO.nttNo}";
		var width = 500;
	    var height = 650;
		var top = (screen.availHeight - height) / 2;
	    var left = (screen.availWidth - width) / 2;
		var bbsWin = window.open(url, "", "width=" + width + ",height=" + height + ", scrollbars=yes, top=" + top + ", left=" + left);
		bbsWin.focus();
	}

	function f_delete() {
		if( confirm("<spring:message code='action.confirm.delete' />") ) {
			$("#crud").val("DELETE");
			document.frmNtt.action = "action";
			document.frmNtt.submit();
		}
	}
	</script>

		<!-- Start Breadcrumb -->
		<jsp:include page="/WEB-INF/jsp/admin/layout/breadcrumb.jsp">
			<jsp:param name="pageName" value="게시판 관리"/>
		</jsp:include>
		<!-- End Breadcrumb -->

		<!-- start: page -->
		<div class="row">
			<div class="col-md-12">
			<section class="panel panel-featured panel-featured-primary">
				<header class="panel-heading">
					<div class="panel-actions">

					</div>
					<h2 class="panel-title">[${bbsSettingVO.bbsSj}] 게시판 <small>상세 조회</small></h2>
					<p class="panel-subtitle">
					게시글 조회
					</p>
				</header>
				<div class="panel-body">
				<f:form modelAttribute="nttVO" method="post" name="frmNtt" id="frmNtt" enctype="multipart/form-data" cssClass="form-horizontal form-bordered mb-md">
				<f:hidden path="crud" />
				<f:hidden path="bbsNo" />
				<f:hidden path="nttNo" />

				<!-- Start Selectable Table Row -->
				<table class="table table-bordered mb-none">
					<colgroup>
						<col style="width:130px"/>
						<col />
					</colgroup>
					<tbody class="cn-wrapper">
						<tr>
							<th>게시글 설정</th>
							<td>
								<div class="control-group">
									<span class="checkbox-custom checkbox-text-primary checkbox-inline">
									<f:checkbox path="noticeAt" value="Y" label="공지글" disabled="true" cssClass="form-control"/></span>
									<span class="checkbox-custom checkbox-text-primary checkbox-inline">
									<f:checkbox path="resveAt" value="Y" label="예약글" disabled="true" cssClass="form-control" /></span>
									<c:if test="${nttVO.resveAt eq 'Y' }">(<c:out value="${nttVO.resveBeginDttm}"/> ~ <c:out value="${nttVO.resveEndDttm}"/>)</c:if>
								</div>
							</td>
						</tr>

						<c:if test="${bbsSettingVO.unityBbsUseAt eq 'Y'}">
						<tr>
							<th>사이트 게시 구분</th>
							<td>
								<c:choose>
									<c:when test="${nttVO.siteNtceNo == 0}">전체</c:when>
									<c:otherwise>${nttVO.siteNtceNm}</c:otherwise>
								</c:choose>
							</td>
						</tr>
						</c:if>

						<c:forEach var="viewObj" items="${nttVO.viewObject}" varStatus="status">
						<c:choose>

							<c:when test="${viewObj.key eq 'ctgryNm' }"><!-- 카테고리 -->
							<c:if test="${nttVO.ctgryNo > 0 and bbsSettingVO.ctgryUseAt == 'Y'}">
								<c:forEach var="viewDtl" items="${viewObj.value }">
								<tr>
									<th>${viewDtl.key }</th>
									<td>${viewDtl.value}</td>
								</tr>
								</c:forEach>
							</c:if>
							</c:when>

							<c:when test="${viewObj.key eq 'secretAt' }"><!-- 공개여부 -->
								<c:forEach var="viewDtl" items="${viewObj.value }">
								<tr>
									<th>${viewDtl.key }</th>
									<td>${secretTyCode[viewDtl.value]}</td>
								</tr>
								</c:forEach>
							</c:when>

							<c:when test="${viewObj.key eq 'confmAt' }"><!-- 승인여부 -->
								<c:forEach var="viewDtl" items="${viewObj.value }">
								<tr>
									<th>${viewDtl.key }</th>
									<td>${confmTyCode[viewDtl.value]}</td>
								</tr>
								</c:forEach>
							</c:when>

							<c:when test="${viewObj.key eq 'sttusTy' }"><!-- CCL여부 -->
								<c:forEach var="viewDtl" items="${viewObj.value }">
								<tr>
									<th>${viewDtl.key }</th>
									<td>${sttusTyCode[viewDtl.value]}</td>
								</tr>
								</c:forEach>
							</c:when>

							<c:when test="${viewObj.key eq 'nttDeptNm' }"><!-- 부서명 -->
							<c:if test="${bbsSettingVO.nttOrgUseAt eq 'Y' }">
								<c:forEach var="viewDtl" items="${viewObj.value}">
								<tr>
									<th>${viewDtl.key}</th>
									<td>${viewDtl.value}</td>
								</tr>
								</c:forEach>
							</c:if>
							</c:when>

							<c:when test="${viewObj.key eq 'telno' }"><!-- 전화번호 -->
							<c:if test="${bbsSettingVO.tellUseAt eq 'Y' }">
								<c:forEach var="viewDtl" items="${viewObj.value}">
								<tr>
									<th>${viewDtl.key}</th>
									<td>${viewDtl.value}</td>
								</tr>
								</c:forEach>
							</c:if>
							</c:when>

							<c:when test="${viewObj.key eq 'organCrdns' }"><!-- 담당기관 -->
							<c:if test="${bbsSettingVO.positionUseAt eq 'Y' }">
								<c:forEach var="viewDtl" items="${viewObj.value}">
								<tr>
									<th>${viewDtl.key} </th>
									<td>${viewDtl.value}</td>
								</tr>
								</c:forEach>
							</c:if>
							</c:when>

							<c:when test="${viewObj.key eq 'emailAdres' }"><!-- 이메일 -->
							<c:if test="${bbsSettingVO.emailUseAt eq 'Y' }">
								<c:forEach var="viewDtl" items="${viewObj.value}">
								<tr>
									<th>${viewDtl.key} </th>
									<td>${viewDtl.value}</td>
								</tr>
								</c:forEach>
							</c:if>
							</c:when>

							<c:otherwise>
								<c:forEach var="viewDtl" items="${viewObj.value}">
								<tr>
									<th>${viewDtl.key}</th>
									<td>${viewDtl.value}</td>
								</tr>
								</c:forEach>
							</c:otherwise>
						</c:choose>
						</c:forEach>

						<!-- 기타필드 -->
						<c:import url="/WEB-INF/jsp/admin/bbs/include/etc_view.jsp"/>

						<!-- 첨부파일 -->
						<c:if test="${not empty nttVO.qestnFileList}">
						<c:forEach var="qestnFileListObj" items="${nttVO.viewExcludeObject['qestnFileList']}">
						<tr>
							<th>${qestnFileListObj.key}</th>
							<td>
								<c:forEach var="qestnFileList" items="${nttVO.qestnFileList}" varStatus="status">
								<a href="/comm/getFile?srvcId=${qestnFileList.srvcId }&amp;upperNo=${qestnFileList.upperNo }&amp;fileTy=${qestnFileList.fileTy }&amp;fileNo=${qestnFileList.fileNo }">${qestnFileList.orginlFileNm} (용량 : ${cmsFn:fileSize(qestnFileList.fileSize)}, 다운로드 : ${qestnFileList.dwldCo}회)</a><br/>
								</c:forEach>
							</td>
						</tr>
						</c:forEach>
						</c:if>

					</tbody>
				</table>
				<!-- End Selectable Table Row -->
				</f:form>
				</div>
				<footer class="panel-footer">
					<div class="row">
					<c:if test="${nttVO.sttusTy eq '1'}">
						<div class="col-sm-7">
							<c:set var="pageParam" value="bbsNo=${param.bbsNo }&amp;curPage=${param.curPage }&amp;srchCtgry=${param.srchCtgry}&amp;srchKey=${param.srchKey}&amp;srchText=${param.srchText}" />
							<a href="./list?${pageParam}" class="btn btn-default">목록</a>
						</div>
						<div class="col-sm-5">
							<div class="btns">
								<a href="./form?bbsNo=${nttVO.bbsNo}&amp;nttNo=${nttVO.nttNo}" class="btn btn-primary">수정</a>
								<a href="#" onclick="f_delete(); return false;" class="btn btn-danger">삭제</a>
								<c:if test="${nttVO.noticeAt ne 'Y' }">
								<a href="./answer?bbsNo=${nttVO.bbsNo}&amp;nttNo=${nttVO.nttNo}" class="btn btn-primary">답변</a>
								</c:if>
							</div>
						</div>
					</c:if>
					</div>
				</footer>
			</section>

			<c:if test="${nttVO.sttusTy eq '2'}">
			<section class="panel panel-featured panel-featured-primary">
				<header class="panel-heading">
					<div class="panel-actions"></div>
					<h2 class="panel-title">답변내용</h2>
					<p class="panel-subtitle"></p>
				</header>
				<div class="panel-body">
					<div class="table-responsive">

					<!-- Start Selectable Table Row -->
						<table class="table table-bordered mb-none">
									<colgroup>
										<col style="width:130px"/>
										<col />
									</colgroup>
									<tbody class="cn-wrapper">
										<!-- 답변자 -->
										<c:forEach var="answrrObj" items="${nttVO.viewExcludeObject['answrr']}">
										<tr>
											<th>${answrrObj.key}</th>
											<td>${answrrObj.value}</td>
										</tr>
										</c:forEach>

										<!-- 답변일 -->
										<c:forEach var="answerDeObj" items="${nttVO.viewExcludeObject['answerDe']}">
										<tr>
											<th>${answerDeObj.key}</th>
											<td>${answerDeObj.value}</td>
										</tr>
										</c:forEach>

										<!-- 답변 내용 -->
										<c:forEach var="answerObj" items="${nttVO.viewExcludeObject['answer']}">
										<tr>
											<th>${answerObj.key}</th>
											<td><c:out value="${answerObj.value}" escapeXml="false" /></td>
										</tr>
										</c:forEach>

										<!-- 첨부파일(답변) -->
										<c:if test="${not empty nttVO.answerFileList}">
										<c:forEach var="answerFileListObj" items="${nttVO.viewExcludeObject['answerFileList']}">
										<tr>
											<th>${answerFileListObj.key}</th>
											<td>
												<c:forEach var="answerFileList" items="${nttVO.answerFileList}" varStatus="status">
												<a href="/comm/getFile?srvcId=${answerFileList.srvcId }&amp;upperNo=${answerFileList.upperNo }&amp;fileTy=${answerFileList.fileTy }&amp;fileNo=${answerFileList.fileNo }">${answerFileList.orginlFileNm} (용량 : ${cmsFn:fileSize(answerFileList.fileSize)}, 다운로드 : ${answerFileList.dwldCo}회)</a><br/>
												</c:forEach>
											</td>
										</tr>
										</c:forEach>
										</c:if>
									</tbody>
								</table>
						<!-- End Selectable Table Row -->

					</div>
				</div>
				<footer class="panel-footer">
					<div class="row">
						<div class="col-sm-7">
							<c:set var="pageParam" value="bbsNo=${param.bbsNo }&amp;curPage=${param.curPage }&amp;srchCtgry=${param.srchCtgry}&amp;srchKey=${param.srchKey}&amp;srchText=${param.srchText}" />
							<a href="./list?${pageParam}" class="btn btn-default">목록</a>
						</div>
						<div class="col-sm-5">
							<div class="btns">
								<a href="./form?bbsNo=${nttVO.bbsNo}&amp;nttNo=${nttVO.nttNo}" class="btn btn-primary">수정</a>
								<a href="#" onclick="f_delete(); return false;" class="btn btn-danger">비공개</a>
								<a href="./answer?bbsNo=${nttVO.bbsNo}&amp;nttNo=${nttVO.nttNo}" class="btn btn-primary">답변</a>
							</div>
						</div>
					</div>
				</footer>
			</section>
			</c:if>

			</div>

		</div>