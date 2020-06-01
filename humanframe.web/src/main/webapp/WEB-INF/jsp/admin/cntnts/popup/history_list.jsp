<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ include file="/common/taglibs.jsp" %>


	<section class="panel panel-primary">
		<header class="panel-heading">
			<div class="panel-actions">
				<button class="btn btn-default" title="선택완료(닫기)" onclick="window.close(); return false;"><i class="fa fa-remove"></i> 선택완료(닫기)</button>
			</div>
			<h2 class="panel-title">콘텐츠 수정이력 (총 ${listVO.totalCount}건)</h2>
		</header>
		<div class="panel-body">
			<table class="table table-bordered table-hover mb-none" id="table-check1">
				<colgroup>
					<col style="width:100px;" />
					<col />
					<col style="width:200px;" />
					<col style="width:150px;" />
				</colgroup>
				<thead>
					<tr>
						<th class="text-center">번호</th>
						<th class="text-center">설명</th>
						<th class="text-center">수정일시</th>
						<th class="text-center">수정자</th>
					</tr>
				</thead>
				<tbody>
					<c:choose>
					<c:when test="${not empty listVO.listObject}">
					<c:forEach items="${listVO.listObject}" var="resultList" varStatus="status">
					<tr>
						<td class="text-center">${listVO.startNo - status.index}</td>
						<td><a href="./historyView?cntntsHistNo=${resultList.cntntsHistNo}&cntntsNo=${resultList.cntntsNo}&curPage=${listVO.curPage}">${resultList.histCm}</a></td>
						<td class="text-center">${fn:substring(resultList.updtDttm, 0, 16)}</td>
						<td class="text-center">${resultList.updusrNm}</td>
					</tr>
					</c:forEach>
					</c:when>
					<c:otherwise>
					<tr>
						<td colspan="4">수정이력이 없습니다.</td>
					</tr>
					</c:otherwise>
					</c:choose>
				</tbody>
			</table>
		</div>
		<footer class="panel-footer">
			<div class="row">
				<div class="col-md-12 text-left">
				<cms:paging listVO="${listVO}" />
				</div>
			</div>
		</footer>
	</section>

