<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/taglibs.jsp" %>
<%@ page trimDirectiveWhitespaces="true" %>
<link rel="stylesheet" href="${globalAdminAssets}/vendor/jstree/themes/default/style.css" />
<script src="${globalAdminAssets}/vendor/jstree/jstree.js"></script>

	<link rel="stylesheet" href="${globalAdminAssets}/vendor/jquery-datatables-bs3/assets/css/datatables.css" />

	<script src="${globalAdminAssets}/vendor/jquery-datatables/media/js/jquery.dataTables.js"></script>
	<script src="${globalAdminAssets}/vendor/jquery-datatables/extras/TableTools/js/dataTables.tableTools.min.js"></script>
	<script src="${globalAdminAssets}/vendor/jquery-datatables-bs3/assets/js/datatables.js"></script>

	<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>

<script>
google.charts.load('current', {'packages':['corechart', 'bar']});

	function f_callAjax(){

		$.ajax({
			type : "post",
			url: './chart',
			data:  $("form[name=searchFrm]").serialize(),
			dataType: 'json', //전송받을 데이터의 타입
			contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
			success: function(data) {
				f_drawChart(data);
			},
			error: function(data, status, err) {
				console.log('error forward : ' + data);
			}
		});
	}

	function f_drawChart(data){

		if(data.length == 0){return}

		//통계데이터 셋팅
		var arrlist = new Array();
		var title;

		for(var i=0; i < data.length; i++){
			var temp = "";
			// 전체일때 - 사이트/사이트명/uv/pv
			if($("#serchSiteNo").val() == "" &&  $("#serchMenuNo").val() == ""){
				title = "사이트";
				temp = data[i].siteNm;
			}
			// 사이트일때 - 메뉴/메뉴명/uv/pv
			if($("#serchSiteNo").val() != "" &&  $("#serchMenuNo").val() == ""){
				title = "메뉴";
				temp = data[i].menuNm;
			}
			// 메뉴일때 - 기간/uv/pv
			if($("#serchSiteNo").val() != "" &&  $("#serchMenuNo").val() != ""){
				title = "기간";
				if( data[i].statsYyyy != undefined && data[i].statsYyyy != ''){
					temp = data[i].statsYyyy;
				}
				if(data[i].statsMm != undefined && data[i].statsMm != ''){
					temp += "-" + data[i].statsMm;
				}
				if(data[i].statsDd != undefined && data[i].statsDd != ''){
					temp += "-" + data[i].statsDd;
				}
				if(temp == ""){ // 기간조회가 아닐경우
					title = data[i].menuNm;
					temp = "전체";
				}
			}

			if(i==0){
				arrlist.push([title, "UV", "PV"]);
			}
			arrlist.push([temp, data[i].uv, data[i].pv]);
		}

		//통계 그래프
		var statsData = google.visualization.arrayToDataTable(arrlist);
		var options = {
				title: title + '조회수',
	            legend: { position: 'right' }
          	};
		var chart;
		if($("#srchType").val() != '' && title == '기간'){
			chart = new google.visualization.LineChart(document.getElementById('chart_div'));
		} else {
			chart = new google.charts.Bar(document.getElementById('chart_div'));
		}

		chart.draw(statsData, options);
	}

	function f_excelDown(){
		$("#searchFrm").attr("action","excel").submit();
	}

	function f_srch(){
		if($("#srchType").val() != ''
				&& ($("#srchStartDay").val() ==""||$("#srchEndDay").val() =="" )){
			alert("조회 날짜를 입력하십시오");
			return;
		}
		$("#chart_div").html('');
		oTable.dataTable().fnDraw();
	}

	function f_setSrch(){
			var srchType = $("#srchType").val();
			var dateType = "";

			if(srchType == "Yy") {dateType='yyyy'}
			if(srchType == "Mt") {dateType='yyyy-mm'}
			if(srchType == "De") {dateType='yyyy-mm-dd'}
			$('input[name="srchStartDay"],[name="srchEndDay"]').datepicker("destroy");

			if(srchType == ""){
				$('input[name="srchStartDay"],[name="srchEndDay"]').val("");
			}else{
				$('input[name="srchStartDay"],[name="srchEndDay"]').datepicker({
				       format: dateType,
				       endDate: 'today',
				       todayHighlight: true
				})
			}
	}

	var oTable;
	$(function() {

		/* dataTable ajax */
		oTable = $('#listTable').dataTable({
			sAjaxSource: "./ajaxList",
			bProcessing: false,
			bServerSide: true,
			bFilter: false,
			bInfo: false,
			bSort : false,
			bAutoWidth: false, //width 고정
			bLengthChange: false, //limit count
			bDeferRender: true,//속도
			aoColumns: [
						{ mData: null, sWidth: "80px"},
						{ mData: function(row,type,set){
							var cmrow="";
							if(row.statsYyyy != undefined && row.statsYyyy != ''){
								cmrow += row.statsYyyy;
							}
							if(row.statsMm != undefined && row.statsMm != ''){
								cmrow += "-" + row.statsMm;
							}
							if(row.statsDd != undefined && row.statsDd != ''){
								cmrow += "-" + row.statsDd;
							}
							if(cmrow == ''){
								cmrow = "전체";
							}
							return cmrow;
						}},
						{ mData: "siteNm"},
						{ mData: "menuNm"},
						{ mData: "uv", sWidth: "100"},
						{ mData: "pv", sWidth: "100"}
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
				restParams.push({name : "sEcho"     , value : paramMap.sEcho});
				restParams.push({name : "cntPerPage", value : cntPerPage});
				restParams.push({name : "curPage"   , value : pageNum });

				restParams.push({name : "serchSiteNo" , value :  $("#serchSiteNo").val()});
				restParams.push({name : "serchMenuNo" , value :  $("#serchMenuNo").val()});
				restParams.push({name : "srchType"    , value :  $("#srchType").val()});
				restParams.push({name : "srchStartDay", value :  $("#srchStartDay").val()});
				restParams.push({name : "srchEndDay"  , value :  $("#srchEndDay").val()});
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


		$("#siteMenuTree").jstree({
			"core" : {
				"multiple" : false,
	               "themes" : { "responsive": false},
	               "ui" : {"select_limit" : 1},
		    	"data" : {
		    		'url' : function (node) {
		    			return node.id === '#' ? 'getSite.json' : 'getSiteMenu.json';
		    		},
		    		'data' : function (node) {
		    			if(node.data !== undefined){
		    				return {'siteNo':node.data.siteNo}
		    			}
		    			return {};
		    		}
		    	}
		       },
	            "types" : {
	                "default" : {
	                    "icon" : "fa fa-folder text-primary"
	                },
	                "top" : {
	                	"icon" : "fa fa-folder text-primary"
	                },
	                "site" : {
	                	"icon" : "fa fa-sitemap text-primary"
	                }


	            },
		       "plugins" : ["types" ]  //"dnd"
		});
		$("#siteMenuTree").bind("select_node.jstree", function(event, data){

			var iddata = data.node.id.split("-");

			if(data.node.id == 'site-0'){
				$("#searchFrm #serchSiteNo").val("");
				$("#searchFrm #serchMenuNo").val("");
			} else if ( iddata[0] == 'site' ) {
				$("#searchFrm #serchSiteNo").val(data.node.data.siteNo);
				$("#searchFrm #serchMenuNo").val("");
			} else if ( iddata[0] == 'menu' ) {
				$("#searchFrm #serchSiteNo").val(data.node.data.siteNo);
				$("#searchFrm #serchMenuNo").val(data.node.data.menuNo);
			}

			$("#chart_div").html('');
			oTable.dataTable().fnDraw();

		});//event 추가
	});
</script>

	<!-- Start Breadcrumb -->
	<jsp:include page="/WEB-INF/jsp/admin/layout/breadcrumb.jsp">
		<jsp:param name="pageName" value="메뉴통계"/>
	</jsp:include>
	<!-- End Breadcrumb -->

          <!-- start: page -->
	<div class="row">
		<div class="col-md-4">
		<section class="panel panel-featured panel-featured-primary">
			<header class="panel-heading">
				<div class="panel-actions">
					<span class="btn btn-xs" onclick='$("#siteMenuTree").jstree(true).load_node("#");'><i class="fa fa-repeat"></i></span>
					<span class="btn btn-xs" onclick='$("#siteMenuTree").jstree(true).refresh();'><i class="fa fa-refresh"></i></span>
				</div>
				<h2 class="panel-title">메뉴 목록</h2>
			</header>
			<div class="panel-body">
				<div class="widget-content" id="siteMenuTree" style="padding:10px 0;">
				</div>
			</div>
		</section>
		</div>
		<div class="col-md-8" >
		<section class="panel panel-featured panel-featured-primary">

		<header class="panel-heading">
			<div class="panel-actions">
				<button onclick="f_callAjax();return false;" class="btn btn-default" title="메뉴만 기간별 그래프제공됩니다">그래프</button>
				<button onclick="f_excelDown();return false;" class="btn btn-default">엑셀</button>
			</div>
				<h2 class="panel-title" id="frmTitle">메뉴통계조회</h2>
			</header>
			<div class="panel-body">
				<form id="searchFrm" name="searchFrm" class="form-horizontal form-bordered mb-md" method="get" action="./list">
					<input type="hidden" id="serchSiteNo" name="serchSiteNo" value="" />
					<input type="hidden" id="serchMenuNo" name="serchMenuNo" value="" />

					<div class="form-group">
						<div class="form-inline ml-md">
							<select id="srchType" name="srchType" class="form-control" onchange="f_setSrch();">
								<option value=""   <c:if test="${param.srchType eq ''}">selected="selected"</c:if>>선택</option>
								<option value="Yy" <c:if test="${param.srchType eq 'Yy'}">selected="selected"</c:if>>년별 조회</option>
								<option value="Mt" <c:if test="${param.srchType eq 'Mt'}">selected="selected"</c:if>>월별 조회</option>
								<option value="De" <c:if test="${param.srchType eq 'De'}">selected="selected"</c:if>>일별 조회</option>
							</select>
							<input type="text" id="srchStartDay" name="srchStartDay" class="form-control" readonly="readonly" style="width: 150px" /> ~
							<input type="text" id="srchEndDay" name="srchEndDay" class="form-control" readonly="readonly" style="width: 150px"/>
							<button onclick="f_srch();return false;" class="btn btn-default"><i class="fa fa-search"></i>검색</button>
						</div>
					</div>
				</form>

				<!-- 통계그래프 -->
				<div  id="chart_div" style="width: 100%;"></div>

				<form id="listFrm" name="listFrm" method="post">
					<table class="table table-bordered table-hover mb-none" id="listTable">
						<colgroup>
							<col style="width:50px" />
							<col style="width:100px" />
							<col/>
							<col/>
							<col style="width:100px" />
							<col style="width:100px" />
						</colgroup>
						<thead>
						<tr>
							<th style="text-align: center;">번호</th>
							<th style="text-align: center;">통계일자</th>
							<th style="text-align: center;">사이트명</th>
							<th style="text-align: center;">메뉴명</th>
							<th style="text-align: center;">순방문자수</th>
							<th style="text-align: center;">페이지뷰</th>
						</tr>
						</thead>
						<tbody id="tableBodyHtml">

						</tbody>
					</table>
				</form>
				<small>* 메뉴 목록에 없는 사이트/메뉴의 경우 수정 또는 사용되지않는 메뉴입니다</small>
				</div>
		</section>
		</div>
	</div>