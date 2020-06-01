<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/taglibs.jsp" %>
<%@ page trimDirectiveWhitespaces="true" %>

			<!-- Smart Editor -->
    		<script type="text/javascript" src="${globalAdminAssets}/smarteditor/js/HuskyEZCreator.js" charset="utf-8"></script>

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
					if(type == "PC"){
						if($("#delPcImgFileNo").val()==""){
							$("#delPcImgFileNo").val(fileNo);
						}
						else{
							$("#delPcImgFileNo").val($("#delPcImgFileNo").val()+","+fileNo);
						}
						$("#pcImgFileViewDiv"+fileNo).remove();
						$("#pcImgFileInputDiv"+spanNo).show();
					}
					else if(type == "TABLET"){
						if($("#delTabletImgFileNo").val()==""){
							$("#delTabletImgFileNo").val(fileNo);
						}
						else{
							$("#delTabletImgFileNo").val($("#delTabletImgFileNo").val()+","+fileNo);
						}
						$("#tabletImgFileViewDiv"+fileNo).remove();
						$("#tabletImgFileInputDiv"+spanNo).show();
					}
					else{
						if($("#delMobileImgFileNo").val()==""){
							$("#delMobileImgFileNo").val(fileNo);
						}
						else{
							$("#delMobileImgFileNo").val($("#delMobileImgFileNo").val()+","+fileNo);
						}
						$("#mobileImgFileViewDiv"+fileNo).remove();
						$("#mobileImgFileInputDiv"+spanNo).show();
					}
				}
			}

			$(function() {

				smEditor.init("sumry");

		        $('input[name="ntceBgnde"],[name="ntceEndde"]').datepicker({
		            format: "yyyy-mm-dd",
		            maxViewMode: 2,
		            todayBtn: "linked",
		            language: "kr",
		            clearBtn: false,
		            autoclose: true,
		            todayHighlight: true
		        });
		        <c:if test="${bannerVO.bannerNo eq 0}">
		        if($('input[name="ntceBgnde"]').val() == ""){
		        	$('input[name="ntceBgnde"]').datepicker('update', new Date());
		        }
		        if($('input[name="ntceEndde"]').val() == ""){
		        	$('input[name="ntceEndde"]').datepicker('update', new Date((new Date()).valueOf() + 1000*3600*24*7)); // +7day
		        }
		        </c:if>
				$("form[name='frmBanner']").validate({
				    ignore: "input[type='text']:hidden",
				    rules : {
				    	sj		: { required : true },
				    	<c:if test="${empty bannerVO.pcFileList}">
				    	pcImgFile0 : { required : true },
				    	</c:if>
						ntceBgnde : { required: "#checkNtce:not(:checked)" },
				    	ntceEndde : { required: "#checkNtce:not(:checked)" }

				    },
				    messages : {
				    	sj		: { required : "제목을 입력하세요"},
				    	<c:if test="${empty bannerVO.pcFileList}">
				    	pcImgFile0 : { required : "이미지를 선택하세요" },
				    	</c:if>
					    ntceBgnde : { required : "게시 시작일을 선택하세요" },
				    	ntceEndde : { required : "게시 종료일을 선택하세요" }
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
							if($("#siteNo option").length > 0){
								$("#siteNo option").each(function(){
									$(this).prop("selected", true);
								 });
							}
							smEditor.submit("sumry");// 에디터 값 적용
				    		frm.submit();
				    	}else{
				    		return false;
				    	}
				    }
				});
			});

			$(document).on("click","#checkNtce",function(){
				if($("#checkNtce").is(":checked")){
					varNtceBgnde = $("#ntceBgnde").val();
					varNtceEndde = $("#ntceEndde").val();
					$("#ntceBgnde").val("");
					$("#ntceEndde").val("");
				}else{
					$("#ntceBgnde").val(varNtceBgnde);
					$("#ntceEndde").val(varNtceEndde);
				}
			}).on("change","#ntceBgnde,#ntceEndde",function(){
				if($("#checkNtce").is(":checked")){
					$("#checkNtce").prop(":checked",false);
				}
			});

			function fn_siteList(){
				var url = "/admin/site/popup/siteList";
				var width = 770;
			    var height = 630;
				var top = (screen.availHeight - height) / 2;
			    var left = (screen.availWidth - width) / 2;
				var mngrWin = window.open(url, "mngrPopup", "width=" + width + ",height=" + height + ", scrollbars=yes, top=" + top + ", left=" + left);
				mngrWin.focus();
			}

			//사이트 추가
			function fn_addSite(value, text){
				if(!$("#siteNo option[value='"+value+"']").val()){
					$('#siteNo').append("<option value='"+value+"'>"+text+"</option>");
				}
			}

			//사이트 삭제
			function fn_delSite(){
				$("#siteNo option:selected").each(function () {
					$(this).remove();
				});
			}
			</script>

			<!-- Start Breadcrumb -->
			<jsp:include page="/WEB-INF/jsp/admin/layout/breadcrumb.jsp">
				<jsp:param name="pageName" value="배너 관리"/>
			</jsp:include>
			<!-- End Breadcrumb -->

            <!-- start: page -->
			<div class="row">
				<div class="col-md-12">
				<section class="panel panel-featured panel-featured-primary">
					<header class="panel-heading">
						<div class="panel-actions">

						</div>
						<h2 class="panel-title">배너 등록/수정</h2>
