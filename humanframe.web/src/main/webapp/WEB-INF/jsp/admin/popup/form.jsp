<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/taglibs.jsp" %>
<%@ page trimDirectiveWhitespaces="true" %>

			<script>
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

			var tmpPopupTop = $("input[name='popupTop']").val();
			var tmpPopupLeft = $("input[name='popupLeft']").val();
			var tmpPopupWidth = $("input[name='popupWidth']").val();
			$(document).on("change","input[name='popupTy']",function(){
				switch($(this).val()){
				case "3":
					tmpPopupTop = $("input[name='popupTop']").val();
					tmpPopupLeft = $("input[name='popupLeft']").val();
					tmpPopupWidth = $("input[name='popupWidth']").val();
					$("div[data-popupty-use]").find("*").addClass("text-muted");
					$("div[data-popupty-use]").find("input").val("0");
					$("div[data-popupty-use]").find("input").prop("readonly",true);
					$("p[data-popupty-use]").show();
					break;
				default:
					$("input[name='popupTop']").val(tmpPopupTop?tmpPopupTop:0);
					$("input[name='popupLeft']").val(tmpPopupLeft?tmpPopupLeft:0);
					$("input[name='popupWidth']").val(tmpPopupWidth?tmpPopupWidth:0);
					$("div[data-popupty-use]").find("*").removeClass("text-muted");
					$("div[data-popupty-use]").find("input").prop("readonly",false);
					$("p[data-popupty-use]").hide();
					break;
				}
			});

			$(function() {

		        $('input[name="bgnDttm"],[name="endDttm"]').datepicker({
		            format: "yyyy-mm-dd",
		            maxViewMode: 2,
		            todayBtn: "linked",
		            language: "kr",
		            clearBtn: false,
		            autoclose: true,
		            todayHighlight: true
		        });
		        if($('input[name="bgnDttm"]').val() == ""){
		        	$('input[name="bgnDttm"]').datepicker('update', new Date());
		        }
		        if($('input[name="endDttm"]').val() == ""){
		        	$('input[name="endDttm"]').datepicker('update', new Date((new Date()).valueOf() + 1000*3600*24*7)); // +7day
		        }
				$("form[name='frmPopup']").validate({
				    ignore: "input[type='text']:hidden",
				    rules : {
				    	popupTy	: { required : true},
				    	popupSj	: { required : true },
				    	siteNo : { required : true },
				    	popupTop : { required : true },
				    	popupLeft : { required : true },
				    	popupWidth : { required : true },
				    	popupHeight : { required : true },
				    	<c:if test="${empty popupVO.fileList}">
				    	attachFile0 : { required : true },
				    	</c:if>
				    	linkUrl : { required : true },
				    	bgnDttm : { required : true },
				    	endDttm : { required : true }
				    },
				    messages : {
				    	popupTy	: {required : "팝업 종류를 선택하세요"},
				    	popupSj	: { required : "제목을 입력하세요"},
				    	siteNo : { required : "사이트를 선택하세요" },
				    	popupTop : { required : "위치를 입력하세요" },
				    	popupLeft : { required : "위치를 입력하세요" },
				    	popupWidth : { required : "크기를 입력하세요" },
				    	popupHeight : { required : "크기를 입력하세요" },
				    	<c:if test="${empty popupVO.fileList}">
				    	attachFile0 : { required : "이미지를 선택하세요" },
				    	</c:if>
					    linkUrl : { required : "링크주소를 입력하세요" },
				    	bgnDttm : { required : "게시 시작일을 선택하세요" },
				    	endDttm : { required : "게시 종료일을 선택하세요" }
				    },
				    errorElement: 'span',
				    errorClass: 'help-block error',
				    errorPlacement: function(error, element) {
				    	error.insertAfter(element.parent().find(':last'));
// 				    	error.appendTo(element.closest("td"));
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
			</script>

			<!-- Start Breadcrumb -->
			<jsp:include page="/WEB-INF/jsp/admin/layout/breadcrumb.jsp">
				<jsp:param name="pageName" value="팝업 관리"/>
			</jsp:include>
			<!-- End Breadcrumb -->

            <!-- start: page -->
			<div class="row">
				<div class="col-md-12">
				<section class="panel panel-featured panel-featured-primary">
					<header class="panel-heading">
						<div class="panel-actions">

						</div>
						<h2 class="panel-title">팝업 등록</h2>
						<p class="panel-subtitle">
						</p>
					</header>

					<f:form name="frmPopup" id="frmPopup" modelAttribute="popupVO" method="post" action="./action" enctype="multipart/form-data" class="form-horizontal">
					<f:hidden path="crud" />
					<f:hidden path="popupNo" />
					<input type="hidden" id="delAttachFileNo" name="delAttachFileNo" value="" />
					<input type="hidden" id="updtImgFileDc" name="updtImgFileDc" value="" />

					<div class="panel-body">
						<table class="table">
							<colgroup>
								<col style="width:100"/>
								<col />
							</colgroup>
							<tbody>
								<tr>
									<th>사이트 선택 <span class="required">*</span></th>
									<td>
										<f:select path="siteNo" cssClass="form-control populate">
											<option value="">선택하세요</option>
											<c:forEach items="${siteListAll}" var="siteListAll">
											<f:option value="${siteListAll.siteNo}" label="${siteListAll.siteNm}" />
											</c:forEach>
										</f:select>
									</td>
								</tr>
								<tr>
									<th>팝업 종류 선택 <span class="required">*</span></th>
									<td>
										<f:radiobuttons path="popupTy" items="${popupTy}" element="div class='radio-custom radio-inline radio-primary'" />
										<%--
										<f:select path="popupTy" cssClass="form-control">
											<option value="">선택하세요</option>
											<c:forEach items="${popupTyList}" var="popupTy">
											<f:option value="${popupTy.codeId}" label="${popupTy.codeNm}" />
											</c:forEach>
										</f:select>
										 --%>
									</td>
								</tr>
								<tr>
									<th>제목 <span class="required">*</span></th>
									<td>
										<f:input path="popupSj" class="form-control" placeholder="제목" maxlength="200"/>
									</td>
								</tr>
								<tr>
									<th>팝업창 위치 <span class="required">*</span></th>
									<td>
										<div class="form-inline">
										<div class="input-group" data-popupty-use><span class="input-group-addon">TOP</span><f:input path="popupTop" cssClass="form-control" readonly="${popupVO.popupTy eq 3}"/></div>
										<div class="input-group" data-popupty-use><span class="input-group-addon">LEFT</span><f:input path="popupLeft" cssClass="form-control" readonly="${popupVO.popupTy eq 3}"/></div>
										</div>
									</td>
								</tr>
								<tr>
									<th>팝업창 사이즈 <span class="required">*</span></th>
									<td>
										<div class="form-inline">
										<div class="input-group" data-popupty-use><span class="input-group-addon">가로</span><f:input path="popupWidth" cssClass="form-control" readonly="${popupVO.popupTy eq 3}"/></div>
										<div class="input-group"><span class="input-group-addon">세로</span><f:input path="popupHeight" cssClass="form-control" /></div>
										</div>
										<p class="mb-none mt-xs" data-popupty-use <c:if test="${popupVO.popupTy ne 3}">style="display:none"</c:if>>
										 <i class="fa fa-info-circle"></i> <code>띠배너</code>는 세로 값을 띠배너의 높이 값으로 사용합니다.
										</p>
									</td>
								</tr>
								<tr>
									<th>이미지 파일 <span class="required">*</span></th>
									<td>
										<c:forEach var="fileList" items="${popupVO.fileList }" varStatus="status">
										<div id="attachFileViewDiv${fileList.fileNo}">
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
										<div class="row" id="attachFileInputDiv${status.index}" <c:if test="${status.index < fn:length(popupVO.fileList) }">style="display:none;"</c:if>>
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
									<th>링크 <span class="required">*</span></th>
									<td>
										<f:input path="linkUrl" class="form-control" placeholder="ex) http://" maxlength="250"/>
									</td>
								</tr>
								<tr>
									<th>링크 타겟 <span class="required">*</span></th>
									<td>
										<f:radiobuttons path="linkTrgt" items="${linkTrgtTyCode}" element="div class='radio-custom radio-inline radio-primary'"/>
									</td>
								</tr>
								<tr>
									<th>게시기간 <span class="required">*</span></th>
									<td>
										<div class="form-inline">
										<f:input path="bgnDttm" cssClass="form-control" readonly="true" /> ~
										<f:input path="endDttm" cssClass="form-control" readonly="true" />
										</div>
									</td>
								</tr>
								<tr>
									<th>그만보기 여부 <span class="required">*</span></th>
									<td>
										<f:radiobuttons path="stopViewAt" items="${useAtCode}" element="div class='radio-custom radio-inline radio-primary'"/>
									</td>
								</tr>
								<tr>
									<th>사용여부 <span class="required">*</span></th>
									<td>
										<f:radiobuttons path="useAt" items="${useAtCode}" element="div class='radio-custom radio-inline radio-primary'"/>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
					<footer class="panel-footer">
						<div class="row">
							<div class="col-sm-6">
								<c:set var="pageParam" value="useAt=${param.useAt }&amp;curPage=${param.curPage }&amp;searchKey=${param.searchKey}&amp;searchText=${param.searchText}" />
								<a href="./list?${pageParam}" class="btn btn-default">목록</a>
							</div>
							<div class="col-sm-6 text-right">
                                <cmsBtn2:btn btnTy="save" path="${curPath}" mngrSession="${mngrSession }" >저장</cmsBtn2:btn>
							</div>
						</div>
					</footer>

					</f:form>

				</section>
				</div>

			</div>