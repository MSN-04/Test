<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/taglibs.jsp" %>
<%@ page trimDirectiveWhitespaces="true" %>

		<c:set var="pageParam" value="useAt=${param.useAt}&amp;curPage=${param.curPage }&amp;srchText=${param.srchText}&amp;srchKey=${param.srchKey}&amp;srchPart=${param.srchPart}&amp;srchStatus=${param.srchStatus}&amp;srchStartDt=${param.srchStartDt}&amp;srchEndDt=${param.srchEndDt}" />

		<script type="text/javascript" src="${globalAdminAssets}/smarteditor/js/HuskyEZCreator.js" charset="utf-8"></script>

	    <!-- Tag Editor -->
		<script>
		
		$(function() {						
			$.validator.addMethod("checkTinyMceText", function (value, element, params) {					      
		        var ir1 = smEditor.getVal('cn');	     		      
		       if( ir1 == ""  || ir1 == null || ir1 == '&nbsp;' || ir1 == '<p>&nbsp;</p>' || ir1 == '<p><br></p>')  {	
		             return false;
		        }else{		        
		        	return true;
		        }	       
		    }, $.validator.format("{0}"));
			
			$("form[name='frmCrs']").validate({
			    ignore: "input[type='text']:hidden",
			    rules : {
		    		 sj : {required : true},
		    		 linkUrl : {required : "#requesturlcheck:not(:checked)" },
			  		 part : {required : true},
			  		 cn : {checkTinyMceText:true}
			    },
			    messages : {
			    	sj : { required : "제목을 입력하세요"},
			    	linkUrl : { required : "URL을 입력하세요" },
			    	part : { required : "파트를 선택하세요" },
			    	cn : { checkTinyMceText : "요청사항을 입력하세요" }
			    	
			    },
			    errorElement: 'label',
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
				    		smEditor.submit("cn");
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
		/** 요청 URL 체크박스 변경 **/
		window.fn_requestUrlCheck = function(obj) {
			if($(obj).is(':checked')) {
				$('#linkUrl').val('');
				$('#linkUrl').attr('disabled', true);
			} else {
				$('#linkUrl').attr('disabled', false);
			}
		};
		$(function() {
			smEditor.init("cn");
			});
	</script>



			<!-- Start Breadcrumb -->
			<jsp:include page="/WEB-INF/jsp/admin/layout/breadcrumb.jsp">
				<jsp:param name="pageName" value="CSR 게시판"/>
			</jsp:include>
			<!-- End Breadcrumb -->

            <!-- start: page -->
			<div class="row">

			<f:form name="frmCrs" id="frmCrs" modelAttribute="crsVO" method="post" enctype="multipart/form-data"  action="./action" class="form-horizontal">
			<f:hidden path="crud" />
			<f:hidden path="crsNo" />
			<f:hidden path="chargerUniqueId" />
			<f:hidden path="aditChargerUniqueId" />
			<f:hidden path="progrsSttus" />
			<f:hidden path="processDt" />
			<f:hidden path="processCn" />

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
						<h2 class="panel-title">CSR 등록/수정</h2>
					</header>
					<div class="panel-body">
						<div class="table-responsive">
							<table class="table table-bordered mb-none">
								<colgroup>
									<col style="width:150px"/>
									<col />
								</colgroup>
								<tbody>
									<tr>
										<th>제목 <span class="required">*</span></th>
										<td>
											<f:input path="sj" class="form-control" maxlength="200"/>
										</td>
									</tr>
									<tr>
										<th>요청 URL <span class="required">*</span></th>
										<td>
											<f:textarea path="linkUrl" class="form-control" maxlength="500"/>
											<div class="checkbox-custom checkbox-default mt-xs">
											<input type="checkbox" value="Y" id="requesturlcheck" onchange="javascript:fn_requestUrlCheck(this);"><label for="requesturlcheck"> URL 없음</label>
											</div>
											<strong>* CSR 수정 요청글 작성시 해당 사이트의 URL을 함께 기재해 주시기바랍니다.</strong>
										</td>
									</tr>
									<tr>
										<th>파트 <span class="required">*</span></th>
										<td>
											<div class="col-sm-6 pl-none">
											<f:select path="part" cssClass="form-control">
											<f:options items="${crsPartCode }"/>
											</f:select>
											</div>
										</td>
									</tr>
									<tr>
										<th>첨부파일</th>
										<td>
											<c:forEach var="fileList" items="${crsVO.crsFileList}" varStatus="status">
												<span class="help-block" id="attachFileViewSpan${status.index+1}">
													<a href="/comm/getFile?srvcId=${fileList.srvcId }&amp;upperNo=${fileList.upperNo }&amp;fileTy=${fileList.fileTy }&amp;fileNo=${fileList.fileNo }">${fileList.orginlFileNm} (용량 : ${cmsFn:fileSize(fileList.fileSize)}, 다운로드 : ${fileList.dwldCo}회)</a>
													<a href="#delFile" onclick="delFile(${status.index+1}, '${fileList.fileNo}', 'ATTACH'); return false;"><i class="fa fa-trash"></i></a>
												</span>
											</c:forEach>

											<c:forEach begin="1" end="5" varStatus="status">
											<div id="attachFileDiv">
												<span class="help-block"  id="attachFileInputSpan${status.index}" <c:if test="${status.index-1 < fn:length(crsVO.crsFileList) }">style="display:none;"</c:if>>
													<input type="file" id="attachFile${status.index}" name="attachFile${status.index}" onchange="f_FileCheck(this);" />
												</span>
											</div>
											</c:forEach>
										</td>
									</tr>
									<tr>
										<th>요청사항 <span class="required">*</span></th>
										<td><f:textarea path="cn" style="width:100%;height:200px;" title="요청사항" class="form-control"/></td>
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
					</footer>
				</section>

			</f:form>
			</div>