<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ include file="/common/taglibs.jsp" %>
	<c:set var="globalAdminAssets" value="/humanframe/admin/assets" />

	<link rel="stylesheet" href="${globalAdminAssets}/vendor/jquery-datatables-bs3/assets/css/datatables.css" />

	<script src="${globalAdminAssets}/vendor/jquery-datatables/media/js/jquery.dataTables.js"></script>
	<script src="${globalAdminAssets}/vendor/jquery-datatables/extras/TableTools/js/dataTables.tableTools.min.js"></script>
	<script src="${globalAdminAssets}/vendor/jquery-datatables-bs3/assets/js/datatables.js"></script>

	<script type="text/javascript">

	$(function() {

		$('[rel="tooltip"]').tooltip();

		var oTable = $('#menuListTable').dataTable({
			sAjaxSource: "/admin/cntnts/ajax/list",
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
								var str = rowData["cntntsNo"];
								if($("input[name='arrCntntsNo'][value='"+str+"']", opener.document).val() != str){
									$(cell).html('<input type="checkbox" name="arrCntntsNo" value="' + str + '">');
								}
								else {
									$(cell).html('<input type="checkbox" name="arrCntntsNo" checked="checked" value="' + str + '">');
								}
							}
						},
						{ mData: "cntntsSj"},
						{ mData: "pblcateDe", sWidth: "80px"},
						{ mData: null, sWidth: "130px",
							createdCell : function(cell, cellData, rowData, row, col ){
								$(cell).html( (rowData["chargerDeptNm"]?rowData["chargerDeptNm"]:"-") + "/" + (rowData["chargerNm"]?rowData["chargerNm"]:"-") );
							}
						},
						{ mData: "crtrNm", sWidth: "150px"},
						{ mData: "creatDttm", sWidth: "80px"}
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
				restParams.push({name : "srchKey", value :  $("#srchKey").val()});
				restParams.push({name : "srchWord", value :  $("#srchWord").val()});
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
				$(":checkbox[name='arrCntntsNo']").on("click", function(){

					$("#mappedCntnts tbody .no_data", opener.document).hide();

					if($(this).prop("checked")){
						var inputMenuNo = "<input type=\"hidden\" name=\"arrCntntsNo\" value=\""+ $(this).val() +"\" />";
						var cntntsTr = '<tr><td><input type="hidden" name="arrCntntsNo" value="'+$(this).val()+'"/>'
									 + '<a href="/admin/cntnts/view?cntntsNo='+$(this).val()+'">'+ $(this).parents("tr").find("td:eq(1)").text()+'</td>'
									 + '<td class="text-right"><a href="#DEL" class="btn btn-default btn-xs delBtn"><i class="fa fa-trash text-danger"></i> 해제</a>'
									 + '</td></tr>';
						$("#mappedCntnts tbody", opener.document).append(cntntsTr.toString());
					}else{
						$("input[name='arrCntntsNo'][value='"+$(this).val()+"']", opener.document).closest("tr").fadeOut(300, function(){
							$(this).remove();
							if($("#mappedCntnts tbody tr", opener.document).not(".no_data").length<1){
								$("#mappedCntnts tbody .no_data", opener.document).show();
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
						<h2 class="panel-title">콘텐츠 리스트</h2>
					</header>
					<div class="panel-body pt-none pb-none">
						<table class="table table-bordered table-striped mb-none" id="menuListTable">
							<colgroup>
								<col style="width:30px;" />
								<col />
								<col style="width:80px;" />
								<col style="width:130px;" />
								<col style="width:150px;" />
								<col style="width:80px;" />
							</colgroup>
							<thead>
								<tr>
									<th></th>
									<th>콘텐츠명</th>
									<th>발행일</th>
									<th>담당부서/담당자</th>
									<th>생성자</th>
									<th>생성일</th>
								</tr>
							</thead>
							<tbody>
							
							</tbody>
							<tfoot>
								<tr>
									<th class="text-center"><button><i class="fa fa-refresh"></i></button></th>
									<th colspan="5">
										<div class="form-inline">
										<select id="srchKey" name="srchKey" class="form-control">
                                			<option value="srchCntntsSj"  <c:if test="${param.srchKey eq 'srchCrtrNm' || param.searchKey eq ''}">selected="selected"</c:if>>콘텐츠명</option>
                                			<option value="srchCrtrNm"    <c:if test="${param.srchKey eq 'srchCrtrNm'}">selected="selected"</c:if>>생성자</option>
                                			<option value="srchChargerNm" <c:if test="${param.srchKey eq 'srchChargerNm'}">selected="selected"</c:if>>담당자</option>
                                		</select>
										<input type="text" id="srchWord" name="srchWord" value="${param.srchWord}" class="form-control" placeholder="검색어">
										</div>
									</th>
								</tr>
							</tfoot>
						</table>
					</div>
				</section>
