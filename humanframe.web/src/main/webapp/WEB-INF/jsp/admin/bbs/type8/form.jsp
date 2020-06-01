<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ include file="/common/taglibs.jsp" %>
<%@ include file="../include/load_plugin.jsp" %>

	<script type="text/javascript">
	function f_empSrch(){
        var target ="deptCode|deptNm|empCode|wrter";
        window.open("/admin/mng/deptEmp/popup/empList?target="+target, "popEmp", "width=780, height=525");
	}
	$(document).ready(function(){

		$('input[name="writngDe"]').datepicker({
			showOn: "button",
            buttonImage: "${globalAdminAssets}/images/calendar.png",
            buttonImageOnly: true
		});

		$(".nttTyCheckClass").click(function() {
			var chk = $(this).is(":checked");
			if(!chk) {
				$(this).prop("checked", false);
			} else {
				$(".nttTyCheckClass").prop("checked", false);
				  $(this).prop("checked", true);
			}
		});
	});

	$(function(){
		$("#frmNtt").validate({
			onkeyup: false,
			onclick: false,
			onfocusout: false,
			showErrors:function(errorMap, errorList){
                if(!$.isEmptyObject(errorList)){
                    alert(errorList[0].message);
                    return;
                }
            },
		    rules : {
		    	ctgryNo : { required : true}
		    	, sj : {required : true}
		    	, wrter : {required : true}
		    	, writngDe : {required : true}
		    	, cclTy : {required : true}
		    	, cn : {required : true}
		    },
		    messages : {
		    	ctgryNo : { required : "<spring:message arguments='" + $("#ctgryNo").prop("title") + "' code='errors.required'/>"}
		    	, sj : { required : "<spring:message arguments='" + $("#sj").prop("title") + "' code='errors.required'/>"}
		    	, wrter : { required : "<spring:message arguments='" + $("#wrter").prop("title") + "' code='errors.required'/>"}
		    	, writngDe : { required : "<spring:message arguments='" + $("#writngDe").prop("title") + "' code='errors.required'/>"}
		    	, cclTy : { required : "<spring:message arguments='" + $("#cclTy").prop("title") + "' code='errors.required'/>"}
		    	, cn : { required : "<spring:message arguments='" + $("#cn").prop("title") + "' code='errors.required'/>"}
		    },
		    submitHandler: function (frm) {
		    	if(confirm("<spring:message code='action.confirm.save'/>")){
		    		frm.submit();
		    	}else{
		    		return false;
		    	}
		    }
		});

		$(".save").click(function(){
        	return f_save();
        });
	})

	function f_save(){
		<c:if test="${bbsSettingVO.etcIemAt eq 'Y'}">
		<c:forEach items="${boardEtcItemList}" var="list">
		<c:if test="${list.useAt eq 'Y' and list.essntlInputAt eq 'Y'}">
		<c:choose>
			<c:when test="${list.dataInputTy eq 'select' }">
				$("#etcInputIem${list.etcIemNo}").rules("add" , {required : true, messages: {required: "<spring:message arguments='${list.etcIemNm}' code='errors.required'/>"}});
			</c:when>
			<c:otherwise>
				$("input[name=etcInputIem${list.etcIemNo}]").rules("add" , {required : true, messages: {required: "<spring:message arguments='${list.etcIemNm}' code='errors.required'/>"}});
			</c:otherwise>
		</c:choose>
		</c:if>
		</c:forEach>
		</c:if>
		return true;
	}

	function f_insertMedia(insertHtml){
		smEditor.setVal("cn", insertHtml);
	}
	//부서 검색 부서코드와 부서명이 들어갈 id를 지정
	function f_deptSrch(){
		var target ="deptCode|nttDeptNm|telno";
		window.open("/admin/mng/dept/popup/deptList2?target="+target, "popDept", "width=780, height=525");
	}
	</script>

		<!-- Start Breadcrumb -->
		<jsp:include page="/WEB-INF/jsp/admin/layout/breadcrumb.jsp">
			<jsp:param name="pageName" value="게시판 관리"/>
		</jsp:include>
		<!-- End Breadcrumb -->

		<!-- start: page -->
		<div class="row">
			<div class="col-md-12">
			<f:form modelAttribute="nttVO" method="post" name="frmNtt" id="frmNtt" enctype="multipart/form-data" action="./action" cssClass="form-horizontal form-bordered mb-md">
				<f:hidden path="crud" />
				<f:hidden path="bbsNo" />
				<f:hidden path="nttNo" />
				<input type="hidden" id="delAttachFileNo" name="delAttachFileNo" value="" />

			<section class="panel panel-featured panel-featured-primary">
				<header class="panel-heading">
					<div class="panel-actions">

					</div>
					<h2 class="panel-title">[${bbsSettingVO.bbsSj}] 게시판 <small>등록/수정</small></h2>
					<p class="panel-subtitle">
					게시글 등록
					</p>
				</header>
				<div class="panel-body">
					<!-- Start Selectable Table Row -->
					<table class="table table-bordered mb-none">
						<colgroup>
							<col style="width:100px"/>
							<col />
						</colgroup>
						<tbody>
						<c:if test="${bbsSettingVO.unityBbsUseAt eq 'Y'}">
						<tr>
							<th>사이트 게시 구분 <span class="required">*</span></th>
							<td>
								<f:select path="siteNtceNo" cssClass="form-control">
									<f:option value="0">전체</f:option>
									<c:forEach items="${siteList}" var="siteList">
									<f:option value="${siteList.siteNo}">${siteList.siteNm}</f:option>
									</c:forEach>
								</f:select>
							</td>
						</tr>
						</c:if>

						<c:forEach var="viewObj" items="${nttVO.viewObject}" varStatus="status">
						<c:choose>

							<c:when test="${viewObj.key eq 'ctgryNm' }"><!-- 카테고리 -->
							<c:if test="${bbsSettingVO.ctgryUseAt == 'Y'}">
							<c:forEach var="viewDtl" items="${viewObj.value}">
							<tr>
								<th>${viewDtl.key} <span class="required">*</span></th>
								<td>
									<select name="ctgryNo" id="ctgryNo" class="form-control" title="${viewDtl.key}">
									<c:forEach items="${bbsSettingVO.ctgryList}" var="ctgry">
										<option value="${ctgry.ctgryNo}" <c:if test="${ctgry.ctgryNo == nttVO.ctgryNo }">selected</c:if> >${ctgry.ctgryNm}</option>
									</c:forEach>
									</select>
								</td>
							</tr>
							</c:forEach>
							</c:if>
							</c:when>

							<c:when test="${viewObj.key eq 'sj' }"><!-- 제목 -->
								<c:forEach var="viewDtl" items="${viewObj.value }">
								<tr>
									<th>${viewDtl.key} <span class="required">*</span></th>
									<td><f:input path="sj" cssClass="form-control" placeholder="${viewDtl.key} 입력" title="${viewDtl.key}" /></td>
								</tr>
								</c:forEach>
							</c:when>

							<c:when test="${viewObj.key eq 'emailAdres' }"><!-- 이메일 -->
							<c:if test="${bbsSettingVO.emailUseAt eq 'Y' }">
								<c:forEach var="viewDtl" items="${viewObj.value}">
								<tr>
									<th>${viewDtl.key} </th>
									<td><f:input path="emailAdres" cssClass="form-control" placeholder="${viewDtl.key} 입력" title="${viewDtl.key}" maxlength="50"/></td>
								</tr>
								</c:forEach>
							</c:if>
							</c:when>

							<c:when test="${viewObj.key eq 'wrter' }"><!-- 작성자 -->
								<c:forEach var="viewDtl" items="${viewObj.value}">
								<tr>
									<th>${viewDtl.key} <span class="required">*</span></th>
									<td><div class="control-group form-inline">
											<f:input path="wrter" cssClass="form-control mx-sm-3" placeholder="${viewDtl.key} 입력" title="${viewDtl.key}" />
											<button class="btn btn-default" onclick="f_empSrch(); return false;">담당자 선택</button>
										</div>
									</td>
								</tr>
								</c:forEach>
							</c:when>

							<c:when test="${viewObj.key eq 'cn' }"><!-- 링크주소 -->
								<c:forEach var="viewDtl" items="${viewObj.value }">
								<tr>
									<th>링크주소 <span class="required">*</span></th>
									<td>
										<f:input path="cn" cssClass="form-control" placeholder="링크주소 입력" title="링크주소" maxlength="50"/>
									</td>
								</tr>
								</c:forEach>
							</c:when>

							<c:when test="${viewObj.key eq 'hashTag' }"><!-- 해시태그 -->
								<c:if test="${bbsSettingVO.hashTagAt eq 'Y'}">
								<c:forEach var="viewDtl" items="${viewObj.value }">
								<tr>
									<th>${viewDtl.key }</th>
									<td><f:textarea path="hashTag" cssClass="form-control" /></td>
								</tr>
								</c:forEach>
								</c:if>
							</c:when>

							<c:when test="${viewObj.key eq 'writngDe' }"><!-- 작성일 -->
								<c:forEach var="viewDtl" items="${viewObj.value }">
								<tr>
									<th>${viewDtl.key} <span class="required">*</span></th>
									<td><div class="control-group form-inline">
											<f:input path="writngDe" cssClass="form-control mx-sm-3" readonly="true" placeholder="${viewDtl.key} 입력" title="${viewDtl.key}"/>
										</div>
									</td>
								</tr>
								</c:forEach>
							</c:when>

						</c:choose>
						</c:forEach>
						</tbody>
					</table>
					<!-- End Selectable Table Row -->
				</div>
				<footer class="panel-footer">
					<div class="row">
						<div class="col-sm-7">
							<c:set var="pageParam" value="bbsSvcNo=${param.bbsSvcNo }&amp;useAt=${param.useAt }&amp;curPage=${param.curPage }&amp;srchCtgryNo=${param.srchCtgryNo}&amp;srchKey=${param.srchKey}&amp;srchText=${param.srchText}" />
							<a href="./list?bbsNo=${nttVO.bbsNo}&curPage=${param.pageNo}" class="btn btn-default">목록</a>
						</div>
						<div class="col-sm-5">
							<div class="btns">
								<button class="btn btn-primary save">저장</button>
							</div>
						</div>
					</div>
				</footer>
			</section>
			</f:form>
			</div>

		</div>