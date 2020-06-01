<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ include file="/common/taglibs.jsp" %>
	<style>
	${cntntsFormVO.formCss}
	</style>

<script type="text/javascript">
	function f_restore() {
		if( confirm("양식을 사용하시면 현재 편집중인 글을 손실하게 됩니다.\n사용 하시겠습니까?") ) {
			opener.f_replaceEditor($("#content_area").html());
			opener.f_replaceCss($("#css_area").html());
			this.close();
		}
	}

	function f_modify() {
		var param = "curPage=${param.curPage}&srchKey=${param.srchKey}&srchWord=${param.srchWord}";
		location.href = "./cntntsFormForm?"+param+"&cntntsFormNo=" + ${cntntsFormVO.cntntsFormNo};
	}
</script>




	<section class="panel panel-primary">
		<header class="panel-heading">
			<div class="panel-actions">
				<button class="btn btn-default" title="선택완료(닫기)" onclick="window.close(); return false;"><i class="fa fa-remove"></i> 선택완료(닫기)</button>
			</div>
			<h2 class="panel-title">콘텐츠 글양식(상세)</h2>
		</header>
		<div class="panel-body">
		<f:form name="frmCntnts" id="frmCntnts" modelAttribute="cntntsFormVO" method="post" action="./cntntsFormAction" class="form-horizontal">
			<f:hidden path="crud" />
			<f:hidden path="cntntsFormNo" />
			<table class="table table-bordered mb-none">
				<colgroup>
					<col style="width:100px;" />
					<col />
					<col style="width:100px;" />
					<col />
				</colgroup>
				<tr>
					<th>양식 제목</th>
					<td colspan="3">${cntntsFormVO.formSj}</td>
				</tr>
				<tr>
					<th>생성일시</th>
					<td>${fn:substring(cntntsFormVO.creatDttm, 0, 16)}</td>
					<th>생성자</th>
					<td>${cntntsFormVO.crtrNm}</td>
				</tr>
				<tr>
					<th>양식 CSS</th>
					<td colspan="3" id="css_area">${cntntsFormVO.formCss}</td>
				</tr>
				<tr>
					<th>양식 내용</th>
					<td colspan="3" id="content_area">${cntntsFormVO.formCn}</td>
				</tr>
			</table>
		</f:form>
		</div>
		<footer class="panel-footer">
			<div class="row">
			<div class="form-group">
				<div class="col-sm-7">
					<a href="./cntntsFormList?curPage=${param.curPage}&srchKey=${param.srchKey}&srchWord=${param.srchWord}" class="btn btn-default">목록</a>
				</div>
				<div class="col-sm-5  text-right">
					<button class="btn btn-primary" onclick="f_modify();">수정</button>
                	<button class="btn btn-info" onclick="f_restore();">콘텐츠양식 적용</button>
				</div>
			</div>
			</div>
		</footer>
	</section>
