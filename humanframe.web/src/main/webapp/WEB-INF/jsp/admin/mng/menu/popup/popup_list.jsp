<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/taglibs.jsp" %>
<%@ page trimDirectiveWhitespaces="true" %>
		<link rel="stylesheet" href="${globalAdminAssets}/vendor/jstree/themes/default/style.css" />
		<script src="${globalAdminAssets}/vendor/jstree/jstree.js"></script>

		<script>
		$(function() {
			$("#mngMenuTree").jstree({
				"core" : {
					"multiple" : false,
	                "themes" : { "responsive": false},
	                "ui" : {"select_limit" : 1},
			    	"data" : [
			              <c:forEach var="mngMenuList" items="${mngMenuList}" varStatus="status">
			              {
			            	  "id" : "${mngMenuList.menuNo}"
			            	  <c:if test="${mngMenuList.upperMenuNo == 0}">, "parent" : "#"</c:if>
			            	  <c:if test="${mngMenuList.upperMenuNo != 0}">, "parent" : "${mngMenuList.upperMenuNo}"</c:if>
			            	  , "text" : "${mngMenuList.menuNm}"
			            	  <c:if test="${mngMenuList.menuTy == 2}">, "type" : "menuTy"</c:if>
			              }<c:if test="${!status.last}">,</c:if>
			              </c:forEach>
			           ]
			       },
		            "types" : {
		                "default" : {
		                    "icon" : "fa fa-folder text-info"
		                },
		                "menuTy" : {
		                    "icon" : "fa fa-folder text-warning"
		                }
		            },
			       "plugins" : [ "types" ]  //"dnd"
			});
			$("#mngMenuTree").jstree("open_all");//전체 열기
			$("#mngMenuTree").bind("select_node.jstree", function(event, data){
				if(data.node.id == "root"){
					opener.$("#upperMenuNo").val(0);
				}else{
					opener.$("#upperMenuNo").val(data.node.id);
				}
				opener.$("#upperMenuNm").val(data.node.text);
				window.close();
			});//event 추가
		});
		</script>


		<section class="panel panel-primary mb-none">
			<header class="panel-heading">
				<div class="panel-actions" style="position: absolute">
					<button class="btn btn-default" title="선택완료(닫기)" onclick="window.close(); return false;"><i class="fa fa-remove"></i> 선택완료(닫기)</button>
				</div>
				<h2 class="panel-title">CMS메뉴 리스트</h2>
			</header>
			<div class="panel-body">
				<c:if test="${menuCrud eq 'UPDATE' }">
				<div class="widget-panel">
	                <div class="widget-panel-inner">
	                	<p>이동이 가능한 메뉴만 출력됩니다</p>
	            	</div>
	            </div>
	            </c:if>
				<div class="widget-content no-padding" id="mngMenuTree">
				</div>
			</div>
		</section>
