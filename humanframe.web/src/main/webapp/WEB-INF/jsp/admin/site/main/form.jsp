<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ include file="/common/taglibs.jsp" %>

	<script type="text/javascript">
	$( document ).ready( function() {

		$("form[id=siteMainVO]").validate({
			ignore: "input[type='text']:hidden",
			rules: {
				gnbAt:{required:true},
				lnbAt:{required:true},
				footerAt:{required:true}
			},
			messages: {
				gnbAt:{required:"GNB 사용여부를 선택하세요"},
				lnbAt:{required:"LNB 사용여부를 선택하세요"},
				footerAt:{required:"Footer 사용여부를 사용하세요"}
			},
			submitHandler: function (frm) {
	            App.blockUI({boxed: true, message: 'Processing...'});
				frm.submit();
			}
		});

	});
	</script>

	<c:import url="/WEB-INF/jsp/admin/site/include/site_tab.jsp"/>

	<f:form name="frmSiteMain" modelAttribute="siteMainVO" method="post" action="action">
	<f:hidden path="crud" />
	<f:hidden path="siteNo" />
	<table class="table table-bordered table-th-bgcolor-eee">
		<caption>메인 레이아웃</caption>
		<colgroup>
			<col style="width:150"/>
			<col />
		</colgroup>
		<tbody>
		<tr>
			<th scope="row">meta tag</th>
			<td><f:textarea path="metaTag" rows="5" class="form-control placeholder-no-fix" placeholder="meta tag를 입력하세요." /></td>
		</tr>
		<tr>
			<th scope="row">GNB 사용여부 <span class="required">*</span></th>
			<td><f:radiobuttons path="gnbAt" items="${useAt}"  /></td>
		</tr>
		<tr>
			<th scope="row">LNB 사용여부 <span class="required">*</span></th>
			<td><f:radiobuttons path="lnbAt" items="${useAt}"/></td>
		</tr>
		<tr>
			<th scope="row">Footer 사용여부 <span class="required">*</span></th>
			<td><f:radiobuttons path="footerAt" items="${useAt}"/></td>
		</tr>
		</tbody>
	</table>

	<div class="clear"></div>

	<table class="table table-bordered table-th-bgcolor-eee hidden">
		<caption>메인 레이아웃</caption>
		<colgroup>
			<col style="width:150"/>
			<col />
		</colgroup>
		<tbody>
		<tr>
			<th scope="row">대표이미지 사용</th>
			<td><f:radiobuttons path="reprsntImageUseAt" items="${useAt}"/></td>
		</tr>
		<tr>
			<th scope="row">가로 X 세로</th>
			<td class="table-inline" style="">
				<f:input path="reprsntImageBt"  cssClass="input input-xsmall" /> X <f:input path="reprsntImageHg" cssClass="input input-xsmall" /> ( 가로 X 세로 )
			</td>
		</tr>
		<tr>
			<th scope="row">알림이미지 사용</th>
			<td><f:radiobuttons path="ntcnImageUseAt" items="${useAt}"/></td>
		</tr>
		<tr>
			<th scope="row">가로 X 세로</th>
			<td>
				<f:input path="ntcnImageBt" cssClass="input input-xsmall"  /> X <f:input path="ntcnImageHg" cssClass="input input-xsmall"  /> ( 가로 X 세로 )
			</td>
		</tr>
		</tbody>
	</table>

	<div class="btns">
		<c:if test="${HUMAN_ADMIN.authTy == 1 || HUMAN_ADMIN.authTy == 2 }">
		<a href="/admin/site/list?curPage=${param.pageNo}" class="btn default float-left">사이트 목록</a>
		</c:if>
		<button type="submit"  class="btn green float-right"><i class="fa fa-check"></i> 저장</button>
	</div>
	</f:form>