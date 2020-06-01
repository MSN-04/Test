<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/taglibs.jsp" %>
<%@ page trimDirectiveWhitespaces="true" %>
<script src="${globalAdminAssets}/vendor/jquery-ui/jquery-ui.js"></script>
<script type="text/javascript" src="${globalAdminAssets}/javascripts/plugins/tag-editor/jquery.caret.min.js"></script>
<script type="text/javascript" src="${globalAdminAssets}/javascripts/plugins/tag-editor/jquery.tag-editor.min.js"></script>
<link rel="stylesheet" type="text/css" href="${globalAdminAssets}/stylesheets/plugins/tag-editor/jquery.tag-editor.css">

<style type="text/css">
	.ui-sortable { list-style-type: none; margin: 0; padding: 0; width: 100%; }
	/*.ui-sortable li { width: 100%; margin: 1px; padding: 1px; border: 0px solid #cccccc; color: #0088cc;}
	.ui-sortable li span { position: absolute; margin-left: -1.3em; }
	.ui-sortable li input { padding:0; font-size:12px; height:18px; } */
</style>

	<script type="text/javascript">

	//항목 추가
	var addIndex = '${listQesitm.size()}';
	function f_addQesitm(){
		var _html="";
		var qesitmNo = 0;
		addIndex++;

		_html+='<li class="ui-state-medium">';
		_html+='  <span style="float:left;cursor:pointer" class="ui-icon ui-icon-arrowthick-2-n-s"></span>';
		_html+='  <input type="hidden" name="qesitmNo" value="'+qesitmNo+'"/>';

		_html+='  <div class="input-group input-group-sm">';
		_html+='    <span class="input-group-addon spQesitmOrdr"></span>';
		_html+='    <input type="text" class="form-control" name="qesitmText" value="" placeholder="항목내용" title="항목내용"/>';
		_html+='    <span class="input-group-btn">';
		_html+='      <button class="btn btn-danger" style="width: 85px" onclick="delQesItm(this);"><i class="fa fa-trash"></i> 항목삭제</button>';
		_html+='    </span>'
		_html+='  </div>';

		if($("[name=qestnTi]:checked").val() == "B"){
		_html+='  <div class="help-block media" style="margin-left: 15px; margin-top:5px; margin-bottom:5px;">';
		_html+='    <input type="file" name="imgFile" onchange="f_FileCheck(this);"/>';
		_html+='  </div>';
		}

		_html+='  <div class="form-horizontal" style="margin-left: 15px; margin-top:5px; margin-bottom:5px;" >';
		_html+='  다음질문가기 여부';
		_html+='    <div class="radio-custom  radio-inline radio-primary">';
		_html+='      <input type="radio" onclick="f_nextQestnAt(' +addIndex+ ');" name="nextQestnAt' +addIndex+ '" id="nextQestnAtY' +addIndex+ '" value="Y">';
		_html+='      <label for="nextQestnAtY' +addIndex+ '">Y</label>';
		_html+='    </div>';
		_html+='    <div class="radio-custom  radio-inline radio-primary">';
		_html+='	  <input type="radio" onclick="f_nextQestnAt(' +addIndex+ ');"  name="nextQestnAt' +addIndex+ '" id="nextQestnAtN' +addIndex+ '" value="N" checked="checked">';
		_html+='	  <label for="nextQestnAtN' +addIndex+ '">N</label>';
		_html+='    </div>';
		_html+='    <div id="divNext' +addIndex+ '" style="display: none;" ><input type="text" name="nextQestnNo" id="nextQestnNo' +addIndex+ '" class="form-control" ></div>';
		_html+='  </div>';

		_html+='</li>';

		$("#ulQesitm").append(_html);

		$(".spQesitmOrdr").each(function(index) {
			$(this).html(index+1);
			$(this).parent().parent().find("[name*='imgFile']").attr('name', 'imgFile'+$(this).html());
		});

		$("#nextQestnNo"+addIndex).tagEditor({
			delimiter : '|'
			, forceLowercase : false
			, placeholder: '다음질문 번호를 입력해주세요.'
			, beforeTagSave: function(field, editor, tags, tag, val) {
				var hashTagReg = /^[0-9]*$/;
				if(!hashTagReg.test(val)) {
					alert("다음질문 번호는 숫자만 입력가능합니다.");
					return false;
				}
			}
		});
	}
	//항목 삭제
	function delQesItm(el) {
		var _html="";
		var qesitmNo = $(el).parent().parent().parent().find("[name='qesitmNo']").val();
		_html+='<input type="hidden" id="del_qesitmNo'+qesitmNo+'" value='+qesitmNo+' name="del_qesitmNo"/>';
		$("#frmQestn").append(_html);

		$(el).parent().parent().parent().remove();


		$(".spQesitmOrdr").each(function(index) {
			$(this).html(index+1);
			$(this).parent().parent().find("[name*='imgFile']").attr('name', 'imgFile'+$(this).html());
		});
	}
	// 다음질문여부시
	function f_nextQestnAt(index) {
		var nextQestnAt = $("input[name=nextQestnAt"+index+"]:checked").val();
		if(  nextQestnAt=="Y"){
			$("#divNext"+index).show();
		}else{
			$("#divNext"+index).hide();
			$("#nextQestnNo"+index).val("");
		}
	}

	$(document).on("click",".fa-minus",function(){
		$(this).parent().remove();
	});

	$(document).ready(function(){

		$("input[name='nextQestnNo']").tagEditor({
			delimiter : '|'
			, forceLowercase : false
			, placeholder: '다음질문 번호를 입력해주세요.'
			, beforeTagSave: function(field, editor, tags, tag, val) {
				var hashTagReg = /^[0-9]*$/;
				if(!hashTagReg.test(val)) {
					alert("다음질문 번호는 숫자만 입력가능합니다.");
					return false;
				}
			}
		});

		$("#ulQesitm").sortable({
	        update:  function (event, ui) {
	        	// 드로그 순서변경시
	        	$(".spQesitmOrdr").each(function(index) {
	    			$(this).html(index+1);
	    			$(this).parent().parent().find("[name*='imgFile']").attr('name', 'imgFile'+$(this).html());
	    		});
	        }
		});

		if ("${qestnarQestnVO.qestnTy}"=="T") {
			$("#trEtc").hide();
			$(".trItem").hide();
			$("#trTi").hide();
		}else{
			$("#trEtc").show();
			$(".trItem").show();
			$("#trTi").show();
		}

		$(":radio[name='qestnTy']").click(function(){
			if( $(this).val()=="T" ){
				$("#trEtc").hide();
				$(".trItem").hide();
				$("#trTi").hide();
			}else{
				$("#trEtc").show();
				$(".trItem").show();
				$("#trTi").show();
			}
		});

		//validator addon
		$.validator.addMethod("ckeckEtcOpinion", function (value, element, params) {
			if ( $("input:radio[name='qestnTy']:checked").val()=="T" ) {
				return true;
			}
			if ( $("input:radio[name=etcOpinionAt]").is(":checked")==false ) {
				return false;
			}
	        return true;
	    }, $.validator.format("{0}"));

		$("form[id=frmQestn]").validate({
			ignore: "input[type='text']:hidden",
			rules: {
				qestnText: { required: true, maxlength:250},
				qestnTy: { required: true},
				etcOpinionAt: { ckeckEtcOpinion: true}
			},
			messages: {
				qestnText: { required: "<spring:message code='errors.required' arguments='질문명'/>", maxlength: jQuery.validator.format("{0}자 이하로 입력하세요")},
				qestnTy: { required: "<spring:message code='errors.required' arguments='질문 유형'/>"},
				etcOpinionAt: { ckeckEtcOpinion: "<spring:message code='errors.required' arguments='기타 의견 여부'/>"},
			},
			submitHandler: function (frm) {

				if('${progrsSttus}' != 'YET' ){
					alert("준비중 상태인 경우에만 수정가능합니다.");
					return false;
				}

				//항목 다음질문 여부 배열담기
				$("input:radio[name^='nextQestnAt']:checked").each(function(index) {
					var _html='<input type="hidden" id="nextQestnAt'+$(this).val()+'" value='+$(this).val()+' name="nextQestnAt"/>';
					$("#frmQestn").append(_html);
				});

				//질문 저장
				var qestnTy = $("input:radio[name='qestnTy']:checked").val();

				if( qestnTy != "T" && $("input:text[name='qesitmText']").length==0 ){
					alert("항목은 1개 이상 등록하셔야 합니다.");
					return false;
				}

				frm.submit();
			}
		});

	});


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
		}
	}

	function f_tiChange(){
		$("#ulQesitm").find('li').remove();
	}

	function f_check(){
		$("input:text[name=qesitmText]").each(function(){
			if($(this).val() == null || $(this).val() == ""){
				$(this).val(" ");
			}
		});
	}

	</script>


	<section class="panel panel-primary">
		<header class="panel-heading">
			<div class="panel-actions" style="position: absolute;">
				<button class="btn btn-default" title="선택완료(닫기)" onclick="window.close(); return false;"><i class="fa fa-remove"></i> 선택완료(닫기)</button>
			</div>
			<h2 class="panel-title">질문 관리</h2>
		</header>

		<f:form name="frmQestn" id="frmQestn" modelAttribute="qestnarQestnVO" method="post" enctype="multipart/form-data" action="./qestnAction" onsubmit="f_check();">
		<f:hidden path="crud" />
		<f:hidden path="qestnarNo" />
		<f:hidden path="qestnNo" />
		<f:hidden path="ordr" />

		<div class="panel-body">
			<table class="table table-bordered mb-none">
				<colgroup>
					<col style="width:150px" />
					<col />
				</colgroup>
				<tbody>
					<tr>
						<th>질문명<span class="required">*</span></th>
						<td><f:input path="qestnText"  class="form-control" placeholder="질문명" title="질문명"/></td>
					</tr>
					<tr>
						<th>질문 유형<span class="required">*</span></th>
						<td>
							<div class="form-horizontal">
								<f:radiobuttons path="qestnTy" items="${mapQestTy}" class="form-control" element="div class='radio-custom radio-inline radio-primary'" />
							</div>
						</td>
					</tr>
					<tr>
					<tr id="trEtc">
						<th>기타 의견 여부<span class="required">*</span></th>
						<td>
							<div class="form-horizontal">
								<f:radiobuttons path="etcOpinionAt" items="${mapUseAt}" class="form-control" element="div class='radio-custom radio-inline radio-primary'"/>
							</div>
						</td>
					</tr>
					<tr id="trTi">
						<th>항목 유형<span class="required">*</span></th>
						<td>
							<div class="form-horizontal">
								<f:radiobuttons path="qestnTi" items="${mapQestTi}" onclick="f_tiChange();" class="form-control" element="div class='radio-custom radio-inline radio-primary'"/>
							</div>
						</td>
					</tr>
					<tr>
						<th>필수여부<span class="required">*</span></th>
						<td>
							<div class="form-horizontal">
								<f:radiobuttons path="essentialTy" items="${mapEssentialTy}" class="form-control" element="div class='radio-custom radio-inline radio-primary'" />
							</div>
						</td>
					</tr>
					<tr>
						<th>다음질문여부<span class="required">*</span></th>
						<td>
							<div class="form-horizontal">
								<f:radiobuttons path="nextQestnTy" items="${mapNextQestnTy}" class="form-control" element="div class='radio-custom radio-inline radio-primary'" />
							</div>
						</td>
					</tr>
					<tr class="trItem">
						<th colspan="2">
							항목  <small><span class="ui-icon ui-icon-arrowthick-2-n-s"></span>위치에서 드래그시 순서 변경 가능합니다.</small>
							<button type="button" style="margin-left: 50%" class="btn btn-sm btn-success text-right" onclick="f_addQesitm();return false;"><i class="fa fa-plus"></i> 추가</button>
						</th>
					</tr>
					<tr class="trItem">
					  <td colspan="2">
							<ul style="margin-left:0" class="ui-sortable" id="ulQesitm">
								<c:forEach var="item" items="${listQesitm }" varStatus="s">
									<c:if test="${item.qesitmText ne '기타의견' && item.qesitmText ne '주관식' }">
									<c:set var="qesitmText" value="${item.qesitmText }"/>

										<li class="ui-state-medium">
											<span style="float:left;cursor:pointer" class="ui-icon ui-icon-arrowthick-2-n-s"></span>
											<input type="hidden" name="qesitmNo" value="${item.qesitmNo}"/>

											<div class="input-group input-group-sm">
												<span class="input-group-addon spQesitmOrdr">${item.qesitmOrdr }</span>
												<input type="text" class="form-control" name="qesitmText" value="${item.qesitmText}" placeholder="항목내용" title="항목내용"/>
												<span class="input-group-btn">
													<button class="btn btn-danger" style="width: 85px" onclick="delQesItm(this);"><i class="fa fa-trash"></i> 항목삭제</button>
												</span>
											</div>

											<div class="form-horizontal" style="margin-left: 15px; margin-top:5px; margin-bottom:5px;" >
												다음질문가기 여부
												<div class="radio-custom  radio-inline radio-primary">
													<input type="radio" onclick="f_nextQestnAt(${s.index});" name="nextQestnAt${s.index}" id="nextQestnAtY${s.index}" value="Y" <c:if test="${item.nextQestnAt eq 'Y' }"> checked="checked"</c:if>>
													<label for="nextQestnAtY${s.index}">Y</label>
												</div>
												<div class="radio-custom  radio-inline radio-primary">
													<input type="radio" onclick="f_nextQestnAt(${s.index});" name="nextQestnAt${s.index}" id="nextQestnAtN${s.index}" value="N" <c:if test="${item.nextQestnAt eq 'N' }"> checked="checked"</c:if>>
													<label for="nextQestnAtN${s.index}">N</label>
												</div>
												<div id="divNext${s.index}" <c:if test="${item.nextQestnAt eq 'N' }"> style="display: none;" </c:if>><input type="text" name="nextQestnNo" id="nextQestnNo${s.index}" value="${item.nextQestnNo}" class="form-control"></div>
											</div>

											<c:forEach var="imgFileVO" items="${imgFileListAll}" varStatus="status">
												<c:choose>
												<c:when test="${item.qesitmNo eq imgFileVO.upperNo }">
												<div class="help-block media " style="margin-left: 15px; margin-top:5px; margin-bottom:5px;" id="attachFileViewDiv${imgFileVO.fileNo}">
                                                	<img style="width:100px;" class="media-object" src="/comm/getFile?srvcId=${imgFileVO.srvcId }&amp;upperNo=${imgFileVO.upperNo }&amp;fileTy=${imgFileVO.fileTy }&amp;fileNo=${imgFileVO.fileNo }" alt="${imgFileVO.orginlFileNm}"/>
						                                                        이미지파일 : <a href="/comm/getFile?srvcId=${imgFileVO.srvcId }&amp;upperNo=${imgFileVO.upperNo }&amp;fileTy=${imgFileVO.fileTy }&amp;fileNo=${imgFileVO.fileNo }">${imgFileVO.orginlFileNm}</a>
                                                </div>
												</c:when>
												</c:choose>
											</c:forEach>
										</li>

									</c:if>
								</c:forEach>
							</ul>
					  </td>
					</tr>
				</tbody>
			</table>


		</div>
		<footer class="panel-footer">
			<div class="row">
			<div class="form-group">
				<div class="col-sm-12  text-right">
					<button type="submit" class="btn btn-primary">저장</button>
				</div>
			</div>
			</div>
		</footer>
		</f:form>
	</section>