<!-- 						<p class="panel-subtitle"> -->
<!-- 						</p> -->
					</header>

					<f:form name="frmBanner" id="frmBanner" modelAttribute="bannerVO" method="post" action="./action" enctype="multipart/form-data" class="form-horizontal">
					<f:hidden path="crud" />
					<f:hidden path="bannerNo" />
					<input type="hidden" id="delPcImgFileNo" name="delPcImgFileNo" value="" />
					<input type="hidden" id="delTabletImgFileNo" name="delTabletImgFileNo" value="" />
					<input type="hidden" id="delMobileImgFileNo" name="delMobileImgFileNo" value="" />
					<input type="hidden" id="updtImgFileDc" name="updtImgFileDc" value="" />

					<div class="panel-body">

							<table class="table">
								<colgroup>
									<col style="width:140px"/>
									<col />
								</colgroup>
								<tbody>
									<tr>
										<th>사이트 선택</th>
										<td>
											<div class="row">
											<div class="col-md-9">
												<select id="siteNo" name="siteNo" class="form-control" multiple="multiple" style="height:150px;">
													<c:forEach items="${bannerVO.siteList}" var="siteList">
													<option value="${siteList.siteNo}">${siteList.siteNm}</option>
													</c:forEach>
												</select>
											</div>
											<div class="col-md-3">
												<button type="button" class="btn btn-success" onclick="javascript:fn_siteList();">추가</button>
												<button type="button" class="btn btn-danger" onclick="javascript:fn_delSite();">삭제</button>
											</div>
											</div>
										</td>
									</tr>
									<tr>
										<th>제목 <span class="required">*</span></th>
										<td>
											<f:input path="sj" class="form-control" placeholder="제목" maxlength="200"/>
										</td>
									</tr>
									<tr>
										<th>부제목</th>
										<td>
											<f:input path="subtitl" class="form-control" placeholder="부제목" maxlength="200"/>
										</td>
									</tr>
									<tr>
										<th>내용</th>
										<td>
											<f:textarea path="sumry" class="form-control" placeholder="내용" style="width:100%;"/>
										</td>
									</tr>
									<tr>
										<th>배너구분 <span class="required">*</span></th>
										<td>
											<f:select path="bannerCodeId" cssClass="form-control">
												<c:forEach items="${bannerCodeList}" var="bannerCodeList">
												<f:option value="${bannerCodeList.codeId}" label="${bannerCodeList.codeNm }" />
												</c:forEach>
											</f:select>
										</td>
									</tr>
									<tr>
										<th>이미지 파일(PC) <span class="required">*</span></th>
										<td>
											<c:forEach var="pcFileList" items="${bannerVO.pcFileList }" varStatus="status">
											<div id="pcImgFileViewDiv${pcFileList.fileNo}">
												<a href="/comm/getFile?srvcId=${pcFileList.srvcId }&amp;upperNo=${pcFileList.upperNo }&amp;fileTy=${pcFileList.fileTy }&amp;fileNo=${pcFileList.fileNo }">${pcFileList.orginlFileNm} (용량 : ${cmsFn:fileSize(pcFileList.fileSize)}, 다운로드 : ${pcFileList.dwldCo}회)</a>
												<a href="#delFile" class="btn btn-danger btn-xs ml-xs" onclick="delFile('${pcFileList.fileNo}', 'PC', '${status.index}'); return false;"><i class="fa fa-trash text-danger-inverse"></i> 삭제</a>
												<div class="input-group input-group-sm">
													<span class="input-group-addon">
														<i class="fa fa-blind"></i>
														대체문구
													</span>
													<input class="form-control" id="updtPcImgFileDc${pcFileList.fileNo}" name="updtPcImgFileDc${pcFileList.fileNo}" value="${pcFileList.fileDc}" data-plugin-maxlength maxlength="200" data-update-dc>
												</div>
											</div>
											</c:forEach>

											<div id="pcImgFileDiv">
											<c:forEach begin="0" end="0" varStatus="status"><!-- 첨부파일 갯수 -->
											<div class="row" id="pcImgFileInputDiv${status.index}" <c:if test="${status.index < fn:length(bannerVO.pcFileList) }">style="display:none;"</c:if>>
												<div class="col-md-4">
													<input type="file" class="form-control-static" id="pcImgFile${status.index}" name="pcImgFile${status.index}" onchange="fileCheck(this);" />
												</div>
												<div class="col-md-8">
													<div class="input-group input-group-sm">
													<span class="input-group-addon">
														<i class="fa fa-blind"></i>
														대체문구
													</span>
													<input class="form-control" id="pcImgFileDc${status.index}" name="pcImgFileDc${status.index}" data-plugin-maxlength maxlength="200">
													</div>
												</div>
											</div>
											</c:forEach>
											</div>
										</td>
									</tr>
									<tr>
										<th>이미지 파일(태블릿)</th>
										<td>
											<c:forEach var="tabletFileList" items="${bannerVO.tabletFileList }" varStatus="status">
											<div id="tabletImgFileViewDiv${tabletFileList.fileNo}">
												<a href="/comm/getFile?srvcId=${tabletFileList.srvcId }&amp;upperNo=${tabletFileList.upperNo }&amp;fileTy=${tabletFileList.fileTy }&amp;fileNo=${tabletFileList.fileNo }">${tabletFileList.orginlFileNm} (용량 : ${cmsFn:fileSize(tabletFileList.fileSize)}, 다운로드 : ${tabletFileList.dwldCo}회)</a>
												<a href="#delFile" class="btn btn-danger btn-xs ml-xs" onclick="delFile('${tabletFileList.fileNo}', 'TABLET', '${status.index}'); return false;"><i class="fa fa-trash text-danger-inverse"></i> 삭제</a>
												<div class="input-group input-group-sm">
													<span class="input-group-addon">
														<i class="fa fa-blind"></i>
														대체문구
													</span>
													<input class="form-control" id="updtTabletImgFileDc${tabletFileList.fileNo}" name="updtTabletImgFileDc${tabletFileList.fileNo}" value="${tabletFileList.fileDc}" data-plugin-maxlength maxlength="200" data-update-dc>
												</div>
											</div>
											</c:forEach>

											<div id="tabletImgFileDiv">
											<c:forEach begin="0" end="0" varStatus="status"><!-- 첨부파일 갯수 -->
											<div class="row" id="tabletImgFileInputDiv${status.index}" <c:if test="${status.index < fn:length(bannerVO.tabletFileList) }">style="display:none;"</c:if>>
												<div class="col-md-4">
													<input type="file" class="form-control-static" id="tabletImgFile${status.index}" name="tabletImgFile${status.index}" onchange="fileCheck(this);" />
												</div>
												<div class="col-md-8">
													<div class="input-group input-group-sm">
													<span class="input-group-addon">
														<i class="fa fa-blind"></i>
														대체문구
													</span>
													<input class="form-control" id="tabletImgFileDc${status.index}" name="tabletImgFileDc${status.index}" data-plugin-maxlength maxlength="200">
													</div>
												</div>
											</div>
											</c:forEach>
											</div>
										</td>
									</tr>
									<tr>
										<th>이미지 파일(모바일)</th>
										<td>
											<c:forEach var="mobileFileList" items="${bannerVO.mobileFileList }" varStatus="status">
											<div id="mobileImgFileViewDiv${mobileFileList.fileNo}">
												<a href="/comm/getFile?srvcId=${mobileFileList.srvcId }&amp;upperNo=${mobileFileList.upperNo }&amp;fileTy=${mobileFileList.fileTy }&amp;fileNo=${mobileFileList.fileNo }">${mobileFileList.orginlFileNm} (용량 : ${cmsFn:fileSize(mobileFileList.fileSize)}, 다운로드 : ${mobileFileList.dwldCo}회)</a>
												<a href="#delFile" class="btn btn-danger btn-xs ml-xs" onclick="delFile('${mobileFileList.fileNo}', 'MOBILE', '${status.index}'); return false;"><i class="fa fa-trash text-danger-inverse"></i> 삭제</a>
												<div class="input-group input-group-sm">
													<span class="input-group-addon">
														<i class="fa fa-blind"></i>
														대체문구
													</span>
													<input class="form-control" id="updtMobileImgFileDc${mobileFileList.fileNo}" name="updtMobileImgFileDc${mobileFileList.fileNo}" value="${mobileFileList.fileDc}" data-plugin-maxlength maxlength="200" data-update-dc>
												</div>
											</div>
											</c:forEach>

											<div id="mobileImgFileDiv">
											<c:forEach begin="0" end="0" varStatus="status"><!-- 첨부파일 갯수 -->
											<div class="row" id="mobileImgFileInputDiv${status.index}" <c:if test="${status.index < fn:length(bannerVO.mobileFileList) }">style="display:none;"</c:if>>
												<div class="col-md-4">
													<input type="file" class="form-control-static" id="mobileImgFile${status.index}" name="mobileImgFile${status.index}" onchange="fileCheck(this);" />
												</div>
												<div class="col-md-8">
													<div class="input-group input-group-sm">
													<span class="input-group-addon">
														<i class="fa fa-blind"></i>
														대체문구
													</span>
													<input class="form-control" id="mobileImgFileDc${status.index}" name="mobileImgFileDc${status.index}" data-plugin-maxlength maxlength="200">
													</div>
												</div>
											</div>
											</c:forEach>
											</div>
										</td>
									</tr>
									<tr>
										<th>링크</th>
										<td>
											<f:input path="linkUrl" class="form-control" placeholder="ex) http://" maxlength="250"/>
										</td>
									</tr>
									<tr>
										<th>링크 타겟 <span class="required">*</span></th>
										<td>
											<f:radiobuttons path="linkTrgt" items="${linkTrgtTyCode}" class="form-control" element="div class='radio-custom radio-inline radio-primary'" />
										</td>
									</tr>
									<tr>
										<th>게시기간 <span class="required">*</span></th>
										<td>
											<div class="form-inline">
											<f:input path="ntceBgnde" cssClass="form-control" readonly="true" /> ~
											<f:input path="ntceEndde" cssClass="form-control mr-sm" readonly="true" />

											<div class="checkbox-custom checkbox-text-primary checkbox-inline">
											<input type="checkbox" name="checkNtce" id="checkNtce" <c:if test="${bannerVO.crud ne 'CREATE' and empty bannerVO.ntceBgnde and empty bannerVO.ntceEndde}">checked</c:if>>
											<label for="checkNtce">상시사용</label>
											</div>

											</div>
										</td>
									</tr>
									<tr>
										<th>사용여부 <span class="required">*</span></th>
										<td>
											<f:radiobuttons path="useAt" items="${useAtCode}" class="form-control" element="div class='radio-custom radio-inline radio-primary'" />
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
