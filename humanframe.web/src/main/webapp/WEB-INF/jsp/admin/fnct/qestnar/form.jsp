<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/taglibs.jsp" %>
<%@ page trimDirectiveWhitespaces="true" %>

	<script type="text/javascript" src="${globalAdminAssets}/smarteditor/js/HuskyEZCreator.js" charset="utf-8"></script>
	<!-- DatetimePicker -->
	<script type="text/javascript" src="${globalAdminAssets}/javascripts/plugins/jquery.datetimepicker.js"></script>
    <link rel="stylesheet" type="text/css" href="${globalAdminAssets}/stylesheets/plugins/jquery.datetimepicker.css">
	<script type="text/javascript">
	//사진첨부파일
	function preview(fileTy, sn){
		//alert(fileTy+'_preview'+sn);
		$('#'+fileTy+'File'+sn).setPreview({img: $('#'+fileTy+'_preview'+sn),w: 150,h: 150});
	}

	$.fn.setPreview = function(opt){
	    var defaultOpt = {
	        inputFile: $(this),
	        img: null,
	        w: 150,
	        //h: 150
	    };
	    $.extend(defaultOpt, opt);

	    var previewImage = function(){
	        if (!defaultOpt.inputFile || !defaultOpt.img) return;

	        var inputFile = defaultOpt.inputFile.get(0);
	        var img       = defaultOpt.img.get(0);

	        // FileReader
	        if (window.FileReader) {

	            if (!inputFile.files[0].type.match(/image\//)) return;

	            // preview
	            try {
	                var reader = new FileReader();
	                reader.onload = function(e){
	                    img.src = e.target.result;
	                    img.style.width  = defaultOpt.w+'px';
	                    //img.style.height = defaultOpt.h+'px';
	                    img.style.display = '';
	                }
	                reader.readAsDataURL(inputFile.files[0]);
	            } catch (e) {
	                // exception...
	            }
	        // img.filters (MSIE)
	        } else if (img.filters) {
	            inputFile.select();
	            inputFile.blur();
	            var imgSrc = document.selection.createRange().text;

	            img.style.width  = defaultOpt.w+'px';
	            //img.style.height = defaultOpt.h+'px';
	            img.style.filter = "progid:DXImageTransform.Microsoft.AlphaImageLoader(enable='true',sizingMethod='scale',src=\""+imgSrc+"\")";
	            img.style.display = '';
	        // no support
	        } else {
	            // Safari5, ...
	        }
	    };

	    // onchange
	    $(this).change(function(){
	        previewImage();
	    });

	    previewImage();

	};

	$(document).ready(function(){
		$("#bgnDttm, #endDttm").datetimepicker({lang:'ko', format:'Y-m-d H:i'});
	})

	$(function() {
		smEditor.init("cn");

		$("form[name='frm']").validate({
		    ignore: "input[type='text']:hidden",
		    rules : {
		    	sj : { required : true, maxlength:200 },
		    	bgnDttm: { required: true },
				endDttm: { required: true },
		    	othbcAt : { required : true },
		    	siteNo : { required : true, min : 1 }
		    },
		    messages : {
		    	sj : { required : "<spring:message code='errors.required' arguments='제목'/>", maxlength: jQuery.validator.format("{0}자 이하로 입력하세요") },
		    	bgnDttm: { required: "<spring:message code='errors.required' arguments='게시시작일시'/>"},
				endDttm: { required: "<spring:message code='errors.required' arguments='게시종료일시'/>"},
		    	othbcAt : { required : "공개여부를 선택하세요." },
		    	siteNo : { required : "맵핑 사이트를 선택하세요.", min : "맵핑 사이트를 선택하세요." }
		    	
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
		    	var crud = $("#crud").val();
		    	if(crud == "UPDATE" || crud == "CREATE"){
			    	if(confirm("입력하신 정보를 저장 하시겠습니까?")){
			    		smEditor.submit("cn");//editor
			    		frm.submit();
			    	}else{
			    		return false;
			    	}
		    	}else{
		    		if(confirm("삭제 하시겠습니까?")){
			    		frm.submit();
			    	}else{
			    		return false;
			    	}
		    	}
		    }
		});
	});

	function f_useAtChg(at){
		$.ajax({
			type : "post",
			url: './useAtChg',
			data: 'qestnarNo='+ $("#qestnarNo").val() + '&useAt='+ at,
			dataType: 'text', //전송받을 데이터의 타입
			contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
			success: function(data) {
				if(data =="true"){
					alert("상태 변경되었습니다.");
					location.reload();
				}else{
					alert("상태 변경에 실패하였습니다\n\n잠시후 다시 시도해 주시기 바랍니다.");
				}
			},
			error: function(data, status, err) {
				console.log('error forward : ' + data);
			}
		});

	}
	function f_remove(){
		if (confirm("사용여부를 변경하겠습니까?")) {
			$("#crud").val("DELETE");
			$("#frm").attr("action","./action").submit();
		}
	}
	function delFile(fileNo, type){
		if(confirm("삭제하시겠습니까?")){
			if(type == "IMG"){
				if($("#delAttachFileNo").val()==""){
					$("#delAttachFileNo").val(fileNo);
				}else{
					$("#delAttachFileNo").val($("#delAttachFileNo").val()+","+fileNo);
				}
				$("#attachFileViewDiv"+fileNo).remove();
				$("#attachFileDiv").show();
			}
		}
	}

	function f_FileCheck(obj) {

		if(obj.value != ""){

			/* 첨부파일 사이즈 체크*/
			var uploadFileSize = 0;
			var limitSize = 1024;

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

			$("#imgDcDiv").show();
		} else {
			$("#imgDcDiv").hide();
		}
	}

	</script>


			<!-- Start Breadcrumb -->
			<jsp:include page="/WEB-INF/jsp/admin/layout/breadcrumb.jsp">
				<jsp:param name="pageName" value="설문조사"/>
			</jsp:include>
			<!-- End Breadcrumb -->

            <!-- start: page -->
			<div class="row">
				<div class="col-sm-12">

				<section class="panel panel-featured panel-featured-primary">
					<header class="panel-heading">
						<div class="panel-actions">

						</div>
						<h2 class="panel-title">설문조사 등록/수정</h2>
					</header>

					<f:form name="frm" id="frm" modelAttribute="qestnarVO" method="post" enctype="multipart/form-data" action="./action" >
					<f:hidden path="crud" />
					<f:hidden path="qestnarNo" />
					<f:hidden path="menuNo" />
					<input type="hidden" id="delAttachFileNo" name="delAttachFileNo" value="" />

					<div class="panel-body">

						<div class="table-responsive">
							<table class="table table-bordered mb-none">
								<colgroup>
									<col style="width:100px" />
									<col />
								</colgroup>
								<tbody>
									<tr>
										<th>사이트 선택 <span class="required">*</span></th>
										<td>
											<f:select path="siteNo" cssClass="form-control">
												<f:option value="0" label="선택" />
												<c:forEach var="site" items="${siteList }" >
												<f:option value="${site.siteNo }" label="${site.siteNm }" />
												</c:forEach>
											</f:select>
										</td>
									</tr>
									<tr>
										<th>제목 <span class="required">*</span></th>
										<td><f:input path="sj" class="form-control" placeholder="제목" maxlength="200" title="제목"/></td>
									</tr>
									<tr>
										<th>내용</th>
										<td><f:textarea path="cn" class="form-control" style="width:100%;height:200px;" placeholder="내용" title="내용"/></td>
									</tr>
									<tr>
										<th>설문대상</th>
										<td>
											<div class="form-horizontal">
											<f:radiobuttons path="qustnrTrget" items="${qustnrTrgetCode}" class="form-control" element="div class='radio-custom radio-inline radio-primary'" />
											</div>
										</td>
									</tr>
									<tr>
										<th>설문기간 <span class="required">*</span></th>
										<td>
											<div class="form-inline">
												<span>
													<label for="bgnDttm"><i class="fa fa-calendar"></i></label>
													<f:input path="bgnDttm" cssClass="form-control" readonly="true" placeholder="설문시작일시" title="설문시작일시" />
												</span>
												~
												<span>
													<label for="endDttm"><i class="fa fa-calendar"></i></label>
													<f:input path="endDttm" cssClass="form-control" readonly="true" placeholder="설문종료일시" title="설문종료일시" />
												</span>
											</div>
										</td>
									</tr>
									<tr>
										<th>이미지</th>
										<td>
											<div id="previewDiv">
												<c:forEach var="imgFileVO" items="${listImgFile}" varStatus="status">
													<div class="help-block media" id="attachFileViewDiv${imgFileVO.fileNo}">
														<img class="media-object" src="/comm/getFile?srvcId=${imgFileVO.srvcId }&amp;upperNo=${imgFileVO.upperNo }&amp;fileTy=${imgFileVO.fileTy }&amp;fileNo=${imgFileVO.fileNo }&thumbTy=S" alt="${imgFileVO.orginlFileNm}"/>
														<a href="/comm/getFile?srvcId=${imgFileVO.srvcId }&amp;upperNo=${imgFileVO.upperNo }&amp;fileTy=${imgFileVO.fileTy }&amp;fileNo=${imgFileVO.fileNo }">${imgFileVO.orginlFileNm} (용량 : ${cmsFn:fileSize(imgFileVO.fileSize)}, 다운로드 : ${imgFileVO.dwldCo}회)</a>
														<a href="#delFile" onclick="delFile('${imgFileVO.fileNo}', 'IMG'); return false;"><i class="fa fa-trash"></i></a>
														<c:if test="${ !empty imgFileVO.fileDc and imgFileVO.fileDc ne '' }"><br>${imgFileVO.fileDc}</c:if>
													</div>
												</c:forEach>
											</div>

											<div id="attachFileDiv" style="<c:if test="${0 < fn:length(listImgFile) }">display:none;</c:if>">
												<span class="help-block" id="attachFileInputSpan" style="line-height:10px;">
													<input type="file" id="imgFile" name="imgFile" onchange="f_FileCheck(this);" accept="image/*" />
												</span>
												<div id="imgDcDiv" class="input-group input-group-sm" style="display:none;">
													<span class="input-group input-group-sm input-group-addon">설명</span>
													<input id="imgFileDc" name ="imgFileDc" class="form-control" placeholder="이미지설명" title="이미지설명">
												</div>
											</div>
										</td>
									</tr>
									<tr>
										<th>공개여부</th>
										<td>
											<div class="form-horizontal">
											<f:radiobuttons path="othbcAt" items="${othbcAtList }"  element="div class='radio-custom  radio-horizontal radio-inline radio-primary'"/>
											</div>
										</td>
									</tr>
								</tbody>
						</table>
						</div>
					</div>
					<footer class="panel-footer">
						<div class="row">
							<div class="col-sm-4">
								<c:set var="pageParam" value="othbcAt=${param.othbcAt }&amp;curPage=${param.curPage }&amp;searchText=${param.searchText}" />
								<a href="./list?${pageParam}" class="btn btn-default">목록</a>
							</div>
							<div class="col-sm-8 text-right">
								<cmsBtn2:btn btnTy="save" path="${curPath}" mngrSession="${mngrSession }" >저장</cmsBtn2:btn>
								<c:if test="${qestnarVO.crud eq 'UPDATE' && qestnarVO.useAt eq 'Y' }">
									<cmsBtn2:btn btnTy="use" path="${curPath}" mngrSession="${mngrSession }" script="f_useAtChg('N'); return false;" useAt="Y" >사용안함</cmsBtn2:btn>
								</c:if>
								<c:if test="${qestnarVO.crud eq 'UPDATE' && qestnarVO.useAt eq 'N' }">
									<cmsBtn2:btn btnTy="use" path="${curPath}" mngrSession="${mngrSession }" script="f_useAtChg('Y'); return false;" useAt="Y" >사용</cmsBtn2:btn>
								</c:if>
							</div>
						</div>
					</footer>

					</f:form>
				</section>
				</div>
			</div>


