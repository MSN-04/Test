<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ include file="/common/taglibs.jsp" %>
	<c:set var="globalAdminAssets" value="/humanframe/admin/assets" />
	<!-- datatables libs -->
	<link rel="stylesheet" href="${globalAdminAssets}/vendor/jquery-datatables-bs3/assets/css/datatables.css" />
	<script src="${globalAdminAssets}/vendor/jquery-datatables/media/js/jquery.dataTables.js"></script>
	<script src="${globalAdminAssets}/vendor/jquery-datatables/extras/TableTools/js/dataTables.tableTools.min.js"></script>
	<script src="${globalAdminAssets}/vendor/jquery-datatables-bs3/assets/js/datatables.js"></script>

	<script type="text/javascript">

	$(function() {

		$('[rel="tooltip"]').tooltip();

		var oTable = $('#fnctListTable').dataTable({
			sAjaxSource: "/admin/fnct/fnctProgrm/ajax/list",
			bProcessing: true,
			bServerSide: true,
			bFilter: false,
			bSort : false,
			bLengthChange: false, //limit count
			bDeferRender: true,//속도
			aoColumns: [
						{ mData: null, sWidth: "30px",
							createdCell : function(cell, cellData, rowData, row, col ){
// 								var postListTy = ${reqMap.postListTy};
								var str = cellData["fnctNo"];
								if($("input[name='fnctNo'][value='"+str+"']", opener.document).val() != str){
									$(cell).html('<input type="checkbox" name="fnctNo" value="' + str + '">');
								}
								else {
									$(cell).html('<input type="checkbox" name="fnctNo" checked="checked" value="' + str + '">');
								}
							}
						},
						{ mData: "fnctNm"},
						{ mData: "svcUrl", sWidth: "130px"},
						{ mData: null, sWidth: "80px",
							createdCell : function(cell, cellData, rowData, row, col ){
								var date = new Date(cellData["creatDttm"]);
								$(cell).html( date.getFullYear() + "/" + (date.getMonth()+1) + "/" + date.getDate() );
							}
						}
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
				restParams.push({name : "srchText", value :  $("#srchText").val()});
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
				$('.dataTables_scrollFootInner').css({"width":"100%"});

				if($(":checkbox[name='fnctNo']:checked").length>0){
					$(":checkbox[name='fnctNo']:unchecked").prop("disabled",true);
				}

				$(":checkbox[name='fnctNo']").on("click", function(){

					$("#mappedFnct tbody .no_data", opener.document).hide();
// 					$("#mappedFnct tbody tr", opener.document).not(".no_data").remove();

					if($(this).prop("checked")){

						$(":checkbox[name='fnctNo']").prop("checked",false);
						$(this).prop("checked",true);
						$(":checkbox[name='fnctNo']:unchecked").prop("disabled",true);

						var fnctTr = '<tr><td><input type="hidden" name="fnctNo" value="'+$(this).val()+'"/>'
								   + '<a href="/admin/fnct/fnctProgrm/view?fnctNo='+$(this).val()+'">'+$(this).parents("tr").find("td:eq(1)").text()+'</td>'
								   + '<td class="text-right"><a href="#DEL" class="btn btn-default btn-xs delBtn"><i class="fa fa-trash text-danger"></i> 해제</a>'
								   + '</td></tr>';
						$("#mappedFnct tbody", opener.document).append(fnctTr);
					}else{
						$(":checkbox[name='fnctNo']").prop("disabled",false);

						$("input[name='fnctNo'][value='"+$(this).val()+"']", opener.document).closest("tr").fadeOut(300, function(){
							$(this).remove();
							if($("#mappedFnct tbody tr", opener.document).not(".no_data").length<1){
								$("#mappedFnct tbody .no_data", opener.document).show();
							}
						});
					}
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

		$("tfoot input").on("keyup", function () {
			$('.dataTable_header').removeClass("hidden");
			oTable.fnPageChange(0);
			oTable.dataTable().fnDraw();
		});
		$("tfoot select").on("change", function(){
			$('.dataTable_header').removeClass("hidden");
			oTable.fnPageChange(0);
			oTable.dataTable().fnDraw();
		});
		$("tfoot button").on("click", function(){
			$('.dataTable_header').removeClass("hidden");
			oTable.dataTable().fnDraw();
		});
	});
	</script>


				<section class="panel panel-primary">
					<header class="panel-heading">
						<div class="panel-actions">
							<button class="btn btn-default" title="선택완료(닫기)" onclick="window.close(); return false;"><i class="fa fa-remove"></i> 선택완료(닫기)</button>
						</div>
						<h2 class="panel-title">메뉴리스트</h2>
					</header>
					<div class="panel-body pt-none pb-none">
						<table class="table table-bordered table-striped mb-none" id="fnctListTable">
							<colgroup>
								<col style="width:30px;" />
								<col />
								<col style="width:130px;" />
								<col style="width:80px;" />
							</colgroup>
							<thead>
								<tr>
									<th></th>
									<th>프로그램명</th>
									<th>서비스URL</th>
									<th>등록일</th>
								</tr>
							</thead>
							<tbody>

							</tbody>
							<tfoot>
								<tr>
									<th class="text-center"><button><i class="fa fa-refresh"></i></button></th>
									<th colspan="3">
										<div class="form-inline">
										<input type="text" id="srchText" name="srchText" value="" class="form-control search-query" placeholder="프로그램명">
										</div>
									</th>
								</tr>
							</tfoot>
						</table>
					</div>
				</section>

