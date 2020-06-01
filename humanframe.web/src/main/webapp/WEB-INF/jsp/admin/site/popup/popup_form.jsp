<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ include file="/common/taglibs.jsp" %>

	<!-- 페이지에서 datetime picker 사용시 -->
	<link href="${pageContext.request.contextPath}/${globalAssets}/admin/css/jquery.datetimepicker.css" rel="stylesheet" type="text/css"/>
	<script src="${pageContext.request.contextPath}/${globalAssets}/admin/plugins/jquery.datetimepicker.js" type="text/javascript" ></script>

	<script type="text/javascript">
	$(document).ready(function(){

       $("#bgnDttm").datetimepicker( {lang:'ko', format:'Y-m-d H:i' });
       $("#endDttm").datetimepicker( {lang:'ko', format:'Y-m-d H:i' });

		$("form[id=frmPopup]").validate({
			ignore: "input[type='text']:hidden",
			rules: {
				popupSj: { required: true, maxlength:200},
				<c:if test="${popupVO.crud == 'CREATE' }">
				imageFile: { required: true},
				</c:if>
				popupTop: { required: true,  number: true},
				popupLeft: { required: true,  number: true},
				popupWidth: { required: true,  number: true},
				popupHeight: { required: true,  number: true},
				bgnDttm: { required: true},
				endDttm: { required: true},
				popupTy: { required: true},
				stopViewAt: { required: true},
				useAt: { required: true}
			},
			messages: {
				popupSj: { required: "<spring:message code='errors.required' arguments='제목'/>", maxlength: jQuery.format("{0}자 이하로 입력하세요")},
				<c:if test="${popupVO.crud == 'CREATE' }">
				imageFile: { required: "<spring:message code='errors.required' arguments='이미지'/>"},
				</c:if>
				popupTop: { required: "<spring:message code='errors.required' arguments='팝업창 위치'/>", number: "<spring:message code='errors.numeric' arguments='팝업창 위치'/>"},
				popupLeft: { required: "<spring:message code='errors.required' arguments='팝업창 위치'/>", number: "<spring:message code='errors.numeric' arguments='팝업창 위치'/>"},
				popupWidth: { required: "<spring:message code='errors.required' arguments='팝업창 사이즈'/>", number: "<spring:message code='errors.numeric' arguments='팝업창 사이즈'/>"},
				popupHeight: { required: "<spring:message code='errors.required' arguments='팝업창 사이즈'/>", number: "<spring:message code='errors.numeric' arguments='팝업창 사이즈'/>"},
				bgnDttm: { required: "<spring:message code='errors.required' arguments='게시기간 시작일'/>"},
				endDttm: { required: "<spring:message code='errors.required' arguments='게시기간 종료일'/>"},
				popupTy: { required: "<spring:message code='error.empty.select.required' arguments='팝업타입'/>"},
				stopViewAt: { required: "<spring:message code='error.empty.select.required' arguments='그만보기 사용여부'/>"},
				useAt: { required: "<spring:message code='error.empty.select.required' arguments='사용여부'/>"}
			},
			submitHandler: function (frm) {
				App.blockUI({boxed: true, message: 'Processing...'});
				frm.submit();
			}
		});

	});
	</script>

	<c:import url="/WEB-INF/jsp/admin/site/include/site_tab.jsp"/>

	<f:form name="frmPopup" id="frmPopup" modelAttribute="popupVO" method="post" action="popupAction" enctype="multipart/form-data">
	<f:hidden path="crud" />
	<f:hidden path="siteNo" />
	<f:hidden path="popupNo" />
	<f:hidden path="imageFileNm" />
	<table class="table table-bordered table-th-bgcolor-eee">
		<caption>메인팝업 관리</caption>
		<colgroup>
			<col style="width:150"/>
			<col />
		</colgroup>
		<tbody>
		<tr>
			<th>제목 <span class="required">*</span></th>
			<td><f:input path="popupSj"  /></td>
		</tr>
		<tr>
			<th <c:if test="${popupVO.crud == 'UPDATE' }"> rowspan="2" </c:if> > 이미지 <span class="required">*</span></th>
			<td><f:input path="imageFile" type="file" /></td>
		</tr>
		<c:if test="${popupVO.crud == 'UPDATE' }">
		<tr>
			<td><a href="/admin/comm/download?flpth=POPUP&amp;nttNo=${popupVO.siteNo }&amp;fileNm=${popupVO.imageFileNm }">${popupVO.imageFileNm }</a></td>
		</tr>
		</c:if>
		<tr>
			<th>팝업창 위치</th>
			<td>
				TOP : <f:input path="popupTop" cssClass="input input-small" />
				LEFT : <f:input path="popupLeft" cssClass="input input-small" />
			</td>
		</tr>
		<tr>
			<th>팝업창 사이즈</th>
			<td>
				가로 : <f:input path="popupWidth" cssClass="input input-small" />
				세로 : <f:input path="popupHeight" cssClass="input input-small" />
			</td>
		</tr>
		<tr>
			<th>게시기간 <span class="required">*</span></th>
			<td>
			<div class="input-group">
				<f:input path="bgnDttm" readonly="true" cssClass="input input-medium" cssStyle="text-align:center;" />
				<span>
					<label for="bgnDttm">
						<i class="fa fa-calendar"></i>
					</label>
				</span>
				~
				<f:input path="endDttm" readonly="true" cssClass="input input-medium" cssStyle="text-align:center;" />
				<span>
					<label for="endDttm">
						<i class="fa fa-calendar"></i>
					</label>
				</span>
			</div>
			</td>
		</tr>
		<tr>
			<th>팝업 타입 <span class="required">*</span></th>
			<td>
				<f:radiobuttons path="popupTy" items="${popupTy}" />
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
			<th>그만보기 설정 여부<span class="required">*</span></th>
			<td>
			<f:radiobuttons path="stopViewAt" items="${useAt}" />
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
		<a href="popupList?siteNo=${param.siteNo}&curPage=${param.pageNo}" class="btn default float-left">목록</a>
		<button type="submit" class="btn green float-right"><i class="fa fa-check"></i> 저장</button>
	</div>
	</f:form>