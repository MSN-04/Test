<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/taglibs.jsp" %>
<%@ page trimDirectiveWhitespaces="true" %>

<%-- 		<link href="${globalAdminAssets}/css/plugins/jstree.css" rel="stylesheet" type="text/css" /> --%>
<%-- 		<script src="${globalAdminAssets}/js/plugins/jstree.min.js"></script> --%>
		<!-- jstree -->
		<link rel="stylesheet" href="${globalAdminAssets}/vendor/jstree/themes/default/style.css" />
		<script src="${globalAdminAssets}/vendor/jstree/jstree.js"></script>
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
			              }
			              <c:if test="${!status.last}">,</c:if>
			              </c:forEach>
			           ]
			       },
		            "types" : {
		                "default" : {
		                    "icon" : "fa fa-folder text-dark"
		                },
		                "1" : {"icon" : "fa fa-folder text-dark"},
		                "2" : {"icon" : "fa fa-book text-dark"},
		                "3" : {"icon" : "fa fa-edit text-dark"},
		                "4" : {"icon" : "fa fa-magic text-dark"},
		                "5" : {"icon" : "fa fa-desktop text-dark"},
		                "6" : {"icon" : "fa fa-map-pin text-dark"},
		                "7" : {"icon" : "fa fa-ban text-danger"}
		            },
			       "plugins" : [ "wholerow",  "ui", "types" ]  //"dnd"
			});
			$("#siteMenuTree").bind("loaded.jstree", function(event, data){
				 $("#siteMenuTree").jstree('open_node', '${siteMenuList[0].menuNo}');
					//$("#siteMenuTree").jstree("open_all");//전체 열기
			});
// 			$("#siteMenuTree").jstree('open_node', '${siteMenuList[0].menuNo}');
			//$("#siteMenuTree").jstree("open_all");//전체 열기
			$("#siteMenuTree").bind("select_node.jstree", function(event, data){
				if(data.node.id == "root"){
					opener.$("#upperMenuNo").val(0);
				}else{
					opener.$("#upperMenuNo").val(data.node.id);
				}
				opener.$("#upperMenuNm").val(data.node.text);
				window.close();
			});//event 추가
		});
		function f_expandMenuAll(){
			$('#siteMenuTree').jstree('open_all');
		}
		function f_collapseMenuAll(){
			$('#siteMenuTree').jstree('close_all');
			$("#siteMenuTree").jstree('open_node', '${siteMenuList[0].menuNo}');
		}
		</script>
		
		
           <!-- start: page -->
			<section class="panel panel-featured panel-featured-bottom">
				<header class="panel-heading">
					<div class="panel-actions text-primary" style="position: absolute;">
						<a href="#" class="panel-action mr-xs" onclick="f_expandMenuAll();" title="전체 열기"><i class="fa fa-plus-square"></i></a>
						<a href="#" class="panel-action mr-md" onclick="f_collapseMenuAll();" title="전체 닫기"><i class="fa fa-minus-square"></i></a>
					</div>
					<h2 class="panel-title">메뉴 리스트</h2>
				</header>
				<div class="panel-body">

					<c:if test="${menuCrud eq 'UPDATE' }">
						<div class="widget-panel">
							<div class="widget-panel-inner">
								<p>이동이 가능한 메뉴만 출력됩니다</p>
							</div>
						</div>
					</c:if>
					<div class="widget-content" id="siteMenuTree" style="padding:10px 0;">
					</div>

				</div>
				<footer class="panel-footer">
					<div class="row">
						<div class="col-sm-12">
						</div>
					</div>
				</footer>
			</section>
