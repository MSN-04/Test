<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/taglibs.jsp" %>
<%@ page trimDirectiveWhitespaces="true" %>
			<link rel="stylesheet" href="${globalAdminAssets}/vendor/jstree/themes/default/style.css" />
			<script src="${globalAdminAssets}/vendor/jstree/jstree.js"></script>

			<script>
			function f_mngMenuSearch(){
				var menuCrud = $('#crud').val();
				var menuNo = $('#menuNo').val();
				window.open("/admin/mng/menu/popup/menuList?menuNo="+menuNo+"&menuCrud="+menuCrud, "popMenu", "width=400,height=500,scrollbars=yes");
			}

			function f_Delete(){//하위메뉴 존재여부 확인
				$.ajax({
					type : "post",
					url: '/admin/mng/menu/lowerMenuCheck',
					data: 'menuNo=' + $("#menuNo").val(),
					dataType: 'text', //전송받을 데이터의 타입
					contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
					success: function(data) {
						if(data=="true"){//없음
							if(confirm("삭제된 메뉴는 복구할 수 없습니다.\n\n선택하신 메뉴를 삭제하시겠습니까?")){
								$("#crud").val("DELETE");
								$("#frmMngMenu").submit();
							}
						}else{
							alert("하위 메뉴가 존재할 경우 삭제할 수 없습니다.");
						}
					},
					error: function(data, status, err) {
						console.log('error forward : ' + data);
					}
				});


			}

			$(function() {

				$("form[name='frmMngMenu']").validate({
				    ignore: "input[type='text']:hidden",
				    rules : {
				    	upperMenuNo	: { required : true },
				    	menuNm			: { required : true },
				    	menuUrl			: { required : true },
				    	sortNo			: { required : true, number : true}
				    },
				    messages : {
				    	upperMenuNo	: { required : "상위메뉴를 선택하세요" },
					    menuNm			: { required : "메뉴명을 입력하세요" },
				    	menuUrl			: { required : "메뉴 URL을 입력하세요" },
				    	sortNo			: { required : "정렬 순서를 입력하세요", number:"숫자만 입력 가능합니다."}
				    },
				    errorElement: 'label',
				    errorClass: 'error',
				    highlight:function(element, errorClass, validClass) {
				        $(element).addClass('error');
				    },
				    unhighlight: function(element, errorClass, validClass) {
				        $(element).removeClass('error');
				    },
				    submitHandler: function (frm) {
				    	frm.submit();
				    }
				});

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
			                    "icon" : "fa fa-folder text-primary"
			                },
			                "menuTy" : {
			                    "icon" : "fa fa-folder text-warning"
			                }
			            },
				       "plugins" : [ "types" ]  //"dnd"
				});
				//$("#mngMenuTree").jstree("open_all");//전체 열기
				$("#mngMenuTree").jstree('open_node', '${mngMenuList[0].menuNo}');
				$("#mngMenuTree").bind("select_node.jstree", function(event, data){
					//alert(data.node.id + "//" + data.node.parent + "//" +data.node.text );
					if(data.node.parent == "\#"){
						alert("홈 메뉴는 수정할 수 없습니다.");
					}else{
						$.ajax({
			          		dataType : "json",
			          	    type : "POST",
			          	    url : "/admin/mng/menu/getMngMenu.json",
							contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
			          	    data : "menuNo="+data.node.id,
			          	    success : function(data) {
			          	    	$("#frmTitle").text("'"+data.mngMenuVO.menuNm +"' 메뉴 수정")

			          	    	//값 설정
			          	    	$("#crud").val("UPDATE");
			        			$("#upperMenuNo").val(data.mngMenuVO.upperMenuNo);	//상위메뉴No
			        			$("#upperMenuNm").val(data.mngMenuVO.upperMenuNm);	//상위메뉴명
			        			$("#menuNo").val(data.mngMenuVO.menuNo);	//메뉴No
			        			$("#menuNm").val(data.mngMenuVO.menuNm);	//메뉴명
			        			$("#menuUrl").val(data.mngMenuVO.menuUrl);	//관리URL
			        			$("#sortNo").val(data.mngMenuVO.sortNo);	//순서
			        			$("#icon").val(data.mngMenuVO.icon);	//아이콘
			        			$("input:radio[name='useAt'][value='"+ data.mngMenuVO.useAt +"']").prop("checked", true);	//사용여부

			          	    	$("#menuTy").val(data.mngMenuVO.menuTy);
			        			if(data.mngMenuVO.menuTy == "1"){
			        				$("#menuUrl").prop("readonly", true);
			        				$("#icon").prop("readonly", true);
			        				$("#icon_btn").css("display", "none");
			        				$("#delBtn").css("display", "none");
			        			}else{
			        				$("#menuUrl").prop("readonly", false);
			        				$("#icon").prop("readonly", false);
			        				$("#icon_btn").css("display", "");
			        				$("#delBtn").css("display", "");
			        			}

							},
							error: function(data, status, err) {
								console.log('error forward : ' + data);
							}
						});
					}
				});//event 추가
			});
			</script>


			<!-- Start Breadcrumb -->
			<jsp:include page="/WEB-INF/jsp/admin/layout/breadcrumb.jsp">
				<jsp:param name="pageName" value="CMS 메뉴 관리"/>
			</jsp:include>
			<!-- End Breadcrumb -->

            <!-- start: page -->
			<div class="row">
				<div class="col-md-4">
				<section class="panel panel-featured panel-featured-primary">
					<header class="panel-heading">
						<div class="panel-actions">
							<button onclick="location.reload();" class="mb-xs mr-xs btn btn-sm btn-default" id="addBtn"><i class="fa fa-plus"></i> 추가</button>
						</div>
						<h2 class="panel-title">메뉴 목록</h2>
					</header>
					<div class="panel-body">
						<div class="widget-content" id="mngMenuTree" style="padding:10px 0;">
						</div>
					</div>
				</section>
				</div>
				<div class="col-md-8">
				<section class="panel panel-featured panel-featured-primary">

					<f:form name="frmMngMenu" id="frmMngMenu" modelAttribute="mngMenuVO" method="post" action="./action" >
					<f:hidden path="crud" />
					<f:hidden path="menuNo" />
					<f:hidden path="menuTy" />
					<f:hidden path="upperMenuNo" />

					<header class="panel-heading">
						<h2 class="panel-title" id="frmTitle">메뉴 추가</h2>
					</header>
					<div class="panel-body">
						<div class="table-responsive">
								<table class="table table-bordered mb-none">
									<colgroup>
										<col style="width:130px" />
										<col />
									</colgroup>
									<tr>
										<th>메뉴 구분 </th>
										<td>
											<i class="fa fa-folder text-primary"></i> 기본 메뉴 &nbsp;
											<i class="fa fa-folder text-warning"></i> 추가 메뉴
											<span class="help-block">* 기본 메뉴는 관리URL 수정 및 메뉴 삭제가 불가능합니다.</span>
										</td>
									</tr>
									<tr>
										<th>상위메뉴 <span class="required">*</span></th>
										<td>
											<div class="form-inline">
											<f:input path="upperMenuNm" readonly="true" placeHolder="메뉴 선택" class="form-control"/>
											<button class="btn btn-default" type="button" onclick="f_mngMenuSearch(); return false;" >선택</button>
											</div>
										</td>
									</tr>
									<tr>
										<th>메뉴명 <span class="required">*</span></th>
										<td><f:input path="menuNm" class="form-control" /></td>
									</tr>
									<tr>
										<th>관리URL <span class="required">*</span></th>
										<td><f:input path="menuUrl" class="form-control" /></td>
									</tr>
									<tr>
										<th>순서 <span class="required">*</span></th>
										<td><f:input path="sortNo" class="form-control" /></td>
									</tr>
									<tr>
										<th>아이콘</th>
										<td>
											<f:input path="icon" class="form-control" />
										</td>
									</tr>
									<tr>
										<th>사용여부 <span class="required">*</span></th>
										<td>
											<div class="radio-group">
												<f:radiobuttons path="useAt" items="${useAtCode}" element="div class='radio-custom radio-primary'"/>
											</div>
											<span class="help-block">* '사용안함'를 선택한 경우 하위메뉴까지 일괄 적용됩니다.</span>
										</td>
									</tr>
								</table>
						</div>
					</div>
					<footer class="panel-footer">
						<div class="row">
							<div class="col-sm-12 text-right">
								<cmsBtn2:btn btnTy="save" path="${curPath}" mngrSession="${mngrSession }" >저장</cmsBtn2:btn>
								<cmsBtn2:btn btnTy="delete" path="${curPath}" mngrSession="${mngrSession }" script="f_Delete(); return false;" >삭제</cmsBtn2:btn>
							</div>
						</div>
					</footer>
					</f:form>

				</section>
				</div>
			</div>