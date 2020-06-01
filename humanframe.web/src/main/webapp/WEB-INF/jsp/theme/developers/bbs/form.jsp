<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/taglibs.jsp" %>
<%@ page trimDirectiveWhitespaces="true" %>
<!-- DatetimePicker -->
	<script type="text/javascript" src="${themeAssets}/script/jquery.datetimepicker.js"></script>
    <link rel="stylesheet" type="text/css" href="${themeAssets}/css/jquery.datetimepicker.css">
	<script type="text/javascript">
	$(function(){
		<c:if test="${bbsSettingVO.noticeTermYn eq 'Y'}">
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
		$("#beginDttm, #endDttm").datetimepicker({lang:'ko', format:'Y-m-d H:i'});

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
		    	, password : {required : true}
		    	, passwordCheck : {required : true, equalTo:"#password"}
		    },
		    messages : {
		    	  ctgryNo : { required : "<spring:message arguments='" + $("#ctgryNo").prop("title") + "' code='errors.required'/>"}
		    	, sj : { required : "<spring:message arguments='" + $("#sj").prop("title") + "' code='errors.required'/>"}
		    	, wrter : { required : "<spring:message arguments='" + $("#wrter").prop("title") + "' code='errors.required'/>"}
		    	, password : {required : "<spring:message arguments='" + $("#password").prop("title") + "' code='errors.required'/>"}
		    	, passwordCheck : {
		    		required : "<spring:message arguments='" + $("#passwordCheck").prop("title") + "' code='errors.required'/>",
		    		equalTo:"<spring:message code='login.fail.password'/>"
		    	}
		    },
		    submitHandler: function (frm) {

		    	if(grecaptcha.getResponse() == ""){
		    		alert("<spring:message code='alert.author.captcha.check' />");
		    		return;
		    	}

		    	<c:if test="${bbsSettingVO.indvdlinfoColctAgreAt eq 'Y'}">
		    	<%-- 개인정보 수집동의 스크립트 --%>
				if(!$("input:radio[name=indvdlinfoColctAgreAt]").is(":checked")){
					alert("개인정보 수집 이용동의를 선택해 주세요.");
					return;
				}

				if($("input[name='indvdlinfoColctAgreAt']:checked").val() != "Y"){
					alert("개인정보 수집 이용에 동의해야만 글작성이 가능합니다.");
					return;
				}
				</c:if>

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
	});

	function leadingZeros(n, digits) {
		  var zero = '';
		  n = n.toString();

		  if (n.length < digits) {
		    for (var i = 0; i < digits - n.length; i++)
		      zero += '0';
		  }
		  return zero + n;
	}

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

	function delFile(fileNo, type, spanNo){
		if( confirm("<spring:message code='action.confirm.delete' />") ) {
			if(type == "ATTACH"){
				if($("#delAttachFileNo").val()==""){
					$("#delAttachFileNo").val(fileNo);
				}else{
					$("#delAttachFileNo").val($("#delAttachFileNo").val()+","+fileNo);
				}
				$("#attachFileViewSpan"+fileNo).remove();
				$("#attachFileInputSpan"+spanNo).show();
			}
			else{
				$("#delThumbFileNo").val(fileNo);
				$("#thumbFileViewSpan" + spanNo).remove();
				$("#thumbFileDiv").show();
			}
		}
	}

	function f_FileCheck(obj) {

		if(obj.value != ""){

			<c:if test="${fn:length(bbsSettingVO.atchmnflExtsn) > 0}">
			/* 첨부파일 확장자 체크*/
			var atchmnflExtsnArr = new Array();
			<c:forEach items="${bbsSettingVO.atchmnflExtsn}" var="atchmnflExtsn">
			atchmnflExtsnArr.push("${atchmnflExtsn}");
			</c:forEach>

			var file = obj.value;
			var fileExt = file.substring(file.lastIndexOf('.') + 1, file.length).toLowerCase();
			var isFileExt = false;

			for (var i = 0; i < atchmnflExtsnArr.length; i++) {
				if (atchmnflExtsnArr[i] == fileExt) {
					isFileExt = true;
					break;
				}
			}

			if (!isFileExt) {
				alert("<spring:message code='errors.ext.limit' arguments='" + atchmnflExtsnArr + "' />");
				obj.value = "";
				return false;
			}
			/* 첨부파일 확장자 체크*/
			</c:if>

			/* 첨부파일 사이즈 체크*/
			var uploadFileSize = 0;
			var limitSize = <c:out value="${bbsSettingVO.atchmnflSize}" default="0"/>;

			if($.browser.msie){
				var objFSO = new ActiveXObject("Scripting.FileSystemObject");
				var sPath = obj.value;
				var objFile = objFSO.getFile(sPath);
				uploadFileSize = objFile.size/ 1024;
			}else {
				uploadFileSize = (obj.files[0].size / 1024);
			}

			//메가바이트(MB)단위 변환
			uploadFileSize = (Math.round((uploadFileSize / 1024) * 100) / 100);

			if(limitSize != 0 && uploadFileSize > limitSize){
				alert("<spring:message code='errors.exceed.limit' arguments='" + uploadFileSize + ";" + limitSize + "' argumentSeparator=';'/>");
				obj.value = "";
				return false;
			}
			/* 첨부파일 사이즈 체크*/
		}

		function f_ThumbnailFileChk(fileObj){
			if(fileObj.value != ""){

				var file = fileObj.value;
				var fileExt = file.substring(file.lastIndexOf('.') + 1, file.length).toLowerCase();
				var reg = /gif|jpg|png|bmp/i;

				if(reg.test(fileExt) == false)
				{
					alert("썸네일이미지는 확장자가 gif, jpg, png, bmp로 된\n파일만 첨부 가능합니다.");
					fileObj.value = "";
					return false;
					return false;
				}
				return true;
			}
		}
	}
	</script>

	<c:if test="${not empty bbsSkinVO.description}">
	${bbsSkinVO.description}
	</c:if>
	
	<f:form name="frmNtt" id="frmNtt" cssClass="form-horizontal form-bordered" modelAttribute="bbsTypeVO" method="post" action="./action" enctype="multipart/form-data" >
	<f:hidden path="crud" />
	<f:hidden path="bbsNo" />
	<f:hidden path="nttNo" />
	<f:hidden path="nttGroup" />
	<f:hidden path="nttOrdr" />
	<f:hidden path="nttLevel" />
	<input type="hidden" id="delAttachFileNo" name="delAttachFileNo" value="" />
	<input type="hidden" id="delThumbFileNo" name="delThumbFileNo" value="" />
	<div class="panel-body">
		<c:forEach var="viewObj" items="${bbsTypeVO.viewObject}" varStatus="status">
		<c:choose>
			<c:when test="${viewObj.key eq 'ctgryNm' }"><!-- 카테고리 -->
			<c:if test="${bbsSettingVO.ctgryUseAt == 'Y'}">
				<c:forEach var="viewDtl" items="${viewObj.value }">
				<div class="form-group">
					<label class="col-md-3 control-label" for="ctgryNm">${viewDtl.key}<span class="required">*</span></label>
					<div class="col-md-6">
						<select name="ctgryNo" id="ctgryNo" class="form-control mb-md">
							<c:forEach items="${bbsSettingVO.ctgryList}" var="ctgry">
							<option value="${ctgry.ctgryNo}" <c:if test="${ctgry.ctgryNo == nttVO.ctgryNo }">selected</c:if> >${ctgry.ctgryNm}</option>
							</c:forEach>
						</select>
					</div>
				</div>
				</c:forEach>
			</c:if>
			</c:when>

			<c:when test="${viewObj.key eq 'sj' }"><!-- 제목 -->
				<c:forEach var="viewDtl" items="${viewObj.value }">
				<div class="form-group">
					<label class="col-md-3 control-label" for="sj">${viewDtl.key}<span class="required">*</span></label>
					<div class="col-md-6">
						<f:input path="sj" cssClass="form-control" placeholder="${viewDtl.key}" title="${viewDtl.key}" autocomplete="off" />
					</div>
				</div>
				</c:forEach>
			</c:when>

			<c:when test="${viewObj.key eq 'wrter' }"><!-- 작성자 -->
				<c:forEach var="viewDtl" items="${viewObj.value}">
				<div class="form-group">
					<label class="col-md-3 control-label" for="wrter">${viewDtl.key}<span class="required">*</span></label>
					<div class="col-md-3">
						<f:input path="wrter" cssClass="form-control" placeholder="${viewDtl.key}" title="${viewDtl.key}" autocomplete="off" />
					</div>
				</div>
				</c:forEach>
				<div class="form-group">
					<label class="col-md-3 control-label" for="wrter"><spring:message code='board.password' /><span class="required">*</span></label>
					<div class="col-md-3">
						<input type="password" name="password" id="password" autocomplete="off"
							placeholder="<spring:message code='board.password' />"
							title="<spring:message code='board.password' />"
							class="form-control" />
					</div>
				</div>
				<div class="form-group">
					<label class="col-md-3 control-label" for="wrter"><spring:message code='board.password.check' /><span class="required">*</span></label>
					<div class="col-md-3">
						<input type="password" name="passwordCheck" id="passwordCheck" autocomplete="off"
							placeholder="<spring:message code='board.password.check' />"
							title="<spring:message code='board.password.check' />"
							class="form-control" />
					</div>
				</div>
			</c:when>

			<c:when test="${viewObj.key eq 'secretAt' }"><!-- 공개여부 -->
				<c:forEach var="viewDtl" items="${viewObj.value }">
				<div class="form-group">
					<label class="col-md-3 control-label" for="wrter">${viewDtl.key}<span class="required">*</span></label>
					<div class="col-md-3">
						<f:radiobuttons path="secretAt" items="${secretTyCode}"/>
					</div>
				</div>
				</c:forEach>
			</c:when>

			<c:when test="${viewObj.key eq 'cn' }"><!-- 내용 -->
				<c:forEach var="viewDtl" items="${viewObj.value }">
				<div class="form-group">
					<label class="col-md-3 control-label" for="cn">${viewDtl.key}</label>
					<div class="col-md-6">
						<f:textarea path="cn" style="width:100%;height:200px;" placeholder="${viewDtl.key}" title="${viewDtl.key}"/>
					</div>
				</div>
				</c:forEach>
			</c:when>

			<c:when test="${viewObj.key eq 'emailAdres' }"><!-- 이메일주소 -->
				<c:forEach var="viewDtl" items="${viewObj.value }">
				<div class="form-group">
					<label class="col-md-3 control-label" for="emailAdres">${viewDtl.key}</label>
					<div class="col-md-6">
						<f:input path="emailAdres" cssClass="form-control" autocomplete="off" placeholder="${viewDtl.key}" title="${viewDtl.key}" />
					</div>
				</div>
				</c:forEach>
			</c:when>

			<c:when test="${viewObj.key eq 'mbtlnum' }"><!-- 휴대폰번호 -->
				<c:forEach var="viewDtl" items="${viewObj.value }">
				<div class="form-group">
					<label class="col-md-3 control-label" for="mbtlnum">${viewDtl.key}</label>
					<div class="col-md-6">
						<f:input path="mbtlnum" cssClass="form-control" autocomplete="off" placeholder="${viewDtl.key}" title="${viewDtl.key}" />
					</div>
				</div>
				</c:forEach>
			</c:when>
		</c:choose>
		</c:forEach>

		<%--기타 필드 --%>
		<c:if test="${bbsSettingVO.etcIemAt eq 'Y'}">
		<c:forEach items="${boardEtcItemList}" var="list">
		<c:if test="${list.useAt eq 'Y'}">
		<div class="form-group">
			<label class="col-md-3 control-label" for="etcInputIem${list.etcIemNo}">${list.etcIemNm}<c:if test="${list.essntlInputAt eq 'Y'}"> <font color="#ff0000">*</font></c:if></label>
			<div class="col-md-6">

				<c:choose>
					<c:when test="${list.dataInputTy eq 'select' }">
							<select name="etcInputIem${list.etcIemNo}" id="etcInputIem${list.etcIemNo}" class="form-control mb-md">
								<option value="">선택</option>
								<c:forEach items="${list.itemExList }" var="itemExList">
								<option value="${itemExList.etcIemExNm }"<c:if test="${list.etcInputIem eq  itemExList.etcIemExNm}">selected="selected"</c:if>>${itemExList.etcIemExNm }</option>
								</c:forEach>
							</select>
					</c:when>

					<c:when test="${list.dataInputTy eq 'radio' }">
						<c:forEach items="${list.itemExList }" var="itemExList">
							<input type="radio" name="etcInputIem${list.etcIemNo}"
								id="etcInputIem${list.etcIemNo}_${itemExList.etcIemExNm }"
								value="${itemExList.etcIemExNm }"
								<c:if test="${list.etcInputIem eq  itemExList.etcIemExNm}">checked="checked"</c:if> />
							<label for="etcInputIem${list.etcIemNo}_${itemExList.etcIemExNm }">${itemExList.etcIemExNm }</label>
						</c:forEach>
					</c:when>

					<c:when test="${list.dataInputTy eq 'checkbox' }">
						<c:forEach items="${list.itemExList }" var="itemExList">
							<input type="checkbox" name="etcInputIem${list.etcIemNo}"
								id="etcInputIem${list.etcIemNo}_${itemExList.etcIemExNm }"
								value="${itemExList.etcIemExNm }"
							<c:if test="${fn:indexOf(list.etcInputIem, itemExList.etcIemExNm) > -1}">checked="checked"</c:if> />
							<label for="etcInputIem${list.etcIemNo}_${itemExList.etcIemExNm }">${itemExList.etcIemExNm }</label>
						</c:forEach>
					</c:when>

					<c:when test="${list.dataInputTy eq 'text' }">
						<input type="text" name="etcInputIem${list.etcIemNo}"
							id="etcInputIem${list.etcIemNo}" value="${list.etcInputIem}"
							class="form-control" placeholder="${list.etcIemNm}"
							title="${list.etcIemNm}" />
					</c:when>

					<c:when test="${list.dataInputTy eq 'textarea' }">
						<textarea name="etcInputIem${list.etcIemNo}"
							id="etcInputIem${list.etcIemNo}"
							placeholder="${list.etcIemNm}" title="${list.etcIemNm}"
							style="width: 100%; height: 200px;">${list.etcInputIem}</textarea>
					</c:when>
				</c:choose>
			</div>
		</div>
		</c:if>
		</c:forEach>
		</c:if>

		<%-- 첨부파일 --%>
		<c:if test="${bbsSettingVO.atchmnflAt eq 'Y'}">
			<c:if test="${bbsSettingVO.atchmnflCo > 0 }">
				<c:forEach var="bbsFileListObj" items="${bbsTypeVO.viewExcludeObject['bbsFileList']}">
				<div class="form-group">
					<label class="col-md-3 control-label" for="inputPlaceholder">${bbsFileListObj.key}</label>
					<div class="col-md-6">
						<c:forEach var="fileList" items="${bbsTypeVO.bbsFileList}" varStatus="status">
						<span class="help-block" id="attachFileViewSpan${fileList.fileNo}">
							<a href="/comm/getFile?srvcId=${fileList.srvcId }&amp;upperNo=${fileList.upperNo }&amp;fileTy=${fileList.fileTy }&amp;fileNo=${fileList.fileNo }">
							${fileList.orginlFileNm}(<spring:message code='board.file.size' /> : ${cmsFn:fileSize(fileList.fileSize)}, <spring:message code='button.download' /> :${fileList.dwldCo}<spring:message code='ui.count' />)
							</a>
							<a href="#delFile" onclick="delFile('${fileList.fileNo}', 'ATTACH', '${status.index}'); return false;"><i class="fa fa-times"></i></a>
						</span>
						</c:forEach>

						<c:forEach begin="0" end="${bbsSettingVO.atchmnflCo-1}" varStatus="status">
						<span class="help-block"  id="attachFileInputSpan${status.index}" <c:if test="${status.index < fn:length(bbsTypeVO.bbsFileList) }">style="display:none;"</c:if>>
							<input type="file" id="attachFile${status.index}" name="attachFile${status.index}" onchange="fileCheck(this);" />
						</span>
						</c:forEach>
					</div>
				</div>
				</c:forEach>
			</c:if>
		</c:if>

		<%-- 썸네일 --%>
		<c:if test="${(bbsSettingVO.bbsTy eq '1' || bbsSettingVO.bbsTy eq '2') && bbsSettingVO.thumbAt eq 'Y'}">
			<c:forEach var="thumbFileObj" items="${bbsTypeVO.viewExcludeObject['thumbFile']}">
				<div class="form-group">
					<label class="col-md-3 control-label" for="inputPlaceholder">${thumbFileObj.key}</label>
					<div class="col-md-6">
						<c:if test="${not empty bbsTypeVO.thumbFile.fileNo}">
						<span class="help-block" id="thumbFileViewSpan${bbsTypeVO.thumbFile.fileNo}">
							<img src="/comm/getImage?srvcId=${bbsTypeVO.thumbFile.srvcId}&amp;upperNo=${bbsTypeVO.thumbFile.upperNo}&amp;fileTy=${bbsTypeVO.thumbFile.fileTy }&amp;fileNo=${bbsTypeVO.thumbFile.fileNo}&amp;thumbTy=S" alt="썸네일 이미지" />
							<a href="#delFile" onclick="delFile('${bbsTypeVO.thumbFile.fileNo}', '${bbsTypeVO.thumbFile.fileTy }', '${bbsTypeVO.thumbFile.fileNo}'); return false;"><i class="fa fa-times"></i></a>
						</span>
						</c:if>

						<div id="thumbFileDiv" <c:if test="${not empty bbsTypeVO.thumbFile.fileNo}">style="display: none;"</c:if>>
							<span class="help-block"  id="thumbFileInputSpan">
								<input type="file" id="thumbnailFile" name="thumbnailFile" title="${thumbFileObj.key}" onchange="f_ThumbnailFileChk(this)"/>
							</span>
						</div>
					</div>
				</div>
			</c:forEach>
		</c:if>

		<c:if test="${bbsSettingVO.noticeTermYn eq 'Y'}">
			<div class="form-group">
				<label class="col-md-3 control-label">게시기간 설정<c:if test="${list.essntlInputAt eq 'Y'}"> <font color="#ff0000">*</font></c:if></label>
				<div class="col-md-6">
					게시시작일 : <f:input path="beginDttm" cssClass="form-control" readonly="true" placeholder="게시시작일 입력" title="게시시작일" />&nbsp;~
					게시종료일 : <f:input path="endDttm" cssClass="form-control" readonly="true" placeholder="게시종료일 입력" title="게시종료일" />
					(게시기간은 기본적으로 1년으로 적용됩니다.)
				</div>
			</div>
		<tr>
			<th><label ></label></th>
			<td>
				<div class="radio-group">
					<span>

					</span>

				</div>
			</td>
		</tr>
		</c:if>

		<%-- Captcha(자동입력방지) --%>
		<c:if test="${bbsSettingVO.crtfcMthd == 2 and bbsTypeVO.crud eq 'CREATE'}">
		<script src="https://www.google.com/recaptcha/api.js?onload=onloadCallback&render=explicit" async defer></script>
		<script type="text/javascript">
	   	  var onloadCallback = function() {
		       grecaptcha.render('captcha', {
		         'sitekey' : '${reCaptchaSiteKey}'
		       });
		     };
	    </script>
	    <div class="form-group">
			<label class="col-md-3 control-label" for="cn"><spring:message code='board.captcha' /></label>
			<div class="col-md-6">
				<div id="captcha"></div>
			</div>
		</div>
		</c:if>

		<c:if test="${bbsSettingVO.indvdlinfoColctAgreAt eq 'Y' and bbsTypeVO.crud eq 'CREATE'}">
		<!-- 개인정보 수집 동의 -->
		<div class="wte-board-agree">
			${bbsSettingVO.indvdlinfoColctAgreWords}<br/>
			<span class="txt-board-agree">개인정보 수집 이용에 동의 하십니까? (동의해야만 이용 가능)</span>
			&nbsp;&nbsp;
			<label for="indvdlinfoColctAgreAt_Y" class="inchk">
				<input type="radio" name="indvdlinfoColctAgreAt" id="indvdlinfoColctAgreAt_Y" value="Y" <c:if test="${nttVO.crud == 'UPDATE'}">checked="checked"</c:if>/> 예
			</label>
			&nbsp;&nbsp;
			<label for="indvdlinfoColctAgreAt_N" class="inchk">
				<input type="radio" name="indvdlinfoColctAgreAt" id="indvdlinfoColctAgreAt_N" value="N"/> 아니오
			</label>
		</div>
		</c:if>

	</div>

	<%-- 버튼 --%>
	<div class="col-md-6" style="float: right; text-align: right;">
		<p>
			<button class="btn btn-primary mr-xs mb-sm save" title="<spring:message code='button.save' />"><spring:message code='button.save' /></button>
			<a href="${baseUri}/${curMenuVO.menuUri}" class="btn btn-default mr-xs mb-sm" title="<spring:message code='button.reset' />"><spring:message code='button.reset' /></a>
		</p>
	</div>
	</f:form>