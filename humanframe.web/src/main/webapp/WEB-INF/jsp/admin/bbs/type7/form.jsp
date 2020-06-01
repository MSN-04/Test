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

		$("#resveBeginDttm, #resveEndDttm, #beginDttm, #endDttm").datetimepicker({lang:'ko', format:'Y-m-d H:i', step: 10});

		$('input[name="writngDe"]').datepicker({
			showOn: "button",
            buttonImage: "${globalAdminAssets}/images/calendar.png",
            buttonImageOnly: true
		});

		$("input[name='resveAt']").on("click", function(){
			if($("input[name='resveAt']:checked").val() == "Y"){
				$(".resve-area").show();
			}else{
				$(".resve-area").hide();
			}
		});

        if($("input[name='resveAt']:checked").val() == "Y"){
			$(".resve-area").show();
		}

        $(".nttTyCheckClass").click(function() {
			var chk = $(this).is(":checked");
			if(!chk) {
				$(this).prop("checked", false);
			} else {
				$(".nttTyCheckClass").prop("checked", false);
				  $(this).prop("checked", true);
			}
		});

		<c:if test="${bbsSettingVO.editrUseAt == 'Y'}">
		smEditor.init("cn");
		</c:if>

		$('#hashTag').tagEditor({
			delimiter : '|'
			, forceLowercase : false
			, placeholder: '해시태그를 입력하세요.'
			, beforeTagSave: function(field, editor, tags, tag, val) {
				var hashTagReg = /[-_+=!@#$%^&*()\[\]{}|\\;:\'\"<>,.?/~`） ]/g;
				if(hashTagReg.test(val)) {
					alert("태그 형식에는 특수문자나 공백이 올 수 없습니다.");
					return false;
				}
			}

			/*
            , onChange : function(field, editor, tags){
            	alert("filed="+field+"\neditor="+editor+"\ntags="+tags);
            }
			*/
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
		    	  beginDttm : {required: true}
    			, endDttm : {required: true}
		    	, resveBeginDttm : {required: $("input:checkbox[name=resveAt]").is(":checked")}
				, resveEndDttm : {required: $("input:checkbox[name=resveAt]").is(":checked")}
				, ctgryNo : { required : true}
		    	, sj : {required : true}
		    	, wrter : {required : true}
		    	, writngDe : {required : true}
		    	, cclTy : {required : true}
		    },
		    messages : {
		    	  beginDttm : { required : "<spring:message arguments='" + $("#beginDttm").prop("title") + "' code='errors.required'/>"}
	    		, endDttm : { required : "<spring:message arguments='" + $("#endDttm").prop("title") + "' code='errors.required'/>"}
	    		, resveBeginDttm : { required : "<spring:message arguments='예약시작일' code='errors.required'/>"}
		    	, resveEndDttm : { required : "<spring:message arguments='예약종료일' code='errors.required'/>"}
		    	, ctgryNo : { required : "<spring:message arguments='" + $("#ctgryNo").prop("title") + "' code='errors.required'/>"}
		    	, sj : { required : "<spring:message arguments='" + $("#sj").prop("title") + "' code='errors.required'/>"}
		    	, wrter : { required : "<spring:message arguments='" + $("#wrter").prop("title") + "' code='errors.required'/>"}
		    	, writngDe : { required : "<spring:message arguments='" + $("#writngDe").prop("title") + "' code='errors.required'/>"}
		    	, cclTy : { required : "<spring:message arguments='" + $("#cclTy").prop("title") + "' code='errors.required'/>"}
		    },
		    submitHandler: function (frm) {
		    	if(confirm("<spring:message code='action.confirm.save'/>")){
		    		<c:if test="${bbsSettingVO.editrUseAt == 'Y'}">
		    		smEditor.submit("cn");// 에디터 값 적용
		    		</c:if>
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
		if($("input:checkbox[name=resveAt]").is(":checked")){
			$("#frmNtt input[name=resveBeginDttm]").rules("add", {required: true});
			$("#frmNtt input[name=resveEndDttm]").rules("add", {required: true});
		}

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
					<p>게시물 작성시 주의사항입니다.<br>
					시각 장애인 등 정보취약계층의 웹접근성을 위하여<br>
					<span style="color:blue;">게시물 작성 시 제목 및 파일명, 본문에</span>
					<span style="color:red;">! $ & ' ( ) * + - . / : ; = ? @ _ ~  < > & 등 특수 기호</span>
					<span style="color:blue;">사용을</span>
					<span style="color:red;">자제</span>
					<span style="color:blue;">하여 주시기 바랍니다.</span><br><br>
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
						<tr>
							<th>게시글 설정</th>
							<td>
								<div class="control-group">
									<span class="checkbox-custom checkbox-text-primary checkbox-inline">
									<f:checkbox path="resveAt" value="Y" label="예약글" cssClass="form-control" /></span>
								</div>
							</td>
						</tr>
						<tr class="resve-area" style="display: none;">
							<th>예약일자 설정</th>
							<td>
								<div class="control-group form-inline">
									<label for="resveBeginDttm">예약시작일</label>
									<f:input path="resveBeginDttm" cssClass="form-control mx-sm-3" readonly="true" title="예약시작일" />&nbsp;&nbsp;&nbsp;
									<label for="resveEndDttm">예약종료일</label>
									<f:input path="resveEndDttm" cssClass="form-control mx-sm-3" readonly="true" title="예약종료일" />
								</div>
							</td>
						</tr>
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

							<c:when test="${viewObj.key eq 'place' }"><!-- 장소 -->
								<c:forEach var="viewDtl" items="${viewObj.value }">
								<tr>
									<th>${viewDtl.key} <span class="required">*</span></th>
									<td><f:input path="place" cssClass="form-control" placeholder="${viewDtl.key} 입력" title="${viewDtl.key}" /></td>
								</tr>
								</c:forEach>
							</c:when>

							<c:when test="${viewObj.key eq 'beginDttm' }"><!-- 시작일 -->
								<c:forEach var="viewDtl" items="${viewObj.value }">
								<tr>
									<th>${viewDtl.key} <span class="required">*</span></th>
									<td><div class="control-group form-inline">
											<f:input path="beginDttm" cssClass="form-control mx-sm-3" placeholder="${viewDtl.key} 입력" title="${viewDtl.key}" readonly="true"/>
											<img class="ui-datepicker-trigger" src="${globalAdminAssets}/images/calendar.png" alt="${viewDtl.key}" onclick="$('#beginDttm').datetimepicker('toggle');" />
										</div>
									</td>
								</tr>
								</c:forEach>
							</c:when>

							<c:when test="${viewObj.key eq 'endDttm' }"><!-- 종료일 -->
								<c:forEach var="viewDtl" items="${viewObj.value }">
								<tr>
									<th>${viewDtl.key} <span class="required">*</span></th>
									<td><div class="control-group form-inline">
											<f:input path="endDttm" cssClass="form-control mx-sm-3" placeholder="${viewDtl.key} 입력" title="${viewDtl.key}" readonly="true"/>
											<img class="ui-datepicker-trigger" src="${globalAdminAssets}/images/calendar.png" alt="${viewDtl.key}" onclick="$('#endDttm').datetimepicker('toggle');" />
										</div>
									</td>
								</tr>
								</c:forEach>
							</c:when>

							<c:when test="${viewObj.key eq 'beginAditCn' }"><!-- 시작 추가 내용 -->
								<c:forEach var="viewDtl" items="${viewObj.value }">
								<tr>
									<th>${viewDtl.key}</th>
									<td><f:input path="beginAditCn" cssClass="form-control" placeholder="${viewDtl.key} 입력" title="${viewDtl.key}" /></td>
								</tr>
								</c:forEach>
							</c:when>

							<c:when test="${viewObj.key eq 'endAditCn' }"><!-- 종료 추가 내용 -->
								<c:forEach var="viewDtl" items="${viewObj.value }">
								<tr>
									<th>${viewDtl.key}</th>
									<td><f:input path="endAditCn" cssClass="form-control" placeholder="${viewDtl.key} 입력" title="${viewDtl.key}" /></td>
								</tr>
								</c:forEach>
							</c:when>

							<c:when test="${viewObj.key eq 'nttDeptNm' }"><!-- 부서명 -->
							<c:if test="${bbsSettingVO.nttOrgUseAt eq 'Y' }">
								<c:forEach var="viewDtl" items="${viewObj.value}">
								<tr>
									<th>${viewDtl.key}</th>
									<td><div class="control-group form-inline">
											<f:input path="nttDeptNm" cssClass="form-control mx-sm-3" placeholder="${viewDtl.key} 입력" title="${viewDtl.key}" />
											<button class="btn btn-default" onclick="f_deptSrch();return false;">검색</button>
										</div>
									</td>
								</tr>
								</c:forEach>
							</c:if>
							</c:when>

							<c:when test="${viewObj.key eq 'telno' }"><!-- 전화번호 -->
							<c:if test="${bbsSettingVO.tellUseAt eq 'Y' }">
								<c:forEach var="viewDtl" items="${viewObj.value}">
								<tr>
									<th>${viewDtl.key}</th>
									<td><f:input path="telno" cssClass="form-control" placeholder="${viewDtl.key} 입력" title="${viewDtl.key}" /></td>
								</tr>
								</c:forEach>
							</c:if>
							</c:when>

							<c:when test="${viewObj.key eq 'organCrdns' }"><!-- 담당기관 -->
							<c:if test="${bbsSettingVO.positionUseAt eq 'Y' }">
								<c:forEach var="viewDtl" items="${viewObj.value}">
								<tr>
									<th>${viewDtl.key} </th>
									<td><f:input path="organCrdns" cssClass="form-control" placeholder="${viewDtl.key} 입력" title="${viewDtl.key}" maxlength="50"/></td>
								</tr>
								</c:forEach>
							</c:if>
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

							<c:when test="${viewObj.key eq 'cn' }"><!-- 내용 -->
								<c:forEach var="viewDtl" items="${viewObj.value }">
								<tr>
									<th>${viewDtl.key}</th>
									<td>
										<c:if test="${bbsSettingVO.editrUseAt eq 'Y'}">
										<a style="margin-bottom:5px;" class="btn btn-default" href="/admin/media/popup/list?targetId=cn" target="_blank" onclick="window.open(this.href, 'mediaPopup', 'width=800, height=910'); return false;" >미디어 삽입</a>
										</c:if>
										<f:textarea path="cn" cssClass="form-control" style="width:100%;height:200px;" title="${viewDtl.key}"/>
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

							<c:when test="${viewObj.key eq 'secretAt' }"><!-- 공개여부 -->
								<c:forEach var="viewDtl" items="${viewObj.value }">
								<tr>
									<th>${viewDtl.key} <span class="required">*</span></th>
									<td>
										<div class="radio-group">
											<f:radiobuttons path="secretAt" items="${secretTyCode}" element="span class='radio-custom radio-inline radio-primary' " cssClass="form-control"/>
										</div>
									</td>
								</tr>
								</c:forEach>
							</c:when>

							<c:when test="${viewObj.key eq 'cclTy' }"><!-- 공공누리 -->
								<c:if test="${bbsSettingVO.cclAt eq 'Y'}">
								<c:forEach var="viewDtl" items="${viewObj.value }">
								<tr>
									<th>${viewDtl.key} <span class="required">*</span></th>
									<td>
										<f:select path="cclTy" items="${licCode}" itemValue="codeId" itemLabel="codeNm" cssClass="form-control" title="${viewDtl.key}"/>
									</td>
								</tr>
								</c:forEach>
								</c:if>
							</c:when>

						</c:choose>
						</c:forEach>

						<!-- 기타필드 -->
						<c:import url="/WEB-INF/jsp/admin/bbs/include/etc_form.jsp"/>

						<!-- 첨부파일 -->
						<c:import url="/WEB-INF/jsp/admin/bbs/include/file_form.jsp" />
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