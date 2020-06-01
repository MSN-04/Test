<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ include file="/common/taglibs.jsp" %>


	<section class="panel panel-primary">
		<header class="panel-heading">
			<div class="panel-actions">
				<button class="btn btn-default" title="선택완료(닫기)" onclick="window.close(); return false;"><i class="fa fa-remove"></i> 선택완료(닫기)</button>
			</div>
			<h2 class="panel-title">콘텐츠 글양식 (총 ${listVO.totalCount}건)</h2>
		</header>
		<div class="panel-body">
		<form id="searchFrm" name="searchFrm" class="form-horizontal form-bordered mb-md" method="get" action="./cntntsFormList">
		<div class="form-group">
			<div class="form-inline ml-md">
			<select id="srchKey" name="srchKey" class="form-control">
				<option value="srchFormSj"  <c:if test="${param.srchKey eq 'srchFormSj' || param.searchKey eq ''}">selected="selected"</c:if>>양식명</option>
				<option value="srchCrtrNm"  <c:if test="${param.srchKey eq 'srchCrtrNm'}">selected="selected"</c:if>>생성자</option>
				</select>
				<input type="text" id="srchWord" name="srchWord" value="${param.srchWord}" class="form-control" placeholder="검색어">
				<button type="submit" class="btn btn-default"><i class="fa fa-search"></i> 검색</button>
			</div>
		</div>
        </form>
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
						<th class="text-center">양식 제목</th>
						<th class="text-center">생성 일시</th>
						<th class="text-center">생성자</th>
					</tr>
				</thead>
				<tbody>
					<c:choose>
					<c:when test="${not empty listVO.listObject}">
					<c:forEach items="${listVO.listObject}" var="resultList" varStatus="status">
					<tr>
						<td class="text-center">${listVO.startNo - status.index}</td>
						<td><a href="./cntntsFormView?cntntsFormNo=${resultList.cntntsFormNo}&curPage=${listVO.curPage}&srchKey=${param.srchKey}&srchWord=${param.srchWord}">${resultList.formSj}</a></td>
						<td class="text-center">${fn:substring(resultList.creatDttm, 0, 16)}</td>
						<td class="text-center">${resultList.crtrNm}</td>
					</tr>
					</c:forEach>
					</c:when>
					<c:otherwise>
					<tr>
						<td colspan="4" style="text-align: center">데이터가 없습니다.</td>
					</tr>
					</c:otherwise>
					</c:choose>
				</tbody>
				</table>
		</div>
		<footer class="panel-footer">
		<div class="form-group">
			<div class="col-sm-7">
			<cms:paging listVO="${listVO}" />
			</div>
			<div class="col-sm-5 text-right">
			<a href="./cntntsFormForm?curPage=${listVO.curPage}&srchKey=${param.srchKey}&srchWord=${param.srchWord}">
			<button class="btn btn-primary">등록</button>
			</a>
			</div>
		</div>

		</footer>
	</section>
