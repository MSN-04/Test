<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ include file="/common/taglibs.jsp" %>
	<link rel="stylesheet" href="${globalAdminAssets}/vendor/jstree/themes/default/style.css" />
	<script src="${globalAdminAssets}/vendor/jstree/jstree.js"></script>

	<script type="text/javascript">
	function f_deptSearch(){
		var deptCrud = $('#crud').val();
		var deptCode = $('#deptCode').val();
		window.open("/admin/mng/dept/popup/deptList?deptCode="+deptCode+"&deptCrud="+deptCrud, "popDept", "width=400, height=500");
	}


	//부서검색>>부서코드|부서명|전화번호(선택)
	function f_deptSrch2(){
		var target ="deptCode|deptNm|telno";
		window.open("/admin/mng/dept/popup/deptList2?target="+target, "popDept", "width=780, height=525");
	}

	function f_Delete(){//하위부서 존재여부 확인
		$.ajax({
			type : "post",
			url: '/admin/mng/dept/lowerDeptCheck',
			data: 'deptCode=' + $("#deptCode").val(),
			dataType: 'text', //전송받을 데이터의 타입
			contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
			success: function(data) {
				if(data=="true"){//없음
					if(confirm("삭제된 부서는 복구할 수 없습니다.\n\n선택하신 부서를 삭제하시겠습니까?")){
						$("#crud").val("DELETE");
						$("#frmDept").submit();
					}
				}else{
					alert("하위 부서가 존재할 경우 삭제할 수 없습니다.");
				}
			},
			error: function(data, status, err) {
				console.log('error forward : ' + data);
			}
		});
	}


	function f_deptAdd(){ //form 초기화
		var selId = $("#mngDeptTree").jstree("get_selected");//선택된 코드

		if(selId == ""){
			alert("상위 부서를 먼저 선택하세요");
			return false;
		}
		//var levelNo = $('#mngDeptTree').jstree("get_json", selId).data.levelNo;
    	$("#levelNo").val(parseInt($('#mngDeptTree').jstree("get_json", selId).data.levelNo)+1);
    	if($("#levelNo").val() > 2){$("#upperDeptDiv").css("display", "");}else{$("#upperDeptDiv").css("display", "none");}
    	$("#upperDeptCode").val($('#mngDeptTree').jstree("get_json", selId).data.deptCode);
    	$("#upperDeptNm").val($('#mngDeptTree').jstree("get_json", selId).data.deptNm);
		$("#frmTitle").text("'"+$('#mngDeptTree').jstree("get_json", selId).data.deptNm +"' 하위부서 추가")

		$("#crud").val("CREATE");

    	$("#deptCode").val("");
    	$("#deptNm").val("");
    	$("#telno").val("");
    	$("#fxnum").val("");
    	$("#deptEngNm").val("");
    	$("#jobGuidance").val("");
    	$("#sortNo").val("");	//서열
		$("#updtDttm").html(new Date().format("yyyy년 MM월 dd일 HH시 mm분"));	//수정일

		$("input:radio[name='dspyAt'][value='Y']").prop("checked", true);
		$("input:radio[name='useAt'][value='Y']").prop("checked", true);

	}


	$(function() {

		$("form[name='frmDept']").validate({
		    ignore: "input[type='text']:hidden",
		    rules : {
		    	deptNm			: { required : true},
		    	sortNo			: { required : true, digits : true }
		    },
		    messages : {
			    deptNm			: { required : "부서명을 입력하세요"},
			    sortNo			: { required : "서열을 입력하세요", digits : "정수만 입력하세요"  }
		    },
		    errorElement: 'label',
		    errorClass: 'error',
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
		    	frm.submit();
		    }
		});

		$("#mngDeptTree").jstree({
			"core" : {
				"multiple" : false,
                "themes" : { "responsive": false},
                "ui" : {"select_limit" : 1},
		    	"data" : [
		              <c:forEach var="deptList" items="${deptList}" varStatus="status">
		              {
		            	  "id" : "${deptList.deptCode}"
		            	  <c:if test="${deptList.levelNo == 1}">
		            	  , "parent" : "#"
		            	  </c:if>
		            	  <c:if test="${deptList.levelNo == 2}">
		            	  , "parent" : "${!empty deptList.virtlCode?deptList.virtlCode:deptList.upperDeptCode}"
		            	  </c:if>
		            	  <c:if test="${deptList.levelNo > 2}">
						  , "parent" : "${deptList.upperDeptCode}"
		            	  </c:if>
		            	  , "text" : "${deptList.deptNm}"
		            	  , "data" : {"levelNo" : "${deptList.levelNo}"
		            		  			, "deptCode" : "${deptList.deptCode}", "deptNm" : "<c:out value='${deptList.deptNm}'/>"
		            		  			, "upperDeptCode" : "${deptList.upperDeptCode}", "upperDeptNm" : "<c:out value='${deptList.upperDeptNm}'/>"}
		              }<c:if test="${!status.last}">,</c:if>
		              </c:forEach>
		           ]
		       },
	            "types" : {
	                "default" : {
	                    "icon" : "fa fa-folder text-info"
	                },
	                "deptTy" : {
	                    "icon" : "fa fa-folder text-warning"
	                }
	            },
		       "plugins" : [ "types" ]  //"dnd"
		});
		$("#mngDeptTree").jstree('open_node', '${deptList[0].upperDeptCode}');
		//$("#mngDeptTree").jstree("open_all");//전체 열기
		$("#mngDeptTree").bind("select_node.jstree", function(event, data){
			//alert(data.node.id + "//" + data.node.parent + "//" +data.node.text );
			//if(data.node.parent == "\#"){
			//	alert("홈 부서는 수정할 수 없습니다.");
			//}else{
				$.ajax({
	          		dataType : "json",
	          	    type : "POST",
	          	    url : "/admin/mng/dept/getDeptInfo.json",
					contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
	          	    data : "deptCode="+data.node.id,
	          	    success : function(data) {
	          	    	$("#frmTitle").text("'"+data.deptNm +"' 부서 수정")

	          	    	//값 설정
	          	    	$("#crud").val("UPDATE");
	        			$("#upperDeptCode").val(data.upperDeptCode);	//상위부서No
	        			$("#upperDeptNm").val(data.upperDeptNm);	//상위부서명
	        			//if(data.levelNo > 2){$("#upperDeptDiv").css("display", "");}else{$("#upperDeptDiv").css("display", "none");}
	        			$("#deptCode").val(data.deptCode);	//부서No
	        			$("#deptNm").val(data.deptNm);	//부서명
	        			$("#levelNo").val(data.levelNo);	//차수
	        			$("#telno").val(data.telno);	//전화번호
	        			$("#fxnum").val(data.fxnum);	//이메일
	        			$("#deptEngNm").val(data.deptEngNm);	//영문명
	        			$("#sortNo").val(data.sortNo);	//서열
	        			$("#jobGuidance").val(data.jobGuidance);	//업무안내
	        			$("#updtDttm").html(new Date(data.updtDttm).format("yyyy년 MM월 dd일 HH시 mm분"));	//수정일
	        			$("input:radio[name='dspyAt'][value='"+ data.dspyAt +"']").prop("checked", true);	//노출여부
	        			$("input:radio[name='useAt'][value='"+ data.useAt +"']").prop("checked", true);	//사용여부

					},
					error: function(data, status, err) {
						console.log('error forward : ' + data);
					}
				});
			//}
		});//event 추가
	});
	</script>

			<!-- Start Breadcrumb -->
			<jsp:include page="/WEB-INF/jsp/admin/layout/breadcrumb.jsp">
				<jsp:param name="pageName" value="부서 관리"/>
			</jsp:include>
			<!-- End Breadcrumb -->

            <!-- start: page -->
			<div class="row">
				<div class="col-md-4">
				<section class="panel panel-featured panel-featured-primary">
					<header class="panel-heading">
						<div class="panel-actions">
							<button onclick="f_deptAdd(); return false;" class="mb-xs mr-xs btn btn-sm btn-default" id="addBtn"><i class="fa fa-plus"></i> 하위부서 추가</button>
						</div>
						<h2 class="panel-title">부서 목록</h2>
					</header>
					<div class="panel-body">
						<div id="mngDeptTree" style="padding:10px 0;">
						</div>
					</div>
				</section>
				</div>
				<div class="col-md-8">
				<section class="panel panel-featured panel-featured-primary">

					<f:form name="frmDept" id="frmDept" modelAttribute="deptVO" method="post" action="./action" >
					<f:hidden path="crud" />
					<f:hidden path="deptCode" />
					<f:hidden path="upperDeptCode" />
					<f:hidden path="levelNo" />

					<header class="panel-heading">
						<h2 class="panel-title" id="frmTitle">부서 추가</h2>
					</header>
					<div class="panel-body">
						<div class="table-responsive">

							<table class="table table-bordered mb-none">
								<colgroup>
									<col style="width:100" />
									<col />
								</colgroup>
								<tr id="upperDeptDiv" style=";">
									<th>상위부서</th>
									<td>
										<div class="form-inline">
										<f:input path="upperDeptNm" readonly="true" placeHolder="부서" class="form-control" />
										<!-- <button class="btn" type="button" onclick="f_deptSearch(); return false;" >선택</button> -->
										</div>
										<div></div>
									</td>
								</tr>
								<tr>
									<th>부서명 <span class="required">*</span></th>
									<td><f:input path="deptNm" class="form-control" maxlength="100" /></td>
								</tr>
								<tr>
									<th>전화번호</th>
									<td><f:input path="telno" class="form-control" maxlength="30" /></td>
								</tr>
								<tr>
									<th>팩스번호</th>
									<td><f:input path="fxnum" class="form-control" maxlength="30" /></td>
								</tr>
								<tr>
									<th>부서명(영문)</th>
									<td><f:input path="deptEngNm" class="form-control" maxlength="100" /></td>
								</tr>
								<tr>
									<th>서열 <span class="required">*</span></th>
									<td>
										<f:input path="sortNo" class="form-control" />
										<span class="help-block">
										* '정렬순서'입니다.
										</span>
									</td>
								</tr>
								<tr>
									<th>업무안내</th>
									<td><f:textarea path="jobGuidance" class="form-control"/></td>
								</tr>
								<tr>
									<th>갱신일</th>
									<td><span id="updtDttm"></span></td>
								</tr>
								<tr>
									<th>노출여부</th>
									<td>
										<f:radiobuttons path="dspyAt" items="${useAtCode}" element="div class='radio-custom radio-primary'" />
									</td>
								</tr>
								<tr>
									<th>사용여부 <span class="required">*</span></th>
									<td>
										<f:radiobuttons path="useAt" items="${useAtCode}" element="div class='radio-custom radio-primary'" />
										<span class="help-block">* '사용안함'를 선택한 경우 하위부서까지 일괄 적용됩니다.</span>
									</td>
								</tr>
							</table>

						</div>
					</div>
					<footer class="panel-footer">
						<div class="row">
							<div class="col-sm-12 text-right">
								<cmsBtn2:btn btnTy="save" path="${curPath}" mngrSession="${mngrSession }" >저장</cmsBtn2:btn>
								<button class="btn btn-danger ml-xs" id="delBtn" onclick="f_Delete(); return false"  style="display:none;">삭제</button>
							</div>
						</div>
					</footer>
					</f:form>

				</section>
				</div>
			</div>