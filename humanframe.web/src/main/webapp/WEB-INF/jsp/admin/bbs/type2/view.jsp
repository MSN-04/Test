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

	function f_delete(bbsNo) {
		if( confirm("<spring:message code='action.confirm.delete' />") ) {

			if(bbsNo == 360){
				$('#list-title-config').modal('show');
			}else{

				$("#crud").val("DELETE");
				document.frmNtt.action = "action";
				document.frmNtt.submit();
			}
		}
	}

	function f_delete_reson(){
		$("#crud").val("DELETE");
		$("#deleteReson").val($("#textCon").val());

		document.frmNtt.action = "action";
		document.frmNtt.submit();
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
				<input type="hidden" name="deleteReson" id="deleteReson" value="">

					<!-- Start Selectable Table Row -->
						<table class="table table-bordered mb-none">
									<colgroup>
										<col style="width:130px"/>
										<col />
									</colgroup>
									<tbody class="cn-wrapper">
										<c:if test="${nttVO.nttGroupCnt == 1}">
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

											<c:when test="${viewObj.key eq 'cclTy' }"><!-- CCL여부 -->
												<c:if test="${bbsSettingVO.cclAt eq 'Y'}">
												<c:forEach var="viewDtl" items="${viewObj.value }">
												<tr>
													<th>${viewDtl.key }</th>
													<td><c:if test="${not empty viewDtl.value}">${licCode[viewDtl.value-1].codeNm}</c:if></td>
												</tr>
												</c:forEach>
												</c:if>
											</c:when>

											<c:when test="${viewObj.key eq 'hashTag' }"><!-- 해시태그 -->
												<c:if test="${bbsSettingVO.hashTagAt eq 'Y'}">
												<c:forEach var="viewDtl" items="${viewObj.value }">
												<tr>
													<th>${viewDtl.key }</th>
													<td>
														<c:if test="${not empty viewDtl.value}">
															<c:forEach items="${fn:split(viewDtl.value, '|')}" var="hashTagValue">
																<a href="#">${hashTagValue}</a>&nbsp;&nbsp;
															</c:forEach>
														</c:if>
													</td>
												</tr>
												</c:forEach>
												</c:if>
											</c:when>

											<c:when test="${viewObj.key eq 'recomendCo' || viewObj.key eq 'oppsCo'}"><!-- 추천반대 -->
												<c:if test="${bbsSettingVO.recomendOppsAt eq 'Y'}">
												<c:forEach var="viewDtl" items="${viewObj.value }">
												<tr>
													<th>${viewDtl.key}</th>
													<td>${viewDtl.value}</td>
												</tr>
												</c:forEach>
												</c:if>
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
										<c:import url="/WEB-INF/jsp/admin/bbs/include/file_view.jsp"/>

										<c:if test="${bbsSettingVO.noticeTermYn eq 'Y'}">
										<tr>
											<th>게시기간</th>
											<td>${nttVO.beginDttm}&nbsp;~ ${nttVO.endDttm}</td>
										</tr>
										</c:if>

										<c:if test="${param.bbsNo eq '360'}">
												<!-- 시민게시판추가 -->
												<tr>
													<th>작성자 고유ID</th>
													<td>${nttVO.crtrUniqueId}</td>
												</tr>
												<tr>
													<th>작성자 ID/DUPINFO</th>
													<td>${nttVO.crtrId} <%-- / <cms:mberInfo mberId="${nttVO.crtrId}"/> --%></td>
												</tr>
										</c:if>
									</tbody>
								</table>
						<!-- End Selectable Table Row -->
					</f:form>
				</div>
				<footer class="panel-footer">
					<div class="row">
						<div class="col-sm-7">
							<cmsBtn:list admin="true" cssClass="btn btn-default">목록</cmsBtn:list>
						</div>
						<div class="col-sm-5">
							<div class="btns">
								<c:if test="${nttVO.noticeAt eq 'N'}">
								<a href="./form?bbsNo=${nttVO.bbsNo}&amp;nttGroup=${nttVO.nttGroup}&amp;nttOrdr=${nttVO.nttOrdr}&amp;nttLevel=${nttVO.nttLevel}" class="btn btn-warning">답글</a>
								</c:if>
                                <a href="./form?bbsNo=${nttVO.bbsNo}&amp;nttNo=${nttVO.nttNo}" class="btn btn-primary">수정</a>
								<a href="#" onclick="f_delete('${bbsSettingVO.bbsNo}'); return false;" class="btn btn-danger">비공개</a>
							</div>
						</div>
					</div>
				</footer>
			</section>
			</div>

		</div>


            <div class="modal fade" id="list-title-config" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" style="height:300px; width:400px; display: none;">
				<div class="modal-dialog">
					<div class="modal-content">
						<div class="modal-header">
							<button type="button" class="close" data-dismiss="modal" aria-hidden="true"></button>
							<h4 class="modal-title">삭제 사유 입력</h4>
						</div>
						<div class="modal-body" style="height:210px;">
							<table class="table" style="width:100%">
							<colgroup>
								<col />
							</colgroup>
							<tbody>
								<tr>
									<td class="control-label">
										<textarea id="textCon" style="width:95%;height:150px;"></textarea>
									</td>
								</tr>
								<tr>
									<td class="control-label">
										(300자 이하로 작성해 주시기 바랍니다.)
									</td>
								</tr>
							</tbody>
							</table>
						</div>
						<div class="modal-footer">
							<button type="button" class="btn btn-success" onclick="javascript:f_delete_reson();">저장</button>
						</div>
					</div>
					<!-- /.modal-content -->
				</div>
				<!-- /.modal-dialog -->
			</div>