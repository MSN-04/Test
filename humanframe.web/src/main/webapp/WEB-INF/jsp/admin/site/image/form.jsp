<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ include file="/common/taglibs.jsp" %>

	<!-- 페이지에서 달력사용시 -->
	<link href="${pageContext.request.contextPath}/${globalAssets}/admin/css/datepicker.min.css" rel="stylesheet" type="text/css"/>
	<script src="${pageContext.request.contextPath}/${globalAssets}/admin/plugins/datepicker.min.js" type="text/javascript"></script>
	<script type="text/javascript">
	$(document).ready(function(){
		datePickerController.createDatePicker({ formElements:{"bgnDttm":"%Y.%m.%d"},noFadeEffect:true});
		datePickerController.createDatePicker({ formElements:{"endDttm":"%Y.%m.%d"},noFadeEffect:true});

		$("form[id=siteMainImageVO]").validate({
			ignore: "input[type='text']:hidden",
			rules: {
				<c:if test="${siteMainImageVO.crud == 'CREATE' }">
				imageFile: { required: true},
				</c:if>
				imageSj: { required: true, maxlength:100},
				bgnDttm: { required: true},
				endDttm: { required: true},
				useAt: { required: true}
			},
			messages: {
				<c:if test="${siteMainImageVO.crud == 'CREATE' }">
				imageFile: { required: "이미지를 첨부하여 주십시요."},
				</c:if>
				imageSj: { required: "제목을 입력해 주십시요", maxlength: jQuery.format("{0}자 이하로 입력하세요")},
				bgnDttm: { required: "게시기간 시작일을 선택해 주십시요"},
				endDttm: { required: "게시기간 종료일을 선택해 주십시요"},
				useAt: { required: "사용여부를 선택해 주십시요."}
			},
			submitHandler: function (frm) {
				App.blockUI({boxed: true, message: 'Processing...'});
				frm.submit();
			}
		});

	});
	</script>

	<c:import url="/WEB-INF/jsp/admin/site/include/site_tab.jsp"/>

	<f:form name="frmImage" modelAttribute="siteMainImageVO" method="post" action="imageAction" enctype="multipart/form-data">
	<f:hidden path="crud" />
	<f:hidden path="siteNo" />
	<f:hidden path="imageNo" />
	<f:hidden path="imageFileNm" />
	<f:hidden path="mobileImgFileNm" />
	<table class="table table-bordered table-th-bgcolor-eee">
		<caption>메인이미지 관리</caption>
		<colgroup>
			<col style="width:150"/>
			<col />
		</colgroup>
		<tbody>
		<tr>
			<th>이미지 구분 <span class="required">*</span></th>
			<td>
			<f:select path="imageTy" cssClass="input input-small">
				<f:option value="1">메인이미지</f:option>
				<f:option value="2">알림이미지</f:option>
				<f:option value="3">배너이미지</f:option>
				<f:option value="4">바로가기이미지</f:option>
			</f:select>
			</td>
		</tr>
		<tr>
			<th <c:if test="${siteMainImageVO.crud == 'UPDATE' }"> rowspan="2" </c:if> > 이미지 <span class="required">*</span></th>
			<td><f:input path="imageFile" type="file" /></td>
		</tr>
		<c:if test="${siteMainImageVO.crud == 'UPDATE' }">
		<tr>
			<td><a href="/admin/comm/download?flpth=MAIN_IMAGE&amp;nttNo=${siteMainImageVO.siteNo }&amp;fileNm=${siteMainImageVO.imageFileNm }">${siteMainImageVO.imageFileNm }</a></td>
		</tr>
		</c:if>
		<tr>
			<th <c:if test="${siteMainImageVO.crud == 'UPDATE' }"> rowspan="2" </c:if> >모바일 이미지 <span class="required">*</span></th>
			<td><f:input path="mobileImgFile" type="file" /></td>
		</tr>
		<c:if test="${siteMainImageVO.crud == 'UPDATE' }">
		<tr>
			<td><a href="/admin/comm/download?flpth=MOBILE_MAIN&amp;nttNo=${siteMainImageVO.siteNo }&amp;fileNm=${siteMainImageVO.mobileImgFileNm }">${siteMainImageVO.mobileImgFileNm }</a></td>
		</tr>
		</c:if>
		<tr>
			<th>제목 <span class="required">*</span></th>
			<td><f:input path="imageSj"  /></td>
		</tr>
		<tr>
			<th>요약글</th>
			<td>
			<f:textarea path="sumry" rows="5" />
			</td>
		</tr>
		<tr>
			<th>링크</th>
			<td>
				<f:input path="linkUrl" cssClass="form-control placeholder-no-fix input input-large" placeholder="ex) http://" />
				타겟 :
				<f:select path="linkTagt" cssClass="input input-small">
					<f:option value="">선택</f:option>
					<f:option value="_self">현재창</f:option>
					<f:option value="_blank">새창</f:option>
				</f:select>
			</td>
		</tr>
		<tr>
			<th>게시기간 <span class="required">*</span></th>
			<td>
				<f:input path="bgnDttm" readonly="true" cssClass="input input-small" cssStyle="text-align:center;" />
				~
				<f:input path="endDttm" readonly="true" cssClass="input input-small" cssStyle="text-align:center;" />
			</td>
		</tr>
		<tr>
			<th>사용여부 <span class="required">*</span></th>
			<td>
			<f:radiobuttons path="useAt" items="${useAt}" />
			</td>
		</tr>
		</tbody>
	</table>

	<div class="btns">
		<a href="imageList?siteNo=${param.siteNo}&curPage=${param.pageNo}" class="btn default float-left">목록</a>
		<button type="submit" class="btn green float-right"><i class="fa fa-check"></i> 저장</button>
	</div>
	</f:form>