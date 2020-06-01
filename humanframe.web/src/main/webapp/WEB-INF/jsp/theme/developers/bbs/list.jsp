<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ include file="/common/taglibs.jsp" %>
<link rel="stylesheet" type="text/css" href="${themeAssets}/vendor/fullcalendar/jquery-ui.min.css">
<script src="${themeAssets}/vendor/jquery/jquery-ui-1.9.2.min.js"></script>
<script src="${themeAssets}/script/common_bbs.js"></script>
<script type="text/javascript">
	$(function() {
		$("#cntPerPage").on("change", function() {
			$("#searchFrm").submit();
		});
	});
	
	function page_href() {
		if(confirm("인증을 통해서만 글등록이 가능합니다\n로그인 또는 인증페이지로 이동하시겠습니까?")){
			location.href = "/member/login";
		}
	}
</script>
	<!-- content -->
	<c:if test="${not empty bbsSettingVO.bbsInfo}">
	${bbsSettingVO.bbsInfo}
	</c:if>
	
	<c:if test="${not empty bbsSkinVO.description}">
	${bbsSkinVO.description}
	</c:if>
	
	<c:if test="${bbsSettingVO.bbsTy ne '7'}">
	<div class="row">
		<div class="col-md-12">
			<form id="searchFrm" name="searchFrm" class="form-search" method="post" action="${currUri}">
			<select id="cntPerPage" name="cntPerPage" class="form-control mb-md" style="float: left; width: 70px; margin-right: 5px;">
				<c:choose>
					<c:when test="${bbsSettingVO.bbsTy eq '3' or bbsSettingVO.bbsTy eq '4'}">
						<c:forEach begin="6" end="30" step="6" var="value">
							<option value="${value}" <c:if test="${param.cntPerPage eq value || (empty param.cntPerPage && bbsSettingVO.nttListOutptCo eq value)}">selected="selected"</c:if>>${value}</option>
						</c:forEach>
					</c:when>
					<c:otherwise>
						<c:forEach begin="10" end="50" step="10" var="value">
							<option value="${value}" <c:if test="${param.cntPerPage eq value || (empty param.cntPerPage && bbsSettingVO.nttListOutptCo eq value)}">selected="selected"</c:if>>${value}</option>
						</c:forEach>
					</c:otherwise>
				</c:choose>
	        </select>
			<c:if test="${bbsSettingVO.ctgryUseAt eq 'Y'}">
				<select id="srchCtgry" name="srchCtgry" class="form-control mb-md" style="float: left; width: 200px; margin-right: 5px;">
					<option value="">카테고리 전체</option>
					<c:forEach items="${bbsSettingVO.ctgryList}" var="ctgry">
					<option value="${ctgry.ctgryNo}" <c:if test="${ctgry.ctgryNo == param.srchCtgry }">selected</c:if>>${ctgry.ctgryNm}</option>
					</c:forEach>
				</select>
			</c:if>
			<select id="srchKey" name="srchKey" class="form-control mb-md" style="float: left; width: 100px; margin-right: 5px;">
				<option value="sj" <c:if test="${param.srchKey eq 'sj' || param.srchKey eq ''}">selected="selected"</c:if>><spring:message code='board.subject' /></option>
				<option value="cn" <c:if test="${param.srchKey eq 'cn'}">selected="selected"</c:if>><spring:message code='board.contents' /></option>
				<option value="wrter" <c:if test="${param.srchKey eq 'wrter'}">selected="selected"</c:if>><spring:message code='board.creat.name' /></option>
			</select>
			<input type="text" name="srchText" id="srchText"
				placeholder="<spring:message code='button.search' />"
				class="form-control"
				style="float: left; margin-right: 5px; width: 200px;"
				value="<c:out value='${param.srchText}'/>" />
			<button type="submit" class="btn btn-quaternary mr-xs mb-sm"><spring:message code='button.search' /></button>
			</form>
		</div>

		<div class="col-md-12">
			<jsp:include page="include/list_dspy_ty${bbsSettingVO.bbsTy}.jsp" />
		</div>
	</div>

	<%-- 버튼 --%>
	<div class="row">
		<div class="col-md-12" style="float: right; text-align: right; margin-top: 10px;">
			<cmsBtn:insert bbsSettingVO="${bbsSettingVO}" cssClass="btn btn-primary mb-sm" admin="false" javascriptCode="page_href();"><spring:message code='button.write' /></cmsBtn:insert>
			<c:if test="${bbsSettingVO.rssAt eq 'Y'}">
			<a href="${currUri}.rss" class="btn btn-primary mb-sm" title="<spring:message code='button.rss' />" target="_blank"><spring:message code='button.rss' /></a>
			</c:if>
		</div>
	</div>

	<!-- paging -->
	<div class="row">
		<div class="col-md-12">
			<cms:paging listVO="${listVO}"
				firstIcon="<i class='fa fa-angle-double-left'></i>"
				prevIcon="<i class='fa fa-angle-left'></i>"
				nextIcon="<i class='fa fa-angle-right'></i>"
				lastIcon="<i class='fa fa-angle-double-right'></i>"
				cssClass="pagination pull-right"/>
		</div>
	</div>
	<!-- //paging -->
	</c:if>

	<c:if test="${bbsSettingVO.bbsTy eq '7'}">
	<div class="col-md-12">
		<jsp:include page="include/list_dspy_ty${bbsSettingVO.bbsTy}.jsp" />
	</div>
	</c:if>

	<!-- 비밀번호 입력 레이어  -->
	<div id="inputPassword" style="display: none;">
		<form id="bbsPasswordChkFrm" method="post">
			<div>
				<input type="hidden" name="bbsNo" id="bbsNo" value=""/>
				<input type="hidden" name="nttNo" id="nttNo" value=""/>
				<input type="password" name="password" id="password" autocomplete="off" placeholder="<spring:message code='board.password'/>" title="<spring:message code='board.password' />" class="form-control" onkeypress="javascript:if(event.keyCode==13){f_bbsPasswordChk();return false;}"/>
				<a class="btn btn-default mr-xs mb-sm" title="<spring:message code='button.confirm' />" onclick="f_bbsPasswordChk(); return false;"><spring:message code='button.confirm' /></a>
			</div>
		</form>
	</div>