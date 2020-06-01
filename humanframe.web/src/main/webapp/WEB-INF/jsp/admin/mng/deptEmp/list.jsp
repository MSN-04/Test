<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ include file="/common/taglibs.jsp" %>

	<link rel="stylesheet" href="${globalAdminAssets}/vendor/jstree/themes/default/style.css" />
	<script src="${globalAdminAssets}/vendor/jstree/jstree.js"></script>

	<link rel="stylesheet" href="${globalAdminAssets}/vendor/jquery-datatables-bs3/assets/css/datatables.css" />

	<script src="${globalAdminAssets}/vendor/jquery-datatables/media/js/jquery.dataTables.js"></script>
	<script src="${globalAdminAssets}/vendor/jquery-datatables/extras/TableTools/js/dataTables.tableTools.min.js"></script>
	<script src="${globalAdminAssets}/vendor/jquery-datatables-bs3/assets/js/datatables.js"></script>


	<script type="text/javascript">

	var oTable;
	$(function() {

		/* dataTable ajax */
		oTable = $('#empListTable').dataTable({
			sAjaxSource: "/admin/ajax/deptEmpList",
			bProcessing: true,
			bServerSide: true,
			bFilter: false,
			bInfo: false,
			bSort : false,
			bAutoWidth: false, //width 고정
			//bStateSave: true,
			bLengthChange: false, //limit count
			bDeferRender: true,//속도
			aoColumns: [
						{ mData: null, sWidth: "40px"},
						{ mData: "deptNmPath"},
						{ mData: "clsfNm", sWidth: "100px"},
						/* { mData: "empCode", sWidth: "100px"}, */
						{ mData: "empNm", sWidth: "80px"},
						{ mDataProp: "telno", sWidth: "100px"}
					 ],
			fnServerData: function ( sSource, aoData, fnCallback ) {
	           	var paramMap = {};
				for ( var i = 0; i < aoData.length; i++) {
	          		paramMap[aoData[i].name] = aoData[i].value;
				}
				var cntPerPage = 10;
				var start = paramMap.iDisplayStart;
				var pageNum = (start == 0) ? 1 : (start / cntPerPage) + 1; // pageNum is 1 based

				var restParams = new Array();
				restParams.push({name : "sEcho", value : paramMap.sEcho});
				restParams.push({name : "cntPerPage", value : cntPerPage});
				restParams.push({name : "curPage", value : pageNum });
				restParams.push({name : "srchDeptCode", value :  $("#srchDeptCode").val()});
				restParams.push({name : "srchDeptNm", value :  $("#srchDeptNm").val()});
				restParams.push({name : "srchClsfNm", value :  $("#srchClsfNm").val()});
				restParams.push({name : "srchEmpCode", value :  $("#srchEmpCode").val()});
				restParams.push({name : "srchEmpNm", value :  $("#srchEmpNm").val()});
				restParams.push({name : "srchTelno", value :  $("#srchTelno").val()});
				restParams.push({name : "srchJobGuidance", value :  $("#srchJobGuidance").val()});
				$.ajax({
	          		dataType : 'json',
	          	    type : "POST",
	          	    url : sSource,
	          	    data : restParams,
	          	    success : function(data) {
	          	    	fnCallback(data);
					}
				});
			},
			fnDrawCallback: function(){
				$('.dataTable_header').addClass("hidden");
				var oSettings = this.fnSettings();
				var startNum = oSettings.fnRecordsDisplay() - oSettings._iDisplayStart;
				var endNum = startNum - oSettings._iDisplayLength + 1;
				if(endNum < 0){ endNum = 1;}
					for ( var i=0, iLen=oSettings.aiDisplay.length ; i<iLen ; i++ ){
						$('td:eq(0)', oSettings.aoData[ oSettings.aiDisplay[i] ].nTr ).html( startNum - i );
					}
					$('#empListTable tbody tr').click(function() {
		               	var empCode = oTable.fnGetData(this)["empCode"];
		               	//직원정보 set
		               	$("#crud").val("UPDATE");
		               	$("#empCode").val(empCode);
		               	$("#deptCode").val(oTable.fnGetData(this)["deptCode"]);
		               	$("#deptNm").val(oTable.fnGetData(this)["deptNm"]);
		               	$("#empNm").val(oTable.fnGetData(this)["empNm"]);
		               	$("#empEngNm").val(oTable.fnGetData(this)["empEngNm"]);
		               	$("input:radio[name='sexdstn'][value='"+ oTable.fnGetData(this)["sexdstn"] +"']").prop("checked", true);
		               	$("#rspofcNm").val(oTable.fnGetData(this)["rspofcNm"]);
		               	$("#clsfNm").val(oTable.fnGetData(this)["clsfNm"]);
		               	$("#ofcpsNm").val(oTable.fnGetData(this)["ofcpsNm"]);
		               	$("#telno").val(oTable.fnGetData(this)["telno"]);
		               	$("#email").val(oTable.fnGetData(this)["email"]);
		               	$("#sortNo").val(oTable.fnGetData(this)["sortNo"]);
		               	$("input:radio[name='dspyAt'][value='"+ oTable.fnGetData(this)["dspyAt"] +"']").prop("checked", true);
		               	$("#jobGuidance").val(oTable.fnGetData(this)["jobGuidance"]);

		              //modal open
		        		$.magnificPopup.open({
		        			items:{src:'#empModal'},
		        			type: 'inline',
		        			preloader: false,
		        			modal: false
		        		});

					});
					$('#empListTable tbody tr').hover(function() {
			        	$(this).css('cursor', 'pointer');
			        }, function() {
						$(this).css('cursor', 'auto');
			        });
			},
		 	oLanguage: {
		 		sEmptyTable: "데이터가 없습니다.",
		 		sProcessing:"로딩중입니다.",
		 		oPaginate: {
		 			"sPrevious" : "PREV",
		 			"sNext" : "NEXT"
		 			},
		 		sInfo: "_START_~_END_ / _TOTAL_"
		    }
		});

		$("tfoot input").keyup( function () {
			$('.dataTable_header').removeClass("hidden");
			oTable.fnPageChange(0);
			oTable.dataTable().fnDraw();
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
	                    "icon" : "fa-folder text-warning"
	                }
	            },
		       "plugins" : ["types" ]  //"dnd"
		});
		$("#mngDeptTree").jstree('open_node', '${deptList[0].upperDeptCode}');
		$("#mngDeptTree").bind("select_node.jstree", function(event, data){
			$("#srchDeptCode").val(data.node.id);
			oTable.dataTable().fnDraw();
		});//event 추가

		//form check
		$("form[name='frmEmp']").validate({
		    ignore: "input[type='text']:hidden",
		    rules : {
		    	deptNm			: { required : true},
		    	empNm			: { required : true},
		    	sortNo			: { required : true, digits : true }
		    },
		    messages : {
			    deptNm			: { required : "부서를 선택하세요"},
			    empNm			: { required : "직원명을 입력하세요"},
			    sortNo			: { required : "서열을 입력하세요", digits : "정수만 입력하세요"  }
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
		    	frm.submit();
		    }
		});

	});

	function f_empAdd(){
		var selId = $("#mngDeptTree").jstree("get_selected");//선택된 코드
		if(selId == ""){
			alert("부서를 먼저 선택하세요");
			return false;
		}

		$("#crud").val("CREATE");
		$("#deptCode").val($("#mngDeptTree").jstree("get_json", selId).data.deptCode);
		$("#deptNm").val($("#mngDeptTree").jstree("get_json", selId).data.deptNm);

		$("#empCode").val("");
       	//$("#deptCode").val("");
       	//$("#deptNm").val("");
       	$("#empNm").val("");
       	$("#empEngNm").val("");
       	$("input:radio[name='sexdstn'][value='Y']").prop("checked", true);
       	$("#rspofcNm").val("");
       	$("#clsfNm").val("");
       	$("#ofcpsNm").val("");
       	$("#telno").val("");
       	$("#email").val("");
       	$("#sortNo").val("");
       	$("input:radio[name='dspyAt'][value='Y']").prop("checked", true);
       	$("#jobGuidance").val("");

       	//modal open
		$.magnificPopup.open({
			items:{src:'#empModal'},
			type: 'inline',
			preloader: false,
			modal: false
		});

	}
	</script>


			<!-- Start Breadcrumb -->
			<jsp:include page="/WEB-INF/jsp/admin/layout/breadcrumb.jsp">
				<jsp:param name="pageName" value="직원관리"/>
			</jsp:include>
			<!-- End Breadcrumb -->

            <!-- start: page -->
			<div class="row">
				<div class="col-md-4">
				<section class="panel panel-featured panel-featured-primary">
					<header class="panel-heading">
						<div class="panel-actions">
							<button onclick="f_empAdd(); return false;" class="mb-xs mr-xs btn btn-sm btn-default"><i class="fa fa-plus"></i> 직원등록</button>
						</div>
						<h2 class="panel-title">부서목록</h2>
					</header>
					<div class="panel-body">
						<div id="mngDeptTree" style="padding:10px 0;">
						</div>
					</div>
				</section>
				</div>
				<div class="col-md-8">
				<section class="panel panel-featured panel-featured-primary">

					<header class="panel-heading">
						<h2 class="panel-title" id="frmTitle">직원목록</h2>
					</header>
					<div class="panel-body">

							<table class="table table-bordered mb-none" id="empListTable">
								<colgroup>
									<col style="width:60px;" />
									<col />
									<col style="width:100px;" />
									<!-- <col style="width:100px;" /> -->
									<col style="width:60px;" />
									<col style="width:100px;" />
								</colgroup>
								<thead>
									<tr>
										<th style="text-align: center;">순번</th>
										<th style="text-align: center;">부서</th>
										<th style="text-align: center;">직급</th>
										<!-- <th>직원코드</th> -->
										<th style="text-align: center;">직원명</th>
										<th style="text-align: center;">연락처</th>
									</tr>
								</thead>
								<tbody>

								</tbody>
								<tfoot>
									<tr>
										<th rowspan="2"></th>
										<th>
											<input type="hidden" id="srchDeptCode" name="srchDeptCode"/>
											<input type="text" id="srchDeptNm" name="srchDeptNm" placeholder="부서" class="form-control" />
										</th>
										<th><input type="text" id="srchClsfNm" name="srchClsfNm" placeholder="직급" class="form-control" /></th>
										<!-- <th><input type="text" id="srchEmpCode" name="srchEmpCode" placeholder="직원코드" class="form-control" /></th> -->
										<th><input type="text" id="srchEmpNm" name="srchEmpNm" placeholder="직원명" class="form-control" /></th>
										<th><input type="text" id="srchTelno" name="srchTelno" placeholder="연락처" class="form-control" /></th>
									</tr>
									<tr>
										<th colspan="5"><input type="text" id="srchJobGuidance" name="srchJobGuidance" placeholder="업무명" class="form-control" /></th>
									</tr>
								</tfoot>
							</table>

					</div>

					<div id="empModal" class="modal-block modal-block-primary mfp-hide" style="width:640px;">
						<section class="panel panel-featured panel-featured-primary">
			            	<f:form name="frmEmp" id="frmEmp" modelAttribute="deptEmpVO" method="post" action="./action" >
			            	<f:hidden path="crud" />
							<f:hidden path="deptCode" />
							<f:hidden path="empCode" />
							<header class="panel-heading">
								<h2 class="panel-title">직원정보 등록/수정</h2>
							</header>
							<div class="panel-body">
								<table class="table table-bordered mb-none">
									<colgroup>
										<col style="width:100px" />
										<col style="width:200px" />
										<col style="width:100px" />
										<col />
									</colgroup>
									<tbody>
										<tr>
											<th>부서명 <span class="required">*</span></th>
											<td colspan="3">
												<f:input path="deptNm" class="form-control" readonly="true" />
											</td>
										</tr>
										<tr>
											<th>직원명 <span class="required">*</span></th>
											<td>
												<f:input path="empNm" class="form-control" />
											</td>
											<th>직원(영문)명 </th>
											<td><f:input path="empEngNm" class="form-control" /></td>
										</tr>
										<tr>
											<th>성별</th>
											<td colspan="3">
													<f:radiobuttons path="sexdstn" items="${sexdstnTyCode}" element="div class='radio-custom radio-primary'" />
											</td>
										</tr>
										<tr>
											<th>직책 </th>
											<td><f:input path="rspofcNm" class="form-control" /></td>
											<th>직급</th>
											<td><f:input path="clsfNm" class="form-control" /></td>
										</tr>
										<tr>
											<th>직위</th>
											<td colspan="3"><f:input path="ofcpsNm" class="form-control"/></td>
										</tr>
										<tr>
											<th>전화번호</th>
											<td><f:input path="telno" class="form-control" /></td>
											<th>이메일</th>
											<td><f:input path="email" class="form-control" /></td>
										</tr>

										<tr>
											<th>서열 <span class="required">*</span></th>
											<td><f:input path="sortNo" class="form-control" /></td>
											<th>전시여부</th>
											<td>
												<f:radiobuttons path="dspyAt" items="${useAtCode}" element="div class='radio-custom radio-primary'" />
											</td>
										</tr>
										<tr>
											<th>업무안내</th>
											<td colspan="3"><f:textarea path="jobGuidance" class="form-control" /></td>

										</tr>
									</tbody>
								</table>
							</div>
							<footer class="panel-footer">
								<div class="row">
									<div class="col-sm-6">
				                    	<button class="btn btn-default modal-dismiss">닫기</button>
				                    </div>
				                    <div class="col-sm-6 text-right">
				                    	<cmsBtn2:btn btnTy="save" path="${curPath}" mngrSession="${mngrSession }" >저장</cmsBtn2:btn>
				                    </div>
			                    </div>
							</footer>
		               		</f:form>
						</section>
		            </div>

				</section>
				</div>
			</div>


