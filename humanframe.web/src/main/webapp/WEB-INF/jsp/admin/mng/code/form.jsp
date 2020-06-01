<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/taglibs.jsp" %>
<%@ page trimDirectiveWhitespaces="true" %>

			<link rel="stylesheet" href="${globalAdminAssets}/vendor/jstree/themes/default/style.css" />
			<script src="${globalAdminAssets}/vendor/jstree/jstree.js"></script>
			<script>
			function f_addLangCodeSet(){
				var langCode = $("#selLangCodeId option:selected").val();
				var langCodeNm = $("#selLangCodeId option:selected").text();
				if(langCode == ""){
					alert("언어를 먼저 선택하세요");
					return false;
				}
				var html = "";
				html = html + "<tr style=\"background-color:#fcf8e3;\" class=\""+langCode+"\"><th colspan=\"2\">";
				html = html + "<a class=\"btn btn-warning\" onclick=\"f_delLangCodeSet('"+ langCode +"', '"+ langCodeNm +"'); return false;\">추가언어 항목 삭제 ("+ langCodeNm +") <i class=\"icon icon-remove\"></i></a> <input type=\"hidden\" name=\"addLangCodeId\" value=\"C-"+ langCode +"\"/>";
				html = html + "</th></tr>";
				html = html + "<tr style=\"background-color:#fcf8e3;\" class=\""+langCode+"\"><th>코드명 ("+ langCodeNm +")</th><td>";
				html = html + "<input id=\"addCodeNm_"+ langCode +"\" name=\"addCodeNm\" class=\"form-control\" type=\"text\" value=\"\"></td></tr>";

				$(html).insertAfter("#langTr");
				$("#selLangCodeId option:selected").remove();
			}

			function f_delLangCodeSet(lang, langNm){
				$("#selLangCodeId").append("<option value=\""+ lang +"\">"+ langNm +"</option>")
				$("."+lang).remove();
				$("#frmCode").append("<input type='hidden' name='delLangCodeId' value='" + lang  + "' />");
			}

			function f_codeAdd(){ //form 초기화
				var selId = $("#codeTree").jstree("get_selected");//선택된 코드

				if(selId == ""){
					alert("상위 코드를 먼저 선택하세요");
					return false;
				}
				var levelNo = $('#codeTree').jstree("get_json", selId).data.levelNo;
		    	$("#upperCodeId").val($('#codeTree').jstree("get_json", selId).data.codeId);
	  	    	$("#upperCodeNm").text($('#codeTree').jstree("get_json", selId).data.codeNm);
	  	    	$("#levelNo").val(parseInt($('#codeTree').jstree("get_json", selId).data.levelNo)+1);
	  	    	$("#sortNo").val(parseInt($("#childCount").val())+1);
				$("#delBtn").css("display", "none");
				$("#frmTitle").text("코드 추가")
				$("#crud").val("CREATE");

				$("#codeTy").val("USR");
				$("#codeId").val($("#upperCodeId").val() + "_" + $("#sortNo").val());
				$("#codeNm").val("");
				$("#codeDc").val("");

				$("input:radio[name='usgAt'][value='Y']").prop("checked", true);

				$(".addTr").remove();
				$("#selLangCodeId option").remove();
    			$("#selLangCodeId").append($("<option></option>").attr("value", "").text("선택하세요"));
				<c:forEach var="langCodeList" items="${langCodeList}" varStatus="status">
				$("#selLangCodeId").append($("<option></option>").attr("value", "${langCodeList.codeId}").text("${langCodeList.codeNm}"));
				</c:forEach>
				$("#selLangCodeId option[value='ko']").remove();
			}

			function f_Delete(){
				if(confirm("삭제된 코드는 복구할 수 없습니다.\n\n선택하신 코드를 삭제하시겠습니까?")){
					$("#crud").val("DELETE");
					$("#frmCode").submit();
				}
			}

			$(function() {
				//언어셋 삭제
				$("#selLangCodeId option[value='ko']").remove();

				$("form[name='frmCode']").validate({
				    ignore: "input[type='text']:hidden",
				    rules : {
				    	upperCodeId	: { required : true },
				    	codeId			: { required : true },
				    	codeNm			: { required : true },
				    	sortNo			: { required : true, number : true}
				    },
				    messages : {
				    	upperCodeId	: { required : "상위코드를 먼저 선택하세요" },
				    	codeId			: { required : "코드를 입력하세요" },
					    codeNm			: { required : "코드명을 입력하세요" },
				    	sortNo			: { required : "정렬 순서를 입력하세요", number:"숫자만 입력 가능합니다."}
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
				    	frm.submit();
				    }
				});

				$("#codeTree").jstree({
					"core" : {
						"multiple" : false,
		                "themes" : { "responsive": false},
		                "ui" : {"select_limit" : 1},
				    	"data" : [
				              <c:forEach var="codeList" items="${codeList}" varStatus="status">
				              {
				            	  "id" : "${codeList.codeId}"
				            	  <c:if test="${codeList.upperCodeId eq '0'}">
				            	  , "parent" : "#"
								  , "text" : "${codeList.codeNm} [${codeList.codeId}]"
				            	  </c:if>
				            	  <c:if test="${codeList.upperCodeId ne '0'}">
				            	  , "parent" : "${codeList.upperCodeId}"
				            	  , "text" : "${codeList.codeNm}"
				            	  </c:if>
				            	  , "data" : {"codeGroupId" : "${codeList.codeGroupId}", "levelNo" : "${codeList.levelNo}"
				            		  			, "codeId" : "${codeList.codeId}", "codeNm" : "<c:out value='${codeList.codeNm}'/>"
				            		  			, "upperCodeId" : "${codeList.upperCodeId}", "upperCodeNm" : "<c:out value='${codeList.upperCodeNm}'/>"}
				            	  <c:if test="${codeList.codeTy ne 'SYS'}">, "type" : "codeTy"</c:if>
				              }<c:if test="${!status.last}">,</c:if>
				              </c:forEach>
				           ]
				       },
			            "types" : {
			                "default" : {
			                    "icon" : "fa fa-folder text-primary"
			                },
			                "codeTy" : {
			                    "icon" : "fa fa-folder text-warning"
			                }
			            },
				       "plugins" : [ "types" ]  //"dnd"
				});
				//$("#codeTree").jstree("open_all");//전체 열기
				$("#codeTree").bind("select_node.jstree", function(event, data){
					$.ajax({
		          		dataType : "json",
		          	    type : "POST",
		          	    url : "/admin/mng/code/getCode.json",
						contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
		          	    data : "codeId="+data.node.id,
		          	    success : function(data) {
		          	    	$("#frmTitle").text("'"+data.codeVO.codeNm +"' 코드 수정")

		          	    	$("#codeNm").attr("readonly", false);

		          	    	//값 설정
		          	    	$("#crud").val("UPDATE");
		          	    	$("#codeGroupId").val(data.codeVO.codeGroupId);
		        			$("#upperCodeId").val(data.codeVO.upperCodeId);
		        			$("#codeId").val(data.codeVO.codeId);
		        			$("#levelNo").val(data.codeVO.levelNo);
		        			$("#childCount").val(data.codeVO.childCount);
		        			$("#codeTy").val(data.codeVO.codeTy);

		        			if(data.codeVO.upperCodeId == "0"){
		        				$("#upperCodeNm").text("최상위 코드");
		        			}else{
		        				$("#upperCodeNm").text(data.codeVO.upperCodeNm);
		        			}
							if(data.codeVO.codeTy == "SYS"){
								$("#codeId").attr("readonly", true);
							}else{
								$("#codeId").attr("readonly", false);
							}
		        			$("#codeNm").val(data.codeVO.codeNm);
		        			$("#codeDc").val(data.codeVO.codeDc);
		        			$("#sortNo").val(data.codeVO.sortNo);

		        			//console.log("data.codeVO.useAt: " + data.codeVO.codeNm +"/"+ data.codeVO.useAt);

		        			$("input:radio[name='useAt'][value='"+ data.codeVO.useAt +"']").prop("checked", true);	//사용여부

		          	    	$("#codeTy").val(data.codeVO.codeTy);
		        			if(data.codeVO.codeTy == "SYS"){
		        				$("#delBtn").css("display", "none");
		        			}else{
		        				$("#delBtn").css("display", "");
		        			}
		        			if(data.codeVO.levelNo > 2){
		        				$("#addBtn").css("display", "none");
		        			}else{
		        				$("#addBtn").css("display", "block");
		        			}

							//reset
		        			$(".addTr").remove();
		        			$("#selLangCodeId option").remove();
		        			$("#selLangCodeId").append($("<option></option>").attr("value", "").text("선택하세요"));
		    				<c:forEach var="langCodeList" items="${langCodeList}" varStatus="status">
		    				$("#selLangCodeId").append($("<option></option>").attr("value", "${langCodeList.codeId}").text("${langCodeList.codeNm}"));
		    				</c:forEach>
		    				$("#selLangCodeId option[value='ko']").remove();

		        			$.each(data.codeVO.codeLangList, function(index, value){
			    				var html = "";
			    				html = html + "<tr style=\"background-color:#fcf8e3;\" class=\""+value.langCodeId+" addTr\"><th colspan=\"2\">";
			    				html = html + "<a class=\"btn btn-warning\" onclick=\"f_delLangCodeSet('"+ value.langCodeId +"', '"+ value.langCodeNm +"'); return false;\">추가언어 항목 삭제 ("+ value.langCodeNm +") <i class=\"icon icon-remove\"></i></a> <input type=\"hidden\" name=\"addLangCodeId\" value=\"U-"+ value.langCodeId +"\"/>";
			    				html = html + "</th></tr>";
			    				html = html + "<tr style=\"background-color:#fcf8e3;\" class=\""+value.langCodeId+" addTr\"><th>코드명 ("+ value.langCodeNm +")</th><td>";
			    				html = html + "<input id=\"addCodeNm_"+ value.langCodeId +"\" name=\"addCodeNm\" class=\"form-control\" type=\"text\" value=\""+ value.codeNm +"\"></td></tr>";

			    				$(html).insertAfter("#langTr");
			    				$("#selLangCodeId option[value='"+ value.langCodeId +"']").remove();

		        			});
						},
						error: function(data, status, err) {
							//console.log('error forward : ' + data);
						}
					});
				});//event 추가
			});
			</script>

			<!-- Start Breadcrumb -->
			<jsp:include page="/WEB-INF/jsp/admin/layout/breadcrumb.jsp">
				<jsp:param name="pageName" value="코드 관리"/>
			</jsp:include>
			<!-- End Breadcrumb -->

            <!-- start: page -->
			<div class="row">
				<div class="col-md-4">
				<section class="panel panel-featured panel-featured-primary">
					<header class="panel-heading">
						<div class="panel-actions">
							<button onclick="f_codeAdd(); return false;" class="mb-xs mr-xs btn btn-sm btn-default" id="addBtn"><i class="fa fa-plus"></i> 하위코드 추가</button>
						</div>
						<h2 class="panel-title">코드 목록</h2>
					</header>
					<div class="panel-body">
						<div class="widget-content" id="codeTree" style="padding:10px 0;">
						</div>
					</div>
				</section>
				</div>
				<div class="col-md-8">
				<section class="panel panel-featured panel-featured-primary">
				<f:form name="frmCode" id="frmCode" modelAttribute="codeVO" method="post" action="./action" class="form-horizontal form-bordered mb-md" >
					<f:hidden path="crud" />
					<f:hidden path="codeTy" />
					<f:hidden path="codeGroupId" />
					<f:hidden path="levelNo" />
					<f:hidden path="childCount" />

					<header class="panel-heading">
						<h2 class="panel-title" id="frmTitle">코드 추가</h2>
					</header>
					<div class="panel-body">
						<div class="table-responsive">

							<table class="table table-bordered mb-none">
								<colgroup>
									<col style="width:130px" />
									<col />
								</colgroup>
								<tr>
									<th>코드 구분 </th>
									<td>
										<i class="fa fa-folder text-primary"></i> 시스템 코드 &nbsp;
										<i class="fa fa-folder text-warning"></i> 추가 코드
										<span class="help-block">* 시스템 코드는 삭제가 불가능합니다.</span>
									</td>
								</tr>
								<tr>
									<th>상위코드</th>
									<td>
										<f:hidden path="upperCodeId" />
										<span id="upperCodeNm"></span>
									</td>
								</tr>
								<tr>
									<th>코드 (한국어) <span class="required">*</span></th>
									<td><f:input path="codeId" class="form-control" readonly="true" /></td>
								</tr>
								<tr>
									<th>코드명 (한국어) <span class="required">*</span></th>
									<td><f:input path="codeNm" class="form-control"  readonly="true" /></td>
								</tr>
								<tr  id="langTr">
									<th>언어항목 추가</th>
									<td>
										<div class="form-inline">
                                           <select id="selLangCodeId" name="selLangCodeId" class="form-control">
											<option value="" selected="selected">선택하세요</option>
											<c:forEach items="${langCodeList}" var="langCodeList">
											<option value="${langCodeList.codeId}">${langCodeList.codeNm }</option>
											</c:forEach>
                                           <select>
                                           <button class="btn btn-default" type="button" onclick="f_addLangCodeSet(); return false;">항목추가</button>
                                         </div>
									</td>
								</tr>
								<tr>
									<th>순서 <span class="required">*</span></th>
									<td><f:input path="sortNo" class="form-control" /></td>
								</tr>
								<tr>
									<th>코드설명</th>
									<td><f:textarea path="codeDc" class="form-control" style="height:100px;" placeholder="코드 설명"/></td>
								</tr>

								<tr>
									<th>사용여부 <span class="required">*</span></th>
									<td>
										<f:radiobuttons path="useAt" items="${useAtCode}" element="div class='radio-custom radio-primary'" />
									</td>
								</tr>
							</table>

						</div>
					</div>
					<footer class="panel-footer">
						<div class="row">
							<div class="col-sm-12 text-right">
                                <cmsBtn2:btn btnTy="save" path="${curPath}" mngrSession="${mngrSession }" >저장</cmsBtn2:btn>
                                <button class="btn btn-danger ml-xs" id="delBtn" onclick="f_Delete(); return false" style="display:none;">삭제</button>
							</div>
						</div>
					</footer>
                </f:form>
				</section>
				</div>
			</div>