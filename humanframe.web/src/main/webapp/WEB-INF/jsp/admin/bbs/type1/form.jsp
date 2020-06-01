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

		<c:if test="${bbsSettingVO.noticeTermYn eq 'Y' and (nttVO.crud eq 'CREATE' or nttVO.crud eq 'ANSWER')}">
			var Now = new Date();
			var NowTime = Now.getFullYear();
			var yearTime = Now.getFullYear() + 1;
			var month = Now.getMonth() + 1 ;
			var date = Now.getDate();
			var hour = Now.getHours();
			var minute = Now.getMinutes();
			var second = Now.getSeconds();

			NowTime += '-' + leadingZeros(month,2) ;
			NowTime += '-' + leadingZeros(date,2);
			NowTime += ' ' + leadingZeros(hour,2);
			NowTime += ':' + leadingZeros(minute,2);

			yearTime += '-' + leadingZeros(month,2) ;
			yearTime += '-' + leadingZeros(date,2);
			yearTime += ' ' + leadingZeros(hour,2);
			yearTime += ':' + leadingZeros(minute,2);

			$("#beginDttm").val(NowTime);
			$("#endDttm").val(yearTime);
		</c:if>

		$("#resveBeginDttm, #resveEndDttm, #beginDttm, #endDttm").datetimepicker({lang:'ko', format:'Y-m-d H:i'});

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

		// 우리시 채용만 힌트변경
