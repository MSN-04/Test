<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<%@ page trimDirectiveWhitespaces="true"%>

	<script type="text/javascript">
	function f_excel(){
		$("#excelDown").submit();
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



			<!-- Start Breadcrumb -->
			<jsp:include page="/WEB-INF/jsp/admin/layout/breadcrumb.jsp">
				<jsp:param name="pageName" value="설문조사"/>
			</jsp:include>
			<!-- End Breadcrumb -->

            <!-- start: page -->
			<div class="row">
				<div class="col-sm-12">

				<section class="panel panel-featured panel-featured-primary">
					<header class="panel-heading">
						<div class="panel-actions">

						</div>
						<h2 class="panel-title">설문조사 개인 결과보기</h2>
					</header>
					<div class="panel-body">

					<table class="table table-bordered mb-none">
						<colgroup>
							<col style="width:10%" >
							<col style="width:13%" >
							<col style="width:10%" >
							<col style="width:13%" >
							<col style="width:10%" >
							<col style="width:13%" >
						</colgroup>
						<tbody>
							<tr>
								<th class="text-align-center">이름</th>
								<td>${listQesitm[0].nm}</td>
								<th class="text-align-center">이메일</th>
								<td>${listQesitm[0].email}</td>
								<th class="text-align-center">전화번호</th>
								<td>${listQesitm[0].telno}</td>
							</tr>
							<tr>
								<th class="text-align-center">국가</th>
								<td>${empty listQesitm[0].countryKo ? listQesitm[0].country : listQesitm[0].countryKo}</td>
								<th class="text-align-center">국적</th>
								<td>${empty listQesitm[0].nationalityKo ? listQesitm[0].nationality : listQesitm[0].nationalityKo}</td>
								<th class="text-align-center">참여일</th>
								<td>${listQesitm[0].creatDttm}</td>
							</tr>
							<tr>
								<th class="text-align-center">주소</th>
								<td class="text-align-left" colspan="5">${listQesitm[0].address}</td>
							</tr>
							<tr>
								<th class="text-align-center">설문명</th>
								<td class="text-align-left" colspan="5">${qestnarVO.sj }</td>
							</tr>
							<tr>
								<th class="text-align-center">설문기간</th>
								<td colspan="2">${qestnarVO.bgnDttm} ~ ${qestnarVO.endDttm}</td>
								<th class="text-align-center">상태</th>
								<td colspan="2"><c:choose>
									<c:when test="${ qestnarVO.progrsSttus eq 'ING' }">진행중</c:when>
									<c:when test="${ qestnarVO.progrsSttus eq 'END' }">종료</c:when>
									<c:when test="${ qestnarVO.progrsSttus eq 'YET' }">준비중</c:when>
									</c:choose>
								</td>
							</tr>
						</tbody>
					</table>
					<br>
					<table class="table table-bordered mb-none">
						<colgroup>
							<col style="width:200" >
							<col />
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
							<tr><th colspan="3">[질문 ${listNum}] ${qestn.qestnText}</th></tr>
							</c:if>

							<!--  success info warning danger -->
							<tr>
								<td class="text-align-left">선택항목) ${qestn.qesitmText}
								<c:if test="${ qestn.qesitmText eq '주관식' || qestn.qesitmText eq '기타의견' || qestn.qesitmText eq 'Others (Please specify)' || qestn.qesitmText eq 'その他' || qestn.qesitmText eq '其它' }">
									&nbsp; &gt;&gt; &nbsp;${qestn.etcAnswer}
									</c:if>
								</td>
							</tr>

							<c:set var="oldQestnNo" value="${qestn.qestnNo}" />
							<c:set var="itemNum" value="${itemNum+1}"/>
						</c:forEach>
						</tbody>
					</table>
					</div>
					<footer class="panel-footer">
						<div class="row">
							<div class="col-sm-12">
								<c:set var="pageParam" value="qestnarNo=${qestnarVO.qestnarNo}&amp;curPage=${param.curPage }&amp;searchText=${param.searchText}" />
								<a href="./personal?${pageParam}" class="btn btn-default">목록</a>
							</div>
						</div>
					</footer>


				</section>
				</div>
			</div>
