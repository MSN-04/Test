<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ include file="/common/taglibs.jsp" %>
<% pageContext.setAttribute("crcn", "\r\n");%>
<link rel="stylesheet" type="text/css" href="${themeAssets}/vendor/fullcalendar/jquery-ui.min.css">
<script src="${themeAssets}/vendor/jquery/jquery-ui-1.9.2.min.js"></script>
<script src="${themeAssets}/script/common_bbs.js"></script>
	<c:if test="${bbsSettingVO.bbsTy ne '5'}">
	<c:if test="${bbsSettingVO.recomendOppsAt eq 'Y'}">
	<script type="text/javascript">
		function updateRecomendOppsCo(updateMode) {
			$.ajax({
				url: '/ajax/bbs/updateRecomendOppsCo.json',
				type: 'POST',
				data: {
					  bbsTy : "${bbsSettingVO.bbsTy}"
					, bbsNo : "${bbsTypeVO.bbsNo}"
					, nttNo : "${bbsTypeVO.nttNo}"
					, updateMode : updateMode
				},
				success: function(data) {
					if(data.result == 'success') {
						$('#recomendCo').text(data.recomendCo);
						$('#oppsCo').text(data.oppsCo);
					}
				}
			});
		}
	</script>
	</c:if>
	<c:if test="${bbsSettingVO.hashTagAt eq 'Y'}">
	<script type="text/javascript">
	$(function() {
	    // var hashUrl = 'http://developers.yooncoms.com/comm/hashTagList?tag='; // 검색앤진 연동 url
	    var hashUrl = "${baseUri}/${curMenuVO.menuUri}?cntPerPage=10&srchCtgry=&srchKey=cn&srchText="; // 테스트 url
	    $(".sib-viw-type-basic-tag > a").click(function(){
	    	// window.open(hashUrl+encodeURIComponent(this.text), 'hashTagSearch', '');
	    	location.href=hashUrl+encodeURIComponent(this.text);
		});
	});
	</script>
	</c:if>
	<c:if test="${bbsSettingVO.reportAt eq 'Y'}">
	<script type="text/javascript">
		$(function() {
			$(".modal-reportTy").click(function(){
				if($(this).val() == "REPORT_3"){
					$("#modal-cn").attr("disabled", false);
				}else{
					$("#modal-cn").attr("disabled", true);
				}
			});
		});
		function getCenter(obj){
			var $layerPopupObj = obj;
			var left = ( $(window).scrollLeft() + ($(window).width() - $layerPopupObj.width()) / 2 );
			var top = ( $(window).scrollTop() + ($(window).height() - $layerPopupObj.height()) / 2 );
			$layerPopupObj.css({'left':left,'top':top, 'position':'absolute'});
			$('body').css('position','relative').append($layerPopupObj);
			obj.modal('show');
		}

		//신고 팝업
		function f_getReportList(bbs_no, ntt_no) {
			$("#modal_bbsNo").val(bbs_no);
			$("#modal_nttNo").val(ntt_no);
			$("#modal-cn").text("");
			getCenter($('#report_modal'));
			//$('#report_modal').modal('show');
		}

		//신고
		function f_saveReport(){
			var formData = $("#modal_report_form").serialize();
			$.ajax({
				type : "post",
				url: '/ajax/bbs/bbsReportAjaxAction.json',
				data:formData,
				dataType: 'json', //전송받을 데이터의 타입
				contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
				success: function(data) {
					if(data.result == "success"){
						alert("정상적으로 신고 되었습니다.");
					}else{
						alert("이미 신고 되었습니다.");
					}
					$('.close').trigger('click');
				},
				error: function(data, status, err) {
					console.log('error forward : ' + data);
				}
			});
		}
	</script>
	<!-- 신고 시작 -->
	<div class="modal fade" id="report_modal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" style="height:600px; width:500px; display: none;">
		<div class="modal-dialog" style="width: 500px;">
			<div class="modal-content">
				<div class="modal-header"><button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
					<h4 class="modal-title">신고</h4>
				</div>
				<div class="modal-body" id="listReportArea">
					<form method="post" name="modal_report_form" id="modal_report_form" action="#" class="form-horizontal form-bordered mb-md">
					<input type="hidden" name="bbsNo" id="modal_bbsNo" />
					<input type="hidden" name="nttNo" id="modal_nttNo" />
					<input type="hidden" name="cmNo" id="modal_cmNo" value="0"/>
					<fieldset>
						<legend></legend>
						<dl class="sib-popup-survey-holder-content-items">
							<dt></dt>
							<c:forEach var="viewObj" items="${reportCodeList}" varStatus="status">
							<dd>
								<label for="sib-popup-survey-holder-content-items${status.index }">
									<input type="radio" name="reportTy" class="modal-reportTy" value="${viewObj.codeId}" id="sib-popup-survey-holder-content-items${status.index }" /> ${viewObj.codeNm}
								</label>
							</dd>
							</c:forEach>
							<dd>
									<textarea name="cn" id="modal-cn" rows="1" cols="" disabled="disabled" maxlength="500" class="form-control"> 1</textarea>
							</dd>
						</dl>
					</fieldset>
				</form>
					<!-- //survey -->
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-success" onclick="javascript:f_saveReport();">선택</button>
				</div>
			</div>
			<!-- /.modal-content -->
		</div>
		<!-- /.modal-dialog -->
	</div>
	<!-- 신고 끝 -->
	</c:if>
	
	<c:if test="${not empty bbsSkinVO.description}">
	${bbsSkinVO.description}
	</c:if>
	
	<div class="panel-body">
		<form class="form-horizontal form-bordered" method="post">
			<div class="featured-box featured-box-primary align-left mt-xlg">
				<div class="box-content shop">
					<h4 class="heading-primary text-uppercase mb-md"><spring:message code='ui.details' /></h4>
					<table class="cart-totals" style="width: 100%;">
						<colgroup>
							<col style="width:200px" />
							<col  />
						</colgroup>
						<tbody>

						<jsp:include page="include/view_dspy_ty${bbsSettingVO.bbsTy}.jsp" />

						<%-- 기타필드 --%>
						<c:if test="${bbsSettingVO.etcIemAt eq 'Y'}">
							<c:forEach items="${boardEtcDataList}" var="list" varStatus="status">
							<c:if test="${list.useAt eq 'Y'}">
							<tr>
								<th>${list.etcIemNm}</th>
								<td><c:out value="${fn:replace(list.etcInputIem, crcn, '<br />')}" escapeXml="false"/></td>
							</tr>
							</c:if>
							</c:forEach>
						</c:if>

						<%-- 첨부파일 --%>
						<c:if test="${bbsSettingVO.atchmnflAt eq 'Y' and fn:length(bbsTypeVO.bbsFileList) > 0}">
						<c:forEach var="viewExcludeObj" items="${bbsTypeVO.viewExcludeObject['bbsFileList']}">
						<tr>
							<th>${viewExcludeObj.key}</th>
							<td>
								<c:forEach var="bbsFileList" items="${bbsTypeVO.bbsFileList}" varStatus="status">
									<a href="/comm/getFile?srvcId=${bbsFileList.srvcId }&amp;upperNo=${bbsFileList.upperNo }&amp;fileTy=${bbsFileList.fileTy }&amp;fileNo=${bbsFileList.fileNo }">
										${bbsFileList.orginlFileNm} (<spring:message code='board.file.size' />: ${cmsFn:fileSize(bbsFileList.fileSize)}, <spring:message code='button.download' /> : ${bbsFileList.dwldCo}<spring:message code='ui.count' />)
									</a><br/>
								</c:forEach>
							</td>
						</c:forEach>
						</c:if>
						</tbody>
					</table>
				</div>
			</div>
		</form>

		<!-- 댓글 -->
		<c:if test="${bbsSettingVO.cmUseAt eq 'Y'}">
			<div class="featured-box featured-box-primary align-left mt-xlg">
				<div class="box-content shop">
					<jsp:include page="../common/cm.jsp">
						<jsp:param name="mapngAt" value="bbs" />
					</jsp:include>
				</div>
			</div>
		</c:if>

		<%-- 추천반대 버튼 --%>
		<c:if test="${bbsSettingVO.recomendOppsAt eq 'Y'}">
		<div class="row">
			<div class="col-md-12" style="float: right; text-align: right; margin-top: 10px;">
				<a onclick="updateRecomendOppsCo('recomend');" class="btn btn-primary mb-sm" title="<spring:message code='button.recomend' />"><spring:message code='button.recomend' />(<span id="recomendCo">${bbsTypeVO.recomendCo}</span>)</a>
				<a onclick="updateRecomendOppsCo('opps');" class="btn btn-primary mb-sm" title="<spring:message code='button.opps' />"><spring:message code='button.opps' />(<span id="oppsCo">${bbsTypeVO.oppsCo}</span>)</a>
			</div>
		</div>
		</c:if>

		<!-- 신고 버튼 -->
		<c:if test="${bbsSettingVO.reportAt eq 'Y'}">
			<div class="sib-set-button-left">
				<a href="#javascript:;" onclick="f_getReportList('${bbsSettingVO.bbsNo}' , '${bbsTypeVO.nttNo}');" class="btn btn-warning mr-xs mb-sm">
					<span class="fa fa-exclamation-triangle"></span>
					신고
				</a>
			</div>
		</c:if>
	</div>
	</c:if>

	<c:if test="${bbsSettingVO.bbsTy eq '5'}">
		<jsp:include page="include/view_dspy_ty${bbsSettingVO.bbsTy}.jsp" />
	</c:if>

	<!-- 관련글 시작 -->
	<c:if test="${not empty nearNttMap }">
	<jsp:include page="include/bbs_relative_view.jsp"/>
	</c:if>
	<!-- 관련글 끝 -->

	<!-- 이전글, 다음글 -->
	<c:if test="${bbsSettingVO.brftrNttAt eq 'Y' && not empty prevNextList}">
	<div class="panel-body">
		<div class="featured-box featured-box-primary align-left mt-xlg">
			<div class="box-content shop">
				<table class="cart-totals" style="width: 100%;">
					<c:forEach items="${prevNextList}" var="prevNext" varStatus="status">
					<tr>
						<td <c:if test="${prevNext.flag eq 'prev'}">style="border-top: 0px;"</c:if>>
							<c:choose>
								<c:when test="${prevNext.flag eq 'next'}"><spring:message code='board.data.next' /></c:when>
								<c:when test="${prevNext.flag eq 'prev'}"><spring:message code='board.data.prev' /></c:when>
							</c:choose>
							:
							<c:choose>
								<c:when test="${empty prevNext.sj}"><spring:message code='data.value.noData' /></c:when>
								<c:when test="${not empty prevNext.sj}">
									<a href="./${prevNext.nttNo}">
									<c:if test="${prevNext.noticeAt eq 'Y'}"><img src="${themeAssets}/img/icon/icon_notice.gif" alt="<spring:message code='board.notice' />" style="margin-right: 5px;"/></c:if>
									${prevNext.sj}
									</a>
								</c:when>
							</c:choose>
						</td>
					</tr>
					</c:forEach>
				</table>
			</div>
		</div>
	</div>
	</c:if>

	<%-- 버튼 --%>
	<div class="col-md-6" style="float: right; text-align: right;">
		<p>
			<!-- 수정버튼 -->
			<cmsBtn:update bbsSettingVO="${bbsSettingVO}" bbsTypeVO="${bbsTypeVO}" javascriptCode="f_showPasswordDialog" cssClass="btn btn-primary mr-xs mb-sm"><spring:message code='button.update' /></cmsBtn:update>
			<!-- 삭제버튼 -->
			<cmsBtn:delete bbsSettingVO="${bbsSettingVO}" bbsTypeVO="${bbsTypeVO}" javascriptCode="f_showPasswordDialog" cssClass="btn btn-danger mr-xs mb-sm"><spring:message code='button.delete' /></cmsBtn:delete>

			<c:if test="${bbsSettingVO.bbsTy eq '2' and bbsTypeVO.noticeAt eq 'N'}">
			<a href="${baseUri}/${curMenuVO.menuUri}/form?bbsNo=${bbsTypeVO.bbsNo}&amp;nttGroup=${bbsTypeVO.nttGroup}&amp;nttOrdr=${bbsTypeVO.nttOrdr}&amp;nttLevel=${bbsTypeVO.nttLevel}"
				class="btn btn-tertiary mr-xs mb-sm"
				title="<spring:message code='board.reply' />">
				<spring:message code='board.reply' />
			</a>
		</c:if>
			<a href="${baseUri}/${curMenuVO.menuUri}" class="btn btn-default mr-xs mb-sm" title="<spring:message code='button.list' />"><spring:message code='button.list' /></a>
			<a href="#" class="btn btn-default mr-xs mb-sm" onclick="f_ClipUrl('http://${curSiteVO.siteUrl}/${currUri}');" title="<spring:message code='button.list' />"><spring:message code='button.copy' /></a>
		</p>
	</div>

	<!-- 비밀번호 입력 레이어  -->
	<div id="inputPassword" style="display: none;">
		<form id="bbsPasswordChkFrm" method="post">
			<div>
				<input type="hidden" name="actionTy" id="actionTy" value=""/>
				<input type="hidden" name="bbsNo" id="bbsNo" value=""/>
				<input type="hidden" name="nttNo" id="nttNo" value=""/>
				<input type="password" name="password" id="password" autocomplete="off" placeholder="<spring:message code='board.password' />" title="<spring:message code='board.password' />" class="form-control" onkeypress="javascript:if(event.keyCode==13){f_bbsPasswordChk();return false;}"/>
				<a class="btn btn-default mr-xs mb-sm" title="<spring:message code='button.confirm' />" onclick="f_bbsPasswordChk(); return false;"><spring:message code='button.confirm' /></a>
			</div>
		</form>
	</div>