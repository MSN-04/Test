<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ include file="/common/taglibs.jsp" %>

	<link rel="stylesheet" href="${globalAdminAssets}/vendor/jquery-datatables-bs3/assets/css/datatables.css" />

	<script src="${globalAdminAssets}/vendor/jquery-datatables/media/js/jquery.dataTables.js"></script>
	<script src="${globalAdminAssets}/vendor/jquery-datatables/extras/TableTools/js/dataTables.tableTools.min.js"></script>
	<script src="${globalAdminAssets}/vendor/jquery-datatables-bs3/assets/js/datatables.js"></script>

	<script type="text/javascript">

	function f_setDeptInfo(selInfo){
		var opener = window.opener;
		var target = $.trim("${target}");
		var targetInfo = target.split("|");
		var tempInfo = selInfo.split("|");

		$("#"+targetInfo[0], opener.document).val(tempInfo[0]);	//부서코드
		$("#"+targetInfo[1], opener.document).val(tempInfo[1]);	//부서명
		if(targetInfo.length > 2){
		$("#"+targetInfo[2], opener.document).val(tempInfo[2]);	//전화번호
		}

		window.close();
	}

	$(function() {

        $('[rel="tooltip"]').tooltip({
        });

		var oTable = $('#empListTable').dataTable({
			sAjaxSource: "/admin/mng/dept/ajaxList",
			//sScrollY:300,
			bProcessing: false,
			bServerSide: true,
			bFilter: false,
			bInfo: false,
			bSort : false,
			bAutoWidth: true, //width 고정
			bLengthChange: false, //limit count
			bDeferRender: true,//속도
			aoColumns: [
						{ mData: null, sWidth: "43px",

							createdCell : function(cell, cellData, rowData, row, col ){
								var str = rowData["deptCode"];
								var strInfo = rowData["deptCode"]+"|"+rowData["deptNm"]+"|"+rowData["telno"];
								<c:if test="${mode eq 'S'}">
										$(cell).html('<a href="#" onclick="f_setDeptInfo(\''+ strInfo +'\');return false;" class="btn-xs btn-primary"><i class="fa fa-check"></i></a>');
								</c:if>
								<c:if test="${mode eq 'M'}">
									$(cell).html('<input type="checkbox" data-style="checkbox" name="arrDeptCode" value="' + str + '">');
								</c:if>
							}
						},
						{ mData: null, sWidth: "40px"},
						{ mData: "deptNm",
							createdCell : function(cell, cellData, rowData, row, col ){
								var str = rowData["deptNm"];
								$(cell).html(str);
							}
						},
						{ mDataProp: "telno", sWidth: "150px"}
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
				restParams.push({name : "srchDeptNm", value :  $("#srchDeptNm").val()});
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
			<h2 class="panel-title">부서리스트</h2>
		</header>
		<div class="panel-body">
			<table class="table table-bordered table-striped mb-none" id="empListTable">
				<colgroup>
					<col style="width:43px;" />
					<col style="width:80px;" />
					<col />
					<col style="width:150px;" />
				</colgroup>
				<thead>
					<tr>
						<th>
							<c:if test="${mode eq 'M'}">
							<input type="checkbox" data-style="checkbox" />
							</c:if>
						</th>
						<th>순번</th>
						<th>부서명</th>
						<th>연락처</th>
					</tr>
				</thead>
				<tbody>

				</tbody>
				<tfoot>
					<tr>
						<th colspan="2"></th>
						<th><input type="text" id="srchDeptNm" name="srchDeptNm" placeholder="부서" class="form-control" /></th>
						<th><input type="text" id="srchTelno" name="srchTelno" placeholder="연락처" class="form-control" /></th>
					</tr>
				</tfoot>
			</table>
		</div>
	</section>
