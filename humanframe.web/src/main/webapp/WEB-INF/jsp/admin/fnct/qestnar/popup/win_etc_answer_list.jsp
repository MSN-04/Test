<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp" %>
<%@ page trimDirectiveWhitespaces="true" %>

	<script type="text/javascript">
	function f_search(){
		if( $.trim($("#srchWord").val())=="" ){
			alert("검색어를 입력해주세요.");
			$("#srchWord").focus();
			return false;
		}

		return true;
		//document.frmSearch.submit();
	}
	function setApp(funcNo, funcNm, svcUrl){
		opener.f_setFunc(funcNo, funcNm);
		self.close();
	}
	</script>


	<section class="panel panel-primary">
		<header class="panel-heading">
			<div class="panel-actions"  style="position: absolute;">
				<button class="btn btn-default" title="닫기" onclick="window.close(); return false;"><i class="fa fa-remove"></i> 선택완료(닫기)</button>
			</div>
			<h2 class="panel-title">결과보기</h2>
			<p class="panel-subtitle">총 ${listVO.totalCount}건</p>
		</header>

			<div class="panel-body">
				<blockquote class="primary rounded b-thin">
				<h4>${qestnVO.qestnText}</h4>
				</blockquote>
				<table class="table table-bordered table-th-bgcolor-eee">
					<colgroup>
						<col style="width: 50px;" />
						<col />
						<col style="width: 150px;" />
					</colgroup>
					<thead>
						<tr>
							<th scope="col" class="text-align-center">번호</th>
							<th scope="col" class="text-align-center">의견</th>
							<th scope="col" class="text-align-center">등록자</th>
						</tr>
					</thead>
					<tbody>
						<c:choose>
						<c:when test="${listVO.totalCount == 0 }">
						<tr>
							<td colspan="3" class="text-center">등록된 의견이 없습니다.</td>
						</tr>
						</c:when>
						<c:otherwise>
							<c:forEach items="${listVO.listObject}" var="list" varStatus="status">
							<c:set var="listNum" value="${listVO.totalCount - ((listVO.curPage - 1) * listVO.cntPerPage) - status.count + 1}"/>
							<tr>
								<td>${listNum}</td>
								<td class="title">${list.etcAnswer}</td>
								<td class="text-align-center">${list.crtrNm}</td>
							</tr>
							</c:forEach>
						</c:otherwise>
						</c:choose>
					</tbody>
				</table>
			</div>

			<div class="panel-footer">
				<div class="row">
					<div class="col-sm-12  text-right">
						<cms:paging listVO="${listVO}" />
					</div>
				</div>
			</div>
	</section>