// 		if ($('#bbsNo').val() == 538) {
// 			$('#sj').attr('placeholder', 'OOOO (모집기간 : 연도-월-일 ~ 연도-월-일)');
// 		}

		// 우리시 채용만 기타항목 - 모집시작일 옆에 문구추가
		if ($('#bbsNo').val() == 538) {
			$('#etcInputIem2').parent().append('<span style="font-weight:bold; color:red;"> ※ 채용공고인 경우 모집시작일과 모집종료일을 꼭 입력해 주십시오.</span>');
		}

		//[부산광역시 설계VE 검토위원 후보자 신청 게시판] 게시판만 비공개를 디폴트로
		if ($('#bbsNo').val() == 862) {

			$("input:radio[name=secretAt]:input[id='secretAt2']").attr("checked",true);

		}

		<c:if test="${bbsSettingVO.nearNttAt == 'Y' and nttVO.crud eq 'UPDATE'}">
 			load_nearGroupdata();
		</c:if>
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
		    	  resveBeginDttm : {required: $("input:checkbox[name=resveAt]").is(":checked")}
				, resveEndDttm : {required: $("input:checkbox[name=resveAt]").is(":checked")}
				, ctgryNo : { required : true}
		    	, sj : {required : true}
		    	, wrter : {required : true}
		    	, writngDe : {required : true}
		    	, cclTy : {required : true}
		    },
		    messages : {
		    	resveBeginDttm : { required : "<spring:message arguments='예약시작일' code='errors.required'/>"}
		    	, resveEndDttm : { required : "<spring:message arguments='예약종료일' code='errors.required'/>"}
		    	, ctgryNo : { required : "<spring:message arguments='" + $("#ctgryNo").prop("title") + "' code='errors.required'/>"}
		    	, sj : { required : "<spring:message arguments='" + $("#sj").prop("title") + "' code='errors.required'/>"}
		    	, wrter : { required : "<spring:message arguments='" + $("#wrter").prop("title") + "' code='errors.required'/>"}
		    	, writngDe : { required : "<spring:message arguments='" + $("#writngDe").prop("title") + "' code='errors.required'/>"}
		    	, cclTy : { required : "<spring:message arguments='" + $("#cclTy").prop("title") + "' code='errors.required'/>"}
		    },
		    submitHandler: function (frm) {
		    	// 우리시 채용만 정규식 적용
// 				if ($('#bbsNo').val() == 538) {
// 					var titleReg = /.+(?=[(])([(]모집기간:)(19|20)\d{2}-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[0-1])(~)(19|20)\d{2}-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[0-1])[)]$/g;
// 					if (!titleReg.test($('#sj').val().replaceAll(" ", ""))) {
// 						alert("제목 입력 형식에 맞지 않습니다.\nOOOO (모집기간 : 연도-월-일 ~ 연도-월-일) 형식으로 입력하여 주십시오");
// 						$('#sj').focus();
// 						return false;
// 					}
// 				}

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

		$(".copyList").hide();
        $("#noticeMaCYn").click(function(){
        	if($(this).is(":checked")){
				$(".copyList").show();
				<c:if test="${nttVO.crud eq 'UPDATE' }">
				$("input[name='noticeCopyYn']").attr("disabled", true);
				</c:if>
        	}else{
        		$(".copyList").hide();
        		<c:if test="${nttVO.crud eq 'UPDATE' }">
        		$("input[name='noticeCopyYn']").removeAttr("disabled");
				</c:if>
        	}
        });

        <c:if test="${nttVO.crud eq 'UPDATE' }">
        $(".updateCopyList").hide();
        $("#noticeCopyYn").click(function(){
        	if($(this).is(":checked")){
				$(".updateCopyList").show();
				$("input[name='noticeMaCYn']").attr("disabled", true);
        	}else{
        		$(".updateCopyList").hide();
        		$("input[name='noticeMaCYn']").removeAttr("disabled");
        	}
        });
        </c:if>
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

		$("#nearNttBbsNo").attr('multiple', 'multiple');
		$("#nearNttBbsNo > option").attr("selected", "selected");

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

	<c:if test="${bbsSettingVO.nearNttAt eq 'Y'}">
	function f_bbs_search_list() {
		$.ajax({
			type : "post",
			url: '/admin/ajax/getBbsList.json',
			data :  {
				  "bbsNo" : $("#bbsNo").val()
				, "bbsTy" : $("#bbsTy").val()
			}
			, dataType : "json"
			, contentType: "application/x-www-form-urlencoded; charset=UTF-8"
			, async : false
			, success: function(data) {
				var bbsListHtml = f_getBbsListHtml(data.bbsList);
				$(".search_list_view").html(bbsListHtml);
				f_near_search($("#s_bbsNo").val(), 'Y');
				$.magnificPopup.open({
					items:{src:'#list-nearNtt-config'},
					type: 'inline',
					preloader: false,
					modal: false
				});
			},
			error: function(data, status, err) {
				console.log('error forward : ' + data);
			}
		});
	}

	function f_getBbsListHtml(list){
		$('#listOutpt').empty();

		var returnHtml = "";
		if(list.length > 0) {
			$.each(list, function(idx, item) {
				var itemHtml = "";
				var bbsNo = $("#bbsNo").val();
				var check = "";
				if(item.bbsNo == bbsNo){
					check = "selected";
				}
				itemHtml += '<option value="'+item.bbsNo+'|'+item.trgtTable+'" '+check+'>'+item.siteNm+' > '+item.bbsSj+'</option>';
				returnHtml += itemHtml;
			});
		} else {
			returnHtml = '<option value="">선택된 게시판이 없습니다.</option>';
		}

		return returnHtml;
	}

	function f_cancel1(){
		$.magnificPopup.close();
	}

	function f_near_search(val, gubun){

		if(val != ""){
			var bbsNo = val.split("|")[0];
			var trgtTable = val.split("|")[1];
		}else{
			var arryBbs = $("#s_bbsNo").val();
			var bbsNo = arryBbs.split("|")[0];
			var trgtTable = arryBbs.split("|")[1];
		}

		if(gubun == "Y"){

			$("#search_text").val($("#search_near_text").val());
		}

		$.ajax({
			type : "post",
			url: '/admin/ajax/getBbsNttList.json',
			data :  {
				  "bbsNo" : bbsNo
				, "trgtTable" : trgtTable
				, "search_select" : $("#search_select").val()
				, "search_text" : $("#search_text").val()
			}
			, dataType : "json"
			, contentType: "application/x-www-form-urlencoded; charset=UTF-8"
			, async : false
			, success: function(data) {
				var bbsListHtml = f_getBbsNttListHtml(data.bbsNttList);
				$("#listOutpt").html(bbsListHtml);
			},
			error: function(data, status, err) {
				console.log('error forward : ' + data);
			}
		});
	}

	function f_getBbsNttListHtml(list){
		var returnHtml = "";
		var itemHtml = "";
		var sj = "";

		$('#listOutpt').empty();

		itemHtml += '<tr>';
		itemHtml += '	<th class="control-label" style="text-align: center;">선택</th>';
		itemHtml += '	<th class="control-label" style="text-align: center;">제목</th>';
		itemHtml += '	<th class="control-label" style="text-align: center;">작성자</th>';
		itemHtml += '	<th class="control-label" style="text-align: center;">작성일</th>';
		itemHtml += '</tr>';

		if(list.length > 0) {
			$.each(list, function(idx, item) {
				if(item.sj != null){
					sj = item.sj;
				}
				itemHtml += '<tr>';
				itemHtml += '	<td class="control-label"><div class="control-group"><input type="checkbox" name="chekVal" id="chekVal'+idx+'" value="'+item.bbsNo+'|'+item.nttNo+'|'+item.sj+'" class="form-control"><div></td>';
				itemHtml += '	<td class="control-label">'+sj+'</td>';
				itemHtml += '	<td class="control-label">'+item.wrter+'</td>';
				itemHtml += '	<td class="control-label">'+item.writngDe+'</td>';
				itemHtml += '</tr>';
			});
		} else {
			itemHtml += '<tr>';
			itemHtml += '	<td class="control-label" colspan="4">조회된 내용이 없습니다.</td>';
			itemHtml += '</tr>';
		}

		returnHtml += itemHtml;

		return returnHtml;
	}

	function f_getNearBbsSelect(){
		var checkArr = [];

		if($("input:checkbox[name='chekVal']:checked").length > 0){

			$("input[name='chekVal']:checked").each(function(i){
				checkArr.push($(this).val());
			});

			var length = checkArr.length;
			var bbsNo = "";
			var nttNo = "";
			var sj = "";
			var nearNttBbsNo = "";
			for(var i=0; i<length; i++){
				bbsNo = checkArr[i].split("|")[0];
				nttNo = checkArr[i].split("|")[1];
				sj = checkArr[i].split("|")[2];

				nearNttBbsNo = bbsNo + "|" + nttNo;

				//console.log("bbsNo : "+bbsNo+" nttNo : "+nttNo+" sj : "+sj+" nearNttBbsNo : "+nearNttBbsNo);

				$("#nearNttBbsNo").append("<option value='" + nearNttBbsNo + "'>"+ sj +"</option>");

				$("#nearNttBbsNo option:selected").val();
				$("#nearNttBbsNo option:selected").text();
			}
			$.magnificPopup.close();
		}else{
			alert("체크박스를 선택해 1개이상 선택해주세요.");
		}

	}

	function load_nearGroupdata()
	{

		$("#nearNttBbsNo").find("option").remove();

		$.ajax({
			   url : "/admin/ajax/loadNearGroupList.json"
			   , data : {
				   bbsNo : $('#bbsNo').val(),
				   nttNo : $("#nttNo").val(),
				   }
			   , type : "POST"
			   , dataType : "json"
			   , contentType: "application/x-www-form-urlencoded; charset=UTF-8"
			   , async : false
			   , success : function(data) {
				   //console.log(data);
				   data = data.nearList;
				   if(data.length)
				   {
					   for(var i=0; i<data.length; i++)
						{
						   var result = data[i].bbsNo + "|" + data[i].nttNo
						   $("#nearNttBbsNo").append("<option value='" + result + "'>"+ data[i].sj +"</option>");
						}
				   }

	    		},
				error: function(data, status, err) {
					console.log('error forward : ' + data);
				},
				complete : function(data) {
				//	$("#menu_group_id").focus();
				}

		});
	}

	function fn_selector_delete(){
		if($("#nearNttBbsNo").val())
		{
			$("#nearNttBbsNo option:selected").remove();

		}else{
			alert("삭제할 글을 선택해주세요.");
		}
	}
	</c:if>

	function leadingZeros(n, digits) {
		  var zero = '';
		  n = n.toString();

		  if (n.length < digits) {
		    for (var i = 0; i < digits - n.length; i++)
		      zero += '0';
		  }
		  return zero + n;
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
				<input type="hidden" id="delThumbFileNo" name="delThumbFileNo" value="" />
				<input type="hidden" id="bbsTy" name="bbsTy" value="${bbsSettingVO.bbsTy}"/>
				<input type="hidden" id="oldNttNo" name="oldNttNo" value="${oldNttNo}"/>
				<input type="hidden" id="mvpTy" name="mvpTy" value="${nttVO.mvpTy}"/>

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
										<f:checkbox path="noticeAt" value="Y" label="공지글" cssClass="form-control"/></span>
										<span class="checkbox-custom checkbox-text-primary checkbox-inline">
										<f:checkbox path="topNttAt" value="Y" label="상위글" cssClass="form-control"/></span>
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

							<c:if test="${bbsSettingVO.nearNttAt eq 'Y'}">
							<tr>
								<th>관련글</th>
								<td>
									<div class="control-group">
										<div class="form-inline">
											<input type="text" name="search_near_text" id="search_near_text" class="form-control" value="" />
											<button class="btn btn-default" type="button" onclick="f_bbs_search_list(); return false;">검색</button>
										</div>
										<div class="form-inline">
											<select name="nearNttBbsNo" id="nearNttBbsNo" size="5" class="chzn-select form-control" style="width:60%">
											</select>
											<button class="btn btn-default" type="button" onclick="javascript:fn_selector_delete();">-</button>
										</div>
									</div>
								</td>
							</tr>
							</c:if>

							<c:if test="${bbsSettingVO.bbsCopyAt eq 'Y' }">
							<tr>
								<th>게시물 ${bbs_nm}</th>
								<td>
									<div class="control-group">
										<span class="checkbox-custom checkbox-text-primary checkbox-inline">
											<input type="checkbox" name="noticeMaCYn" id="noticeMaCYn" value="Y" class="form-control" />
											<label class="form-check-label">(체크하면  ${bbs_nm}대상 게시판 선택하실 수 있습니다.)</label>
										</span>
									</div>
								</td>
							</tr>
							<tr class="copyList">
								<th>${bbs_nm} 대상 게시판  </th>
								<td>
									<c:if test="${bbs_nm eq '이동'}">
										<select name="toBbsNo" id="toBbsNo" class="form-control">
										<option value="0" >선택하세요</option>
										<c:forEach items="${bbs_list}" var="board" varStatus="status">
											<option value="${board.bbsNo}" >${board.bbsSj}(${board.bbsNo})</option>
										</c:forEach>
										</select>
									</c:if>
									<c:if test="${bbs_nm eq '복사'}">
										<c:forEach items="${bbs_copy_list}" var="board" varStatus="status">
											<input type="checkbox" name="bbsCopyList" value="${board.bbsNo}" class="form-control" /> ${board.bbsSj}<br/>
										</c:forEach>
									</c:if>
								</td>
							</tr>
							<c:if test="${nttVO.crud eq 'UPDATE' }">
							<tr>
								<th>게시물 복사</th>
								<td>
									<div class="control-group">
										<span class="checkbox-custom checkbox-text-primary checkbox-inline">
											<input type="checkbox" name="noticeCopyYn" id="noticeCopyYn" value="Y" class="form-control" />
											<label class="form-check-label">(체크하면  복사대상 게시판을 선택하실 수 있습니다.)</label>
										</span>
									</div>
								</td>
							</tr>
							<tr class="updateCopyList">
								<th>복사 대상 게시판</th>
								<td>
									<div class="control-group">
									<c:forEach items="${bbs_copy_list}" var="board" varStatus="status">
										<span class="checkbox-custom checkbox-text-primary checkbox-inline">
											<input type="checkbox" name="bbsCopyList" value="${board.bbsNo}" class="form-control" />
											<label class="form-check-label">${board.bbsSj}</label>
										</span>
									</c:forEach>
									</div>
								</td>
							</tr>
							</c:if>
							</c:if>

							<!-- 기타필드 -->
							<c:import url="/WEB-INF/jsp/admin/bbs/include/etc_form.jsp"/>

							<!-- 첨부파일 -->
							<c:import url="/WEB-INF/jsp/admin/bbs/include/file_form.jsp" />

							<c:if test="${bbsSettingVO.noticeTermYn eq 'Y'}">
							<tr>
								<th>게시기간 설정</th>
								<td>
									<div class="control-group form-inline">
										게시시작일 : <f:input path="beginDttm" cssClass="form-control mx-sm-3" readonly="true" title="게시시작일" />&nbsp;~
										게시종료일 : <f:input path="endDttm" cssClass="form-control mx-sm-3" readonly="true" title="게시종료일" />
										(게시기간을 설정하지 않은 경우에는 기본 1년으로 셋팅됩니다.)
									</div>
								</td>
							</tr>
							</c:if>
							</tbody>
						</table>
						<!-- End Selectable Table Row -->
				</div>
				<!-- End -->
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
			<!-- end -->
		</div>
		<!-- end -->

		<c:if test="${bbsSettingVO.nearNttAt eq 'Y'}">
		<!-- BEGIN MODAL FORM (게시판 관련글 리스트 다이얼 로그) -->
			<div class="modal-block modal-block-primary mfp-hide" id="list-nearNtt-config"style="height:600px; width:620px;">
			<section class="panel panel-featured panel-featured-primary">
					<div class="panel-heading">
						<h4 class="panel-title">게시판 목록</h4>
					</div>
					<div class="panel-body" id="listOutptArea">
						<div class="control-group form-inline" style="text-align: center; padding-bottom: 15px;">
							게시판 검색 : <select name="s_bbsNo" id="s_bbsNo" style="width:70%;margin-bottom: 0px;" class="search_list_view form-control" onchange="f_near_search(this.value, 'N');">
									  </select>
						</div>
						<div class="control-group form-inline" style="text-align: right;padding-bottom: 10px;">
							<select name="search_select" id="search_select" class="form-control" style="width:100px;margin-bottom: 0px;">
								<option value="sj">제목</option>
								<option value="wrter">작성자</option>
						    </select>
							<input type="text" name="search_text" id="search_text" value="" class="form-control" style="margin-bottom: 0px;" />
							<button class="btn btn-default" onclick="javascript:f_near_search('', 'N');">검색</button>
						</div>
						<div style="width:100%; height:500px; overflow:auto">
							<table class="table table-bordered table-hover mb-none">
							<colgroup>
								<col width="10%"/>
								<col />
								<col width="20%" />
								<col width="20%" />
							</colgroup>
							<tbody id="listOutpt">

							</tbody>
							</table>
						</div>
					</div>
					<div class="panel-footer">
						<div class="row">
							<div class="col-sm-12 text-right">
								<button type="button" class="btn btn-success" onclick="javascript:f_getNearBbsSelect();">확인</button>
								<button type="button" class="btn btn-danger" onclick="javascript:f_cancel1();">취소</button>
							</div>
						</div>
					</div>
			</section>
			</div>
			<!-- /.modal -->
		</c:if>