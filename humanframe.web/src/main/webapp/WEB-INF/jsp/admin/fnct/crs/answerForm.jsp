<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/taglibs.jsp" %>
<%@ page trimDirectiveWhitespaces="true" %>
<% pageContext.setAttribute("LF", "\n"); %>

	<c:set var="pageParam" value="useAt=${param.useAt }&amp;curPage=${param.curPage }&amp;srchText=${param.srchText}&amp;srchKey=${param.srchKey}&amp;srchPart=${param.srchPart}&amp;srchStatus=${param.srchStatus}&amp;srchStartDt=${param.srchStartDt}&amp;srchEndDt=${param.srchEndDt}" />

	<script type="text/javascript" src="${globalAdminAssets}/smarteditor/js/HuskyEZCreator.js" charset="utf-8"></script>

		<script>
		$(function() {
			// 강제 초기화
			$('#main-content label').css('display', 'inline');

			$("form[name='frmCrs']").validate({
			    ignore: "input[type='text']:hidden",
			    rules : {
			    	chargerUniqueId : {required : true},
			    },
			    messages : {
			    	chargerUniqueId : { required : "처리담당자를 지정하세요"},
			    },
			    errorElement: 'span',
			    errorClass: 'help-block error',
			    errorPlacement: function(error, element) {
			    	if(element.content.type == "radio"){
			    		error.insertAfter(element.parent().parent().find(':last'));
			    	}else{
		    			error.insertAfter(element.parent().find(':last'));
			    	}
				},
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
				    		smEditor.submit("processCn");
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
		function delFile(index, fileNo, type){
			if( confirm("삭제하시겠습니까?") ) {
				if(type == "ATTACH"){
					if($("#delAttachFileNo").val()==""){
						$("#delAttachFileNo").val(fileNo);
					}else{
						$("#delAttachFileNo").val($("#delAttachFileNo").val()+","+fileNo);
					}
					$("#attachFileViewSpan"+index).remove();
					$("#attachFileInputSpan"+index).show();
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
			}
		}
		$(function() {
			if ($('#processCn').val() == "" || $('#processCn').val() == "<p>&nbsp;</p>") {
				var mngrId = "${mngrSession.mngrId}";
					var mngrNm = "${mngrSession.mngrNm}";
					var mngrBaseComment = "<br />처리담당자 : 통합유지보수팀 " + mngrNm + "(000-0000)";

					$('#processCn').val(mngrBaseComment);
			}

			smEditor.init("processCn");
			 $('input[name="processDt"]').datepicker();
		});
	</script>


			<!-- Start Breadcrumb -->
			<jsp:include page="/WEB-INF/jsp/admin/layout/breadcrumb.jsp">
				<jsp:param name="pageName" value="CSR 게시판"/>
			</jsp:include>
			<!-- End Breadcrumb -->

            <!-- start: page -->
			<div class="row">

				<f:form name="frmCrs" id="frmCrs" modelAttribute="crsVO" method="post" enctype="multipart/form-data" action="./answerAction" class="form-horizontal">
					<f:hidden path="crud" />
					<f:hidden path="crsNo" />
					<f:hidden path="sj" />
					<f:hidden path="linkUrl" />
					<f:hidden path="part" />
					<f:hidden path="cn" />

					<input type="hidden" id="srchKey" name="srchKey" value="${param.srchKey}" />
					<input type="hidden" id="srchText" name="srchText" value="${param.srchText}" />
					<input type="hidden" id="srchPart" name="srchPart" value="${param.srchPart}" />
					<input type="hidden" id="srchStatus" name="srchStatus" value="${param.srchStatus}" />
					<input type="hidden" id="srchStartDt" name="srchStartDt" value="${param.srchStartDt}" />
					<input type="hidden" id="srchEndDt" name="srchEndDt" value="${param.srchEndDt}" />
					<input type="hidden" id="curPage" name="curPage" value="${param.curPage}" />
					<input type="hidden" id="searchUseAt" name="searchUseAt" value="${param.useAt}" />

					<input type="hidden" id="delAttachFileNo" name="delAttachFileNo" value="" />

				<section class="panel panel-featured panel-featured-primary">
					<header class="panel-heading">
						<div class="panel-actions">
							<a href="#" class="panel-action panel-action-toggle" data-panel-toggle></a>
						</div>
						<h2 class="panel-title">CSR 요청사항</h2>
					</header>
					<div class="panel-body">
						<div class="table-responsive">
							<table class="table table-bordered mb-none">
								<colgroup>
									<col style="width:150px" />
									<col />
								</colgroup>
								<tbody>
									<tr>
										<th>제목 <span class="required">*</span></th>
										<td>${crsVO.sj}</td>
									</tr>
									<tr>
										<th>요청 URL <span class="required">*</span></th>
										<td>
											<c:choose>
												<c:when test="${not empty crsVO.linkUrl}">
													<c:set var="requesturl" value="${fn:split(fn:replace(crsVO.linkUrl, LF, '|'),'|')}" />
													<c:forEach var="url" items="${requesturl}" varStatus="status">
														<c:out value="${status.count}"/>. <c:out value="${url}" escapeXml="false"/>
														<a href="${url}" target="_blank" title="새창열기"><i class="icon iconfa-link"></i></a>
														<br>
													</c:forEach>
												</c:when>
												<c:otherwise>
													<strong>※ 요청 URL이 없습니다.</strong>
												</c:otherwise>
											</c:choose>
										</td>
									</tr>
									<tr>
										<th>파트 <span class="required">*</span></th>
										<td>${crsPartCode[crsVO.part]}</td>
									</tr>
									<tr>
										<th>첨부파일 <span class="required">*</span></th>
										<td>
											<c:forEach var="fileList" items="${crsVO.crsFileList}" varStatus="status">
												<span class="help-block">
													<a href="/comm/getFile?srvcId=${fileList.srvcId }&amp;upperNo=${fileList.upperNo }&amp;fileTy=${fileList.fileTy }&amp;fileNo=${fileList.fileNo }">${fileList.orginlFileNm} (용량 : ${cmsFn:fileSize(fileList.fileSize)}, 다운로드 : ${fileList.dwldCo}회)</a>
												</span>
											</c:forEach>
										</td>
									</tr>
									<tr>
										<th>요청사항 <span class="required">*</span></th>
										<td>${crsVO.cn}</td>
									</tr>
									<tr>
										<th>요청일</th>
										<td><fmt:formatDate pattern="yyyy-MM-dd" value="${crsVO.creatDttm}" /></td>
									</tr>
									<tr>
										<th>작성자</th>
										<td>${crsVO.crtrNm}</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
				</section>

				<section class="panel panel-featured panel-featured-primary">
					<header class="panel-heading">
						<h2 class="panel-title">CSR 처리내용 등록/수정</h2>
					</header>
					<div class="panel-body">
						<div class="table-responsive">
							<table class="table table-bordered mb-none">
								<colgroup>
									<col style="width:150px" />
									<col />
									<col style="width:150px" />
									<col />
								</colgroup>
								<tbody>
									<tr>
										<th>처리담당자지정 <span class="required">*</span></th>
										<td colspan="3">
											<div class="radio-group">
											<label><input type="radio" value="TMPINFO_000000000001" name="chargerUniqueId" <c:if test="${crsVO.chargerUniqueId eq 'TMPINFO_000000000001' }">checked="checked"</c:if>> 윤커뮤니케이션</label>
											<label><input type="radio" value="TMPINFO_000000000002" name="chargerUniqueId" <c:if test="${crsVO.chargerUniqueId eq 'TMPINFO_000000000002' }">checked="checked"</c:if>> ETC</label>
											<%-- <c:forEach items="${mngrListVO.listObject}" var="mngr">
												<input type="radio" value="${mngr.uniqueId }" name="chargerUniqueId">${mngr.mngrNm }
											</c:forEach> --%>
											</div>
											<div></div>
										</td>
									</tr>
									<tr>
										<th>추가 처리담당자지정 <span class="required">*</span></th>
										<td colspan="3">
											<div class="radio-group">
											<label><input type="radio" value="TMPINFO_000000000001" name="aditChargerUniqueId" <c:if test="${crsVO.aditChargerUniqueId eq 'TMPINFO_000000000001' }">checked="checked"</c:if>> 윤커뮤니케이션</label>
											<label><input type="radio" value="TMPINFO_000000000002" name="aditChargerUniqueId" <c:if test="${crsVO.aditChargerUniqueId eq 'TMPINFO_000000000002' }">checked="checked"</c:if>> ETC</label>
											<%-- <c:forEach items="${mngrListVO.listObject}" var="mngr">
												<input type="radio" value="${mngr.uniqueId }" name="aditChargerUniqueId">${mngr.mngrNm }
											</c:forEach> --%>
											</div>
										</td>
									</tr>
									<tr>
										<th>진행상태 <span class="required">*</span></th>
										<td>
											<f:select path="progrsSttus" cssClass="form-control">
											<f:options items="${crsStatusCode }"/>
											</f:select>
										</td>
										<th>처리일자 <span class="required">*</span></th>
										<td>
											<div class="col-sm-4">
											<f:input path="processDt" cssClass="form-control" readonly="true"/>
											</div>
										</td>
									</tr>
									<tr>
										<th>첨부파일 <span class="required">*</span></th>
										<td colspan="3">
											<c:forEach var="fileList" items="${crsVO.crsFileList1}" varStatus="status">
												<span class="help-block" id="attachFileViewSpan${status.index+1}">
													<a href="/comm/getFile?srvcId=${fileList.srvcId }&amp;upperNo=${fileList.upperNo }&amp;fileTy=${fileList.fileTy }&amp;fileNo=${fileList.fileNo }">${fileList.orginlFileNm} (용량 : ${cmsFn:fileSize(fileList.fileSize)}, 다운로드 : ${fileList.dwldCo}회)</a>
													<a href="#delFile" onclick="delFile(${status.index+1}, '${fileList.fileNo}', 'ATTACH'); return false;"><i class="iconfugue16-cross"></i></a>
												</span>
											</c:forEach>

											<c:forEach begin="1" end="5" varStatus="status">
											<div id="attachFileDiv">
												<span class="help-block"  id="attachFileInputSpan${status.index}" <c:if test="${status.index-1 < fn:length(crsVO.crsFileList1) }">style="display:none;"</c:if>>
													<input type="file" id="attachFile${status.index}" name="attachFile${status.index}" onchange="f_FileCheck(this);" />
												</span>
											</div>
											</c:forEach>
										</td>
									</tr>
									<tr>
										<th>처리내용 <span class="required">*</span></th>
										<td colspan="3"><f:textarea path="processCn" style="width:100%;height:200px;" title="처리내용" cssClass="form-control"/></td>
									</tr>

								</tbody>
							</table>
						</div>
					</div>
					<footer class="panel-footer">
						<div class="row">
							<div class="col-sm-6">
								<a href="./list?${pageParam}" class="btn btn-default">목록</a>
							</div>
							<div class="col-sm-6 text-right">
								<button class="btn btn-primary save">저장</button>
							</div>
							</div>
						</div>
					</footer>
				</section>

				</f:form>
			</div>