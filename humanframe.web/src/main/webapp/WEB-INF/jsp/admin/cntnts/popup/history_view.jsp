<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ include file="/common/taglibs.jsp" %>
<script type="text/javascript">
	function f_Restore() {
		if( confirm("복원을 진행하시면 현재 편집중인 글을 손실하게 됩니다.\n복원 하시겠습니까?") ) {
			//alert($("#histCn").html());
			opener.f_replaceEditor($("#content_area").html());
			this.close();
		}
	}
</script>

	<section class="panel panel-primary">
		<header class="panel-heading">
			<div class="panel-actions">
				<button class="btn btn-default" title="선택완료(닫기)" onclick="window.close(); return false;"><i class="fa fa-remove"></i> 선택완료(닫기)</button>
			</div>
			<h2 class="panel-title">콘텐츠 수정이력 상세</h2>
		</header>
		<div class="panel-body">
			<table class="table table-bordered mb-none" id="table-check1">
				<colgroup>
					<col style="width:100px;" />
					<col />
					<col style="width:100px;" />
					<col />
				</colgroup>
				<thead>
					<tr>
						<th>수정일시</th>
						<td>${fn:substring(historyVO.updtDttm, 0, 16)}</td>
						<th>수정자</th>
						<td>${historyVO.updusrNm}</td>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td colspan="4" id="content_area">${historyVO.cn}</td>
					</tr>
				</tbody>
			</table>
		</div>
		<footer class="panel-footer">
			<div class="row">
				<div class="text-right">
				<a href="./historyList?cntntsNo=${param.cntntsNo}&curPage=${param.curPage}" class="btn btn-default">목록</a>
				<button class="btn btn-info" onclick="f_Restore()">이 글로 복원</button>
				</div>
			</div>
		</footer>
	</section>

