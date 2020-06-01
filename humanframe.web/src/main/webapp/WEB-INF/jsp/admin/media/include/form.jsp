<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/taglibs.jsp" %>
<%@ page trimDirectiveWhitespaces="true" %>
		<script>
		function fileCheck(obj) {
			if(obj.value != ""){
				var atchLmttArr = new Array();
				atchLmttArr.push("jpg");
				atchLmttArr.push("gif");
				atchLmttArr.push("png");

				var file = obj.value;
				var fileExt = file.substring(file.lastIndexOf('.') + 1, file.length).toLowerCase();
				var isFileExt = false;

				for (var i = 0; i < atchLmttArr.length; i++) {
					if (atchLmttArr[i] == fileExt) {
						isFileExt = true;
						break;
					}
				}

				if (!isFileExt) {
					alert("미디어 썸네일은 이미지만 가능합니다. (" + atchLmttArr + ")");
					obj.value = "";
					return false;
				}
			}
		}

		function f_addLangCodeSet(){
			var langCode = $("#selLangCodeId option:selected").val();
			var langCodeNm = $("#selLangCodeId option:selected").text();
			if(langCode == ""){
				alert("언어를 먼저 선택하세요");
				return false;
			}
			var html = "";
			html = html + "<tr style=\"background-color:#fcf8e3;\" class=\""+langCode+"\"><th colspan=\"2\">";
			html = html + "<a class=\"btn\" onclick=\"f_delLangCodeSet('"+ langCode +"', '"+ langCodeNm +"'); return false;\">추가언어 항목 삭제 ("+ langCodeNm +") <i class=\"icon icon-remove\"></i></a> <input type=\"hidden\" name=\"addLangCodeId\" value=\"C-"+ langCode +"\"/>";
			html = html + "</th></tr>";
			html = html + "<tr style=\"background-color:#fcf8e3;\" class=\""+langCode+"\"><th>미디어 명 ("+ langCodeNm +")</th><td>";
			html = html + "<input id=\"addMediaNm_"+ langCode +"\" name=\"addMediaNm\" class=\"form-control\" type=\"text\" value=\"\"></td></tr>";
			html = html + "<tr style=\"background-color:#fcf8e3;\" class=\""+langCode+"\"><th>대체텍스트 ("+ langCodeNm +")</th><td>";
			html = html + "<textarea id=\"addSumry_"+ langCode +"\" name=\"addSumry\" class=\"form-control\"></textarea></td></tr>";

			$(html).insertAfter("#mediaTr");
			$("#selLangCodeId option:selected").remove();
		}

		function f_delLangCodeSet(lang, langNm){
			$("#selLangCodeId").append("<option value=\""+ lang +"\">"+ langNm +"</option>")
			$("."+lang).remove();
			$("#frmMedia").append("<input type='hidden' name='delLangCodeId' value='" + lang  + "' />");
		}

		function delFile(fileNo, type){
			if(confirm("삭제하시겠습니까?")){
				if(type == "MEDIA"){
					if($("#delMediaFileNo").val()==""){
						$("#delMediaFileNo").val(fileNo);
					}else{
						$("#delMediaFileNo").val($("#delMediaFileNo").val()+","+fileNo);
					}
					$("#mediafileViewSpan"+fileNo).remove();
					$("#mediafileInputSpan").show();
				}else if(type == "THUMB"){
					if($("#delThumbFileNo").val()==""){
						$("#delThumbFileNo").val(fileNo);
					}else{
						$("#delThumbFileNo").val($("#delThumbFileNo").val()+","+fileNo);
					}
					$("#thumbfileViewSpan"+fileNo).remove();
					$("#thumbfileInputSpan").show();
				}
			}
		}

		$(function() {
			//언어셋 삭제
			$("#selLangCodeId option[value='ko']").remove();
			<c:forEach var="mediaLang" items="${mediaVO.mediaLangList }" varStatus="status">
			$("#selLangCodeId option[value='${mediaLang.langCodeId}']").remove();
			</c:forEach>

			<c:if test="${mediaVO.streMthTy eq 'FILE'}">
			$("#htmlTr").hide();
			</c:if>
			<c:if test="${mediaVO.streMthTy eq 'HTML'}">
			$("#fileTr").hide();
			</c:if>
			$("input[name=streMthTy]").on("click", function(){
				$("#fileTr, #htmlTr").hide();
				if($(this).val() == "FILE"){
					$("#fileTr").show();
				}else if($(this).val() == "HTML"){
					$("#htmlTr").show();
				}
			});

			//validator addon
			$.validator.addMethod("checkMediaFile", function (value, element, params) {
				var streMthTy = $("input[name=streMthTy]:checked").val();
				//console.log("streMthTy: " + streMthTy + " mediafile: " + $("#mediaFile").val());
				if(streMthTy == "FILE" && $("#mediaFile").val() != ""){
			        return true;
				}else if(streMthTy == "HTML"){
					return true;
				}
				if($("#crud").val()=="UPDATE"){
					if($("#mediafileInputSpan").css("display") == "none"){
					return true;
					}
				}
				return false;
		    }, $.validator.format("{0}"));
			$.validator.addMethod("checkMediaHtml", function (value, element, params) {
				var streMthTy = $("input[name=streMthTy]:checked").val();
				if(streMthTy == "HTML" && $("#mediaHtml").val() != ""){
					return true;
				}else if(streMthTy == "FILE") {
					return true;
				}
				return false;
		    }, $.validator.format("{0}"));

			$.validator.addMethod("checkUri", function (value, element, params) {
				if(confirmUri){
					return true;
				}
				return false;
		    }, $.validator.format("{0}"));

			$.validator.addMethod("phoneUS", function(value, element) {
				value = value.replace(/\s+/g, "");
				return this.optional(element) || value.length > 9 &&
				value.match(/^\d{2,3}-\d{3,4}-\d{4}$/);
			}, $.validator.format("{0}"));

	        $("form[name='frmMedia']").validate({
	            ignore: "input[type='text']:hidden",
	            rules : {
	            	mediaCodeId	: { required : true },
	            	mediaNm 		: { required : true, maxlength : 50 },
	            	sumry 			: { required : false, maxlength : 20000 },
	            	mediaFile		: { checkMediaFile : true },
	            	mediaHtml		: { checkMediaHtml : true },
	            	chargerTelno	: { phoneUS : true },
	            	uriWrd2 		: { checkUri : true }
	            },
	            messages : {
	            	mediaCodeId	: { required : "미디어 분류를 선택하세요" },
	            	mediaNm 			: { required : "미디어 명을 입력하세요", maxlength : "{0}자 까지 입력 가능합니다." },
	            	sumry 			: { maxlength : "{0}자 까지 입력 가능합니다." },
	            	mediaFile		: { checkMediaFile : "미디어 파일을 첨부하세요" },
	            	mediaHtml		: { checkMediaHtml : "HTML 내용을 입력하세요" },
	            	chargerTelno	: { phoneUS : "전화번호가 유효하지 않습니다." },
	            	uriWrd2 		: { checkUri : "uri를 중복체크해주세요" }
	            },
	            errorElement: 'span',
	            errorClass: 'help-block error',
	            highlight:function(element, errorClass, validClass) {
	                $(element).addClass('error');
	            },
	            unhighlight: function(element, errorClass, validClass) {
	                $(element).removeClass('error');
	            },
	            submitHandler: function (frm) {
	            	$("#cpyrhtTy").val($("#lic2").val());
	            	
	            	if(document.getElementById("mediaFile").value!=""){
	            	    var fileSize = document.getElementById("mediaFile").files[0].size;	            	   
	            	    var maxSize = 20 * 1024 * 1024;//20MB	            	 
	            	    if(fileSize > maxSize){
	            	       alert("첨부파일 사이즈는 20MB 이내로 등록 가능합니다.");
	            	       return;
	            	    }					
	            	}	            	
	            	frm.submit();
	            }
	        });

	        var $usrCreatDePicker = $("#usrCreatDe");
			if ($usrCreatDePicker.length > 0) {
				//$pblicteDatePicker.datetimepicker({lang:'ko', format:'Y-m-d H:i' })
				$usrCreatDePicker.datepicker();
		        /* if($pblicteDatePicker.val() == ""){
		        	$pblicteDatePicker.val($.datepicker.formatDate('yy-mm-dd', new Date()))
		        } */
			}

			 var $pubDePicker = $("#pubDe");
				if ($pubDePicker.length > 0) {
					//$pblicteDatePicker.datetimepicker({lang:'ko', format:'Y-m-d H:i' })
					$pubDePicker.datepicker();
			        /* if($pblicteDatePicker.val() == ""){
			        	$pblicteDatePicker.val($.datepicker.formatDate('yy-mm-dd', new Date()))
			        } */
				}

		});

		function f_extSetting(obj){
			if(obj.value != ""){
				var file = obj.value;
				var fileExt = file.substring(file.lastIndexOf('.') + 1, file.length).toLowerCase();
				var date = new Date();
				$("#uriWrd2").val(date.getFullYear().toString()+(date.getMonth()+1).toString()+date.getDate().toString()+date.getHours().toString()+date.getMinutes().toString()+date.getSeconds().toString()+"."+fileExt);
				confirmUri = false;
			}
		}

		var confirmUri = false;
		if('${mediaVO.crud}' == "UPDATE"){
			confirmUri = true;
		}
		function f_dupUri(){
			var uriWrd = $("#uriWrd1").val()+"/"+$("#uriWrd2").val();
			var mediaNo = $("#mediaNo").val();

			$.ajax({
		        url: '/admin/ajax/media/dupUriAjax.json',
		        type: "post",
		        data: {"uriWrd": uriWrd, "mediaNo": mediaNo},
		        success : function(result) {
					if(!result){
						alert("사용하실수 있는 uri입니다.");
						confirmUri = true;
					}else{
						alert("사용하실수 없는 uri입니다.");
						$("#uriWrd2").val("");
					}
		        }, error : function(e){
					alert(e.messages);
				}
		    });
		}
		</script>

        <!-- start: page -->
        <f:form name="frmMedia" id="frmMedia" modelAttribute="mediaVO" method="post" action="./action" class="form-horizontal" enctype="multipart/form-data">
			<input type="hidden" id="searchKey" name="searchKey" value="${param.searchKey}" />
			<input type="hidden" id="searchText" name="searchText" value="${param.searchText}" />
			<input type="hidden" id="targetId" name="targetId" value="${param.targetId}" />
			<input type="hidden" id="curPage" name="curPage" value="${param.curPage}" />
			<input type="hidden" id="searchUseAt" name="searchUseAt" value="${param.searchUseAt}" />
			<input type="hidden" id="srchMediaCodeId" name="srchMediaCodeId" value="${param.srchMediaCodeId}" />

			<f:hidden path="crud" />
			<f:hidden path="mediaNo" />
			<f:hidden path="thumbOrgFileNm"		/>
			<f:hidden path="thumbStartWidth"		/>
			<f:hidden path="thumbStartHeight"		/>
			<f:hidden path="thumbEndWidth"		/>
			<f:hidden path="thumbEndHeight"		/>
			<f:hidden path="thumbImageNm"		/>
			<f:hidden path="cpyrhtTy"		/>
			<f:hidden path="creatDttm"		/>

			<input type="hidden" id="delThumbFileNo" name="delThumbFileNo" value=""/>
			<input type="hidden" id="delMediaFileNo" name="delMediaFileNo" value=""/>



		<div class="row">
			<div class="col-md-12">
			<section class="panel panel-featured panel-featured-primary">
				<header class="panel-heading">
					<h2 class="panel-title">미디어관리 등록/수정</h2>
				</header>
				<div class="panel-body">
					<div class="panel-group" id="accordion">
					<div class="panel panel-accordion">
						<div class="panel-heading">
							<h4 class="panel-title">
								<a class="accordion-toggle" >
									<i class="fa fa-edit"></i> 기본정보
								</a>
							</h4>
						</div>
						<div id="collapseOne" >
							<div class="panel-body p-none">
								<table class="table m-none">
									<colgroup>
										<col style="width:150px"/>
										<col />
									</colgroup>
									<tbody>
										<tr>
											<th>미디어 분류 <span class="required">*</span></th>
											<td>
												<f:select path="mediaCodeId" class="form-control">
													<f:option value="" label="선택하세요" />
													<c:forEach items="${mediaCodeList}" var="mediaCodeList">
													<option value="${mediaCodeList.codeId}" ${(empty mediaVO.mediaCodeId && fn:containsIgnoreCase(param.srchMediaCodeId, mediaCodeList.codeId)) || fn:containsIgnoreCase(mediaVO.mediaCodeId, mediaCodeList.codeId) ? 'selected' : ''}>${mediaCodeList.codeNm}</option>
													</c:forEach>
	                                            </f:select>
											</td>
										</tr>
										<tr>
											<th>언어항목 추가</th>
											<td>
												<div class="input-append">
												<div class="form-inline">
		                                            <select id="selLangCodeId" name="selLangCodeId" class="form-control">
														<option value="" selected="selected">선택하세요</option>
														<c:forEach items="${langCodeList}" var="langCodeList">
														<option value="${langCodeList.codeId}">${langCodeList.codeNm }</option>
														</c:forEach>
		                                            </select>
		                                            <button class="btn btn-info" type="button" onclick="f_addLangCodeSet(); return false;">항목추가</button>
	                                           </div>
	                                            </div>

											</td>
										</tr>
										<tr>
											<th>미디어 명 (한국어)<span class="required">*</span></th>
											<td><f:input path="mediaNm" class="form-control"/></td>
										</tr>
										<tr id="mediaTr">
											<th>대체텍스트 (한국어)</th>
											<td>
												<f:textarea path="sumry" class="form-control"/>
											</td>
										</tr>
										<c:forEach var="mediaLang" items="${mediaVO.mediaLangList }" varStatus="status">
										<tr style="background-color:#fcf8e3;" class="${mediaLang.langCodeId}">
											<th colspan="2">
												<a class="btn" onclick="f_delLangCodeSet('${mediaLang.langCodeId}', '${mediaLang.langCodeNm }'); return false;">추가언어 항목 삭제 (${mediaLang.langCodeNm }) <i class="icon icon-remove"></i></a>
												<input type="hidden" name="addLangCodeId" value="U-${mediaLang.langCodeId }" /></th>
										</tr>
										<tr style="background-color:#fcf8e3;" class="${mediaLang.langCodeId}">
											<th>미디어 명 (${mediaLang.langCodeNm})</th>
											<td><input id="addMediaNm_${mediaLang.langCodeId}" name="addMediaNm" class="form-control" type="text" value="${mediaLang.mediaNm}" /></td>
										</tr>
										<tr style="background-color:#fcf8e3;" class="${mediaLang.langCodeId}">
											<th>대체텍스트 (${mediaLang.langCodeNm})</th>
											<td><textarea id="addSumry_${mediaLang.langCodeId}" name="addSumry" class="form-control">${mediaLang.sumry}</textarea></td>
										</tr>
										</c:forEach>
										<tr>
											<th>미디어 썸네일</th>
											<td>
												<c:forEach var="thumbFile" items="${mediaVO.thumbFileList }" varStatus="status">
												<span class="help-block" id="thumbfileViewSpan${thumbFile.fileNo}">
												<c:if test="${fn:toLowerCase(mediaVO.cpyrhtTy) eq '' }">
													<a href="/comm/getFile?srvcId=${thumbFile.srvcId }&amp;upperNo=${thumbFile.upperNo }&amp;fileTy=${thumbFile.fileTy }&amp;fileNo=${thumbFile.fileNo }">${thumbFile.orginlFileNm} (${cmsFn:fileSize(thumbFile.fileSize)})</a>
												</c:if>
												<c:if test="${fn:toLowerCase(mediaVO.cpyrhtTy) ne '' }">
													<a href="/comm/getFile?srvcId=${thumbFile.srvcId }&amp;upperNo=${thumbFile.upperNo }&amp;fileTy=${thumbFile.fileTy }&amp;fileNo=${thumbFile.fileNo }">${thumbFile.orginlFileNm} (${cmsFn:fileSize(thumbFile.fileSize)})</a>
												</c:if>
													<a href="#delFile" onclick="delFile('${thumbFile.fileNo}', 'THUMB'); return false;"><i class="fa fa-trash"></i></a>
												</span>
												</c:forEach>
												<div id="thumbfileDiv">
													<span id="thumbfileInputSpan" <c:if test="${fn:length(mediaVO.thumbFileList) > 0 }">style="display:none;"</c:if>>
														<input type="file" id="mediaThumbFile" name="mediaThumbFile" onchange="f_ImgPreview();" />
													</span>
												</div>
												<span class="help-block">* 썸네일 사용시 업로드 해야합니다.</span>
											</td>
										</tr>
										<tr class="thumbEdit" style="display: none;">
											<th>썸네일편집</th>
											<td>
												<div class="radio-custom radio-primary">
												<input type="radio" name="thumbType" id="thumbOrg" value="org" onchange="f_ShowImg();" checked="checked" />
												<label for="thumbOrg">원본</label>
												</div>
												<div class="radio-custom radio-primary">
												<input type="radio" name="thumbType" id="thumbEdit" value="edit" onchange="f_ShowImg();" />
												<label for="thumbEdit">영역지정</label>
												</div>
											</td>
										</tr>
										<tr class="thumbEdit" style="display: none;">
											<td colspan="2">
												<div class="cropDiv"></div>
											</td>
										</tr>
										<tr>
											<th>저장 방법 <span class="required">*</span></th>
											<td>
												<div class="radio-group">
												<f:radiobuttons path="streMthTy" items="${streMthTyCode}" element="div class='radio-custom radio-primary'"/>
												</div>
											</td>
										</tr>
										<tr id="fileTr">
											<th>미디어 파일 <span class="required">*</span></th>
											<td>
												<c:forEach var="mediaFile" items="${mediaVO.mediaFileList }" varStatus="status">
												<span class="help-block" id="mediafileViewSpan${mediaFile.fileNo}">
												<c:if test="${fn:toLowerCase(mediaVO.cpyrhtTy) eq '' }">
													<a href="/comm/getFile?srvcId=${mediaFile.srvcId }&amp;upperNo=${mediaFile.upperNo }&amp;fileTy=${mediaFile.fileTy }&amp;fileNo=${mediaFile.fileNo }">${mediaFile.orginlFileNm} (${cmsFn:fileSize(mediaFile.fileSize)})</a>
												</c:if>
												<c:if test="${fn:toLowerCase(mediaVO.cpyrhtTy) ne '' }">
													<a href="/comm/getFile?srvcId=${mediaFile.srvcId }&amp;upperNo=${mediaFile.upperNo }&amp;fileTy=${mediaFile.fileTy }&amp;fileNo=${mediaFile.fileNo }">${mediaFile.orginlFileNm} (${cmsFn:fileSize(mediaFile.fileSize)})</a>
												</c:if>
													<a href="#delFile" onclick="delFile('${mediaFile.fileNo}', 'MEDIA'); return false;"><i class="fa fa-trash"></i></a>
												</span>
												</c:forEach>
												<div id="mediafileDiv">
												<span id="mediafileInputSpan" <c:if test="${fn:length(mediaVO.mediaFileList) > 0 }">style="display:none;"</c:if>><input type="file" id="mediaFile" name="mediaFile" onchange="f_extSetting(this);"/></span>
												</div>
												<span class="help-block">* 첨부파일 사이즈는 20MB 이내로 등록 가능합니다.</span>
											</td>
										</tr>
										<tr id="htmlTr">
											<th>HTML <span class="required">*</span></th>
											<td>
												<f:textarea path="mediaHtml" class="form-control" style="height:100px;"/>
											</td>
										</tr>
										<tr>
											<th>CCL/공공누리</th>
											<td>
												<select name="lic2" id="lic2" class="form-control">
													<option value=""><spring:message code='form.select.default' /></option>
													<c:forEach items="${licCodeList}" var="list">
													<option value="${list.codeId}" <c:if test="${list.codeId eq mediaVO.cpyrhtTy}">selected="selected"</c:if>>${list.codeNm}</option>
													</c:forEach>
												</select>
											</td>
										</tr>
										<tr>
											<th>URI</th>
											<td>
											<div class="form-inline">
												<f:hidden path="uriWrd1" />
												<span>${mediaVO.uriWrd1}/</span>
												<f:input path="uriWrd2" class="form-control"/>
												<button class="btn btn-info" type="button" onclick="f_dupUri(); return false;">중복체크</button>
											</div>
											</td>
										</tr>
										<tr>
											<th>통합검색 노출여부 <span class="required">*</span></th>
											<td>
												<div class="radio-group">
												<f:radiobuttons path="srchAt" items="${useAtCode}" element="div class='radio-custom radio-primary'" />
												</div>
											</td>
										</tr>
										<tr>
											<th>사용여부 <span class="required">*</span></th>
											<td>
												<div class="radio-group">
												<f:radiobuttons path="useAt" items="${useAtCode}" element="div class='radio-custom radio-primary'" />
												</div>
											</td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>
					</div>
					<div class="panel panel-accordion">
						<div class="panel-heading">
							<h4 class="panel-title">
								<a class="accordion-toggle" data-toggle="collapse" href="#collapseTwo" >
									<i class="fa fa-file-text"></i> 메타정보
								</a>
							</h4>
						</div>
						<div id="collapseTwo" class="accordion-body collapse">
							<div class="panel-body p-none">
								<table class="table m-none">
									<colgroup>
										<col style="width:150px"/>
										<col />
									</colgroup>
									<tbody>
										<tr>
											<th>정보원</th>
											<td><f:input path="source" id="source" class="form-control" /></td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>
					</div>
					</div>
				</div>

				<footer class="panel-footer">
					<div class="row">
						<div class="col-sm-7">
							<c:set var="pageParam" value="curPage=${param.curPage }&amp;searchKey=${param.searchKey}&amp;searchText=${param.searchText}&amp;srchMediaCodeId=${param.srchMediaCodeId }&amp;targetId=${param.targetId}&amp;useAt=${param.useAt}" />
							<a href="./list?${pageParam}" class="btn btn-default">목록</a>
						</div>
						<div class="col-sm-5 text-right">
							<cmsBtn2:btn btnTy="save" path="${curPath}" mngrSession="${mngrSession }" >저장</cmsBtn2:btn>
		                 </div>
					</div>
				</footer>
			</section>
			</div>
		</div>

	</f:form>
