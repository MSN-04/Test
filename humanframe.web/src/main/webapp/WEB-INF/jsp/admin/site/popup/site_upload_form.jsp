<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ include file="/common/taglibs.jsp" %>

	<link rel="stylesheet" href="${globalAdminAssets}/vendor/bootstrap-fileupload/bootstrap-fileupload.min.css" />
	<script src="${globalAdminAssets}/vendor/bootstrap-fileupload/bootstrap-fileupload.min.js"></script>
	<script src="${globalAdminAssets}/vendor/additional-methods.min.js"></script>

	<script type="text/javascript">
	$(document).ready(function(){

		$("form[name=siteUploadFrm]").submit(function(e) {
		    e.preventDefault();
		}).validate({
			ignore: "input[type='text']:hidden",
			rules: {
				bundleFile: { required: true, extension: "csv"},
				uploadCheck: { required: true}
			},
			messages: {
				bundleFile: { required: "번들 파일을 선택해주세요.", extension: "csv 파일만 사용가능합니다."},
				uploadCheck: { required: "체크박스를 선택해야 작업이 진행됩니다."}
			},
			errorPlacement: function(error, element) {
				//error.appendTo(element.closest("div.col-sm-6"));
				error.insertAfter(element.closest("div"));
			},
			submitHandler: function (frm) {
				//XXX 아래 FormData Object는 IE10부터 지원됨. 이하 브라우저 지원을 위해서는 jQuery Form Plugin을 사용해야 함 
				var formData = new FormData(frm);
				$.ajax({
			        url: $(frm).attr('action'),
					type: "POST",
			        data: formData,
			        success: function(data, status) {
			        	console.log(data,status);
			        	var msg="";
			        	var close=false;
			        	if(status=="success"){
			        		if(data.result=="good"){
			        			msg=data.count+"개의 사이트가 등록되었습니다.";
			        			if(data.count > 0){
			        				msg += "\n[" + data.siteList.join(",") +"]";
			        				close=true;
			        			}
			        		}
			        		else {
			        			msg="사이트 등록에 실패했습니다.\파일 형식을 확인해주세요.";
			        		}
			        	}
			        	else{
			        		msg="사이트 등록 중 오류가 발생했습니다.";
			        	}
			        	alert(msg);
			        	if(close){
			        		window.opener.location.reload();
			        		window.close();
			        	}
			        },
			        error: function(jqXHR, status, error) {
			        	console.log(jqXHR, status, error);
			        	console.log("jqXHR:" + JSON.stringify(jqXHR));
			        	alert("에러가 발생했습니다.("+error+")");
			        },
			        cache: false,
			        contentType: false,
			        processData: false
				});
			}
		});

	});
	</script>
			<div class="col-md-6 pl-none pr-none">
				<form class="form-horizontal form-bordered" name="siteUploadFrm" method="post" enctype="multipart/form-data" action="siteUploadAction.json">
				<section class="panel panel-primary mb-none">
					<header class="panel-heading">
						<div class="panel-actions">
							<a href="javascript:window.close();" class="panel-action panel-action-dismiss"></a>
						</div>
		
						<h2 class="panel-title">사이트 일괄 등록</h2>
						<p class="panel-subtitle">번들 파일을 사용하여 사이트를 일괄 등록합니다.</p>
					</header>
					<div class="panel-body">
							<div class="form-group">
								<label class="col-sm-3 control-label" for="inputDefault">번들 파일</label>
								<div class="col-sm-6">
									<div class="fileupload fileupload-new" data-provides="fileupload">
										<div class="input-append">
											<div class="uneditable-input">
												<i class="fa fa-file fileupload-exists"></i>
												<span class="fileupload-preview"></span>
											</div>
											<span class="btn btn-default btn-file">
												<span class="fileupload-exists">Change</span>
												<span class="fileupload-new">Select file</span>
												<input type="file" name="bundleFile"/>
											</span>
											<a href="#" class="btn btn-default fileupload-exists" data-dismiss="fileupload">Remove</a>
										</div>
									</div>
									<p>
										<code>csv</code>파일로만 입력이 가능합니다.<br/>
										<code>csv</code>문자셋을 <code>UTF-8</code>로 저장하셔야지만 한글이<br/> 정상적으로 입력됩니다.<br/>
										샘플파일 문자셋은 <code>ANSI</code>
									</p>
									<a class="btn btn-info btn-sm" href="${globalAdminAssets}/samples/cms-create-site-bundle-template.zip">
    									<i class="fa fa-file-archive-o"></i> 샘플 파일 다운로드
    								</a>
								</div>
							</div>
							<div class="form-group">
								<div class="col-sm-6">
									<div class="checkbox-custom checkbox-danger">
										<input type="checkbox" name="uploadCheck" id="uploadCheck">
										<label for="uploadCheck">번들 파일 포맷이 이상없음을 확인하였습니다.</label>
									</div>
								</div>
							</div>
					</div>
					<footer class="panel-footer">
						<button class="btn btn-primary">Submit </button>
						<button type="reset" class="btn btn-default">Reset</button>
					</footer>
				</section>
				</form>
			</div>