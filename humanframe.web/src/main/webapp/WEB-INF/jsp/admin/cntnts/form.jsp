<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ include file="/common/taglibs.jsp" %>

	<!-- Smart Editor -->
    <script type="text/javascript" src="${globalAdminAssets}/smarteditor/js/HuskyEZCreator.js" charset="utf-8"></script>

   	<script type="text/javascript" src="${globalAdminAssets}/javascripts/plugins/tag-editor/jquery.caret.min.js"></script>
    <script type="text/javascript" src="${globalAdminAssets}/javascripts/plugins/tag-editor/jquery.tag-editor.min.js"></script>
    <link rel="stylesheet" type="text/css" href="${globalAdminAssets}/stylesheets/plugins/tag-editor/jquery.tag-editor.css">

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
				$("#attachFileViewSpan"+fileNo).remove();
				$("#attachFileInputSpan"+spanNo).show();
			}
		}
	}

	function f_duplCheck(){
		$.ajax({
			type : "post",
			url: './retrieveDupCo',
			data: 'uriWrd=' + $("#uriWrd").val() + "&cntntsNo=" + $("#cntntsNo").val(),
			dataType: 'text', //전송받을 데이터의 타입
			contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
			success: function(data) {
				if(data=="true"){
					alert("사용가능한 URI 입니다.");
					$("#dataDupCheck").val(1);
				}else{
					alert("이미 사용중인 URI 입니다.");
					$("#dataDupCheck").val(0);
				}
			},
			error: function(data, status, err) {
				console.log('error forward : ' + data);
			}
		});
	}

	function f_insertMedia(insertHtml){
		smEditor.setVal("cn", insertHtml);
	}
	function f_insertData(insertHtml){
		smEditor.setVal("cn", insertHtml);
	}
	function f_replaceEditor(insertHtml){
		smEditor.reset("cn");
		smEditor.setVal("cn", insertHtml);
	}
	function f_replaceCss(insertCss){
		$("#cnCss").val(insertCss)
	}

	$(document).on("click", "#mnMapngTable .delBtn", function(){
		$(this).parents("tr").fadeOut(300, function(){$(this).remove();});
	});
	//미리보기
	function f_preview(menuNo){
		var data = {
				"menuNo" : menuNo
			  , "uriWrd" :'${cntntsVO.uriWrd}'
		}
		$.ajax({
			type : "post",
			url: './getSiteMenuUrl',
			data: data,
			dataType: 'text', //전송받을 데이터의 타입
			contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
			success: function(targetURI) {
				if(targetURI == "noMenu"){
					alert("해당메뉴는 접근할수없습니다. 배포되었는지 확인해주세요");
				} else if(targetURI == "noSite"){
					alert("해당사이트는 접근할수없습니다. 배포되었는지 확인해주세요");
				}else {
					window.open(targetURI, '_blank', 'width=1000, height=1000, resizable=yes, scrollbars=yes');
				}
			},
			error: function(data, status, err) {
				alert("<spring:message code='fail.common.network' />");
			}
		});
	}

	//메뉴검색
	function f_menuSrch(){
		window.open("/admin/site/menu/popup/srchMenuList?srchMenuTy=2", "popMenuList", "width=900, height=605");
	}
	//직원검색>>부서코드|부서명|직원코드|직원명이 들어갈 id를 지정
	function f_empSrch(){
		var target ="deptCode|chargerDeptNm|empCode|chargerNm|chargerTelno";
		window.open("/admin/mng/deptEmp/popup/empList?target="+target, "popEmp", "width=780, height=525");
	}
	function f_historyPop(){
		var targetURI = './historyList?cntntsNo=' +  $("#cntntsNo").val();
		window.open(targetURI, 'historyPopup', 'width=900, height=600, resizable=yes, scrollbars=yes');
	}
	function f_cntntsFormPop(menuNo){
		var targetURI = './cntntsFormList';
		window.open(targetURI, 'cntntsFormPopup', 'width=900, height=600, resizable=yes, scrollbars=yes');
	}
	function f_mediaPop(targetId){
		var targetURI = '/admin/media/popup/list?targetId=' +  targetId + '&srchMediaCodeId=IMAGE';
		window.open(targetURI, 'mediaPopup', 'width=800, height=800, resizable=yes, scrollbars=yes');
	}
	function f_addrPop(){
		var targetURI = '/admin/comm/zonecode/popup/search?zoneTagtId=zip|adres&amp;positionId=adresLa|adresLo';
		window.open(targetURI, 'zonecodePopup', 'width=770, height=530, resizable=yes, scrollbars=yes');
	}
	function f_mapPop(){
		var targetURI = '/admin/comm/zonecode/popup/searchMap?zoneTagtId=zip|adres&amp;positionId=adresLa|adresLo';
		window.open(targetURI, 'zonecodePopup', 'width=850, height=600, resizable=yes, scrollbars=yes');
	}
	function f_miniBbsPop(){
		var targetURI = '/admin/bbs/mini/popup/bbsList';
		window.open(targetURI, 'miniBbsPop', 'width=850, height=650, resizable=yes, scrollbars=yes');
	}
	//롤링이미지
	function f_insertCnRelateImage (data) {
		if (data != null) {
			var fileInfo = (data.mediaVO.mediaFileList.length > 0) ? data.mediaVO.mediaFileList[0] : null;
			if (fileInfo != null) {

				var id = fileInfo.upperNo + "_" + fileInfo.fileNo;
				var isDupl = false;
				$("#rolling_td > div").each(function (index, entity) {
					var $entity = $(entity);
					var keys = $entity.attr("id").replaceAll("item_", "");
					if (keys == id){
						isDupl = true;
						return;
					}
				});

				if (!isDupl) {
					var image_html = '<div id="item_@@id@@" class="isotope-item document col-sm-6 col-md-6 col-lg-3">';
						image_html +=   '<input type="hidden" id="delegate_@@id@@" value="N">';
						image_html +=	'<div class="thumbnail">';
						image_html +=	   '<div class="thumb-preview">';
						image_html +=	       '<img src="@@path@@" alt="" style="width:100%;height:140px;" class="img-responsive">';
						image_html +=	       '<div class="mg-thumb-options">';
						image_html +=    	     '<div class="mg-toolbar" style="height: 20px; padding-top: 2px">';
						image_html +=	           '<div class="mg-group pull-left">';
						image_html +=	             '<span id="desc_@@id@@"></span>';
						image_html +=	           '</div>';
						image_html +=	           '<div class="mg-group pull-right">';
						image_html +=		         '<a href="#remove" title="삭제" onclick="f_cntnt_media_remove(\'@@id@@\')"><i class="fa fa-trash-o"></i></a>';
						image_html +=		         '<a href="#choice" title="대표이미지 설정" onclick="f_cntnt_media_choice(\'@@id@@\')"><i class="fa fa-wrench"></i></a>';
						image_html +=	           '</div>';
						image_html +=	         '</div>';
						image_html +=	       '</div>';
						image_html +=	   '</div>';
						image_html +=	 '</div>';
						image_html += '</div>';

					var image_path = "/comm/getImage?srvcId=" + fileInfo.srvcId + "&amp;upperNo=" + fileInfo.upperNo + "&amp;fileTy=" + fileInfo.fileTy + "&amp;fileNo=" + fileInfo.fileNo +"&thumbTy=S";

					image_html = image_html.replaceAll("@@id@@", id);
					image_html = image_html.replaceAll("@@path@@", image_path);

					$("#rolling_td").append(image_html).promise().done(function () {
						f_calc_cntnt_medias();
					});
				} else {
					alert("<spring:message code='error.duplicate.value' arguments='이미지파일' />");
				}
			} else {
				alert("<spring:message code='fail.common.network' />");
			}
		} else {
			alert("<spring:message code='fail.common.network' />");
		}
	}

	function f_calc_cntnt_medias () {
		var rolling_value = "";
		$("#rolling_td > div").each(function (index, entity) {
			var $entity = $(entity);
			var id = $entity.attr("id").replace("item_", "");
			var ids = id.split("_");
			var sn = ids[0];
			var no = ids[1];

			rolling_value += (sn + "|" + no + "|" + (index + 1) + "|" + (($("#delegate_" + id).val() == "Y") ? "Y" : "N") + ",");
		});

		rolling_value = rolling_value.substring(0, (rolling_value.length - 1));
		$("#setRelationImage").val(rolling_value);
	}

	function f_cntnt_media_remove (id) {
		$("#item_" + id).remove().promise().done(function () {
			f_calc_cntnt_medias();
		});
	}

	function f_cntnt_media_choice (id) {
		$("#rolling_td > div").each(function (index, entity) {
			var $entity = $(entity);
			var keys = $entity.attr("id").replace("item_", "");
			if (keys == id){
				$("#desc_" + id).html("<i class='fa fa-heart'></i> 대표이미지");
				$("#delegate_" + id).val("Y");
			} else {
				$("#desc_" + keys).text("");
				$("#delegate_" + keys).val("N");
			}
		});

		f_calc_cntnt_medias();
	}

	$(function() {
		
		$("input:text").keydown(function(evt) { if (evt.keyCode == 13) return false; });
		
		$('[rel="tooltip"]').tooltip();

		smEditor.init("cn");

        $('input[name="pblcateDe"],[name="fxBgnde"],[name="fxEndde"]').datepicker();
        if($('input[name="pblcateDe"]').val() == ""){
        	$('input[name="pblcateDe"]').datepicker("update", new Date());
        }

		$("#uriWrd").on("change keyup", function(){
			//$(this).val( $(this).val().replace(/[^A-Za-z0-9\-\?\&\=\/\_]/gi,"") );//영문,숫자,하이픈.?,&
			$(this).val( $(this).val().replace(/[\~\!\@#$\%\^\*\(\)\_\+\=\`\{\}\[\]\|\\\:\"\;\'\<\>\?\,\.\s\/]/gi,"") );//영문,숫자,하이픈.?,&
		});

		$("#uriWrd").on("keyup", function(){
			$("#dataDupCheck").val(0);
		});

		$('#tag').tagEditor({
			delimiter : '|'
			, forceLowercase : false
			, placeholder: '해시태그를 입력하세요.'
			, beforeTagSave: function(field, editor, tags, tag, val) {
				var hashTagReg = /[-_+=!@#$%^&*()\[\]{}|\\;:\'\"<>,.?/~`） ]/g;
				if(hashTagReg.test(val)) {
					alert("태그 형식에는 특수문자나 공백이 올 수 없습니다.");
					return false;
				}
			}
		});
		
		$.validator.addMethod("cntntsSjCk",  function( value, element ) {
			return this.optional(element) ||  /^[ㄱ-ㅎ\s|가-힣\s|a-z\s|A-Z\s|0-9\s|\*]+$/.test(value);
		});
		
        $("form[name='frmCntnts']").validate({
		    ignore: "input[type='text']:hidden",
		    rules : {
		    	cntntsSj	: { required : true, cntntsSjCk : true }
		    },
		    messages : {
		    	cntntsSj	: { required : "콘텐츠 제목을 입력하세요", cntntsSjCk : "영어,한글,숫자만 입력하세요."}
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

		    	if(($("#dataDupCheck").val() == 0 && $("#uriWrd").val() != "") && $("#crud").val() == "UPDATE"){
		    		alert("URI수정시 중복 확인을 해야 합니다.");
		    		return false;
		    	}

		    	if(confirm("입력하신 정보를 저장 하시겠습니까?")){
		    		smEditor.submit("cn");//editor
		    		frm.submit();
		    	}else{
		    		return false;
		    	}
		    }
		});
        //롤링이미지
        f_calc_cntnt_medias();

	});
	</script>


	<!-- Start Breadcrumb -->
	<jsp:include page="/WEB-INF/jsp/admin/layout/breadcrumb.jsp">
		<jsp:param name="pageName" value="콘텐츠 관리"/>
	</jsp:include>
	<!-- End Breadcrumb -->

	<!-- start: page -->
	<div class="row">
	<f:form name="frmCntnts" id="frmCntnts" modelAttribute="cntntsVO" method="post" action="./action" enctype="multipart/form-data" class="form-horizontal">
		<f:hidden path="crud" />
		<f:hidden path="cntntsNo" />
		<input type="hidden" id="dataDupCheck" name="dataDupCheck" value="${cntntsVO.crud eq 'CREATE'?0:1}" />
		<input type="hidden" id="delAttachFileNo" name="delAttachFileNo" value="" />

		<div class="col-md-9">
		<section class="panel panel-featured panel-featured-primary">
			<header class="panel-heading">
				<div class="panel-actions">

				</div>
				<h2 class="panel-title">콘텐츠관리 등록/수정</h2>
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
											<col style="width:100"/>
											<col />
										</colgroup>
										<tbody>
											<tr>
												<th>제목 <span class="required">*</span></th>
												<td>
													<f:input path="cntntsSj" class="form-control" placeholder="제목" maxlength="200"/>
												</td>
											</tr>

											<tr>
												<th>내용 <span class="required">*</span></th>
												<td>
													<button style="margin-bottom:5px;" class="btn btn-default" onclick="f_mediaPop('cn');return false;" >미디어 삽입</button>
													<button style="margin-bottom:5px;" class="btn btn-default" onclick="f_miniBbsPop();return false;" >미니게시판 삽입</button>
													<button style="margin-bottom:5px;" class="btn btn-default" onclick="f_historyPop();return false;" >수정이력</button>
													<button style="margin-bottom:5px;" class="btn btn-default" onclick="f_cntntsFormPop();return false;" >글양식</button>
													<f:textarea path="cn" style="width:100%;" />
												</td>
											</tr>
											<tr>
												<th>추가 CSS</th>
												<td> <f:textarea path="cnCss" class="form-control" />
												</td>
											</tr>
											<tr>
												<th>발행상태</th>
												<td>
													<div class="radio-group">
														<f:radiobuttons path="pblcateSttusTy" items="${pblcateSttusTyCode}" element="div class='radio-custom radio-primary'"/>
													</div>
												</td>
											</tr>
											<tr>
												<th>발행일</th>
												<td><f:input path="pblcateDe" class="form-control" readonly="true" /></td>
											</tr>
											<tr>
												<th>담당자</th>
												<td>
													<button class="btn btn-info" style="margin-bottom:5px;" onclick="f_empSrch(); return false;">담당자선택</button>
													<div class="form-inline">
													<f:input path="chargerDeptNm" class="form-control" placeholder="담당자 부서" style="width: 120px"/>
													<f:input path="chargerNm" class="form-control" placeholder="담당자" style="width: 120px"/>
													<f:input path="chargerTelno" class="form-control" placeholder="전화번호" style="width: 120px"/>
													<f:input path="chargerEmail" class="form-control" placeholder="E-mail" style="width: 150px"/>
													</div>
												</td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>
						</div>
						<div class="panel panel-accordion" >
							<div class="panel-heading">
								<h4 class="panel-title">
									<a class="accordion-toggle" data-toggle="collapse" href="#collapseTwo" >
										<i class="fa fa-plus-square"></i> 부가 정보
									</a>
								</h4>
							</div>
							<div id="collapseTwo" class="accordion-body collapse">
								<div class="panel-body p-none">
									<table class="table m-none">
										<colgroup>
											<col style="width:100"/>
											<col />
										</colgroup>
										<tbody>
											<tr>
												<th>URI</th>
												<td>
													<div class="form-inline">
														<f:input path="uriWrd" class="form-control" placeholder="URI" maxlength="200"/>
														<button class="btn btn-info" onclick="f_duplCheck(); return false;">중복확인</button>
													</div>
													<c:if test="${cntntsVO.crud eq 'CREATE'}">
													<span class="help-block">* URI미입력시 자동으로 번호가 부여 됩니다.</span>
													</c:if>
													<span class="help-block">* '콘텐츠형>일반형' 메뉴와 연결시에는 메뉴 URI가 우선 적용됩니다.</span>
												</td>
											</tr>
											<tr>
												<th>썸네일 이미지</th>
												<td>
													<c:forEach var="fileList" items="${cntntsVO.fileList }" varStatus="status">
													<span class="help-block" id="attachFileViewSpan${fileList.fileNo}">
														<a href="/comm/getFile?srvcId=${fileList.srvcId }&amp;upperNo=${fileList.upperNo }&amp;fileTy=${fileList.fileTy }&amp;fileNo=${fileList.fileNo }">
															${fileList.orginlFileNm} (용량 : ${cmsFn:fileSize(fileList.fileSize)}, 다운로드 : ${fileList.dwldCo}회)</a>
														<a href="#delFile" onclick="delFile('${fileList.fileNo}', 'ATTACH', '${status.index}'); return false;"><i class="fa fa-trash"></i></a>
													</span>
													</c:forEach>

													<div id="attachFileDiv">
													<c:forEach begin="0" end="0" varStatus="status"><!-- 첨부파일 갯수 -->
													<span class="help-block"  id="attachFileInputSpan${status.index}" <c:if test="${status.index < fn:length(cntntsVO.fileList) }">style="display:none;"</c:if>>
														<input type="file" id="attachFile${status.index}" name="attachFile${status.index}" onchange="fileCheck(this);" />
													</span>
													</c:forEach>
													</div>
												</td>
											</tr>
											<tr>
												<th>언어</th>
												<td>
													<f:select path="langCodeId" class="form-control">
														<c:forEach items="${langCodeList}" var="langCodeList">
														<f:option value="${langCodeList.codeId}" label="${langCodeList.codeNm }" />
														</c:forEach>
													</f:select>
													<div></div>
												</td>
											</tr>
											<tr>
												<th>요약글</th>
												<td><f:textarea path="sumry" class="form-control" placeholder="요약글" /></td>
											</tr>
											<tr>
												<th>일정정보</th>
												<td>
												<div class="form-inline">
											 		<f:input path="fxBgnde" class="form-control" readonly="true" /> ~ <f:input path="fxEndde" class="form-control" readonly="true" />
												</div>
												</td>
											</tr>
											<tr>
												<th>위치정보</th>
												<td>
													<div class="form-inline" style="margin-bottom:5px;">
													<button onclick="f_addrPop(); return false;" class="btn btn-info">주소 검색</button>
													<!-- <button onclick="f_mapPop(); return false;" class="btn btn-info">지도 검색</button> -->
													<f:input path="zip" class="form-control" readonly="true" />
													</div>
													<f:input path="adres" class="form-control" placeholder="주소" />
													<f:hidden path="adresLa" />
													<f:hidden path="adresLo" />
												</td>
											</tr>
											<tr>
												<th>CCL/공공누리</th>
												<td>
													<f:select path="lic" class="form-control">
														<f:option value="" label="선택하세요" selected="selected" />
														<c:forEach items="${licCodeList}" var="licCodeList">
														<f:option value="${licCodeList.codeId}" label="${licCodeList.codeNm }" />
														</c:forEach>
													</f:select>
													<div></div>
												</td>
											</tr>
											<tr>
												<th>검색허용</th>
												<td>
													<div class="radio-group">
														<f:radiobuttons path="searchAt" items="${atCode}" element="div class='radio-custom radio-primary'" />
													</div>
												</td>
											</tr>
											<tr>
												<th>해시태그</th>
												<td>
													<f:input path="tag" class="form-control" placeholder="해시태그" maxlength="250"/>
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
									<a class="accordion-toggle" data-toggle="collapse" href="#collapseThree">
										<i class="fa fa-file-image-o"></i> 롤링 이미지
									</a>
								</h4>
							</div>
							<div id="collapseThree" class="accordion-body collapse">
								<div class="panel-body p-none">
									<table class="table m-none">
										<colgroup>
											<col style="width:100px"/>
											<col />
										</colgroup>
										<tbody>
											<tr>
												<th>이미지 사용</th>
												<td>
													<div class="radio-group">
														<f:radiobuttons path="relateImageAt" items="${atCode}" element="div class='radio-custom radio-primary'"/>
													</div>
												</td>
											</tr>
											<tr>

											<td colspan="2">

											<button style="margin-bottom:5px;" class="btn btn-default" onclick="f_mediaPop('cnRelateImage');return false;" >미디어 삽입</button>
											<input type="hidden" id="setRelationImage" name="setRelationImage" value="" />

											<div id="rolling_td" class="row mg-files" data-sort-destination data-sort-id="media-gallery">
											<c:forEach items="${cntntsVO.relateImageList}" var="relateList" varStatus="relate_status">
												<c:set var="id" value="${relateList.mediaNo}_${relateList.fileNo}" />
												<c:set var="fileInfo" value="${relateList.mediaVO.mediaFileList[0]}" />
												<div id="item_${id}" class="isotope-item document col-sm-6 col-md-6 col-lg-3" >
												<input type="hidden" id="delegate_${id}" value="${relateList.reprsntAt}">
													<div class="thumbnail">
														<div class="thumb-preview">
															<img src="/comm/getImage?srvcId=${fileInfo.srvcId}&upperNo=${fileInfo.upperNo}&fileTy=${fileInfo.fileTy}&fileNo=${fileInfo.fileNo}&thumbTy=S"  style="width:100%;height:140px;" class="img-responsive" alt="">
															<div class="mg-thumb-options">
																<div class="mg-toolbar" style="height: 20px; padding-top: 2px">
																	<div class="mg-group pull-left">
																		<span id="desc_${id}">${relateList.reprsntAt eq 'Y' ? '<i class="fa fa-heart"></i> 대표이미지' : ''}</span>
																	</div>
																	<div class="mg-group pull-right">
																		<a href="#remove" title="삭제" onclick="f_cntnt_media_remove('${id}')">
																		<i class="fa fa-trash-o"></i>
																		</a>
																		<a href="#choice" title="대표이미지 설정" onclick="f_cntnt_media_choice('${id}')">
																		<i class="fa fa-wrench"></i>
																		</a>
																	</div>
																</div>
															</div>
														</div>
													</div>
												</div>
											</c:forEach>
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
									<a class="accordion-toggle" data-toggle="collapse" href="#collapseFour">
										<i class="fa fa-file-text"></i> 메타더이터 정보
									</a>
								</h4>
							</div>
							<div id="collapseFour" class="accordion-body collapse">
								<div class="panel-body p-none">
									<table class="table m-none">
										<colgroup>
											<col style="width:100"/>
											<col />
										</colgroup>
										<tbody>
											<tr>
												<th>유형</th>
												<td>
													<f:select path="type" class="form-control">
														<%-- <f:option value="" label="선택하세요" selected="selected" /> --%>
														<c:forEach items="${cntntsTyCodeList}" var="cntntsTyCodeList" >
														<f:option value="${cntntsTyCodeList.codeId}" label="${cntntsTyCodeList.codeNm }" />
														</c:forEach>
													</f:select>
												</td>
											</tr>
											<tr>
												<th>정보원</th>
												<td><f:input path="source" class="form-control" placeholder="정보원" /></td>
											</tr>
											<tr>
												<th>발행자</th>
												<td><f:input path="publisher" class="form-control" placeholder="발행자" /></td>
											</tr>
											<tr>
												<th>기여자</th>
												<td><f:input path="contributor" class="form-control" placeholder="기여자" /></td>
											</tr>
											<tr>
												<th>관련자료</th>
												<td>
													<select id="relationSelect" multiple="multiple" class="form-control">
														 <c:forEach items="${cntntsVO.relationMap}" var="media">
														 <option value="${media.key}">${media.value}</option>
														 </c:forEach>
													</select>
													미디어 추가시 자동 등록
												</td>
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
						<c:set var="pageParam" value="useAt=${param.useAt }&amp;curPage=${param.curPage }&amp;srchWord=${param.srchWord}&amp;srchPblcateSttus=${param.srchPblcateSttus}&amp;srchSiteMenu=${param.srchSiteMenu}&amp;srchKey=${parm.srchKey}&amp;srchWord=${parm.srchWord}" />
						<a href="./list?${pageParam}" class="btn btn-default">목록</a>
					</div>
					<div class="col-sm-5 text-right">
						<div class="btns">
						<cmsBtn2:btn btnTy="save" path="${curPath}" mngrSession="${mngrSession }" modifyParam="?${pageParam}" >저장</cmsBtn2:btn>
	                    </div>
					</div>
				</div>
			</footer>
		</section>
		</div>

		<div class="col-sm-3 pr-none">
			<section class="panel panel-featured panel-featured-primary">
				<header class="panel-heading">
					<div class="panel-actions">
						<a href="#" class="panel-action" onclick="f_menuSrch(); return false;" ><i class="fa fa-cogs"></i> 설정</a>
					</div>
					<h2 class="panel-title">메뉴 연결</h2>
				</header>
				<div class="panel-body">
					<table class="table table-hover" id="mnMapngTable">
						<tbody>
							<c:if test="${empty siteMenuList }">
							<tr class="emptyTr">
								<td>연결된 메뉴가 없습니다.</td>
							</tr>
							</c:if>
							<c:forEach var="menuList" items="${siteMenuList}" varStatus="menuStatus">
							<tr>
								<td>
									<input type="hidden" name="arrMenuNo" value="${menuList.menuNo }" />
									<code><small>${menuList.siteNm}</small></code>
									<a href="#preview" onclick="f_preview(${menuList.menuNo});" class="mb-xs mt-xs mr-xs btn btn-xs btn-success" title="저장후미리보기 확인가능">
									<i class="fa fa-eye"  style="vertical-align: text-bottom"></i><!--  미리보기 --></a>
									<br />
									${fn:replace(menuList.menuNmPath, '>Home', '홈')}
								</td>
								<td><a href="#DEL" class="badge badge-important delBtn">X</a></td>
							</tr>
							</c:forEach>
						</tbody>
					</table>
				</div>
				<footer class="panel-footer">
				</footer>
			</section>
		</div>

	</f:form>
	</div>
