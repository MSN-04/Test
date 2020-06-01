<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/taglibs.jsp" %>
<%@ page trimDirectiveWhitespaces="true" %>


<script>
$(function() {

    $("form[name='frmMber']").validate({
	    ignore: "input[type='text']:hidden",
	    rules : {
	    	mberId	: { required : true }
	       ,mberNm : { required : true }
	    },
	    messages : {
	    	mberId	: { required : "회원아이디를 입력하세요" }
	       ,mberNm	: { required : "회원성명을 입력하세요" }
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
	    		frm.submit();
	    	}else{
	    		return false;
	    	}
	    }
	});
});

</script>

<!-- Start Breadcrumb -->
<jsp:include page="/WEB-INF/jsp/admin/layout/breadcrumb.jsp">
<jsp:param name="pageName" value="배너 관리"/>
</jsp:include>
<!-- End Breadcrumb -->

      <!-- start: page -->
<div class="row">
	<div class="col-md-12">
	<section class="panel panel-featured panel-featured-primary">
		<header class="panel-heading">
			<h2 class="panel-title">회원정보 수정</h2>
		</header>

		<f:form name="frmMber" id="frmMber" modelAttribute="mberVO" method="post" action="./action" class="form-horizontal">
		<f:hidden path="crud" />
		<f:hidden path="uniqueId" />

		<div class="panel-body">
			<div class="table-responsive">
				<table class="table">
					<colgroup>
						<col style="width:150px"/>
					<col />
				</colgroup>
				<tbody>
					<tr>
						<th>회원아이디<span class="required">*</span></th>
						<td>
							<f:input path="mberId" class="form-control" placeholder="회원 ID" maxlength="25" readonly="true"/>
						</td>
					</tr>
					<tr>
						<th>회원이름<span class="required">*</span></th>
						<td>
							<f:input path="mberNm" class="form-control" placeholder="회원성명" maxlength="100"/>
						</td>
					</tr>
					<tr>
						<th>회원전화번호</th>
						<td>
							<f:input path="telno" class="form-control" placeholder="회원전화번호" maxlength="100"/>
						</td>
					</tr>
					<tr>
						<th>회원E-mail</th>
						<td>
							<f:input path="email" class="form-control" placeholder="회원E-mail" maxlength="100"/>
						</td>
					</tr>
					</tbody>
				</table>
			</div>
		</div>

		<footer class="panel-footer">
			<div class="row">
				<div class="col-sm-6">
					<c:set var="pageParam" value="useAt=${param.useAt }&amp;curPage=${param.curPage }&amp;searchKey=${param.searchKey}&amp;searchText=${param.searchText}" />
				<a href="./list?${pageParam}" class="btn btn-default">목록</a>
			</div>
			<div class="col-sm-6 text-right">
		          <cmsBtn2:btn btnTy="save" path="${curPath}" mngrSession="${mngrSession }" >저장</cmsBtn2:btn>
			</div>
			</div>
		</footer>
	</f:form>
	</section>
	</div>


</div>
