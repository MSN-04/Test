<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ include file="/common/taglibs.jsp" %>
	<c:set var="globalAdminAssets" value="/humanframe/admin/assets" />

	<link rel="stylesheet" href="${globalAdminAssets}/vendor/jquery-datatables-bs3/assets/css/datatables.css" />

	<script src="${globalAdminAssets}/vendor/jquery-datatables/media/js/jquery.dataTables.js"></script>
	<script src="${globalAdminAssets}/vendor/jquery-datatables/extras/TableTools/js/dataTables.tableTools.min.js"></script>
	<script src="${globalAdminAssets}/vendor/jquery-datatables-bs3/assets/js/datatables.js"></script>

	<script type="text/javascript">

	function f_setMngrInfo(strInfo){
		var opener = window.opener;
		if (typeof opener.f_mngrCallBack != "function") {
			alert("f_mngrCallBack() 함수를 정의하세요.");
		}else{
			opener.f_mngrCallBack(strInfo);
		}
		$.popup(false);
	}

	$(function() {

		var oTable = $('#mngrListTable').dataTable({
			sAjaxSource: "/admin/ajax/mngrList",
			bProcessing: true,
			bServerSide: true,
			bFilter: false,
			bSort : false,
			bLengthChange: false, //limit count
			bDeferRender: true,//속도
			aoColumns: [
						{ mData: null, sWidth: "30px",
							createdCell : function(cell, cellData, rowData, row, col ){
								var str = cellData["mngrId"];
								<c:if test="${mode eq 'S'}">
								var strInfo = cellData["uniqueId"]+"|"+cellData["mngrId"]+"|"+cellData["mngrNm"];
								$(cell).html('<a href="#" onclick="f_setMngrInfo(\''+ strInfo +'\');return false;" class="btn btn-xs btn-dark"><i class="fa fa-check"></i></a>');
								</c:if>
								<c:if test="${mode eq 'M'}">
								var btn = "<div class='checkbox-custom checkbox-text-primary'>"
								if($("input[name='arrMngrId'][value='"+str+"']", opener.document).val() == str){
// 									$(cell).html('<input type="checkbox" name="arrMngrId" checked="checked" value="' + str + '">');
									btn += '<input type="checkbox" name="arrMngrId" checked="checked" value="' + str + '" id="mngrCheck_'+row+'">';
								}else{
// 									$(cell).html('<input type="checkbox" name="arrMngrId" value="' + str + '">');
									btn += '<input type="checkbox" name="arrMngrId" value="' + str + '" id="mngrCheck_'+row+'">';
								}
								btn += "<label for='mngrCheck_'+row+''></label></div>";
								$(cell).html(btn);
								</c:if>
							}
						},
						{ mData: "authorNm", sWidth: "150px", sClass: "text-center"},
						{ mData: "deptNm"},
						{ mData: "mngrNm", sWidth: "100px", sClass: "text-center"},
						{ mData: "mngrId", sWidth: "100px", sClass: "text-center"}
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

				restParams.push({name : "type", value :  "${type}"});
				restParams.push({name : "srchDeptNmPath", value :  $("#srchDeptNmPath").val()});
				restParams.push({name : "srchMngrNm", value :  $("#srchMngrNm").val()});
				restParams.push({name : "srchMngrId", value :  $("#srchMngrId").val()});
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

				$(":checkbox[name='arrMngrId']").on("click", function(){

// 					$("#mngrMapngTable tbody .emptyTr", opener.document).remove();

					if($(this).prop("checked")){
						var inputMngrId = "<input type=\"hidden\" name=\"arrMngrId\" value=\""+ $(this).val() +"\" />";
						var mngrNm = $(this).parents("tr").find("td:eq(3)").text();
						var mngrDept = $(this).parents("tr").find("td:eq(2)").text();

						$("#mngrMapngTable tbody .emptyTr", opener.document).hide();
						$("#mngrMapngTable tbody", opener.document).append("<tr><td>"+inputMngrId+mngrNm+"</td><td>"+ mngrDept +"</td><td><a href=\"#DEL\" class=\"badge delBtn\">X</a></td></tr>");

					}else{
						$("input[name='arrMngrId'][value='"+$(this).val()+"']", opener.document).parents("tr").fadeOut(300, function(){
							$(this).remove();
							if($("input[name='arrMngrId']", opener.document).length<1){
								$("#mngrMapngTable tbody .emptyTr", opener.document).show();
							}
						});
// 						if($("input[name='arrMngrId']", opener.document).length<=1 && $("#mngrMapngTable tbody .emptyTr", opener.document).length == 0){
// 							$("#mngrMapngTable tbody", opener.document).append("<tr class=\"emptyTr\"><td colspan=\"3\">등록된 관리자가 없습니다.</td></tr>");
// 						}
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

		$("tfoot input").keyup( function () {
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
							<button class="btn btn-default btn-icon btn-sm" title="선택완료(닫기)" onclick="window.close(); return false;"><i class="fa fa-window-close"></i>선택완료(닫기)</button>
						</div>
						<h2 class="panel-title">관리자리스트</h2>
					</header>
					<div class="panel-body pt-none pb-none">
						<table class="table table-bordered table-striped mb-none" id="mngrListTable">
							<colgroup>
								<col style="width:30px;" />
								<col style="width:150px;" />
								<col />
								<col style="width:100px;" />
								<col style="width:100px;" />
							</colgroup>
							<thead>
								<tr>
									<th class="text-center"></th>
									<th class="text-center">권한그룹명</th>
									<th class="text-center">부서명</th>
									<th class="text-center">이름</th>
									<th class="text-center">아이디</th>
								</tr>
							</thead>
							<tbody>
							
							</tbody>
							<tfoot>
								<tr>
									<th class="text-center"><button><i class="fa fa-refresh"></i></button></th>
									<th></th>
									<th>
										<input type="text" id="srchDeptNmPath" name="srchDeptNmPath" placeholder="부서명" class="form-control" />
									</th>
									<th><input type="text" id="srchMngrNm" name="srchMngrNm" placeholder="이름" class="form-control" /></th>
									<th><input type="text" id="srchMngrId" name="srchMngrId" placeholder="아이디" class="form-control" /></th>
								</tr>
							</tfoot>
						</table>
					</div>
				</section>
