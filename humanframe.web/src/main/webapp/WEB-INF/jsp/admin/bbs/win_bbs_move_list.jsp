<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ include file="/common/taglibs.jsp" %>
<html lang="ko">
<head>
	<title>게시물 ${mth eq 'move'? '이동':'복사'}</title>
	<script type="text/javascript">
	function f_search(){
		if( $.trim($("#srchWord").val())=="" ){
			alert("검색어를 입력해주세요.");
			$("#srchWord").focus();
			return false;
		}

		return true;
	}

	//배포 체크
	function f_Action(){
		var checkedVar = $("input[name='arrTagtbbsNo']:checked").val();
		if(!checkedVar ) {
			alert("대상 게시판을 선택하여 주십시요");
			return;
		}
		$("#listFrm").attr("action", "./winBbsNttMoveAction");
		$("#listFrm").submit();
	}

	var _checkboxNm = "arrTagtbbsNo";
	var checkedCnt = 0;
	$(document).ready(function(){
		var totalCnt = $(":checkbox[name='"+_checkboxNm+"']").length;

		//전체 선택 체크박스 클릭시
		$(":checkbox[name='chkAll']").click(function(){
			var isChecked = $(this).is(":checked");
			$(":checkbox[name='"+_checkboxNm+"']").prop("checked",isChecked);
			$(":checkbox[name='chkAll']").prop("checked",isChecked);
			$.uniform.update();
		});

		//리스트 체크박스 클릭시
		$(":checkbox[name='"+_checkboxNm+"']").click(function(){
			checkedCnt = $(":checkbox[name='"+_checkboxNm+"']:checked").length;

			if( totalCnt==checkedCnt ){
				$(":checkbox[name='chkAll']").prop("checked",true);
			}else{
				$(":checkbox[name='chkAll']").prop("checked",false);
			}
			$.uniform.update();
		});
	});
	</script>

	<form id="searchFrm" name="searchFrm" action="" onsubmit="return f_search();">
		<input type="hidden" name="mth" value="${mth}"/>
		<input type="hidden" name="bbsNo" value="${bbsNo}"/>
		<input type="hidden" name="orgNttNo" value="${orgNttNo}"/>
		<fieldset>
		<legend>게시판 검색영역</legend>
			<div class="fr">
				<label for="srchWord" class="hid">게시판명 입력</label>
				<div class="float-right">
					<input type="text" name="srchWord" id="srchWord" value="${param.srchWord}" class="form-control placeholder-no-fix input-small input-inline"  placeholder="검색어" />
					<button type="submit" class="btn default">검색 <i class="fa fa-search"></i></button>
				</div>
			</div>
		</fieldset>
	</form>

	<p class="count">총 <strong>${listVO.totalCount}</strong>개의 <strong>${boardTyMap[bbsTy]}게시판</strong>이 있습니다.</p>
	<form name="listFrm" id="listFrm" method="post" >
	<input type="hidden" name="mth" value="${mth}"/>
	<input type="hidden" name="bbsNo" value="${bbsNo}"/>
	<input type="hidden" name="orgNttNo" value="${orgNttNo}"/>
	<table class="table table-bordered table-th-bgcolor-eee" summary="등록된 게시판 목록을 확인 할 수 있습니다.">
		<caption>게시판 리스트</caption>
		<colgroup>
			<col style="width:60" />
			<col />
		</colgroup>
		<thead>
		<tr>
			<th scope="col" class="text-align-center"><input type="checkbox" name="chkAll" id="chkAllTop" /></th>
			<th scope="col" class="text-align-center">게시판</th>
		</tr>
		</thead>
		<tbody>
		<c:choose>
		<c:when test="${listVO.totalCount == 0 }">
			<tr>
				<td colspan="2" class="text-center">등록된 게시판이 없습니다.</td>
			</tr>
		</c:when>
		<c:otherwise>
			<c:forEach items="${listVO.listObject}" var="board" varStatus="status">
			<tr>
				<td class="text-align-center"><input type="checkbox" name="arrTagtbbsNo" value="${board.bbsNo}"/></td>
				<td>
					${board.siteNm}${!empty board.siteNm? ' >' : '' } ${board.bbsSj}
					<span class="label label-danger" >${board.bbsNo eq bbsNo ? '현재':'' }</span>
				</td>
			</tr>
			</c:forEach>
		</c:otherwise>
		</c:choose>
		</tbody>
	</table>
	</form>
	<div style="height:60px;">
		<div class="float-left">
			<cms:paging listVO="${listVO}" />
		</div>
		<div class="float-right" style="margin-top:10px;">
			<button class="btn green" onclick="f_Action(); return false;">게시물 ${mth eq 'move'? '이동':'복사'} <i class="fa fa-share"></i></button>
		</div>
	</div>