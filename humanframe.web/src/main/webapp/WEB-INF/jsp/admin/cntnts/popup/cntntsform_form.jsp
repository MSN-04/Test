<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ include file="/common/taglibs.jsp" %>
<!-- Smart Editor -->
    <script type="text/javascript" src="${globalAdminAssets}/smarteditor/js/HuskyEZCreator.js" charset="utf-8"></script>

<script type="text/javascript">
	function f_Save() {
		$("#frmCntnts").submit();
	}
	$(function() {
		smEditor.init("formCn");

		 $("form[name='frmCntnts']").validate({
			    ignore: "input[type='text']:hidden",
			    rules : {
			    	formSj	: { required : true }
			    },
			    messages : {
			    	formSj	: { required : "콘텐츠양식 제목을 입력하세요" }
			    },
			    errorElement: 'span',
			    errorClass: 'help-block error',
			    errorPlacement: function(error, element) {
					error.insertAfter(element.parent().find(':last'));
				},
			    highlight:function(element, errorClass, validClass) {
			        $(element).addClass('error');
			    },
			    unhighlight: function(element, errorClass, validClass) {
			        $(element).removeClass('error');
			    },
			    submitHandler: function (frm) {

			    	if(confirm("입력하신 정보를 저장 하시겠습니까?")){
			    		smEditor.submit("formCn");//editor
			    		frm.submit();
			    	}else{
			    		return false;
			    	}
			    }
			});
	});
</script>


	<section class="panel panel-primary">
		<header class="panel-heading">
			<div class="panel-actions">
				<button class="btn btn-default" title="선택완료(닫기)" onclick="window.close(); return false;"><i class="fa fa-remove"></i> 선택완료(닫기)</button>
			</div>
			<h2 class="panel-title">콘텐츠 글양식</h2>
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
					<th>양식제목<span class="required">*</span></th>
					<td>
					<f:input path="formSj" class="form-control" placeholder="제목" maxlength="200"/>
					</td>
				</tr>
				<tr>
					<th>양식 CSS</th>
					<td><f:textarea path="formCss" class="form-control" /></td>
				</tr>
				<tr>
					<th>양식 내용<span class="required">*</span></th>
					<td><f:textarea path="formCn" style="width:100%" /></td>
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
					<button class="btn btn-primary" onclick="f_Save()">저장</button>
				</div>
			</div>
			</div>
		</footer>
	</section>
