<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<%@ page trimDirectiveWhitespaces="true"%>

	<script type="text/javascript">
	function f_excel(){
		$("#excelDown").submit();
	}

	function f_winEtcAnswer(qestnNo, qestimNo){
		var url = "./winEtcAnswer?qestnarNo=${qestnarVO.qestnarNo}&qestnNo="+qestnNo+"&qesitmNo="+qestimNo;
		var width = 670;
	    var height = 400;
		var top = (screen.availHeight - height) / 2;
	    var left = (screen.availWidth - width) / 2;
		var appWin = window.open(url, "", "width=" + width + ",height=" + height + ", scrollbars=yes, top=" + top + ", left=" + left);
		appWin.focus();
	}

	function f_winPrtcpnt(){
		var url = "/admin/func/mng/winPrtcpntList.do";
		var width = 500;
	    var height = 400;
		var top = (screen.availHeight - height) / 2;
	    var left = (screen.availWidth - width) / 2;
		var appWin = window.open(url, "", "width=" + width + ",height=" + height + ", scrollbars=yes, top=" + top + ", left=" + left);
		appWin.focus();
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
						<h2 class="panel-title">설문조사 결과 목록</h2>
						<p class="panel-subtitle">총 ${fn:length(listQestn)}건</p>
					</header>

					<div class="panel-body">

						<c:if test="${qestnarVO.crud eq 'UPDATE' }">
							<c:import url="/WEB-INF/jsp/admin/fnct/qestnar/include/qestnar_tab.jsp" >
								<c:param name="tabKind" value="result" />
							</c:import>
						</c:if>

						<div class="tab-content">
							<div class="form-group">
	                        </div>

	                        <div class="table-responsive">
								<table class="table table-bordered table-hover mb-none">
								<colgroup>
									<col style="width:15%" >
									<col style="width:35%" >
									<col style="width:15%" >
									<col style="width:35%" >
								</colgroup>
								<tbody>
									<tr>
										<th class="text-align-center">설문명</th>
										<td class="text-align-left" colspan="3">${qestnarVO.sj }</td>
									</tr>
									<tr>
										<th class="text-align-center">설문기간</th>
										<td>${qestnarVO.bgnDttm} ~ ${qestnarVO.endDttm}</td>
										<th class="text-align-center">상태</th>
										<td><c:choose>
											<c:when test="${ qestnarVO.progrsSttus eq 'ING' }">진행중</c:when>
											<c:when test="${ qestnarVO.progrsSttus eq 'END' }">종료</c:when>
											<c:when test="${ qestnarVO.progrsSttus eq 'YET' }">준비중</c:when>
											</c:choose>
										</td>
									</tr>
								</tbody>
								</table>
							</div>

							<div class="table-responsive">
								<table class="table table-bordered table-hover mb-none">
									<colgroup>
										<col />
										<col />
										<col style="width:130px" >
									</colgroup>
									<tbody>

									<c:set var="arColor" value="${ fn:split('success,info,warning,danger',',') }" />
									<c:set var="oldQestnNo" value="0"/>
									<c:set var="listNum" value="0"/>
									<c:set var="itemNum" value="0"/>

									<c:forEach var="qestn" items="${listQesitm}" varStatus="status">
										<c:if test="${ oldQestnNo ne qestn.qestnNo }">
										<c:set var="listNum" value="${listNum+1}"/>
										<c:set var="itemNum" value="0"/>
										<tr><th colspan="3" style="">[질문 ${listNum}] ${qestn.qestnText}</th></tr>
										</c:if>

										<!--  success info warning danger -->
										<tr>
											<td class="text-align-left">
												${qestn.qesitmText}
												<c:if test="${qestn.fileNo ne null }">
													<img style="width:64px; height:64px" class="media-object" src="/comm/getFile?srvcId=QESTNARTM&amp;upperNo=${qestn.qesitmNo }&amp;fileTy=${qestn.fileTy }&amp;fileNo=${qestn.fileNo }" alt="${qestn.orginlFileNm}"/>
												</c:if>
												<c:if test="${ qestn.qesitmText eq '주관식' || qestn.qesitmText eq '기타의견' || qestn.qesitmText eq 'Others (Please specify)' || qestn.qesitmText eq 'その他' || qestn.qesitmText eq '其它'  }">
												&nbsp;<button class="btn btn-xs btn-success" type="button" onclick="f_winEtcAnswer('${qestn.qestnNo}','${qestn.qesitmNo}');return false;">결과보기</button>
												</c:if>
											</td>
											<td>
												<div class="progress progress-striped" style="margin-bottom:0" >
												<div class="progress-bar" role="progressbar" aria-valuenow="${qestn.qesitmPercent}" aria-valuemin="0" aria-valuemax="100" style="width: ${qestn.qesitmPercent}%;">
												 ${qestn.qesitmPercent}%
												</div>
												</div>
											</td>
											<td>${qestn.resultCnt}명(${qestn.qesitmPercent}%)</td>
										</tr>

										<c:set var="oldQestnNo" value="${qestn.qestnNo}" />
										<c:set var="itemNum" value="${itemNum+1}"/>
									</c:forEach>

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
							<div class="col-md-5 text-right">
								<a href="#none" class="btn btn-primary" onclick="f_excel();return false;"><strong>결과 엑셀 받기</strong></a>
							</div>
							<form name="excelDown" id="excelDown" action="./resultExcel" method='post' enctype="application/octet-stream" target="popForm">
								<input type="hidden" name="qestnarNo" id="qestnarNo" value="${qestnarVO.qestnarNo}" />
							</form>
						</div>
					</footer>

				</section>
			</div>
		</div>
