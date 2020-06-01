<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/taglibs.jsp" %>
<%@ page trimDirectiveWhitespaces="true" %>
	<!-- content -->
	<div class="row">
		<div class="col-md-12">
			<form id="searchFrm" name="searchFrm" class="form-search" method="post" action="${baseUri}/${curMenuVO.menuUri}">
			<select id="srchKey" name="srchKey" class="form-control mb-md" style="float: left; width: 100px; margin-right: 5px;">
				<option value="sj" <c:if test="${param.srchKey eq 'sj' || param.srchKey eq ''}">selected="selected"</c:if>>제목</option>
				<option value="wrter" <c:if test="${param.srchKey eq 'wrter'}">selected="selected"</c:if>>작성자</option>
			</select>
			<input type="text" name="srchText" id="srchText"
				placeholder="<spring:message code='button.search' />"
				class="form-control"
				style="float: left; margin-right: 5px; width: 200px;"
				value="<c:out value='${param.srchText}'/>" />
			<button type="submit" class="btn btn-quaternary mr-xs mb-sm">검색</button>
			</form>
		</div>

		<div class="col-md-12">
			<table class="table table-bordered table-striped mb-none" id="datatable-default">
				<colgroup>
					<col style="width:60px;" />
					<col />
					<col style="width:100px;" />
				</colgroup>
				<thead>
					<tr>
						<th>순번</th>
						<th>제목</th>
						<th>등록일</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${listVO.listObject}" var="resultList" varStatus="status">
					<c:set var="pageParam" value="sampleNo=${resultList.sampleNo}&amp;curPage=${listVO.curPage}${!empty(listVO.urlParam)? '&amp;' : ''}${listVO.urlParam}" />
					<tr>
						<td>${listVO.startNo - status.index }</td>
						<td><a href="${baseUri}/${curMenuVO.menuUri}/view?${pageParam}">${resultList.sj }</a></td>
						<td>
							<fmt:formatDate pattern="yyyy.MM.dd" value="${resultList.creatDttm}" />
						</td>
					</tr>
					</c:forEach>
					<c:if test="${empty listVO.listObject}">
					<tr>
						<td colspan="4" style="height:50px; text-align:center; vertical-align:middle;">등록된 데이터가 없습니다.</td>
					</tr>
					</c:if>
				</tbody>
			</table>
		</div>
	</div>

	<%-- 버튼 --%>
	<div class="row">
		<div class="col-md-12" style="float: right; text-align: right; margin-top: 10px;">
			<a href="${baseUri}/${curMenuVO.menuUri}/form" class="btn btn-primary mb-sm" title="<spring:message code='button.write' />"><spring:message code='button.write' /></a>
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