<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/taglibs.jsp" %>
<%@ page trimDirectiveWhitespaces="true" %>

	<link rel="stylesheet" href="${globalAdminAssets}/vendor/jstree/themes/default/style.css" />
	<link rel="stylesheet" href="${globalAdminAssets}/vendor/jquery-datatables-bs3/assets/css/datatables.css" />

	<script src="${globalAdminAssets}/vendor/jstree/jstree.js"></script>
	<script src="${globalAdminAssets}/vendor/jquery-datatables/media/js/jquery.dataTables.js"></script>
	<script src="${globalAdminAssets}/vendor/jquery-datatables/extras/TableTools/js/dataTables.tableTools.min.js"></script>
	<script src="${globalAdminAssets}/vendor/jquery-datatables-bs3/assets/js/datatables.js"></script>

		<script>
		$(function() {
			$("#siteMenuTree").jstree({
				"core" : {
					"multiple" : false,
	                "themes" : { "responsive": false},
	                "ui" : {"select_limit" : 1},
			    	"data" : [
			              <c:forEach var="siteMenuList" items="${siteMenuList}" varStatus="status">
			              {
			            	  "id" : "${siteMenuList.menuNo}"
			            	  <c:if test="${siteMenuList.upperMenuNo == 0}">, "parent" : "#"</c:if>
			            	  <c:if test="${siteMenuList.upperMenuNo != 0}">, "parent" : "${siteMenuList.upperMenuNo}"</c:if>
			            	  , "text" : "${siteMenuList.menuNm}"
			            	  , "type" : "<c:if test='${siteMenuList.useAt eq "Y"}'>${siteMenuList.menuTy}</c:if><c:if test='${siteMenuList.useAt eq "N"}'>7</c:if>"
			            	  , "data" : {
			            		  "bbsNo" : "${siteMenuList.bbsNo}",
			            		  "postListTy" : "${siteMenuList.postListTy}",
			            		  "menuUri" : "${siteMenuList.menuUri}"
			            		}
			              }
			              <c:if test="${!status.last}">,</c:if>
			              </c:forEach>
			           ]
			       },
		            "types" : {
		                "default" : {
		                    "icon" : "iconfa-folder-close text-info"
		                },
		                "1" : {"icon" : "iconfa-folder-close text-info"},
		                "2" : {"icon" : "iconfa-book text-info"},
		                "3" : {"icon" : "iconfa-edit text-info"},
		                "4" : {"icon" : "iconfa-magic text-info"},
		                "5" : {"icon" : "iconfa-desktop text-info"},
		                "6" : {"icon" : "iconfa-pushpin text-info"},
		                "7" : {"icon" : "iconfa-ban-circle text-error"}
		            },
		           "search" : { "show_only_matches" : true},
			       "plugins" : [ "wholerow",  "ui", "types", "search" ]

			});

			$('#treeSearchBtn').on('click', function () {
				$('#siteMenuTree').jstree('search', $('#treeSearch').val());
           	});

			$("#treeSearch").on('keyup', function(e){
				if (e.which == 13) {
					$('#treeSearchBtn').click();
					return false;
				}
			});

			//$("#siteMenuTree").jstree('open_node', '${siteMenuList[0].menuNo}');
			$("#siteMenuTree").jstree("open_all");//전체 열기

			$("#siteMenuTree").bind("select_node.jstree", function(event, data){

				if(data.node.type == "2" || data.node.type == "3"){
					var getJsonData = $('#siteMenuTree').jstree("get_json", $("#siteMenuTree").jstree("get_selected")).data;
					$("#srchMenuNo").val(data.node.id);
					$("#srchMenuTy").val(data.node.type);
					$("#srchPostListTy").val(getJsonData.postListTy);
					$("#srchBbsNo").val(getJsonData.bbsNo);
					$("#menuUri").val(getJsonData.menuUri);
					$("#srchWritngDe, #srchSj").val('');
					oTable.dataTable().fnDraw();
				}
			});//event 추가

			/* dataTable ajax */
			var oTable = $('#empListTable').dataTable({
				sAjaxSource: "/admin/siteMain/nttAjaxList",
				bProcessing: true,
				bServerSide: true,
				bFilter: false,
				bInfo: true,
				bSort : false,
				bAutoWidth: false, //width 고정
				//bStateSave: true,
				bLengthChange: false, //limit count
				bDeferRender: true,//속도
				aoColumns: [
							{ mData: null, sWidth: "70px"},
							{ mData: "sj"},
							{ mData: "sumry", bVisible : false},
							{ mData: "writngDe", sWidth: "130px"},
							{ mData: "nttNo", bVisible : false}
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
					restParams.push({name : "srchSiteNo", value :  $("#srchSiteNo").val()});
					restParams.push({name : "srchMenuNo", value :  $("#srchMenuNo").val()});
					restParams.push({name : "srchMenuTy", value :  $("#srchMenuTy").val()});
					restParams.push({name : "srchBbsNo", value :  $("#srchBbsNo").val()});
					restParams.push({name : "srchSj", value :  $("#srchSj").val()});
					restParams.push({name : "srchWritngDe", value :  $("#srchWritngDe").val()});
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
						if($('#empListTable tbody tr td').length != 1){
							var sumry = oTable.fnGetData(this)['sumry'].replace(/(<([^>]+)>)/ig,"").replace(/&nbsp;/ig, " ");
							$("#nttSj", opener.document).val(oTable.fnGetData(this)['sj']);
							$("#nttCn", opener.document).val(sumry);
							$("#writngDe", opener.document).val(oTable.fnGetData(this)['writngDe']);

							var linkUrl = "";
							if($("#srchMenuTy").val() == "2" && $("#srchPostListTy").val() == "1"){//컨텐츠이고 일반형일때
								linkUrl = "http://${siteVO.siteUrl}<c:if test="${siteVO.firstUriDivYn eq 'Y'}">/${siteVO.firstUri }</c:if>/" + $("#menuUri").val();
							}
							else{
								linkUrl = "http://${siteVO.siteUrl}<c:if test="${siteVO.firstUriDivYn eq 'Y'}">/${siteVO.firstUri }</c:if>/" + $("#menuUri").val() + "/" + oTable.fnGetData(this)['nttNo'];
							}
							$("#linkUrl", opener.document).val(linkUrl);
							self.close();
						}
					});
					$('#empListTable tbody tr').hover(function() {
						if($('#empListTable tbody tr td').length != 1){
			        		$(this).css('cursor', 'pointer');
						}
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

			$('input[name="srchWritngDe"]').datepicker({
				showOn: "button",
	            buttonImage: "${globalAdminAssets}/img/calendar.png",
	            buttonImageOnly: true,
	            dateFormat: 'yy-mm-dd',
	    		prevText: '이전 달',
	    		nextText: '다음 달',
	    		changeYear: true,
	    		changeMonth: true,
	    		monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
	    		monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
	    		dayNames: ['일','월','화','수','목','금','토'],
	    		dayNamesShort: ['일','월','화','수','목','금','토'],
	    		dayNamesMin: ['일','월','화','수','목','금','토'],
	    		showMonthAfterYear: true,
	    		onSelect: function (dateText, inst) {
	    			$('.dataTable_header').removeClass("hidden");
					oTable.dataTable().fnDraw();
	    		}
			});
		});

		</script>
		
		<!-- left layout -->
		<div class="col-sm-4">
			<section class="panel panel-featured panel-featured-bottom">
				<header class="panel-heading">
					<div class="panel-actions text-primary" style="position: absolute;">
					</div>
					<h2 class="panel-title">메뉴 리스트</h2>
				</header>
				<div class="panel-body">
                    <form class="form-bordered" onsubmit="return false;">
					<div class="form-group text-right form-inline">
                        <input type="text" id="treeSearch" class="form-control" placeholder="메뉴 검색">
                        <button type="button" id="treeSearchBtn" class="btn">Search</button>
					</div>
					<div class="form-group" id="siteMenuTree" style="padding:10px 0;">
					</div>
                    </form>
				</div>
				<footer class="panel-footer">
					<div class="row">
						<div class="col-sm-12">
						</div>
					</div>
				</footer>
			</section>
		</div>
		<!-- right layout -->
		<div class="col-sm-8">
			<section class="panel panel-primary">
				<header class="panel-heading">
					<div class="panel-actions">
					</div>
					<h2 class="panel-title">게시물 리스트</h2>
				</header>
				<div class="panel-body pt-none pb-none">
					<table class="table table-bordered table-striped mb-none" id="empListTable">
						<colgroup>
							<col style="width:70px;" />
							<col />
							<col style="width:0px;" />
							<col style="width:130px;" />
						</colgroup>
						<thead>
							<tr>
								<th>순번</th>
								<th>제목</th>
								<th></th>
								<th>작성일</th>
							</tr>
						</thead>
						<tbody>
						
						</tbody>
						<tfoot>
							<tr>
								<th class="text-center"><button><i class="fa fa-refresh"></i></button></th>
								<th>
									<input type="hidden" id="srchPostListTy" name="srchPostListTy"/>
									<input type="hidden" id="menuUri" name="menuUri"/>
									<input type="hidden" id="srchSiteNo" name="srchSiteNo" value="${param.siteNo}"/>
									<input type="hidden" id="srchMenuNo" name="srchMenuNo"/>
									<input type="hidden" id="srchMenuTy" name="srchMenuTy"/>
									<input type="hidden" id="srchBbsNo" name="srchBbsNo"/>
									<input type="text" id="srchSj" name="srchSj" placeholder="제목" class="form-control" />
								</th>
								<th></th>
								<th><input type="text" id="srchWritngDe" name="srchWritngDe" placeholder="작성일" class="form-control" /></th>
							</tr>
						</tfoot>
					</table>
				</div>
			</section>
		</div>
		