<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ include file="/common/taglibs.jsp" %>

	<script type="text/javascript">
	$(document).ready(function(){

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
		    	skinName : { required : true}
            	,imageDocbase : { required : true}
            	,cssDocbase : { required : true}
            	,description : { required : true}
		    },
		    messages : {
		    	skinName : { required : "<spring:message arguments='스킨명' code='errors.required'/>"}
		    	,imageDocbase : { required : "<spring:message arguments='이미지' code='errors.required'/>"}
		    	,cssDocbase : { required : "<spring:message arguments='CSS' code='errors.required'/>"}
		    	,description : { required : "<spring:message arguments='설명' code='errors.required'/>"}
		    },
		    submitHandler: function (frm) {
	    		//validator_numberOfInvalids 0으로 초기화를 해야 submit된다.
	    		validator_numberOfInvalids = 0;

		    	if(confirm("<spring:message code='action.confirm.save'/>")){
		    		
		    		// Yooncoms Editor 적용
		    		// $("#description").val(yooncomsEditor.GetEditorContent());
		    		
		    		frm.submit();
		    	}else{
		    		return false;
		    	}
		    },

		    //validate 에러 확인 callback
		    invalidHandler: function(event, validator) {
				//페이지에서 에러 개수를 저장한다.
				//이를 이용하여 웹필터의 서브밋을 제어하도록 한다.
				//webfilter.js파일에 추가하였으며, webfilterResult.html에서 확인하여 에러가 0이면 submit하고 아니면 하지 않도록 수정함.
				//중용한 변수임.
		    	validator_numberOfInvalids = validator.numberOfInvalids();
				//alert(validator_numberOfInvalids);
		      }
		});

		 $(".save").click(function(){
        	return f_save();
        });
	})

	function f_save(){

		return true;
	}

	function ntt_list(){
		document.frmNtt.action = "./list";
		document.frmNtt.submit();
	}
	
	// Yooncoms Editor 적용(내용)
	/* function f_insertMedia(insertHtml){
		yooncomsEditor.InsertHTMLByFocus(insertHtml);
	}
	function sendCn(){
		var $editorFrame = null;
		$editorFrame = $('#editor');
        window.yooncomsEditor = $editorFrame[0].contentWindow.window.yooncomsEditor;
        var cn = $("#sendCn").html();
        var rtn = yooncomsEditor.SetEditorContent(cn);
	} */
	
	</script>

			<!-- Start Breadcrumb -->
			<jsp:include page="/WEB-INF/jsp/admin/layout/breadcrumb.jsp">
				<jsp:param name="pageName" value="스킨 관리"/>
			</jsp:include>
			<!-- End Breadcrumb -->

            <!-- start: page -->
			<div class="row">
				<f:form modelAttribute="bbsSkinVO" method="post" name="frmNtt" id="frmNtt"  action="./action" cssClass="form-horizontal form-bordered mb-md">
				<f:hidden path="skinId" />
				<f:hidden path="crud" />
				<input type="hidden" name="curPage" id="curPage" />
				
				<%-- Yooncoms Editor 적용 --%>
				<%-- <input type="hidden" id="description" name="description" value="" />
				<span id="sendCn" style="display:none;">${bbsSkinVO.description}</span> --%>
				<%-- // Yooncoms Editor 적용 --%>

				<div class="col-md-12">

					<section class="panel panel-featured panel-featured-primary">
						<header class="panel-heading">
							<h2 class="panel-title">스킨 등록/수정</h2>
						</header>
						<div class="panel-body">
							<div class="table-responsive">
								<table class="table table-bordered table-hover mb-none">
									<colgroup>
										<col width="100"/>
										<col />
									</colgroup>
									<tbody>
									<tr>
										<th>스킨명 <span class="required">*</span></th>
										<td><f:input path="skinName" class="form-control" placeholder="스킨명" maxlength="80"/></td>
									</tr>
									
									<tr>
										<th>이미지 <span class="required">*</span></th>
										<td><f:input path="imageDocbase" class="form-control" placeholder="이미지" maxlength="200"/></td>
									</tr>
									<tr>
										<th>CSS <span class="required">*</span></th>
										<td><f:input path="cssDocbase" class="form-control" placeholder="CSS" maxlength="200"/></td>
									</tr>
									<tr>
										<th>설명 <span class="required">*</span></th>
										<td>
											<%-- Yooncoms Editor 적용 --%>
											<!-- <a style="margin-bottom:5px;" class="btn btn-default" href="/good001/media/popup/list?targetId=description" target="_blank" onclick="window.open(this.href, 'mediaPopup', 'width=800, height=910'); return false;" >미디어 삽입</a>
											<iframe name="editor" id="editor" src="/webeditor/webEditor.jsp" width="100%" height="1000px" frameborder="0"></iframe> -->
											
											<%-- 기본 --%>
											<f:textarea path="description" class="form-control" placeholder="설명" maxlength="150"/>
										</td>
									</tbody>
								</table>
							</div>
						</div>
						<footer class="panel-footer">
							<div class="row">
								<div class="col-sm-6">
									<cmsBtn:list admin="true" cssClass="btn btn-default">목록</cmsBtn:list>
								</div>
								<div class="col-sm-6 text-right">
									<button class="btn btn-primary save">저장</button>
								</div>
							</div>
						</footer>
					</section>

				</div>
				</f:form>
			</div>