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

		var oTable = $('#menuListTable').dataTable({
			sAjaxSource: "/admin/site/menu/ajax/menuList",
			bProcessing: true,
			bServerSide: true,
			bFilter: false,
			bSort : false,
			bLengthChange: false, //limit count
			bDeferRender: true,//속도
			aoColumns: [
						{ mData: null, sWidth: "30px",
							createdCell : function(cell, cellData, rowData, row, col ){
								var str = rowData["menuNo"];
								var menuTy = rowData["menuTy"];
								var postListTy = rowData["postListTy"];
								var cntntsCount = rowData["cntntsCount"];
								var fnctNo = rowData["fnctNo"];
								var bbsNo = rowData["bbsNo"];
								if(menuTy == "2" && postListTy == "1" && cntntsCount > 0 && $("input[name='arrMenuNo'][value='"+str+"']", opener.document).val() != str){
									$(cell).html('<i class="fa fa-ban"></i>');
								}else{
									if((menuTy == "4" && fnctNo > 0 && fnctNo != $("input[name='fnctNo']", opener.document).val()) || menuTy == "3" && bbsNo > 0 && bbsNo != $("input[name='bbsNo']", opener.document).val()){
										$(cell).html('<i class="fa fa-ban"></i>');
									}else{
										if($("input[name='arrMenuNo'][value='"+str+"']", opener.document).val() == str){
											$(cell).html('<div class="checkbox-custom checkbox-text-primary"><input type="checkbox" name="arrMenuNo" checked="checked" value="' + str + '"><label/></div>');
										}else{
											$(cell).html('<div class="checkbox-custom checkbox-text-primary"><input type="checkbox" name="arrMenuNo" value="' + str + '"><label/></div>');
										}
									}
								}
							}
						},
						{ mData: "siteNm", sWidth: "130px"},
						{ mData: "menuNm", sWidth: "150px"},
						{ mData: "menuNmPath",
							createdCell : function(cell, cellData, rowData, row, col ){
								var str = rowData["menuNmPath"];
								str = str.replace(">Home", "홈").trim();
								$(cell).html(str);
							}
						},
						{ mData: null, sWidth: "100px",
							createdCell : function(cell, cellData, rowData, row, col ){
								var menuTy = rowData["menuTy"];
								var postListTy = rowData["postListTy"];

								switch (menuTy) {
									case "1" : $(cell).html("상위메뉴"); return;
									case "2" :
										if(postListTy == "1"){
											$(cell).html("콘텐츠(싱글)"); return;
										}else{
											$(cell).html("콘텐츠(멀티)"); return;
										}
									case "3" : $(cell).html("게시판"); return;
									case "4" : $(cell).html("기능프로그램"); return;
									case "5" : $(cell).html("JSP"); return;
								}
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
				restParams.push({name : "srchSiteNo", value :  $("#srchSiteNo").val()});
				<c:if test="${empty srchMenuTy}">
				restParams.push({name : "srchMenuTy", value :  $("#srchMenuTy").val()});
				</c:if>
				<c:if test="${!empty srchMenuTy}">
				restParams.push({name : "srchMenuTy", value :  "${srchMenuTy}"});
				</c:if>
				restParams.push({name : "srchMenuNm", value :  $("#srchMenuNm").val()});
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
				$(":checkbox[name='arrMenuNo']").on("click", function(){

					$("#mnMapngTable tbody .emptyTr", opener.document).remove();

					if($(this).prop("checked")){
						var inputMenuNo = "<input type=\"hidden\" name=\"arrMenuNo\" value=\""+ $(this).val() +"\" />";
						var siteName = $(this).parents("tr").find("td:eq(1)").text();
						var fullMenuPath = $(this).parents("tr").find("td:eq(3)").text();

						$("#mnMapngTable tbody", opener.document).append("<tr><td>"+inputMenuNo+"<code><small>"+ siteName +"</small></code><br />"+ fullMenuPath +"</td><td class=\"text-center\"><a href=\"#DEL\" class=\"badge hvr-grow btn-danger delBtn\">X</a></td></tr>");

					}else{
						$("input[name='arrMenuNo'][value='"+$(this).val()+"']", opener.document).parents("tr").fadeOut(300, function(){$(this).remove();});
					}
				});

			},
		 	oLanguage: {
		 		sEmptyTable: "데이터가 없습니다.",
		 		sInfo: "_START_~_END_ / _TOTAL_"
		    }
		});

		$("tfoot input").on("keyup", function () {
			oTable.fnPageChange(0);
			oTable.dataTable().fnDraw();
		});
		$("tfoot select").on("change", function(){
			oTable.fnPageChange(0);
			oTable.dataTable().fnDraw();
		});
		$("tfoot button").on("click", function(){
			oTable.dataTable().fnDraw();
		});
	});
	</script>


				<section class="panel panel-primary mb-none">
					<header class="panel-heading">
						<div class="panel-actions">
							<button class="btn btn-default" title="선택완료(닫기)" onclick="window.close(); return false;"><i class="fa fa-remove"></i> 선택완료(닫기)</button>
						</div>
						<h2 class="panel-title">메뉴리스트</h2>
					</header>
					<div class="panel-body pt-none pb-none">
						<table class="table table-bordered table-striped mb-none" id="menuListTable">
							<colgroup>
								<col style="width:30px;" />
								<col style="width:170px;" />
								<col style="width:150px;" />
								<col />
								<col style="width:100px;" />
							</colgroup>
							<thead>
								<tr>
									<th></th>
									<th>사이트명</th>
									<th>메뉴명</th>
									<th>전체메뉴명</th>
									<th>메뉴타입</th>
								</tr>
							</thead>
							<tbody>

							</tbody>
							<tfoot>
								<tr>
									<th class="text-center"><button><i class="fa fa-refresh"></i></button></th>
									<th>
										<select id="srchSiteNo" name="srchSiteNo" class="form-control">
											<option value="" selected="selected">사이트 선택</option>
											<c:forEach items="${siteListAll}" var="siteListAll">
											<option value="${siteListAll.siteNo}">${siteListAll.siteNm}</option>
											</c:forEach>
										</select>
									</th>
									<th colspan="2">
										<input type="text" id="srchMenuNm" name="srchMenuNm" placeholder="메뉴명" class="form-control" />
									</th>
									<th>
										<c:if test="${empty srchMenuTy}">
										<select id="srchMenuTy" name="srchMenuTy" class="form-control">
											<option value="" selected="selected">메뉴타입선택</option>
											<c:forEach var="siteMenuTy" items="${siteMenuTyCode}">
											<option value="${siteMenuTy.key}">${siteMenuTy.value}</option>
											</c:forEach>
										</select>
										</c:if>
									</th>
								</tr>
							</tfoot>
						</table>
					</div>
				</section>
