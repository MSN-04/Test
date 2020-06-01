<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ include file="/common/taglibs.jsp" %>
	<link href="${globalAdminAssets}/css/plugins/jstree.css" rel="stylesheet" type="text/css" />
	<style type="text/css">
	.iconsample li {width:150px; cursor:pointer;}
	</style>
	<script src="${globalAdminAssets}/js/plugins/jstree.min.js"></script>

	<script type="text/javascript">

	$(document).ready(function(){

		//부서 목록 tree처리
		$("#deptTree").jstree({
			"core" : {
				"multiple" : false,
                "themes" : { "responsive": false},
                "ui" : {"select_limit" : 1},
		    	"data" : [
					<c:forEach var="deptList" items="${deptList}" varStatus="status">
					{
						  "id" : "${deptList.deptCode}"
						  <c:if test="${deptList.levelNo == 1}">
						  , "parent" : "#"
						  </c:if>
						  <c:if test="${deptList.levelNo == 2}">
						  , "parent" : "${deptList.virtlCode}"
						  </c:if>
						  <c:if test="${deptList.levelNo > 2}">
						  , "parent" : "${deptList.upperDeptCode}"
						  </c:if>
						  , "text" : "${deptList.deptNm}"
					}<c:if test="${!status.last}">,</c:if>
					</c:forEach>
		           ]
		       },
	            "types" : {
	                "default" : {
	                    "icon" : "iconfa-folder-close text-info"
	                }
	            },
		       "plugins" : [ "wholerow",  "ui", "types" ]  //"dnd"
		});
		//$("#deptTree").jstree("open_all");//전체 열기
		$("#deptTree").bind("select_node.jstree", function(event, data){
			if(data.node.id == "root"){
				opener.$("#upperDeptCode").val(0);
			}else{
				opener.$("#upperDeptCode").val(data.node.id);
			}
			opener.$("#upperDeptNm").val(data.node.text);
			window.close();
		});//event 추가
	});

	</script>

	<!-- Start Main Content -->
            <div style="padding:0 10px;">
                <!-- Start Main Content -->
                <div class="row-fluid">
                    <div class="span12">
						<div class="widget dark">
							<div class="widget-head">
								<span class="title">부서리스트</span>
							</div>
							<c:if test="${deptCrud eq 'UPDATE' }">
							<div class="widget-panel">
                                <div class="widget-panel-inner">
                                	<p>이동이 가능한 메뉴만 출력됩니다</p>
                            	</div>
                            </div>
                            </c:if>
							<div class="widget-content no-padding" id="deptTree">
							</div>
						</div>
                    </div>
                </div><!-- End -->
                <br />
            </div><!-- End Main Content -->