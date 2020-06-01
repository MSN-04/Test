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

		var oTable = $('#bbsListTable').dataTable({
			sAjaxSource: "/admin/bbs/ajax/list",
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
								var str = cellData["bbsNo"];
								if($("input[name='bbsNo'][value='"+str+"']", opener.document).val() != str){
									$(cell).html('<input type="checkbox" name="bbsNo" value="' + str + '">');
								}
								else {
									$(cell).html('<input type="checkbox" name="bbsNo" checked="checked" value="' + str + '">');
								}
							}
						},
						{ mData: "bbsSj"},
						{ mData: null, sWidth: "80px",
							createdCell : function(cell, cellData, rowData, row, col ){
								var bbsTyInput = "<input type='hidden' name='bbsTy' value='"+cellData["bbsTy"]+"'/>";
								switch(cellData["bbsTy"]){
								<c:forEach varStatus="status" begin="1" end="${fn:length(bbsTyCode)}">
								<c:set var="tyIdx">${status.count}</c:set>
								case "${tyIdx}":
									$(cell).html(bbsTyInput + "${bbsTyCode[tyIdx]}");
									break;
								</c:forEach>
								default:
									$(cell).html(bbsTyInput + cellData["bbsTy"]);
								}
							}},
						{ mData: null, sWidth: "140px",
							createdCell : function(cell, cellData, rowData, row, col ){
								var useMenuList = "";
								cellData["useMenuList"].forEach(function(val, idx, arr){
									if(idx>0) useMenuList += "<br />";
									useMenuList += val.menuNm;
								});
								$(cell).html(useMenuList.toString());
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
				restParams.push({name : "srchBbsTy", value :  $("#srchBbsTy").val()});
				restParams.push({name : "srchSiteNo", value :  $("#srchSiteNo").val()});
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
				
				if($(":checkbox[name='bbsNo']:checked").length>0){
					$(":checkbox[name='bbsNo']:unchecked").prop("disabled",true);
				}
				
				$(":checkbox[name='bbsNo']").on("click", function(){
					
					$("#mappedBbs tbody .no_data", opener.document).hide();
// 					$("#mappedBbs tbody tr", opener.document).not(".no_data").remove();

					if($(this).prop("checked")){
						
						$(":checkbox[name='bbsNo']").prop("checked",false);
						$(this).prop("checked",true);
						$(":checkbox[name='bbsNo']:unchecked").prop("disabled",true);

						var bbsTr = '<tr><td><input type="hidden" name="bbsNo" value="'+$(this).val()+'"/>'
								  + '<a href="/admin/bbs/setting/form?bbsNo='+$(this).val()+'">'+$(this).parents("tr").find("td:eq(1)").text()+'</a> '
								  + '<a href="/admin/bbs/type'+$(this).parents("tr").find("input[name='bbsTy']").val()+'/list?bbsNo='+$(this).val()+'" target="_blank"><i class="fa fa-external-link"></i></a></td>'
								  + '<td class="text-right"><a href="#DEL" class="btn btn-default btn-xs delBtn"><i class="fa fa-trash text-danger"></i> 해제</a>'
								  + '</td></tr>';
						$("#mappedBbs tbody", opener.document).append(bbsTr);
					}else{
						$(":checkbox[name='bbsNo']").prop("disabled",false);
						
						$("input[name='bbsNo'][value='"+$(this).val()+"']", opener.document).closest("tr").fadeOut(300, function(){
							$(this).remove();
							if($("#mappedBbs tbody tr", opener.document).not(".no_data").length<1){
								$("#mappedBbs tbody .no_data", opener.document).show();
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
						<h2 class="panel-title">게시판리스트</h2>
					</header>
					<div class="panel-body pt-none pb-none">
						<table class="table table-bordered table-striped mb-none" id="bbsListTable">
							<colgroup>
								<col style="width:30px;" />
								<col />
								<col style="width:80px;" />
								<col style="width:140px;"  />
							</colgroup>
							<thead>
								<tr>
									<th></th>
									<th>게시판명</th>
									<th>게시판 유형</th>
									<th>사용메뉴</th>
								</tr>
							</thead>
							<tbody>

							
							</tbody>
							<tfoot>
								<tr>
									<th class="text-center"><button><i class="fa fa-refresh"></i></button></th>
									<th colspan="3">
										<div class="form-inline">
		                                	<select id="srchBbsTy" name="srchBbsTy" class="form-control">
												<option value="">전체(게시판 유형)</option>
		                                    	<c:forEach items="${bbsTyCode}" var="bbsTy">
												<option value="${bbsTy.key}" <c:if test="${param.srchBbsTy eq bbsTy.key}">selected="selected"</c:if>>${bbsTy.value}</option>
		                                    	</c:forEach>
		                                	</select>
		                                	<select id="srchSiteNo" name="srchSiteNo" class="form-control">
												<option value="">전체(사용중 사이트)</option>
		                                    	<c:forEach items="${siteList}" var="siteList">
												<option value="${siteList.siteNo}" <c:if test="${param.srchSiteNo eq siteList.siteNo}">selected="selected"</c:if>>${siteList.siteNm}</option>
		                                    	</c:forEach>
		                                	</select>
		                                    <input type="text" id="srchText" name="srchText" value="<c:out value='${param.srchText}'/>" class="form-control search-query">
		                                </div>
									</th>
								</tr>
							</tfoot>
						</table>
					</div>
				</section>