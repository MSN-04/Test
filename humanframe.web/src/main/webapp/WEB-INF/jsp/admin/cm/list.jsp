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

	function updateStatus(cmno,type,val){

		var paramData = "cmNo="+cmno;
		if(type == 'hide'){
			paramData += "&hideAt=" + val;
		}
		if(type == 'delete'){
			paramData += "&deleteAt=" + val;
		}
		$.ajax({
      		dataType : 'json',
      	    type : "POST",
      	    url : "updateStatus",
      	    data : paramData,
      	    success : function(data) {
      	    	if(data){
      				oTable.dataTable().fnDraw();
      	    	} else {
      	    		alert("변경 실패");
      	    	}
			}
		});
	}
	function toggleDeleteView(){
		if($("#deleteAt").val()=="N"){
			$("#deleteAt").val("Y");
			$("#cm-list-delete-n").hide();
			$("#cm-list-delete-y").show();
			oTable.dataTable().fnDraw();
		} else {
			$("#deleteAt").val("N");
			$("#cm-list-delete-n").show();
			$("#cm-list-delete-y").hide();
			oTable.dataTable().fnDraw();
		}
	}

	var oTable;
	$(function() {

		/* dataTable ajax */
		oTable = $('#cmListTable').dataTable({
			sAjaxSource: "/admin/cm/ajaxList",
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
						{ mData: null},
						{ mData: function(row,type,set){
							var cmrow="<code class='bg-default text-dark'>";
							if(row.siteNm != undefined && row.siteNm != ''){
								cmrow += row.siteNm +" ";
							}
							if(row.menuNmPath != undefined && row.menuNmPath != ''){
								cmrow += row.menuNmPath.replace(/^>Home/i,"");
							}
							cmrow+="</code>";
							if(row.hideAt=="N"){
								cmrow += "<p>";
							} else {
								cmrow += "<p class='text-muted'><span class='label label-warning' title='숨김 상태'><i class='fa fa-eye-slash'></i></span> ";
							}
							cmrow += row.cn + "</p>";
							cmrow += "<div class='pull-right'>";
							cmrow += "<code class='text-muted'><i class='fa fa-user'></i> " + row.wrter + " </code> ";
							cmrow += "<code class='text-muted'><i class='fa fa-clock-o'></i> " + row.creatDttm + "</code>";
							cmrow += "</div>";
							return cmrow;
						}},
						{ mData: function(row,type,set){

							var btnrow = "<div class='btn-group btn-group-xs'>";
							if(row.hideAt=="N") {
								btnrow += "<button type='button' class='btn btn-warning' title='사용안함' onclick='updateStatus(\""+row.cmNo+"\",\"hide\",\"Y\")'><i class='fa fa-eye-slash'></i></button>";
							} else {
								btnrow += "<button type='button' class='btn btn-warning' title='사용안함 해제' onclick='updateStatus(\""+row.cmNo+"\",\"hide\",\"N\")'><i class='fa fa-eye'></i></button>";
							}
							if(row.deleteAt=="N") {
								btnrow += "<button type='button' class='btn btn-danger' title='삭제' onclick='updateStatus(\""+row.cmNo+"\",\"delete\",\"Y\")'><i class='fa fa-trash'></i></button>";
							} else {
								btnrow += "<button type='button' class='btn btn-success' title='복원' onclick='updateStatus(\""+row.cmNo+"\",\"delete\",\"N\")'><i class='fa fa-recycle'></i></button>";
							}
							btnrow += "</div>";

							return btnrow;
						}, sClass: 'text-center' }
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
				restParams.push({name : "mapngAt", value :  $("#mapngAt").val()});
				restParams.push({name : "useAdmin", value :  $("#useAdmin").val()});
				restParams.push({name : "deleteAt", value :  $("#deleteAt").val()});

				restParams.push({name : "siteNo", value :  $("#siteNo").val()});
				restParams.push({name : "menuNo", value :  $("#menuNo").val()});
				restParams.push({name : "bbsNo", value :  $("#bbsNo").val()});
				restParams.push({name : "nttNo", value :  $("#nttNo").val()});
				restParams.push({name : "cntntsNo", value :  $("#cntntsNo").val()});

				restParams.push({name : "srchCn", value :  $("#srchCn").val()});
				restParams.push({name : "srchWrter", value :  $("#srchWrter").val()});
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

		$("tfoot input").keyup( function () {
			$('.dataTable_header').removeClass("hidden");
			oTable.fnPageChange(0);
			oTable.dataTable().fnDraw();
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
		    		},
// 		    		'dataFilter' : function (data,type) {
// 		    			for(var i in data){
// 		    				if(data[i].data!=undefined && data[i].data.cmUseAt!=undefined && data[i].data.cmUseAt == "N"){
// 		    					data[i].type = data[i].type + "-N";
// 		    				}
// 		    			}
// 		    			return data;
// 		    		}
		    		'converters' : {
		    			"text json" : function(data){
			    			data = $.parseJSON(data);
			    			for(var i in data) {
			    				if(data[i].data!=undefined && data[i].data.cmUseAt!=undefined && data[i].data.cmUseAt == "N"){
			    					data[i].type = data[i].type + "-x";
			    				}
			    			}
			    			return data;
			    		}
		    		}
		    	}
		       },
	            "types" : {
	                "default" : {
	                    "icon" : "fa fa-question-circle"
	                },
	                "top" : {
	                	"icon" : "fa fa-commenting"
	                },
	                "site" : {
	                	"icon" : "fa fa-sitemap"
	                },
	                "site-x" : {
	                	"icon" : "fa fa-sitemap text-muted"
	                },
	                "menu-ty1" : {
	                	"icon" : "fa fa-folder text-primary"
	                },
	                "menu-ty1-x" : {
	                	"icon" : "fa fa-folder text-muted"
	                },
	                "menu-ty2" : {
	                	"icon" : "fa fa-book text-primary"
	                },
	                "menu-ty2-x" : {
	                	"icon" : "fa fa-book text-muted"
	                },
	                "menu-ty3" : {
	                	"icon" : "fa fa-edit text-primary"
	                },
	                "menu-ty3-x" : {
	                	"icon" : "fa fa-edit text-muted"
	                },
	                "menu-ty4" : {
	                	"icon" : "fa fa-magic text-primary"
	                },
	                "menu-ty4-x" : {
	                	"icon" : "fa fa-magic text-muted"
	                },
	                "menu-ty5" : {
	                	"icon" : "fa fa-desktop text-primary"
	                },
	                "menu-ty5-x" : {
	                	"icon" : "fa fa-desktop text-muted"
	                },
	            },
		       "plugins" : ["types" ]  //"dnd"
		});
		$("#siteMenuTree").bind("select_node.jstree", function(event, data){

			var iddata = data.node.id.split("-");

			if(data.node.id == 'site-0'){
				$("#cmListTable #mapngAt").val("");
				$("#cmListTable #siteNo").val("");
				$("#cmListTable #menuNo").val("");
				$("#cmListTable #bbsNo").val("");
				$("#cmListTable #nttNo").val("");
				$("#cmListTable #cntntsNo").val("");
			} else if ( iddata[0] == 'site' ) {
				$("#cmListTable #mapngAt").val("");
				$("#cmListTable #siteNo").val(data.node.data.siteNo);
				$("#cmListTable #menuNo").val("");
				$("#cmListTable #bbsNo").val("");
				$("#cmListTable #nttNo").val("");
				$("#cmListTable #cntntsNo").val("");
			} else if ( iddata[0] == 'menu' ) {
				$("#cmListTable #mapngAt").val("");
				$("#cmListTable #siteNo").val(data.node.data.siteNo);
				$("#cmListTable #menuNo").val(data.node.data.menuNo);
				$("#cmListTable #bbsNo").val("");
				$("#cmListTable #nttNo").val("");
				$("#cmListTable #cntntsNo").val("");
			}

			$("#srchDeptCode").val(data.node.id);
			oTable.dataTable().fnDraw();
		});//event 추가



	});

	</script>


			<!-- Start Breadcrumb -->
			<jsp:include page="/WEB-INF/jsp/admin/layout/breadcrumb.jsp">
				<jsp:param name="pageName" value="댓글 관리"/>
			</jsp:include>
			<!-- End Breadcrumb -->

            <!-- start: page -->
			<div class="row">
				<div class="col-md-4 p-none">
				<section class="panel panel-featured panel-featured-primary">
					<header class="panel-heading">
						<div class="panel-actions">
							<span class="btn btn-xs" onclick='$("#siteMenuTree").jstree(true).load_node("#");'><i class="fa fa-repeat"></i></span>
							<span class="btn btn-xs" onclick='$("#siteMenuTree").jstree(true).refresh();'><i class="fa fa-refresh"></i></span>
						</div>
						<h2 class="panel-title">사이트 메뉴 목록</h2>
					</header>
					<div class="panel-body">
						<div id="siteMenuTree" style="padding:10px 0;">
						</div>
					</div>
				</section>
				</div>
				<div class="col-md-8 pr-none">
				<section class="panel panel-featured panel-featured-primary">

					<header class="panel-heading">
						<div class="panel-actions">
							<button class="btn btn-default" onclick='toggleDeleteView()' id="cm-list-delete-n"><i class="fa fa-th-list"></i> 사용중</button>
							<button class="btn btn-default" onclick='toggleDeleteView()' id="cm-list-delete-y" style="display:none;"><i class="fa fa-trash"></i> 사용안함</button>
						</div>
						<h2 class="panel-title" id="frmTitle">댓글</h2>
					</header>
					<div class="panel-body">

							<table class="table table-bordered mb-none" id="cmListTable">
								<colgroup>
									<col style="width:20px;" />
									<col />
									<col style="width:65px;" />
								</colgroup>
								<thead>
									<tr>
										<th class="text-center"></th>
										<th class="text-center">댓글</th>
										<th class="text-center">관리</th>
									</tr>
								</thead>
								<tbody>
								</tbody>
								<tfoot>
									<tr>
										<th></th>
										<th>
											<div class="form-inline">
											<input type="hidden" id="useAdmin" name="useAdmin" value="Y"/>
											<input type="hidden" id="mapngAt" name="mapngAt"/>
											<input type="hidden" id="siteNo" name="siteNo"/>
											<input type="hidden" id="menuNo" name="menuNo"/>
											<input type="hidden" id="bbsNo" name="bbsNo"/>
											<input type="hidden" id="nttNo" name="nttNo"/>
											<input type="hidden" id="cntntsNo" name="cntntsNo"/>
											<input type="hidden" id="deleteAt" name="deleteAt" value="N"/>
											<input type="hidden" id="hideAt" name="hideAt"/>
											<input type="text" id="srchCn" name="srchCn" placeholder="글 내용" class="form-control" />
											<input type="text" id="srchWrter" name="srchWrter" placeholder="작성자" class="form-control" />
											</div>
										</th>
										<th></th>
									</tr>
								</tfoot>
							</table>

					</div>

				</section>
				</div>
			</div>
