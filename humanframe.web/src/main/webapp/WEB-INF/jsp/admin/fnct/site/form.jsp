<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ include file="/common/taglibs.jsp" %>

	<script type="text/javascript">
	$( document ).ready( function() {
        $('input[name="writngDe"],[name="bgnDttm"],[name="endDttm"]').datepicker({
            format: "yyyy-mm-dd",
            maxViewMode: 2,
            todayBtn: "linked",
            language: "kr",
            clearBtn: false,
            autoclose: true,
            todayHighlight: true
        });
        <c:if test="${siteMainVO.siteMainNo eq 0}">
        if($('input[name="bgnDttm"]').val() == ""){
        	$('input[name="bgnDttm"]').datepicker('update', new Date());
        }
        if($('input[name="endDttm"]').val() == ""){
        	$('input[name="endDttm"]').datepicker('update', new Date((new Date()).valueOf() + 1000*3600*24*7)); // +7day
        }
        </c:if>
        
        $.validator.addMethod("nttSjCk",  function( value, element ) {
			return this.optional(element) ||  /^[ㄱ-ㅎ\s|가-힣\s|a-z\s|A-Z\s|0-9\s|\*]+$/.test(value);
		});
       
		$("form[name='frmSiteMain']").validate({
		    ignore: "input[type='text']:hidden",
		    rules : {
		    	nttCl	: { required : true },
		    	nttSj	: { required : true/* , nttSjCk : true  */},
		    	writngDe	: { required : true },
		    	linkUrl : { required : true },
		    	linkTrgt : { required : true },
				bgnDttm : { required: "#checkAlways:not(:checked)" },
		    	endDttm : { required: "#checkAlways:not(:checked)" }
		    },
		    messages : {
		    	nttCl	: { required : "메인분류를 선택하세요" },
		    	nttSj : { required : "제목을 입력하세요"/* , nttSjCk : "영어,한글,숫자만 입력하세요." */},
		    	writngDe	: { required : "작성일을 입력하세요" },
		    	linkUrl : { required : "링크URL을 입력하세요" },
		    	linkTrgt : { required : "링크타켓을 선택하세요" },
		    	bgnDttm : { required : "게시 시작일을 선택하세요" },
		    	endDttm : { required : "게시 종료일을 선택하세요" }
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

		    	var arrUpdateDc = [];
		    	$("input[data-update-dc]").each(function(){
		    		arrUpdateDc.push($(this).attr("name"));
		    	});
		    	if(arrUpdateDc.length>0){
			    	$("input#updtImgFileDc").val(arrUpdateDc.join(","));
		    	}

		    	if(confirm("입력하신 정보를 저장 하시겠습니까?")){
		    		frm.submit();
		    	}else{
		    		return false;
		    	}
		    }
		});

	});

	$(document).on("click","#checkAlways",function(){
		if($("#checkAlways").is(":checked")){
			varBgnDttm = $("#bgnDttm").val();
			varEndDttm = $("#endDttm").val();
			$("#bgnDttm").val("");
			$("#endDttm").val("");
		}else{
			$("#bgnDttm").val(varBgnDttm);
			$("#endDttm").val(varEndDttm);
		}
	}).on("change","#bgnDttm,#endDttm",function(){
		if($("#checkAlways").is(":checked")){
			$("#checkAlways").prop("checked",false);
		}
	});


	function fn_siteList(){
		var url = "/admin/siteMain/nttList?siteNo=${siteMainVO.siteNo}";
		var width = 1300;
	    var height = 630;
		var top = (screen.availHeight - height) / 2;
	    var left = (screen.availWidth - width) / 2;
		var mngrWin = window.open(url, "mngrPopup", "width=" + width + ",height=" + height + ", scrollbars=yes, top=" + top + ", left=" + left);
		mngrWin.focus();
	}

	function fileCheck(obj) {

		if(obj.value != ""){

			/* 첨부파일 확장자 체크*/
			var atchLmttArr = new Array();
			atchLmttArr.push("jpg");
			atchLmttArr.push("png");
			atchLmttArr.push("gif");

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
				alert("<spring:message code='errors.ext.limit' arguments='" + atchLmttArr + "' />");
				obj.value = "";
				return false;
			}
			/* 첨부파일 확장자 체크*/

			/* 첨부파일 사이즈 체크*/
			var uploadFileSize = 0;
			var limitSize = 2;

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
	}

	function delFile(fileNo, type, spanNo){
		if(confirm("삭제하시겠습니까?")){
			if(type == "ATTACH"){
				if($("#delAttachFileNo").val()==""){
					$("#delAttachFileNo").val(fileNo);
				}else{
					$("#delAttachFileNo").val($("#delAttachFileNo").val()+","+fileNo);
				}
				$("#attachFileViewDiv"+fileNo).remove();
				$("#attachFileInputDiv"+spanNo).show();
			}
		}
	}
	
	function strip_tag(str){	
	    return str.replace(/(<([^>]+)>)/ig,"");
	}
	
	</script>


			<!-- Start Breadcrumb -->
			<jsp:include page="/WEB-INF/jsp/admin/layout/breadcrumb.jsp">
				<jsp:param name="pageName" value="메인 관리"/>
			</jsp:include>
			<!-- End Breadcrumb -->

            <!-- start: page -->
			<div class="row">

				<f:form name="frmSiteMain" id="frmSiteMain" modelAttribute="siteMainVO" method="post" action="./action" enctype="multipart/form-data" class="form-horizontal">
				<f:hidden path="crud" />
				<f:hidden path="siteNo" />
				<f:hidden path="siteMainNo" />
				<input type="hidden" id="delAttachFileNo" name="delAttachFileNo" value="" />
				<input type="hidden" id="updtImgFileDc" name="updtImgFileDc" value="" />

				<div class="col-sm-12 p-none">
				<section class="panel panel-featured panel-featured-primary">
					<header class="panel-heading">
						<div class="panel-actions">

						</div>
						<h2 class="panel-title">메인 등록/수정</h2>
					</header>
					<div class="panel-body">

						<table class="table">
							<colgroup>
								<col style="width:100px"/>
								<col />
							</colgroup>
							<tbody>
								<tr>
									<th>메인분류 <span class="required">*</span></th>
									<td>
										<f:select path="nttCl" cssClass="form-control">
											<c:forEach items="${siteMainCodeTy}" var="siteMainCode">
											<f:option value="${siteMainCode.codeId}" label="${siteMainCode.codeNm }" />
											</c:forEach>
										</f:select>
									</td>
								</tr>
								<tr>
									<th>제목 <span class="required">*</span></th>
									<td>
										<f:input path="nttSj" class="form-control" placeholder="제목" maxlength="200" onkeyup="strip_tag(this.value);"/>
									</td>
								</tr>
								<tr>
									<th>부제목</th>
									<td>
										<f:input path="nttSubSj" class="form-control" placeholder="부제목" maxlength="200"/>
									</td>
								</tr>
								<tr>
									<th>내용</th>
									<td>
										<f:textarea path="nttCn" class="form-control" placehoder="내용" rows="3"/>
									</td>
								</tr>
								<tr>
									<th>작성일 <span class="required">*</span></th>
									<td>
										<div class="form-inline">
										<f:input path="writngDe" class="form-control" placeholder="작성일"/>
										</div>
									</td>
								</tr>
								<tr>
									<th>이미지 파일</th>
									<td>
										<c:forEach var="fileList" items="${siteMainVO.fileList }" varStatus="status">
										<div class="help-block" id="attachFileViewDiv${fileList.fileNo}">
											<img src="/comm/getImage?srvcId=${fileList.srvcId }&amp;upperNo=${fileList.upperNo }&amp;fileTy=${fileList.fileTy }&amp;fileNo=${fileList.fileNo }&amp;thumbTy=S">
											<a href="/comm/getFile?srvcId=${fileList.srvcId }&amp;upperNo=${fileList.upperNo }&amp;fileTy=${fileList.fileTy }&amp;fileNo=${fileList.fileNo }">${fileList.orginlFileNm} (용량 : ${cmsFn:fileSize(fileList.fileSize)}, 다운로드 : ${fileList.dwldCo}회)</a>
											<a href="#delFile" class="btn btn-danger btn-xs ml-xs" onclick="delFile('${fileList.fileNo}', 'ATTACH', '${status.index}'); return false;"><i class="fa fa-trash text-danger-inverse"></i> 삭제</a>
											<div class="input-group input-group-sm">
												<span class="input-group-addon">
													<i class="fa fa-blind"></i>
													대체문구
												</span>
												<input class="form-control" id="updtAttachFileDc${fileList.fileNo}" name="updtAttachFileDc${fileList.fileNo}" value="${fileList.fileDc}" data-plugin-maxlength maxlength="200" data-update-dc>
											</div>
										</div>
										</c:forEach>

										<div id="attachFileDiv">
										<c:forEach begin="0" end="0" varStatus="status"><!-- 첨부파일 갯수 -->
										<div class="row" id="attachFileInputDiv${status.index}" <c:if test="${status.index < fn:length(siteMainVO.fileList) }">style="display:none;"</c:if>>
											<div class="col-md-4">
												<input type="file" class="form-control-static" id="attachFile${status.index}" name="attachFile${status.index}" onchange="fileCheck(this);" />
											</div>
											<div class="col-md-8">
												<div class="input-group input-group-sm">
												<span class="input-group-addon">
													<i class="fa fa-blind"></i>
													대체문구
												</span>
												<input class="form-control" id="attachFileDc${status.index}" name="attachFileDc${status.index}" data-plugin-maxlength maxlength="200">
												</div>
											</div>
										</div>
										</c:forEach>
										</div>
									</td>
								</tr>
								<tr>
									<th>링크URL <span class="required">*</span></th>
									<td>
										<f:input path="linkUrl" class="form-control" placeholder="ex) http://" maxlength="250"/>
									</td>
								</tr>
								<tr>
									<th>링크 타겟 <span class="required">*</span></th>
									<td>
										<f:radiobuttons path="linkTrgt" items="${linkTrgtTyCode}" class="form-control" element="div class='radio-custom radio-inline radio-primary'"  />
									</td>
								</tr>
								<tr>
									<th>게시기간 <span class="required">*</span></th>
									<td>
										<div class="form-inline">
										<f:input path="bgnDttm" cssClass="form-control" readonly="true" /> ~
										<f:input path="endDttm" cssClass="form-control mr-sm" readonly="true" />

										<div class="checkbox-custom checkbox-text-primary checkbox-inline">
										<input type="checkbox" name="checkAlways" id="checkAlways" <c:if test="${siteMainVO.crud ne 'CREATE' and empty siteMainVO.bgnDttm and empty siteMainVO.bgnDttm}">checked</c:if>>
										<label for="checkAlways">상시사용</label>
										</div>

										</div>
									</td>
								</tr>
								<tr>
									<th>사용여부 <span class="required">*</span></th>
									<td>
										<f:radiobuttons path="useAt" items="${useAtCode}"  class="form-control" element="div class='radio-custom radio-inline radio-primary'" />
									</td>
								</tr>
								<tr>
									<th>게시순서</th>
									<td>
										<f:input path="siteSeq" class="form-control"/>
									</td>
								</tr>
							</tbody>
						</table>

					</div>
					<footer class="panel-footer">
						<div class="row">
							<div class="col-sm-6">
								<c:set var="pageParam" value="siteNo=${param.siteNo}" />
								<a href="./list?${pageParam}" class="btn btn-default">목록</a>
							</div>
							<div class="col-sm-6 text-right">
								<button type="button" class="btn btn-success" onclick="javascript:fn_siteList();">선택</button>
                                <cmsBtn2:btn btnTy="save" path="${curPath}" mngrSession="${mngrSession }" >저장</cmsBtn2:btn>
							</div>
						</div>
					</footer>

				</section>
				</div>
			</f:form>
			</div>

