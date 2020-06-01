<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ include file="/common/taglibs.jsp" %>
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
	function setBbs(bbsNo, boardNm){
		opener.f_setBoard(bbsNo, boardNm);
		self.close();
	}
	</script>

	<form name="frmSearch" action="" onsubmit="return f_search();">
		<input type="hidden" name="domain" id="domain" value="${param.domain}" />
		<fieldset>
		<legend>게시판 검색영역</legend>
			<div class="fl">
			
			</div>
			<div class="fr">
				<label for="srchWord" class="hid">게시판명 입력</label>
				<div class="float-right">
					<input type="text" name="srchWord" id="srchWord" value="${param.srchWord}" class="form-control placeholder-no-fix input-small input-inline"  placeholder="검색어" />	
					<button type="submit" class="btn default">검색 <i class="fa fa-search"></i></button>
				</div>
			</div>
		</fieldset>
	</form>

	<p class="count">총 <strong>${listVO.totalCount}</strong>개의 게시판이 있습니다.</p>
	<table class="table table-bordered table-th-bgcolor-eee" summary="기능프로그램 검색 결과를 확인할 수 있습니다.">
		<caption>게시판 리스트</caption>
		<colgroup>
			<col style="width:80" />
			<col style="width:120" />
			<col />
			<col style="width:100" />
		</colgroup>
		<thead>
		<tr>
			<th scope="col" class="text-align-center">번호</th>
			<th scope="col" class="text-align-center">게시판 유형</th>
			<th scope="col" class="text-align-center">게시판명</th>
			<th scope="col" class="text-align-center">선택</th>
		</tr>
		</thead>
		<tbody>
		<c:choose>
		<c:when test="${listVO.totalCount == 0 }">
			<tr>
				<td colspan="6" class="text-center">등록된 게시판이 없습니다.</td>
			</tr>
		</c:when>
		<c:otherwise>
			<c:forEach items="${listVO.listObject}" var="board" varStatus="status">
			<c:set var="listNum" value="${listVO.totalCount - ((listVO.curPage - 1) * listVO.cntPerPage) - status.count + 1}"/>
			<tr>
				<td class="text-align-center">${listNum}</td>
				<td class="text-align-center">${boardTyMap[board.bbsTy]}</td>
				<td class="text-align-center">${board.bbsSj}</td>
				<td class="text-align-center"><a href="#none" onclick="setBbs('${board.bbsNo}','${board.bbsSj}');return false;">선택</a></td>
			</tr>
			</c:forEach>
		</c:otherwise>
		</c:choose>
		</tbody>
	</table>
	<div class="float-left" style="margin-top: 10px;">
		<cms:paging listVO="${listVO}" />
	</div>