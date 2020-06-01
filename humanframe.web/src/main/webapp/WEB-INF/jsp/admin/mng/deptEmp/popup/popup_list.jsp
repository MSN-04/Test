<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ include file="/common/taglibs.jsp" %>
	<c:set var="globalAdminAssets" value="/humanframe/admin/assets" />

 	<link rel="stylesheet" href="${globalAdminAssets}/vendor/jquery-datatables-bs3/assets/css/datatables.css" />

	<script src="${globalAdminAssets}/vendor/jquery-datatables/media/js/jquery.dataTables.js"></script>
	<script src="${globalAdminAssets}/vendor/jquery-datatables/extras/TableTools/js/dataTables.tableTools.min.js"></script>
	<script src="${globalAdminAssets}/vendor/jquery-datatables-bs3/assets/js/datatables.js"></script>


	<script type="text/javascript">

	function f_setEmpInfo(empInfo){
		var opener = window.opener;
		var target = $.trim("${target}");
		var targetInfo = target.split("|");
		var tempInfo = empInfo.split("|");

		//TO-DO 추후 개선
		if(targetInfo.length > 0 && targetInfo[0] != "")
			$("#"+targetInfo[0], opener.document).val(tempInfo[0]);	//부서코드
		if(targetInfo.length > 1 && targetInfo[1] != "")
			$("#"+targetInfo[1], opener.document).val(tempInfo[1]);	//부서명
		if(targetInfo.length > 2 && targetInfo[2] != "")
			$("#"+targetInfo[2], opener.document).val(tempInfo[2]);	//직원코드
		if(targetInfo.length > 3 && targetInfo[3] != "")
			$("#"+targetInfo[3], opener.document).val(tempInfo[3]);	//직원명
		if(targetInfo.length > 4 && targetInfo[4] != "")
			$("#"+targetInfo[4], opener.document).val(tempInfo[4]);	//전화번호
		if(targetInfo.length > 5 && targetInfo[5] != "")
			$("#"+targetInfo[5], opener.document).val(tempInfo[5]);	//이메일

		//callback
		if (typeof(opener.f_empSrch_callback) == "function") {
			opener.f_empSrch_callback();
		}

		window.close();
	}

	$(function() {

		var oTable = $('#empListTable').dataTable({
			sAjaxSource: "/admin/ajax/deptEmpList",
			//sScrollY:300,
			bProcessing: false,
			bServerSide: true,
			bFilter: false,
			bInfo: true,
			bSort : false,
			bAutoWidth: true, //width 고정
			bLengthChange: false, //limit count
			bDeferRender: true,//속도
			aoColumns: [
						{ mData: null, sWidth: "30px",

							createdCell : function(cell, cellData, rowData, row, col ){
								var str = rowData["empCode"];
								var strInfo = rowData["deptCode"]+"|"+rowData["deptNm"]+"|"+rowData["empCode"]+"|"+rowData["empNm"]+"|"+rowData["telno"]+"|"+rowData["email"];
								<c:if test="${mode eq 'S'}">
									<c:if test="${se eq 'R'}">
										if(rowData["mngrId"] == null){
											$(cell).html('<a href="#" onclick="f_setEmpInfo(\''+ strInfo +'\');return false;" class="btn-xs btn-primary"><i class="fa fa-check"></i></a>');
										}else{
											$(cell).html('<i class="fa fa-ban"></i>');
										}
									</c:if>
									<c:if test="${se eq 'S'}">
										$(cell).html('<a href="#" onclick="f_setEmpInfo(\''+ strInfo +'\');return false;" class="btn-xs btn-primary"><i class="fa fa-check"></i></a>');
									</c:if>
								</c:if>
								<c:if test="${mode eq 'M'}">
									$(cell).html('<input type="checkbox" data-style="checkbox" name="arrEmpCode" value="' + str + '">');
								</c:if>
							}
						},
						{ mData: null, sWidth: "40px"},
						{ mData: "deptNmPath",
							createdCell : function(cell, cellData, rowData, row, col ){
								var str = rowData["deptNmPath"];
								$(cell).html(str);
							}
						},
						{ mData: "clsfNm", sWidth: "150px"},
						{ mData: "empNm", sWidth: "60px"},
						{ mDataProp: "telno", sWidth: "100px"}
					 ],
			fnServerData: function ( sSource, aoData, fnCallback ) {
				$('.dataTable_header').removeClass("hidden");
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
				restParams.push({name : "srchEmpNm", value :  $("#srchEmpNm").val()});
				restParams.push({name : "srchTelno", value :  $("#srchTelno").val()});
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
						$('td:eq(1)', oSettings.aoData[ oSettings.aiDisplay[i] ].nTr ).html( startNum - i );
					}

			 		$('#empListTable tbody tr').hover(function() {
			        	$(this).css('cursor', 'pointer');
			         }, function() {
						$(this).css('cursor', 'auto');
			         });
			 		$('#empListTable_info').html("");
					//담당자 계정신청화면에서만
					if(window.opener.location.pathname=="/admin/loginMngrReq"){
						//검색결과가 1명인데 이미 아이디가 있을 때 문구 추가
						if(startNum == 1 && $('#empListTable tbody tr:eq(0) td:eq(0)').find('a').length == 0){
							var ename = $('#empListTable tbody tr:eq(0) td:eq(4)').text();
							var word1 = "<tr><td colspan='6'><div style='display:block; border:1px solid blue; padding: 5px; border-radius: 10px; font-weight:bold; '>"+ename+"님은 이미 담당자의 계정(아이디/비밀번호)가 있습니다.<br/>아이디/비밀번호를 잊어버리신 경우 관리자에게 문의바랍니다.</div></td></tr>";
							$('#empListTable tbody').append(word1);
						}
						//안내 문구 추가
						$('#empListTable_info').append("<p style='color:black; font-weight:bold;'><i class='fa fa-ban'></i> 표시가 있는 분은 이미 계정(아이디/비밀번호)가 있습니다.</p>");
					}

					$('.dataTables_scrollFootInner').css({"width":"100%"});
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
	});
	</script>


		<section class="panel panel-primary mb-none">
		<header class="panel-heading">
			<div class="panel-actions">
				<button class="btn btn-default" title="선택완료(닫기)" onclick="window.close(); return false;"><i class="fa fa-remove"></i> 선택완료(닫기)</button>
			</div>
			<h2 class="panel-title">직원리스트</h2>
		</header>
		<div class="panel-body">
			<table class="table table-bordered table-striped mb-none" id="empListTable">
				<colgroup>
					<col style="width:20px;" />
					<col style="width:20px;" />
					<col />
					<col style="width:100px;" />
					<col style="width:100px;" />
					<col style="width:100px;" />
				</colgroup>
				<thead>
					<tr>
						<th>
							<c:if test="${mode eq 'M'}">
							<input type="checkbox" data-style="checkbox" />
							</c:if>
						</th>
						<th>순번</th>
						<th>부서</th>
						<th>직급</th>
						<th>직원명</th>
						<th>연락처</th>
					</tr>
				</thead>
				<tbody>

				</tbody>
				<tfoot>
					<tr>
						<th colspan="2"></th>
						<th>
							<input type="hidden" id="srchDeptCode" name="srchDeptCode"/>
							<input type="text" id="srchDeptNm" name="srchDeptNm" placeholder="부서" class="form-control" />
						</th>
						<th><input type="text" id="srchClsfNm" name="srchClsfNm" placeholder="직급" class="form-control" /></th>
						<th><input type="text" id="srchEmpNm" name="srchEmpNm" placeholder="직원명" class="form-control" /></th>
						<th><input type="text" id="srchTelno" name="srchTelno" placeholder="연락처" class="form-control" /></th>
					</tr>
				</tfoot>
			</table>
		</div>
	</section>
