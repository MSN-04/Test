<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/taglibs.jsp" %>
<%@ page trimDirectiveWhitespaces="true" %>

<div class="tabs">
	<!-- content -->
	<c:import url="../fnct/qestnar/inc/inc_tab.jsp" >
		<c:param name="srchSttus" value="${param.srchSttus }" />
	</c:import>
	<div class="tab-content">
		<div class="col-md-12">
			<div class="form-inline">
				<form id="searchFrm" name="searchFrm" method="post" action="${curUri}/list?srchSttus=${param.srchSttus }">
					<!-- <strong class="form-search">제목 검색</strong>
					<label for="srchWord" class="hidden">검색어 입력</label> -->
					<input type="text" class="form-control" placeholder="<spring:message code='button.search' />"
							id="srchWord" name="srchWord" style="float: left; margin-right: 5px; width: 200px;" value="<c:out value='${param.srchWord}'/>" />
					<button type="submit" class="btn btn-quaternary mr-xs mb-sm"><spring:message code='button.search' /></button>
				</form>
			</div>
		</div>

		<div class="col-md-12">
			<p class="boardListTxt">총 <b class="totalNum">${listVO.totalCount}</b>건 </p>
			<table class="table table-bordered table-striped mb-none">
				<%-- <caption><c:out value="${param.srchSttus == 'END'?'지난 설문조사':'설문조사'}" /> : 번호, 제목, 설문기간, 참여자수로 구성된 표</caption> --%>
				<colgroup>
					<col style="width:50px;">
					<col style="width:50%;">
					<col style="width:200px;">
					<col style="width:80px;">
				</colgroup>
				<thead>
					<tr>
						<th class="pc_Y ta_Y mo_N" scope="col">번호</th>
						<th class="pc_Y ta_Y mo_Y nowrap" scope="col">제목</th>
						<th class="pc_Y ta_Y mo_Y nowrap" scope="col">설문기간</th>
						<th class="pc_Y ta_Y mo_N" scope="col">참여자수</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${listVO.listObject}" var="list" varStatus="status">
					<tr>
						<td class="pc_Y ta_Y mo_N">${listVO.startNo - status.index}</td>
						<td class="title"><a href="${curUri}/view?qestnarNo=${list.qestnarNo}&amp;srchSttus=${param.srchSttus}">${list.sj}</a></td>
						<td>${fn:substring(list.bgnDttm,0,10)} ~ ${fn:substring(list.endDttm,0,10)}</td>
						<td>${list.resultCnt }</td>
					</tr>
					</c:forEach>
					<c:if test="${empty listVO.listObject}">
					<tr>
						<td colspan="4" style="height:50px; text-align:center; vertical-align:middle;"><spring:message code="data.value.noData"/></td>
					</tr>
					</c:if>
				</tbody>
			</table>
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
	</div>
</div>

	<!-- //content -->
