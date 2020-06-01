<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/taglibs.jsp" %>
<%@ page trimDirectiveWhitespaces="true" %>

<script>
function f_useAtChg(at){
	$.ajax({
		type : "post",
		url: './useAtChg',
		data: 'uniqueId=${mberVO.uniqueId}&useAt='+at,
		dataType: 'text', //전송받을 데이터의 타입
		contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
		success: function(data) {
			if(data =="true"){
				alert("상태 변경되었습니다.");
				location.reload();
			}else{
				alert("상태 변경에 실패하였습니다\n\n잠시후 다시 시도해 주시기 바랍니다.");
			}
		},
		error: function(data, status, err) {
			console.log('error forward : ' + data);
		}
	});

}

</script>

<!-- Start Breadcrumb -->
<jsp:include page="/WEB-INF/jsp/admin/layout/breadcrumb.jsp">
<jsp:param name="pageName" value="회원관리"/>
</jsp:include>
<!-- End Breadcrumb -->

        <!-- start: page -->
<div class="row">
	<div class="col-md-12">
	<section class="panel panel-featured panel-featured-primary">
		<header class="panel-heading">
			<div class="panel-actions">

			</div>
			<h2 class="panel-title">회원정보조회</h2>
		</header>
		<div class="panel-body">

			<div class="table-responsive">

				<table class="table">
					<colgroup>
						<col style="width:200px"/>
						<col />
						<col style="width:200px"/>
						<col />
					<col />
				</colgroup>
				<tbody>
					<tr>
						<th>회원 고유아이디</th>
						<td colspan="3">${mberVO.uniqueId }</td>
					</tr>
					<tr>
						<th>회원아이디</th>
						<td>${mberVO.mberId }</td>
						<th>회원이름 </th>
						<td>${mberVO.mberNm }</td>
					</tr>
					<tr>
						<th>회원전화번호</th>
						<td>${mberVO.telno }</td>
						<th>회원E-mail </th>
						<td>${mberVO.email }</td>
					</tr>
					<tr>
						<th>최종 로그일시</th>
						<td colspan="3">${fn:substring(mberVO.lastVisitDttm, 0, 16)}</td>
					</tr>
					<tr>
						<th>생성자ID</th>
						<td>${mberVO.crtrId }</td>
						<th>생성일시</th>
						<td>${fn:substring(mberVO.creatDttm, 0, 16)}</td>
					</tr>
					<tr>
						<th>수정자ID</th>
						<td>${mberVO.updusrId }</td>
						<th>수정일시</th>
						<td>${fn:substring(mberVO.updtDttm, 0, 16)}</td>
					</tr>
				</tbody>
			</table>

		</div>
	</div>
	<footer class="panel-footer">
		<div class="row">
			<div class="col-md-6">
				<c:set var="pageParam" value="useAt=${param.useAt }&amp;curPage=${param.curPage }&amp;searchKey=${param.searchKey}&amp;searchText=${param.searchText}" />
				<a href="./list?${pageParam}" class="btn btn-default">목록</a>
			</div>
			<div class="col-md-6 text-right">
                <cmsBtn2:btn btnTy="modify" path="${curPath}" mngrSession="${mngrSession }" modifyParam="?uniqueId=${mberVO.uniqueId}&amp;${pageParam}">수정</cmsBtn2:btn>
				<c:if test="${mberVO.useAt eq 'Y'}">
				<cmsBtn2:btn btnTy="use" path="${curPath}" mngrSession="${mngrSession }" script="f_useAtChg('N'); return false;" useAt="N" >사용안함</cmsBtn2:btn>
				</c:if>
				<c:if test="${mberVO.useAt eq 'N'}">
				<cmsBtn2:btn btnTy="use" path="${curPath}" mngrSession="${mngrSession }" script="f_useAtChg('Y'); return false;" useAt="Y" >사용</cmsBtn2:btn>
				</c:if>
				</div>
			</div>
		</footer>
	</section>
	</div>

</div>

