<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/taglibs.jsp" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%--
			<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jstree/3.2.1/themes/default/style.min.css" />
			<script src="https://cdnjs.cloudflare.com/ajax/libs/jstree/3.2.1/jstree.min.js"></script>
--%>
			<!-- jstree -->
			<link rel="stylesheet" href="${globalAdminAssets}/vendor/jstree/themes/default/style.css" />
			<script src="${globalAdminAssets}/vendor/jstree/jstree.js"></script>
			

			<script>

			function f_empSrch(){
                var target ="deptCode|deptNm|empCode|mngrNm";
                window.open("/admin/mng/deptEmp/popup/empList?target="+target, "popEmp", "width=780, height=525");
        	}

			function f_duplCheck(){
				
				if($("#menuUri").val() == ''){
					alert("URI를 입력해주세요.");
					$("#menuUri").focus();
					
				}else{
					$.ajax({
						type : "post",
						url: './retrieveDupCo',
						data: 'siteNo=${siteMenuVO.siteNo }&menuUri=' + $("#menuUri").val(),
						dataType: 'text', //전송받을 데이터의 타입
						contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
						success: function(data) {
							if(data=="true"){
								alert("사용가능한 URI 입니다.");
								$("#dataDupCheck").val(1);
							}else{
								alert("이미 사용중인 URI 입니다.");
								$("#dataDupCheck").val(0);
							}
						},
						error: function(data, status, err) {
							console.log('error forward : ' + data);
						}
					});
				}
			}

			function f_radioBtnAllCheck(){
				$(".menu-ty").hide();
				$(".menu-ty.ty"+$("input[name='menuTy']:checked").val()).show();
				if($("input[name='menuTy']:checked").val() == 1){
					$(".menu-ty.ty1-"+$("input[name='subMainUseAt']:checked").val()).show();
				}
			}

			function f_menuSearch(){
				var menuCrud = $('#crud').val();
				var siteNo = $('#siteNo').val();
				var menuNo = $('#menuNo').val();
				window.open("/admin/site/menu/popup/menuList?siteNo="+siteNo+"&menuNo="+menuNo+"&menuCrud="+menuCrud, "popMenu", "width=400, height=500, scrollbars=yes");
			}

			//직원검색>>부서코드|부서명|직원코드|직원명이 들어갈 id를 지정
			function f_empSrch(){
				var target ="deptCode|mnuChargerOrgnztNm|empCode|mnuChargerNm|mnuChargerTelno";
				window.open("/admin/mng/deptEmp/popup/empList?target="+target, "popEmp", "width=780, height=525");
			}

			function f_empSrch_callback(){
	        	$('input[name="mnuChargerUpdtDt"]').datepicker('update', new Date());
// 				$('input[name="mnuChargerUpdtDt"]').val($.datepicker.formatDate('yy-mm-dd', new Date()));
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
								$("#frmSiteMenu").submit();
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

			function f_moveMenuPos(){

			}
			
			function f_expandMenuAll(){
				$('#siteMenuTree').jstree('open_all');
			}
			
			function f_collapseMenuAll(){
				$('#siteMenuTree').jstree('close_all');
				$("#siteMenuTree").jstree('open_node', '${siteMenuList[0].menuNo}');
			}
			
			function f_loadMenuList(){
				$.ajax({
					type : "post",
					url  : "getSiteMenuList.json",
					data : "siteNo=${siteVO.siteNo}",
					dataType : 'json',
					success  : function (data) {
						var menu = [];
						for (var idx in data) {
							
							var menuType = '';
							
							if(data[idx].upperMenuNo == '0'){
								menuType = '0';
							}
							else if (data[idx].menuTy != '1'){
								menuType = data[idx].menuTy;
							}
							else if (data[idx].menuTy == '1' && ! data[idx].linkUrl) {
								menuType = '8';
							}
							else if (data[idx].menuTy == '1') {
								menuType = '1';
							}
							
							if (data[idx].useAt == 'N') {
								menuType = '1' + menuType;	
							}
							
							menu.push({
								'id' : data[idx].menuNo
								, 'parent' : data[idx].upperMenuNo != 0 ? data[idx].upperMenuNo : '#'
								, 'text' : data[idx].menuNm
								, 'type' : menuType
								, 'menuTy' : data[idx].menuTy
							});
							
						}
						
						$("#siteMenuTree").jstree(true).settings.core.data = menu;
						$("#siteMenuTree li").each( function() {
							$("#siteMenuTree").jstree('enable_node', this.id);
						});
						$("#siteMenuTree").jstree(true).refresh();
						
					},
					error : function (data) {
						console.log(data);
						alert("메뉴 리스트 갱신에 실패하였습니다.");
					}
				});
			}
			
			var menuList = [
							<c:forEach var="siteMenuList" items="${siteMenuList}" varStatus="status">
								/***
								 *  ${siteMenuList.upperMenuNo}
								 *  ${siteMenuList.menuTy}
								 */
								<c:set var="menuType" value=""/>
								<c:choose>
								<c:when test="${siteMenuList.upperMenuNo eq '0'}">
									<c:set var="menuType" value="0" />
								</c:when>
								<c:when test='${siteMenuList.menuTy ne "1"}'>
									<c:set var="menuType" value="${siteMenuList.menuTy}" />
								</c:when>
								<c:when test='${siteMenuList.menuTy eq "1" && empty siteMenuList.linkUrl}'>
									<c:set var="menuType" value="8" />
								</c:when>
								<c:when test='${siteMenuList.menuTy eq "1"}'>
									<c:set var="menuType" value="1" />
								</c:when>
								</c:choose>
								<c:if test='${siteMenuList.useAt eq "N"}'>
									<c:set var="menuType" value="1${menuType}"/>
								</c:if>
			               {
			            	   "id" : "${siteMenuList.menuNo}"
			            	   , "parent" :
			            	   <c:choose>
			            	     <c:when test="${siteMenuList.upperMenuNo == 0}">"#"</c:when>
			            	     <c:otherwise>"${siteMenuList.upperMenuNo}"</c:otherwise>
			            	   </c:choose>
			            	   , "text" : "${siteMenuList.menuNm}<c:if test='${!empty bassMenu}'> (${bassMenu})</c:if> (${siteMenuList.menuNo})"
			            	   , "type" : "${menuType}"
			            	   , "menuTy" : "${siteMenuList.menuTy}"
			               }<c:if test="${!status.last}">,</c:if>
							</c:forEach>
			           ];

			$(function() {

		        $('input[name="mnuChargerUpdtDt"]').datepicker({
		            format: "yyyy-mm-dd",
		            maxViewMode: 2,
		            todayBtn: "linked",
		            language: "kr",
		            clearBtn: false,
		            autoclose: true,
		            todayHighlight: true
		        });
 		        if($('input[name="mnuChargerUpdtDt"]').val() == ""){
 		        	$('input[name="mnuChargerUpdtDt"]').datepicker('update', new Date());
// 		        	$('input[name="mnuChargerUpdtDt"]').val($.datepicker.formatDate('yy-mm-dd', new Date()));
		        }

				$('[rel="popover"]').popover({
		            trigger : 'hover'
		        });
				$("#asideBtn").popover({title:"aside란?"
						, content:"<div style='wdith:200px;'><div style='height:50px; width:50px;'><div style='float:left;border:solid 1px #ccc; width:96%; height:10px;'></div><div style='float:left;border:solid 1px #ccc;width:64%; height:30px;'></div><div style='float:left; background-color:#bbb; border:solid 1px #ccc;width:28%; height:30px;'></div><div style='float:left;border:solid 1px #ccc; width:96%; height:10px;'></div></div><div style='margin-top:-40px;'>사이트의 좌측 또는 우측영역</div></div>"
						, html:true, placement:"left", trigger:"hover"});

				$("#menuUri").on("keyup", function(){
					$("#dataDupCheck").val(0);
				});

				$("input[name='menuTy']").on("change", function(){
					$(".menu-ty").hide();
					$(".menu-ty.ty"+$(this).val()).show();
					if($(this).val() == 1){$(".menu-ty.ty1-"+$("input[name='subMainUseAt']:checked").val()).show();}
	 				$("#mappedItemsTable button").hide();
	 				if($("input[name='menuNo']").val() > 0){
		 				$("#mappedItemsTable .menu-ty"+$(this).val()+" button").show();
	 				}
	 				else{
		 				$("#mappedItemsTable .menu-ty"+$(this).val()+" button.btn-search").show();
	 				}
				});
				$("input[name='subMainUseAt']").on("change", function(){
					$(".menu-ty[class*='ty1-']").hide();
					$(".menu-ty.ty1-"+$(this).val()).show();
				});
				$(".menu-ty.ty"+$("input[name='menuTy']:checked").val()).show();
				$(".menu-ty.ty1-"+$("input[name='subMainUseAt']:checked").val()).show();

				$("#menuUri").on("change keyup", function(){
					//$(this).val( $(this).val().replace(/[^A-Za-z0-9\-\?\&\=\/\_]/gi,"") );//영문,숫자,하이픈.?,&
					//$(this).val( $(this).val().replace(/[\~\!\@#$\%\^\*\(\)\_\+\`\{\}\[\]\|\\\:\"\;\'\<\>\,\.\s\/]/gi,"") );//영문,숫자,하이픈.?,&
					$(this).val( $(this).val().replace(/[\~\!\@#$\%\^\*\(\)\_\\`\{\}\[\]\|\\\:\"\;\'\<\>\,\.\s\/]/gi,"") );//영문,숫자,하이픈.?,&
					$("#preview_uri").text($(this).val());
				});

				$("form[name='frmSiteMenu']").validate({
				    ignore: "input[type='text']:hidden",
				    rules : {
				    	upperMenuNm	: { required : true },
				    	menuNm			: { required : true },
				    	menuUri			: { required : true },
				    	sortNo			: { required : true, number:true }
				    },
				    messages : {
				    	upperMenuNm	: { required : "상위메뉴를 선택하세요" },
					    menuNm			: { required : "메뉴명을 입력하세요" },
					    menuUri			: { required : "메뉴URI를 입력하세요" },
					    sortNo			: { required : "메뉴 순서를 숫자로 입력하세요", number : "숫자만 입력 가능합니다." },
				    },
				    errorElement: 'span',
				    errorClass: 'help-block error',
				    errorPlacement: function(error, element) {
						error.insertAfter(element.parent().find(':last'));
					},
				    highlight:function(element, errorClass, validClass) {
				        $(element).addClass('error');
				    },
				    unhighlight: function(element, errorClass, validClass) {
				        $(element).removeClass('error');
				    },
				    submitHandler: function (frm) {

				    	if($("#dataDupCheck").val() == 0){
				    		alert("URI 중복 확인을 해야 합니다.");
				    		return false;
				    	}
				    	
						if($("input[name='menuTy']:checked").val() == "2" && $("input[name='postListTy']:checked").val() == "1"
								&& $("#mappedCntnts tbody tr").not(".no_data").length > 1 ){
							alert("일반형 콘텐츠 메뉴는 1개의 콘텐츠를 연결해야 합니다.");
				    		return false;
						}

				    	if(confirm("입력하신 정보를 저장 하시겠습니까?")){
				    		frm.submit();
				    	}else{
				    		return false;
				    	}
				    }
				});

				$("#siteMenuTree").jstree({
					"core" : {
						"multiple" : false,
		                "themes" : { "responsive": false},
//		                "ui" : {"select_limit" : 1},
		                "check_callback" : function (operation, node, node_parent, node_position, more) {

		                    if(operation === 'move_node') {

 		                    	if(node_parent.id === "#"){return false;}
 		                    	if(node.state.disabled){return false;}

		                    	return true;
		                    }

		                    return false;
		                },
				    	"data" : menuList
				       },
			            "types" : {
			                "default" : {
			                    "icon" : "fa fa-file text-info"
			                },
			                "0" : {"icon" : "fa fa-home text-primary"},
			                "1" : {"icon" : "fa fa-folder text-primary"},
			                "2" : {"icon" : "fa fa-book text-primary", "valid_children" : []},
			                "3" : {"icon" : "fa fa-edit text-primary", "valid_children" : []},
			                "4" : {"icon" : "fa fa-magic text-primary", "valid_children" : []},
			                "5" : {"icon" : "fa fa-desktop text-primary", "valid_children" : []},
			                "6" : {"icon" : "fa fa-map-pin text-primary", "valid_children" : []},
			                "7" : {"icon" : "fa fa-ban text-danger", "valid_children" : []},
			                "8" : {"icon" : "fa fa-newspaper-o text-primary"},
			                "11" : {"icon" : "fa fa-folder text-muted"},
			                "12" : {"icon" : "fa fa-book text-muted", "valid_children" : []},
			                "13" : {"icon" : "fa fa-edit text-muted", "valid_children" : []},
			                "14" : {"icon" : "fa fa-magic text-muted", "valid_children" : []},
			                "15" : {"icon" : "fa fa-desktop text-muted", "valid_children" : []},
			                "16" : {"icon" : "fa fa-map-pin text-muted", "valid_children" : []},
			                "17" : {"icon" : "fa fa-ban text-muted", "valid_children" : []},
			                "18" : {"icon" : "fa fa-newspaper-o text-muted"}
			            },
			             "dnd" : {
			                "copy" : false,
			                "inside_pos" : "last"
			            },
				       "plugins" : [ "wholerow", "types", "dnd" ]  //"dnd"
				});

				// 메뉴 이동 시
				$("#siteMenuTree").bind("move_node.jstree", function(e, data){

					console.log(data.parent
							, data.position
							, data.node.id
							, data.old_position
							, data.old_parent
							);
					
					console.log($("#siteMenuTree").jstree('is_open', data.parent));
					
// 					// 이동할 폴더가 닫혀 있을 경우 연다
// 					if( ! $("#siteMenuTree").jstree('is_open', data.parent) ) {
// 						$("#siteMenuTree").jstree('open_node', data.parent);
// 					}

					if(data.parent == data.old_parent && data.position == data.old_position) {
						console.log("same position!");
						return false;
					}
					else {
						// 메뉴 이동 처리 전 메뉴 리스트 비활성화
						$("#siteMenuTree li").each( function() {
						  $("#siteMenuTree").jstree('disable_node', this.id);
						});
						$.ajax({
							dataType : "json",
							type : "POST",
							url : "/admin/site/menu/moveSiteMenu.json",
							contentType : "application/x-www-form-urlencoded; charset=UTF-8",
							data : "siteNo=${siteMenuVO.siteNo}&menuNo="+data.node.id+"&upperMenuNo="+data.parent+"&sortNo="+data.position,
							success : function(data){
								console.log("***************** move site menu ");
								console.log(data);
								f_loadMenuList(false);
							},
							error : function(data){
								alert("메뉴 이동 처리가 실패했습니다.");
								f_loadMenuList(false);
							}
						})
					}


				});

				// 메뉴 선택 시
				$("#siteMenuTree").bind("select_node.jstree", function(event, data){
					if(data.node.parent == "\#"){
						alert("홈 메뉴는 수정할 수 없습니다.");
					}else{
						$.ajax({
			          		dataType : "json",
			          	    type : "POST",
			          	    url : "/admin/site/menu/getSiteMenu.json",
							contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
			          	    data : "menuNo="+data.node.id,
			          	    success : function(data) {
			          	    	$("#frmTitle").text("메뉴 수정");
			          	    	$("#frmSubTitle").text(data.siteMenuVO.menuNm);

			          	    	$("#crud").val("UPDATE");
			        			$("#upperMenuNo").val(data.siteMenuVO.upperMenuNo);
			        			$("#upperMenuNm").val(data.siteMenuVO.upperMenuNm);
			        			$("#menuNo").val(data.siteMenuVO.menuNo);
			        			$("#menuNm").val(data.siteMenuVO.menuNm);
			        			$("#menuUri").val(data.siteMenuVO.menuUri);
			        			$("#sortNo").val(data.siteMenuVO.sortNo);
			        			$("#levelNo").val(data.siteMenuVO.levelNo);

			        			$("input:radio[name='menuTy'][value='"+ data.siteMenuVO.menuTy +"']").prop("checked", true);
			        			$("input:radio[name='subMainUseAt'][value='"+ data.siteMenuVO.subMainUseAt +"']").prop("checked", true);
			        			$("input:radio[name='postListTy'][value='"+ data.siteMenuVO.postListTy +"']").prop("checked", true);
			        			$("input:radio[name='tagCloudAt'][value='"+ data.siteMenuVO.tagCloudAt +"']").prop("checked", true);

			        			$("input:checkbox[name='asideOpt']").prop("checked", false);
			        			if(data.siteMenuVO.asideOpt != null){
				        			$.each(data.siteMenuVO.asideOpt, function(index, value){
				        				$("input:checkbox[name='asideOpt'][value='"+ value +"']").prop("checked", true);
				        			});
			        			}

			        			$("#linkUrl").val(data.siteMenuVO.linkUrl);
			        			$("input:radio[name='linkTrgt'][value='"+ data.siteMenuVO.linkTrgt +"']").prop("checked", true);

			        			$("input:radio[name='mnmnuDspyAt'][value='"+ data.siteMenuVO.mnmnuDspyAt +"']").prop("checked", true);
			        			$("input:radio[name='sbmnuDspyAt'][value='"+ data.siteMenuVO.sbmnuDspyAt +"']").prop("checked", true);
			        			$("input:radio[name='useAt'][value='"+ data.siteMenuVO.useAt +"']").prop("checked", true);
			        			
			        			$("input:radio[name='siteMenuDspyAt'][value='"+ data.siteMenuVO.siteMenuDspyAt +"']").prop("checked", true);

			        			$("input:radio[name='cmUseAt'][value='"+ data.siteMenuVO.cmUseAt +"']").prop("checked", true);
			        			$("input:radio[name='stsfdgUseAt'][value='"+ data.siteMenuVO.stsfdgUseAt +"']").prop("checked", true);
			        			$("input:radio[name='mnuChargerUseAt'][value='"+ data.siteMenuVO.mnuChargerUseAt +"']").prop("checked", true);

			        			$("#preview_uri").text(data.siteMenuVO.menuUri);

			        			$("#dataDupCheck").val(1);

			        			$("#mnuChargerNm").val(data.siteMenuVO.mnuChargerNm);
			        			$("#mnuChargerOrgnztNm").val(data.siteMenuVO.mnuChargerOrgnztNm);
			        			$("#mnuChargerTelno").val(data.siteMenuVO.mnuChargerTelno);
			        			$("#mnuChargerUpdtDt").val(data.siteMenuVO.mnuChargerUpdtDt);
			     		        if($('input[name="mnuChargerUpdtDt"]').val() == ""){
			     		        	$('input[name="mnuChargerUpdtDt"]').datepicker('update', new Date());
// 			    		        	$('input[name="mnuChargerUpdtDt"]').val($.datepicker.formatDate('yy-mm-dd', new Date()));
			    		        }

			          	    	f_radioBtnAllCheck();

			          	    	f_callbackAdminList("${siteMenuVO.siteNo}", data.siteMenuVO.menuNo);

			          	    	f_callbackMappedItems("${siteMenuVO.siteNo}", data.siteMenuVO.menuNo, data.siteMenuVO.bbsNo, data.siteMenuVO.fnctNo);
							},
							error: function(data, status, err) {
								console.log('error forward : ' + data);
							}
						});
					}
				});//event 추가
				
				$("#siteMenuTree").bind("loaded.jstree", function(event, data){
					 $("#siteMenuTree").jstree('open_node', '${siteMenuList[0].menuNo}');
						//$("#siteMenuTree").jstree("open_all");//전체 열기
				});
			});

			//관리자검색>>
			function f_mngrSearch(){
				var type ="M";
				window.open("/admin/mng/mngr/popup/mngrList2?type="+type, "popMngr", "width=780, height=525");
			}

			$(document).on("click", "#mngrMapngTable .delBtn", function(){
				$(this).closest("tr").fadeOut(300, function(){
					$(this).remove();
					$("#mngrMapngTable .emptyTr").show();
				});
			});

			function f_callbackAdminList(sn, mn){
// 				$("#mngrDiv").show();

				$("#mngrMapngTable tbody tr").not(".emptyTr").remove();
				$("#mngrMapngTable tbody tr.emptyTr").show();

				$.ajax({//관리자 목록 호출
					type : "post",
					url: '/admin/mng/mngr/siteMngrList.json',
					dataType: 'json',
					data:{siteNo:sn, menuNo:mn, type:"M"},
					contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
					success: function(data) {
						if(data.length < 1){
							$("#mngrMapngTable tbody tr.emptyTr").show();
						} else {
							$("#mngrMapngTable tbody tr.emptyTr").hide();
						}
						$.each(data, function (index, value) {
							var inputMngrId = "<input type=\"hidden\" name=\"arrMngrId\" value=\""+ value.mngrId +"\" />";
							var mngrNm = value.mngrNm;
							var mngrDept = value.deptNm;
							$("#mngrMapngTable tbody").append("<tr><td>"+inputMngrId+mngrNm+"</td><td>"+ mngrDept +"</td><td><a href=\"#DEL\" class=\"badge delBtn\">X</a></td></tr>");
		                });
					},
					error: function(data, status, err) {
					}
				});
			}

			//메뉴연결>삭제버튼
			$(document).on("click", "#mappedItemsTable tbody#relation_post .delBtn", function(){
				$(this).closest("tr").fadeOut(300, function(){
					if($(this).closest("tbody").children("tr").not(".no_data").length<=1){
						$(this).closest("tbody").children("tr.no_data").show();
					}
					$(this).remove();
				});
			});
			
			// 메뉴에 연결할 아이템을 생성
			function f_create_relation_item(ty){
				switch(ty){
				case "cntnts":
					window.open("/admin/cntnts/form?mapngMenuNo="+$("input[name='menuNo']").val(),"_self");
					break;
				case "bbs":
					window.open("/admin/bbs/setting/form?mapngMenuNo="+$("input[name='menuNo']").val(),"_self");
					break;
				case "fnct":
					window.open("/admin/fnct/fnctProgrm/form?mapngMenuNo="+$("input[name='menuNo']").val(),"_self");
					break;
				}
			}

			// 메뉴에 연결할 아이템을 검색하여 연결
			function f_find_relation_item(ty){
				switch(ty){
				case "cntnts":
// 					var postListTy = $("input:radio[name='postListTy']:checked").val();
// 					if(postListTy==1 && $("#mappedCntnts tbody tr").not(".no_data").length > 0){
// 						alert("콘텐츠 목록 형식이 '일반형'입니다.");
// 						return false;
// 					}
// 					window.open("/admin/cntnts/popup/list?srchPostListTy="+postListTy, "popCntntsList", "width=900, height=605")
					window.open("/admin/cntnts/popup/list", "popCntntsList", "width=900, height=605")
					break;
				case "bbs":
					window.open("/admin/bbs/popup/list", "popCntntsList", "width=900, height=605");
					break;
				case "fnct":
					window.open("/admin/fnct/fnctProgrm/popup/list", "popCntntsList", "width=900, height=605");
					break;
				}
			}
			
			// 콘텐츠 목록 형식이 일반형일 경우, 매핑된 콘텐츠는 1개만 존재 가능
			function f_check_cntnts_relation_limit(){
				if($("input[name='postListTy']:checked").val() == "1"){
					alert("일반형 콘텐츠 메뉴는 1개의 콘텐츠를 연결해야 합니다.");
					return false;
				} 
				else 
					return true;
			}
			
			// 메뉴 연결 정보 확인
			function f_callbackMappedItems(sn, mn, bn, fn) {
				$("#mappedItemsTable tbody#relation_post tr").not(".no_data").remove();
				$("#mappedItemsTable tbody#relation_post tr.no_data").show();
				$("#mappedItemsTable button").hide();
				$("#mappedItemsTable .menu-ty"+$("input:radio[name='menuTy']:checked").val()+" button").show();
				$.ajax({
					type : "post",
					url	 : "/admin/site/menu/getSiteMenuMapped.json",
					dataType : "json",
					data : {siteNo:sn, menuNo:mn, bbsNo:bn, fnctNo:fn},
					contentType : "application/x-www-form-urlencoded; charset=UTF-8",
					success : function(data) {
						if(data.bbs){
							var bbsTr = '<tr><td><input type="hidden" name="bbsNo" value="'+data.bbs.bbsNo+'"/>'
							+ '<a href="/admin/bbs/setting/form?bbsNo='+data.bbs.bbsNo+'">'+data.bbs.bbsSj+'</a> '
							+ '<a href="/admin/bbs/type'+data.bbs.bbsTy+'/list?bbsNo='+data.bbs.bbsNo+'" target="_blank"><i class="fa fa-external-link"></i></a></td>'
//							+ '<a href="/admin/bbs/setting/form?bbsNo='+data.bbs.bbsNo+'" class="badge badge-success">설정</a> '
//							+ '<a href="/admin/bbs/type'+data.bbs.bbsTy+'/list?bbsNo='+data.bbs.bbsNo+'" class="badge badge">게시물</a> '
							+ '<td class="text-right"><a href="#DEL" class="btn btn-default btn-xs delBtn"><i class="fa fa-trash text-danger"></i> 해제</a></td>'
							+ '</tr>';
							$("#mappedBbs tbody").append(bbsTr);
							if($("#mappedBbs tbody tr").not(".no_data").length>0){
								$("#mappedBbs tbody tr.no_data").hide();
							}
						}
						if(data.fnct){
							var fnctTr = '<tr><td><input type="hidden" name="fnctNo" value="'+data.fnct.fnctNo+'"/>'
							+ '<a href="/admin/fnct/fnctProgrm/view?fnctNo='+data.fnct.fnctNo+'">'+ data.fnct.fnctNm+'</td>'
//							+ '<a href="/admin/fnct/fnctProgrm/view?fnctNo='+data.fnct.fnctNo+'" class="badge badge-success">상세</a> '
							+ '<td class="text-right"><a href="#DEL" class="btn btn-default btn-xs delBtn"><i class="fa fa-trash text-danger"></i> 해제</a></td>'
							+ '</tr>';
							$("#mappedFnct tbody").append(fnctTr);
							if($("#mappedFnct tbody tr").not(".no_data").length>0){
								$("#mappedFnct tbody tr.no_data").hide();
							}
							<%--
							$("#mappedItemsTable tbody").append("<tr><td>기능프로그램 > " + data.fnct.fnctNm + '</td><td><a href="#DEL" class="badge badge-success delBtn"><i class="iconfugue16-magnifier--pencil"></i></a><a href="#DEL" class="badge badge-important delBtn"><i class="iconfugue16-eraser--minus"></i></a></td></tr>');
							--%>
						}
						if(data.cntnts.listObject.length>0){
							var cntntsTr = "";
							$.each(data.cntnts.listObject, function (index, value) {
								cntntsTr += '<tr><td><input type="hidden" name="arrCntntsNo" value="'+value.cntntsNo+'"/>'
								+ '<a href="/admin/cntnts/view?cntntsNo='+value.cntntsNo+'">'+ value.cntntsSj+'</td>'
// 								+ '<a href="/admin/cntnts/view?cntntsNo='+value.cntntsNo+'" class="badge badge-success">상세</a> '
// 								+ '<a href="#DEL" class="badge badge-important delBtn"><i class="icon icon-white icon-trash"></i></a>'
								+ '<td class="text-right"><a href="#DEL" class="btn btn-default btn-xs delBtn"><i class="fa fa-trash text-danger"></i> 해제</a></td>'
								+ '</tr>';
							});
							$("#mappedCntnts tbody").append(cntntsTr);
							if($("#mappedCntnts tbody tr").not(".no_data").length>0){
								$("#mappedCntnts tbody tr.no_data").hide();
							}
							// 콘텐츠 목록 형식이 일반형일 경우, 매핑된 콘텐츠는 1개만 존재 가능
							
						}
					},
					error : function(data, status, err) {

					}
				});
			}

			</script>
			
			
			
			<!-- Start Breadcrumb -->
			<jsp:include page="/WEB-INF/jsp/admin/layout/breadcrumb.jsp">
				<jsp:param name="pageName" value="사이트 메뉴 관리"/>
			</jsp:include>
			<!-- End Breadcrumb -->

            <!-- start: page -->
			<div class="row">
				<div class="col-md-4 p-none">
				<section class="panel panel-featured panel-featured-primary">
					<header class="panel-heading">
						<div class="panel-actions text-primary">
							<a href="#" class="panel-action mr-xs" onclick="f_expandMenuAll();" title="전체 열기"><i class="fa fa-plus-square"></i></a>
							<a href="#" class="panel-action mr-md" onclick="f_collapseMenuAll();" title="전체 닫기"><i class="fa fa-minus-square"></i></a>
							<a href="./form?siteNo=${siteMenuVO.siteNo }" class="panel-action" title="메뉴 추가"><i class="fa fa-pencil-square"></i> 추가</a>
						</div>
						<h2 class="panel-title">메뉴 리스트</h2>
						<p class="panel-subtitle">
							<span>${siteVO.siteNm}</span>
							<c:set var="siteUrl">${siteVO.siteUrl}<c:if test="${siteVO.firstUriDivYn eq 'Y'}">/${siteVO.firstUri}</c:if></c:set>
							<a href="//${siteUrl }" target="_blank"><i class="fa fa-home text-primary"></i>${siteUrl}</a>
						</p>
					</header>
					<div class="panel-body">

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
				</div>
				
				<div class="col-md-8 pr-none">
				<section class="panel panel-featured panel-featured-primary">
					<header class="panel-heading">
						<div class="panel-actions">

						</div>
						<h2 class="panel-title" id="frmTitle">메뉴 추가</h2>
						<p class="panel-subtitle" id="frmSubTitle">
							&nbsp;
						</p>
					</header>
					
					<f:form name="frmSiteMenu" id="frmSiteMenu" modelAttribute="siteMenuVO" method="post" action="./action" class="form-horizontal" target="hiddenFrame">
						<f:hidden path="crud" />
						<f:hidden path="siteNo" />
						<f:hidden path="upperMenuNo" />
						<f:hidden path="menuNo" />
						<f:hidden path="levelNo"	/>
						<input type="hidden" id="dataDupCheck" name="dataDupCheck" value="0" />
					
					<div class="panel-body">
					
					<div class="panel-group">
						<!-- 메뉴 정보 서브섹션 -->
						<div class="panel panel-accordion">
							<div class="panel-heading">
								<h4 class="panel-title">
									<a>
										<i class="fa fa-"></i> 메뉴 정보
									</a>
								</h4>
							</div>
							<div id="collapse1" class="accordion-body collapse in">
						
								<table class="table m-none">
									<colgroup>
										<col style="width:125px" />
										<col />
									</colgroup>
									<tr>
										<th>상위메뉴 <span class="required">*</span></th>
										<td>
											<div class="form-inline">
											<f:input path="upperMenuNm" readonly="true" placeHolder="메뉴 선택" class="form-control"/>
											<button class="btn btn-default" type="button" onclick="f_menuSearch(); return false;" >선택</button>
											</div>
											<div></div>
										</td>
									</tr>
									<tr>
										<th>메뉴명 <span class="required">*</span></th>
										<td><f:input path="menuNm" class="form-control" maxlength="200" /></td>
									</tr>
									<tr>
										<th>유형 <span class="required">*</span></th>
										<td>
											<f:radiobuttons path="menuTy" items="${siteMenuTyCode}" class="form-control" element="div class='radio-custom radio-inline radio-primary'"/>
										</td>
									</tr>
		
									<tr class="menu-ty ty1" style="background-color:#fcf8e3;display:none;">
										<th>서브메인 사용 </th>
										<td>
											<f:radiobuttons path="subMainUseAt" items="${useAtCode}" class="form-control" element="div class='radio-custom radio-inline radio-primary'"/>
										</td>
									</tr>
									<tr class="menu-ty ty1-N" style="background-color:#fcf8e3;display:none;">
										<th>링크 정보</th>
										<td>
											<f:input path="linkUrl" class="form-control" placeholder="ex) http://" maxlength="250" />
										</td>
									</tr>
									<tr class="menu-ty ty1-N" style="background-color:#fcf8e3;display:none;">
										<th>링크 타겟</th>
										<td>
											<f:radiobuttons path="linkTrgt" items="${linkTrgtTyCode}" class="form-control" element="div class='radio-custom radio-inline radio-primary'" />
										</td>
									</tr>
		
									<tr class="menu-ty ty2" style="background-color:#fcf8e3;display:none;">
										<th><a href="#" style="color:#666;" rel="popover" data-placement="left" data-content="콘텐츠의 노출 형태 입니다.">콘텐츠 목록 형식</a></th>
										<td>
											<f:radiobuttons path="postListTy" items="${postListTyCode}" class="form-control" element="div class='radio-custom radio-inline radio-primary'" />
										</td>
									</tr>
		
									<tr>
										<th>URI <span class="required">*</span></th>
										<td>
											<div class="form-inline">
											<f:input path="menuUri" class="form-control" mexlength="20" />
											<button class="btn btn-info"  onclick="f_duplCheck(); return false;">중복확인</button>
											</div>
											<span class="help-block">
												http://${siteVO.siteUrl}<c:if test="${siteVO.firstUriDivYn eq 'Y'}">/${siteVO.firstUri }</c:if>/<b id="preview_uri"></b>
											</span>
										</td>
									</tr>
									<tr>
										<th>메뉴순서</th>
										<td>
											<div class="row"><div class="col-sm-2">
											<f:input path="sortNo" class="form-control" mexlength="2" />
											</div></div>
										</td>
									</tr>
									<tr>
										<th>GNB메뉴(노출) <span class="required">*</span></th>
										<td>
											<f:radiobuttons path="mnmnuDspyAt" items="${useAtCode}" class="form-control" element="div class='radio-custom radio-inline radio-primary'" />
										</td>
									</tr>
									<tr>
										<th>LNB메뉴(노출) <span class="required">*</span></th>
										<td>
											<f:radiobuttons path="sbmnuDspyAt" items="${useAtCode}" class="form-control" element="div class='radio-custom radio-inline radio-primary'" />
										</td>
									</tr>
									<tr>
										<th><a href="#" style="color:#666;" id="asideBtn">aside 설정 <i class="fa fa-question-circle"></i></a></th>
										<td>
											<f:checkboxes path="asideOpt" items="${asideOptTyCode}" cssStyle="vertical-align: top;" element="div class='checkbox-custom checkbox-default checkbox-inline checkbox-text-primary'" />
										</td>
									</tr>
									<tr>
										<th><a href="#" style="color:#666;" id="asideBtn">sitemap 노출</a></th>
										<td>
											<f:radiobuttons path="siteMapDspyAt" items="${useAtCode}" class="form-control" element="div class='radio-custom radio-inline radio-primary'" />
										</td>
									</tr>
									<tr>
										<th>코멘트 사용 <span class="required">*</span></th>
										<td>
											<f:radiobuttons path="cmUseAt" items="${useAtCode}" class="form-control" element="div class='radio-custom radio-inline radio-primary'" />
										</td>
									</tr>
									<tr>
										<th>만족도조사 사용 <span class="required">*</span></th>
										<td>
											<f:radiobuttons path="stsfdgUseAt" items="${useAtCode}" class="form-control" element="div class='radio-custom radio-inline radio-primary'" />
										</td>
									</tr>
									<tr>
										<th>메뉴담당자 사용 <span class="required">*</span></th>
										<td>
											<f:radiobuttons path="mnuChargerUseAt" items="${useAtCode}" class="form-control" element="div class='radio-custom radio-inline radio-primary'" />
										</td>
									</tr>
									<tr>
										<th>사용여부 <span class="required">*</span></th>
										<td>
											<f:radiobuttons path="useAt" items="${useAtCode}" class="form-control" element="div class='radio-custom radio-inline radio-primary'" />
											<!-- <span class="help-block">* '사용안함'를 선택한 경우 하위메뉴까지 일괄 적용됩니다.</span> -->
										</td>
									</tr>
								</table>
								
							</div>
						</div><!-- //panel -->
						
						
						<div class="panel panel-accordion">
							<div class="panel-heading">
								<h4 class="panel-title">
									<a class="accordion-toggle collapsed" data-toggle="collapse" href="#collapse2">
										<i class="fa fa-"></i> 담당자 정보
									</a>
								</h4>
							</div>
							<div id="collapse2" class="accordion-body collapse">
							
								<table class="table m-none">
									<colgroup>
										<col style="width:125px"/>
										<col />
									</colgroup>
									<tbody>
										<tr>
											<th>담당자</th>
											<td>
												<div class="form-inline">
													<f:input path="mnuChargerOrgnztNm" class="form-control" placeHolder="담당자 부서" style="width:140px;"/>
													<f:input path="mnuChargerNm" class="form-control" placeHolder="담당자" style="width:100px;"/>
													<f:input path="mnuChargerTelno" class="form-control" placeHolder="전화번호" style="width:120px;"/>
													<button class="btn btn-info" onclick="f_empSrch(); return false;">선택</button>
												</div>
											
											</td>
										</tr>
										<tr>
											<th>업데이트일</th>
											<td>
												<div class="row">
													<div class="col-md-4">
														<f:input path="mnuChargerUpdtDt" class="form-control" readonly="true" />
													</div>
												</div>
											</td>
										</tr>
									</tbody>
								</table>
								
							</div>
						</div><!-- //panel -->
						
						<div class="panel panel-accordion">
							<div class="panel-heading">
								<h4 class="panel-title">
									<a class="accordion-toggle collapsed" data-toggle="collapse" href="#collapse3">
										<i class="fa fa-"></i> 메뉴 연결 정보
									</a>
								</h4>
							</div>
							<div id="collapse3" class="accordion-body collapse">
							
								<table class="table m-none" id="mappedItemsTable">
									<colgroup>
										<col style="width:125px"/>
										<col />
									</colgroup>
									<tbody>
										<tr class="menu-ty2">
											<th>
												콘텐츠
											</th>
											<td>
												<button class="btn btn-info btn-search btn-sm" type="button" id="linkCntnts" onclick="f_find_relation_item('cntnts')" style="display: none;">콘텐츠 검색</button>
												<button class="btn btn-primary btn-sm" type="button" id="creatCntnts" onclick="f_create_relation_item('cntnts')" style="display: none;">콘텐츠 추가</button>

												<table class="table m-none mt-xs" id="mappedCntnts">
													<colgroup>
														<col />
														<col width="100"/>
													</colgroup>
<!-- 													<thead> -->
<!-- 														<tr> -->
<!-- 															<th>콘텐츠명</th> -->
<!-- 															<th>삭제</th> -->
<!-- 														</tr> -->
<!-- 													</thead> -->
													<tbody id="relation_post">
													<tr class="no_data">
														<td colspan="2">링크된 콘텐츠가 없습니다.</td>
													</tr>
													</tbody>
												</table>
											</td>
										</tr>
										<tr class="menu-ty3">
											<th>
												게시판
											</th>
											<td>
												<button class="btn btn-info btn-search btn-sm" type="button" id="linkBbs" onclick="f_find_relation_item('bbs')" style="display: none;">게시판 검색</button>
												<button class="btn btn-primary btn-sm" type="button" id="creatBbs" onclick="f_create_relation_item('bbs')" style="display: none;">게시판 생성</button>

												<table class="table m-none mt-xs" id="mappedBbs">
													<colgroup>
														<col />
														<col width="100"/>
													</colgroup>
<!-- 													<thead> -->
<!-- 														<tr> -->
<!-- 															<th>게시판명</th> -->
<!-- 															<th>삭제</th> -->
<!-- 														</tr> -->
<!-- 													</thead> -->
													<tbody id="relation_post">
													<tr class="no_data">
														<td colspan="2">링크된 게시판이 없습니다.</td>
													</tr>
													</tbody>
												</table>
											</td>
										</tr>
										<tr class="menu-ty4">
											<th>
												기능프로그램
											</th>
											<td>
												<button class="btn btn-info btn-search btn-sm" type="button" id="linkFnct" onclick="f_find_relation_item('fnct')" style="display: none;">기능프로그램 검색</button>
												<button class="btn btn-primary btn-sm" type="button" id="creatFnct" onclick="f_create_relation_item('fnct')" style="display: none;">기능프로그램 추가</button>

												<table class="table m-none mt-xs" id="mappedFnct">
													<colgroup>
														<col />
														<col width="100"/>
													</colgroup>
<!-- 													<thead> -->
<!-- 														<tr> -->
<!-- 															<th>기능프로그램명</th> -->
<!-- 															<th>삭제</th> -->
<!-- 														</tr> -->
<!-- 													</thead> -->
													<tbody id="relation_post">
													<tr class="no_data">
														<td colspan="2">링크된 기능프로그램이 없습니다.</td>
													</tr>
													</tbody>
												</table>
											</td>
										</tr>
									</tbody>
								</table>
								
							</div>
						</div><!-- //panel -->
						
						
						<div class="panel panel-accordion">
							<div class="panel-heading">
								<div class="panel-actions">
									<span class="btn btn-default btn-icon btn-xs mr-lg" onclick="f_mngrSearch();">
										<i class="fa fa-cogs"></i>선택
									</span>
								</div>
								<h4 class="panel-title">
									<a class="accordion-toggle collapsed" data-toggle="collapse" href="#collapse4">
										<i class="fa fa-"></i> 권한 설정
									</a>
								</h4>
							</div>
							<div id="collapse4" class="accordion-body collapse">
							
								<table class="table table-striped m-none" id="mngrMapngTable">
									<thead>
									<tr>
										<th>이름</th>
										<th>부서명</th>
										<th>*</th>
									</tr>
									</thead>
									<tbody>
									<tr class="emptyTr">
										<td colspan='3'>등록된 관리자가 없습니다.</td>
									</tr>
									</tbody>
								</table>
								
							</div>
						</div><!-- //panel -->
							
					</div>
<%--
						<section class="panel panel-featured">
							<header class="panel-heading">
								<h3 class="panel-title">메뉴 정보</h3>
							</header>
							<div class="panel-body p-none">
								
								<table class="table m-none">
									<colgroup>
										<col style="width:125" />
										<col />
									</colgroup>
									<tr>
										<th>상위메뉴 <span class="required">*</span></th>
										<td>
											<div class="form-inline">
											<f:input path="upperMenuNm" readonly="true" placeHolder="메뉴 선택" class="form-control"/>
											<button class="btn btn-default" type="button" onclick="f_menuSearch(); return false;" >선택</button>
											</div>
											<div></div>
										</td>
									</tr>
									<tr>
										<th>메뉴명 <span class="required">*</span></th>
										<td><f:input path="menuNm" class="form-control" maxlength="200" /></td>
									</tr>
									<tr>
										<th>유형 <span class="required">*</span></th>
										<td>
											<f:radiobuttons path="menuTy" items="${siteMenuTyCode}" class="form-control" element="div class='radio-custom radio-inline radio-primary'"/>
										</td>
									</tr>
		
									<tr class="menu-ty ty1" style="background-color:#fcf8e3;display:none;">
										<th>서브메인 사용 </th>
										<td>
											<f:radiobuttons path="subMainUseAt" items="${useAtCode}" class="form-control" element="div class='radio-custom radio-inline radio-primary'"/>
										</td>
									</tr>
									<tr class="menu-ty ty1-N" style="background-color:#fcf8e3;display:none;">
										<th>링크 정보</th>
										<td>
											<f:input path="linkUrl" class="form-control" placeholder="ex) http://" maxlength="250" />
										</td>
									</tr>
									<tr class="menu-ty ty1-N" style="background-color:#fcf8e3;display:none;">
										<th>링크 타겟</th>
										<td>
											<f:radiobuttons path="linkTrgt" items="${linkTrgtTyCode}" class="form-control" element="div class='radio-custom radio-inline radio-primary'" />
										</td>
									</tr>
		
									<tr class="menu-ty ty2" style="background-color:#fcf8e3;display:none;">
										<th><a href="#" style="color:#666;" rel="popover" data-placement="left" data-content="콘텐츠의 노출 형태 입니다.">콘텐츠 목록 형식</a></th>
										<td>
											<f:radiobuttons path="postListTy" items="${postListTyCode}" class="form-control" element="div class='radio-custom radio-inline radio-primary'" />
										</td>
									</tr>
		
									<tr>
										<th>URI <span class="required">*</span></th>
										<td>
											<div class="form-inline">
											<f:input path="menuUri" class="form-control" mexlength="20" />
											<button class="btn btn-info"  onclick="f_duplCheck(); return false;">중복확인</button>
											</div>
											<span class="help-block">
												http://${siteVO.siteUrl}<c:if test="${siteVO.firstUriDivYn eq 'Y'}">/${siteVO.firstUri }</c:if>/<b id="preview_uri"></b>
											</span>
										</td>
									</tr>
									<tr>
										<th>메뉴순서</th>
										<td>
											<div class="row"><div class="col-sm-2">
											<f:input path="sortNo" class="form-control" mexlength="2" />
											</div></div>
										</td>
									</tr>
									<tr>
										<th>GNB메뉴(노출) <span class="required">*</span></th>
										<td>
											<f:radiobuttons path="mnmnuDspyAt" items="${useAtCode}" class="form-control" element="div class='radio-custom radio-inline radio-primary'" />
										</td>
									</tr>
									<tr>
										<th>LNB메뉴(노출) <span class="required">*</span></th>
										<td>
											<f:radiobuttons path="sbmnuDspyAt" items="${useAtCode}" class="form-control" element="div class='radio-custom radio-inline radio-primary'" />
										</td>
									</tr>
									<tr>
										<th><a href="#" style="color:#666;" id="asideBtn">aside 설정 <i class="icon-question-sign"></i></a></th>
										<td>
											<f:checkboxes path="asideOpt" items="${asideOptTyCode}" cssStyle="vertical-align: top;" element="div class='checkbox-custom checkbox-default checkbox-inline checkbox-text-primary'" />
										</td>
									</tr>
									<tr>
										<th>코멘트 사용 <span class="required">*</span></th>
										<td>
											<f:radiobuttons path="cmUseAt" items="${useAtCode}" class="form-control" element="div class='radio-custom radio-inline radio-primary'" />
										</td>
									</tr>
									<tr>
										<th>만족도조사 사용 <span class="required">*</span></th>
										<td>
											<f:radiobuttons path="stsfdgUseAt" items="${useAtCode}" class="form-control" element="div class='radio-custom radio-inline radio-primary'" />
										</td>
									</tr>
									<tr>
										<th>메뉴담당자 사용 <span class="required">*</span></th>
										<td>
											<f:radiobuttons path="mnuChargerUseAt" items="${useAtCode}" class="form-control" element="div class='radio-custom radio-inline radio-primary'" />
										</td>
									</tr>
									<tr>
										<th>사용여부 <span class="required">*</span></th>
										<td>
											<f:radiobuttons path="useAt" items="${useAtCode}" class="form-control" element="div class='radio-custom radio-inline radio-primary'" />
											<!-- <span class="help-block">* '사용안함'를 선택한 경우 하위메뉴까지 일괄 적용됩니다.</span> -->
										</td>
									</tr>
								</table>
								
							</div>
						</section>
						
						<!-- 담당자 정보 서브섹션 -->
						<section class="panel panel-featured">
							<header class="panel-heading" data-toggle="collapse" data-target="#collapseMnuCharger">
								<div class="panel-actions">
									<a href="#collapseMnuCharger" class="panel-action panel-action-toggle" data-toggle="collapse"></a>
								</div>
								<h3 class="panel-title">담당자 정보</h3>
							</header>
							<div class="panel-body p-none collapse" id="collapseMnuCharger">
								<table class="table m-none">
									<colgroup>
										<col style="width:125"/>
										<col />
									</colgroup>
									<tbody>
										<tr>
											<th>담당자</th>
											<td>
												<div class="row m-none">
													<div class="col-md-2 p-none">
														<f:input path="mnuChargerOrgnztNm" class="form-control" placeHolder="담당자 부서" />
													</div>
													<div class="col-md-2 p-none">
														<f:input path="mnuChargerNm" class="form-control" placeHolder="담당자" />
													</div>
													<div class="col-md-2 p-none">
														<f:input path="mnuChargerTelno" class="form-control" placeHolder="전화번호"/>
													</div>
													<div class="col-md-3 p-none">
														<button class="btn btn-info" onclick="f_empSrch(); return false;">담당자 선택</button>
													</div>
												</div>
											
											</td>
										</tr>
										<tr>
											<th>업데이트일</th>
											<td>
												<div class="row">
													<div class="col-md-4">
														<f:input path="mnuChargerUpdtDt" class="form-control" readonly="true" />
													</div>
												</div>
											</td>
										</tr>
									</tbody>
								</table>
							</div>
						</section>
					
						<!-- 메뉴 연결 서브섹션 -->
						<section class="panel panel-featured">
							<header class="panel-heading" data-toggle="collapse" data-target="#collapseMappedItems">
								<div class="panel-actions">
									<a href="#collapseMappedItems" class="panel-action panel-action-toggle" data-toggle="collapse"></a>
								</div>
								<h3 class="panel-title">메뉴 연결 정보</h3>
							</header>
							<div class="panel-body p-none collapse" id="collapseMappedItems">
								<table class="table" id="mappedItemsTable">
									<colgroup>
										<col style="width:90"/>
										<col />
									</colgroup>
									<tbody>
										<tr class="menu-ty2">
											<th>
												콘텐츠
											</th>
											<td>
												<button class="btn btn-info btn-search btn-sm" type="button" id="linkCntnts" onclick="f_find_relation_item('cntnts')" style="display: none;">콘텐츠 검색</button>
												<button class="btn btn-primary btn-sm" type="button" id="creatCntnts" onclick="f_create_relation_item('cntnts')" style="display: none;">콘텐츠 추가</button>

												<table class="table m-none mt-xs" id="mappedCntnts">
													<colgroup>
														<col />
														<col width="100"/>
													</colgroup>
<!-- 													<thead> -->
<!-- 														<tr> -->
<!-- 															<th>콘텐츠명</th> -->
<!-- 															<th>삭제</th> -->
<!-- 														</tr> -->
<!-- 													</thead> -->
													<tbody id="relation_post">
													<tr class="no_data">
														<td colspan="2">링크된 콘텐츠가 없습니다.</td>
													</tr>
													</tbody>
												</table>
											</td>
										</tr>
										<tr class="menu-ty3">
											<th>
												게시판
											</th>
											<td>
												<button class="btn btn-info btn-search btn-sm" type="button" id="linkBbs" onclick="f_find_relation_item('bbs')" style="display: none;">게시판 검색</button>
												<button class="btn btn-primary btn-sm" type="button" id="creatBbs" onclick="f_create_relation_item('bbs')" style="display: none;">게시판 생성</button>

												<table class="table m-none mt-xs" id="mappedBbs">
													<colgroup>
														<col />
														<col width="100"/>
													</colgroup>
<!-- 													<thead> -->
<!-- 														<tr> -->
<!-- 															<th>게시판명</th> -->
<!-- 															<th>삭제</th> -->
<!-- 														</tr> -->
<!-- 													</thead> -->
													<tbody id="relation_post">
													<tr class="no_data">
														<td colspan="2">링크된 게시판이 없습니다.</td>
													</tr>
													</tbody>
												</table>
											</td>
										</tr>
										<tr class="menu-ty4">
											<th>
												기능프로그램
											</th>
											<td>
												<button class="btn btn-info btn-search btn-sm" type="button" id="linkFnct" onclick="f_find_relation_item('fnct')" style="display: none;">기능프로그램 검색</button>
												<button class="btn btn-primary btn-sm" type="button" id="creatFnct" onclick="f_create_relation_item('fnct')" style="display: none;">기능프로그램 추가</button>

												<table class="table m-none mt-xs" id="mappedFnct">
													<colgroup>
														<col />
														<col width="100"/>
													</colgroup>
<!-- 													<thead> -->
<!-- 														<tr> -->
<!-- 															<th>기능프로그램명</th> -->
<!-- 															<th>삭제</th> -->
<!-- 														</tr> -->
<!-- 													</thead> -->
													<tbody id="relation_post">
													<tr class="no_data">
														<td colspan="2">링크된 기능프로그램이 없습니다.</td>
													</tr>
													</tbody>
												</table>
											</td>
										</tr>
									</tbody>
								</table>
							</div>
						</section>
					
						<!-- 메뉴 관리자 서브섹션 -->
						<section class="panel panel-featured">
							<header class="panel-heading" data-toggle="collapse" data-target="#collapseMnuMngr">
								<div class="panel-actions">
									<a href="#" class="panel-action" onclick="f_mngrSearch(); return false;"><i class="fa fa-cogs"></i> 관리자 선택</a>
									<a href="#collapseMnuMngr" class="panel-action panel-action-toggle" data-toggle="collapse"></a>
								</div>
								<h3 class="panel-title">권한 설정</h3>
							</header>
							<div class="panel-body p-none collapse" id="collapseMnuMngr">
								<table class="table m-none" id="mngrMapngTable">
									<tr class="emptyTr">
										<td>등록된 관리자가 없습니다.</td>
									</tr>
									</tbody>
								</table>
							</div>
						</section>
--%>
					</div>
					
					<footer class="panel-footer">
						<div class="row">
							<div class="col-sm-6">
								<c:set var="pageParam" value="curPage=${param.curPage }&amp;searchKey=${param.searchKey}&amp;searchText=${param.searchText}" />
								<a href="/admin/site/list?${pageParam}" class="btn btn-default">목록</a>
							</div>
							<div class="col-sm-6 text-right">
                                <button class="btn btn-primary">저장</button>
                                <button class="btn btn-danger" id="delBtn" onclick="f_Delete(); return false" style="display:none;">삭제</button>
							</div>
						</div>
					</footer>
					
					</f:form><!--//frmSiteMenu -->
					
				</section>
				</div>

			</div>


			<!-- hidden target -->
			<iframe id="hiddenFrame" name="hiddenFrame" style="display:none;"></iframe>
