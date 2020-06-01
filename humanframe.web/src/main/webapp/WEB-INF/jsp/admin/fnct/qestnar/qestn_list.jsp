<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<%@ page trimDirectiveWhitespaces="true"%>

	<script type="text/javascript">
	var qestnarNo = "${qestnarVO.qestnarNo}";

	//질문 등록/수정 폼 열기
	function f_getQestn(qestnNo){
		if (qestnNo == '') {
			qestnNo = 0;
		}

		if( qestnarNo ){
			var gsWin = window.open('about:blank','popForm','width=700,height=600');
			$("#frm").attr({
				action:"./qestnForm",
				target:"popForm"
			});
			$("#qestnNo").val(qestnNo);
			$("#crud").val("");
			$("#frm").submit();
			gsWin.focus();
		}
	}

	//질문 삭제
	function f_delQestn(qestnNo){
		if( qestnNo ){
			if( confirm("<spring:message code='action.confirm.delete'/>") ){
				if( qestnarNo ){
					$("#frm").attr({
						action:"./qestnAction",
						target:""
					});
					$("#qestnNo").val(qestnNo);
					$("#crud").val("DELETE");
					$("#frm").submit();
				}
			}
		}
	}

	//질문 순서 변경
	function f_viewQestnSort(){
		if (qestnarNo != '' && qestnarNo > 0) {
			var gsWin = window.open('about:blank','popForm','width=500,height=300');
			$("#frm").attr({
				action:"./qestnSortForm",
				target:"popForm"
			});
			$("#qestnNo").val("");
			$("#crud").val("");
			$("#frm").submit();
			gsWin.focus();
		}
	}
	</script>

		<jsp:include page="/WEB-INF/jsp/admin/layout/breadcrumb.jsp">
			<jsp:param name="pageName" value="설문조사 관리"/>
		</jsp:include>
		<!-- End Breadcrumb -->

		<div class="row">
			<div class="col-md-12">
				<section class="panel panel-featured panel-featured-primary">
					<header class="panel-heading">
						<div class="panel-actions">
							<div class="btn-group">
							</div>
						</div>
						<h2 class="panel-title">설문조사 질문 목록</h2>
						<p class="panel-subtitle">총 ${fn:length(listQestn)}건</p>
					</header>

					<div class="panel-body">

						<c:if test="${qestnVO.crud eq 'CREATE' }">
							<c:import url="/WEB-INF/jsp/admin/fnct/qestnar/include/qestnar_tab.jsp" >
								<c:param name="tabKind" value="qestn" />
							</c:import>
						</c:if>

						<div class="tab-content">
							<div class="form-group">
								<span style="float:right;"><i class="fa fa-info-circle"></i> 준비중 상태일 때만 질문 수정이 가능합니다.</span>
	                        </div>

	                        <div class="table-responsive">
								<table class="table table-bordered table-hover mb-none">
									<colgroup>
										<col style="width:50px" />
										<col />
										<col style="width:150px" />
									</colgroup>
									<thead>
										<tr>
											<th class="text-center">번호</th>
											<th class="text-center">질문내용</th>
											<th class="text-center">관리</th>
										</tr>
									</thead>
									<tbody>
										<c:choose>
										<c:when test="${fn:length(listQestn) == 0 }">
											<tr>
												<td colspan="4" style="text-align: center;">등록된 질문이 없습니다.</td>
											</tr>
										</c:when>
										<c:otherwise>
											<c:forEach items="${listQestn}" var="list" varStatus="status">
											<tr>
												<td class="text-center">${status.count}</td>
												<td class="text-align-left">${list.qestnText}</td>
												<td class="text-center">
													<div class="btn-group-sm">
													<c:choose>
														<c:when test="${qestnarVO.progrsSttus eq 'YET'}">
															<a href="#none" onclick="f_getQestn('${list.qestnNo}');return false;" class="btn btn-small btn-primary">수정</a>
															<a href="#none" onclick="f_delQestn('${list.qestnNo}');return false;" class="btn btn-small btn-danger">삭제</a>
														</c:when>
														<c:otherwise>
															<a href="#none" onclick="f_getQestn('${list.qestnNo}');return false;" class="btn btn-small btn-primary">상세</a>
														</c:otherwise>
													</c:choose>
													</div>
												</td>
											</tr>
											</c:forEach>
										</c:otherwise>
									</c:choose>
									</tbody>
								</table>
							</div>
						</div>
					</div>
					<!--탭내용-->
					<footer class="panel-footer">
						<div class="row">
							<div class="col-sm-7">
								<a href="./list" class="btn btn-default">목록</a>
							</div>
							<c:if test="${qestnarVO.progrsSttus	eq 'YET' }" >
								<div class="col-md-5 text-right">
									<c:if test="${ fn:length(listQestn)>0 }">
									<a href="#none" class="btn btn-success" onclick="f_viewQestnSort();return false;" target="_blank"><strong>질문 순서 변경</strong></a>
									</c:if>
									<a href="#none" class="btn btn-primary" onclick="f_getQestn('');return false;" target="_blank"><strong>추가</strong></a>
								</div>
							</c:if>
						</div>
					</footer>
				</section>
			</div>
		</div>

	<form name="frm" id="frm" action="#" method="post" enctype="multipart/form-data">
		<input type="hidden" name="qestnarNo" id="qestnarNo" value="${qestnarVO.qestnarNo}" />
		<input type="hidden" name="qestnNo" id="qestnNo" value="" />
		<input type="hidden" name="crud" id="crud" value="" />
		<input type="hidden" name="progrsSttus" id="progrsSttus" value="${qestnarVO.progrsSttus}" />
	</form>