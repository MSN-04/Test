<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ include file="/common/taglibs.jsp" %>
	<style type="text/css">
	#selectOutptList option{ height:21px; margin:5px 5px 4px 5px; }
	#sortable { list-style-type: none; margin: 0; padding: 0; width: 90%; }
	#sortable li { margin: 1px; padding: 1px; border: 1px solid #cccccc; color: #0088cc; background: #eeeeee; }
	#sortable li span { position: absolute; margin-left: -1.3em; }
	#sortable li input { padding:0; font-size:12px; height:18px; }
	</style>

	<!-- Tag Editor -->
	<script type="text/javascript" src="${globalAdminAssets}/javascripts/plugins/tag-editor/jquery.caret.min.js"></script>
    <script type="text/javascript" src="${globalAdminAssets}/javascripts/plugins/tag-editor/jquery.tag-editor.min.js"></script>
    <link rel="stylesheet" type="text/css" href="${globalAdminAssets}/stylesheets/plugins/tag-editor/jquery.tag-editor.css">

    <!-- Smart Editor -->
    <script type="text/javascript" src="${globalAdminAssets}/smarteditor/js/HuskyEZCreator.js" charset="utf-8"></script>

    <!-- spectrum-colorPicker -->
    <link rel="stylesheet" type="text/css" href="${globalAdminAssets}/stylesheets/plugins/colorpicker/spectrum.css">
    <script type="text/javascript" src="${globalAdminAssets}/javascripts/plugins/colorpicker/spectrum.js"></script>

	<script type="text/javascript">
	function f_ctgryAdd() {
		if( $("#ctgryNm").val() == "" ) {
			alert("카테고리명을 입력하여 주십시요");
			$("#ctgryNm").focus();
			return false;
		}
		if( $("#ctgryValue").val() == "" ) {
			var optLength = $("#ctgry > option").length;
			var text = $("#ctgryNm").val();
			$("#ctgry").append( new Option( text , "C-" + (optLength + 1), false, false  ) );

		} else {
			var selectValue = $("#ctgryValue").val();
			var values = selectValue.split("-");
			$("#ctgry option").each(function(){
				if($(this).val() == selectValue) {
					$(this).text( $("#ctgryNm").val() );
					$(this).val( "U-" + values[1]);
				}
			});
			$("#ctgryValue").val("");
		}
		$("#ctgryNm").val("");
	}
	function f_ctgryMod() {
		var option = $("#ctgry option:selected");
		if( option.length != 1 ) {
			alert("수정할 항목을 하나만 선택하여 주십시요");
			return;
		}
		$("#ctgryNm").val(option.text());
		$("#ctgryValue").val(option.val());
	}
	function f_ctgryRemove() {
		$("#ctgry option:selected").each(function(){
			var values = $(this).val().split("-");
			if( "C" == values[0]) {
				$(this).remove();
				return;
			} else {
				var html = getCtgryForm( "D-" + values[1], $(this).text() );
				$("#frmBbsSt").append( html );
				$(this).remove();
			}
		});
	}
	function getCtgryForm(value, text) {
		var html  = "<input type='hidden' name='ctgryValues' value='" + value  + "' />";
    		html += "<input type='hidden' name='ctgryTexts'  value='" + text + "' />";
    	return html;
	}


	$(document).ready(function(){
//		$("#groupBbsTable").selectRow({
//			classname : 'grey'
//		});

		smEditor.init("bbsInfo");
		smEditor.init("indvdlinfoColctAgreWords");
		f_SetupBoard();

		$('#bdtPrhibtWrd, #ncnmPrhibtWrd').tagEditor({
			delimiter : '|'
			, placeholder: '금지어를 입력하세요'
			/*
            , onChange : function(field, editor, tags){
            	alert("filed="+field+"\neditor="+editor+"\ntags="+tags);
            }

			, beforeTagSave: function(field, editor, tags, tag, val) {
				alert("filed="+field+"\neditor="+editor+"\ntags="+tags+"\ntag="+tag+"\nval="+val);
			}
			*/
		});

		$('#intrcpIp, #permIp').tagEditor({
			delimiter : '|'
			, placeholder: '아이피를 입력하세요'
				, beforeTagSave: function(field, editor, tags, tag, val) {
					var ipRegExp = /\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b/;
					if(!val.match(ipRegExp)) {
						alert("IP 형식에 맞추어 입력해 주세요.");
						return false;
					}
				}
		});

		$("#hideAfterPaletteSelect").spectrum({
		    showPaletteOnly: true,
		    showPalette:true,
		    hideAfterPaletteSelect:true,
		    color: '<c:out value="${bbsSettingVO.popularNttColor}"/>',
		    palette: [["#ff0000", "#ff8000", "#ffff00", "#008000", "#0000ff", "#3f0099"]],
		    change: function(color) {
		        	$(".pop-ntt-font").css("color", color.toHexString());
		    }
		});

		/*
		$("label[for=" + $("input[name=newNttImageUseAt]").eq(0).attr("id") + "]").html(
				$("label[for=" + $("input[name=newNttImageUseAt]").eq(0).attr("id") + "]").text()
				+ "(<img src='${globalAdminAssets}/img/icon/icon_new.png' width='30' height='30' alt='기본이미지'/>)"
				);
		*/

		for(var row = 1; row <= $("#etcTotalRow").val(); row++){
			$(".etc_field" + row).show();
			f_showDataInput(row);
		}

		<c:if test="${bbsSettingVO.crud eq 'UPDATE'}">
			load_menugroupdata();
		</c:if>
	});

	//메뉴연결>삭제버튼
	$(document).on("click", "#mnMapngTable .delBtn", function(){
		$(this).parents("tr").fadeOut(300, function(){$(this).remove();});
	});
	//메뉴검색
	function f_menuSrch(){
		window.open("/admin/site/menu/popup/srchMenuList?srchMenuTy=3", "popMenuList", "width=900, height=605");
	}

	$(function(){

		$('[rel="tooltip"]').tooltip();

		$("#frmBbsSt input[type=text]").keydown(function (key) {
	        if(key.keyCode == 13)
	            return false;
	    });

		//카테고리 사용 여부
		$("input[name='ctgryUseAt']").on("click", function(){
			if($("input[name='ctgryUseAt']:checked").val() == "Y"){
				$(".ctgry-use-at-div").slideDown("fast").removeClass("hidden");
			}else{
				$(".ctgry-use-at-div").slideUp("fast", function(){
					$(this).addClass("hidden");
				});
			}
		});

		//첨부파일 사용 여부
		$("input[name='atchmnflAt']").on("click", function(){
			if($("input[name='atchmnflAt']:checked").val() == "Y"){
				$(".atch-div").slideDown("fast").removeClass("hidden");
			}else{
				$(".atch-div").slideUp("fast", function(){
					$(this).addClass("hidden");
				});
			}
		});

		//개인정보 수집 이용동의 사용 여부
		$("input[name='indvdlinfoColctAgreAt']").on("click", function(){
			//smEditor.autoWidth("indvdlinfoColctAgreWords");
			if($("input[name='indvdlinfoColctAgreAt']:checked").val() == "Y"){
				$(".indvdlinfo-div").slideDown("fast").removeClass("hidden");
			}else{
				$(".indvdlinfo-div").slideUp("fast", function(){
					$(this).addClass("hidden");
				});
			}
		});

		//기타항목 사용 여부
		$("input[name='etcIemAt']").on("click", function(){
			if($("input[name='etcIemAt']:checked").val() == "Y"){
				$("#etcSettingArea, .etcIem-button").show();
				if($("#etcTotalRow").val() > 0){
					$(".etcIem-div").show();
				}
			}else{
				$("#etcSettingArea, .etcIem-div, .etcIem-button").hide();
			}
		});

		// 신규 게시물 이미지 사용 여부
		$("input[name='newNttImageUseAt']").on("click", function(){
			if($("input[name='newNttImageUseAt']:checked").val() == "Y"){
				$(".ntt-img-div-new").removeClass("hidden");
				$(".ntt-img-div").slideDown("fast").removeClass("hidden");
			}
			else if($("input[name='newNttImageUseAt']:checked").val() == "D"){
				$(".ntt-img-div-new").addClass("hidden");
				$(".ntt-img-div").slideDown("fast").removeClass("hidden");
			}
			else{
				$(".ntt-img-div").slideUp("fast", function(){
					$(this).addClass("hidden");
				});
			}
		});

		// 인기 게시물 사용 여부
		$("input[name='popularNttUseAt']").on("click", function(){
			if($("input[name='popularNttUseAt']:checked").val() == "Y"){
				$(".pop-ntt-div").slideDown("fast").removeClass("hidden");
			}else{
				$(".pop-ntt-div").slideUp("fast", function(){
					$(this).addClass("hidden");
				});
			}
		});

		//게시글 복사 사용여부
		$("input[name='bbsCopyAt']").on("click", function(){
			if($("input[name='bbsCopyAt']:checked").val() == "Y"){
				$(".show_bbs_copy_view").slideDown("fast").removeClass("hidden");
			}else{
				$(".show_bbs_copy_view").slideUp("fast", function(){
					$(this).addClass("hidden");
				});
			}
		});
		/*
		// 통합게시판 사용 여부
 		$("input[name='unityBbsUseAt']").on("click", function(){
			if($("input[name='unityBbsUseAt']:checked").val() == "Y"){
				$("#unityBbsSiteTy").removeClass("hidden");
			}else{
				$("#unityBbsSiteTy").addClass("hidden");
			}
		});

		// 그룹게시판 사용 여부
		$("input[name='groupBbsUseAt']").on("click", function(){
			if($("input[name='groupBbsUseAt']:checked").val() == "Y"){
				$(".group-bbs-div").slideDown("fast").removeClass("hidden");
			}
			else{
				$(".group-bbs-div").slideUp("fast", function(){
					$(this).addClass("hidden");
				});
			}
		}); */

		if($("input[name='groupBbsUseAt']:checked").val() == "Y"){
			$(".group-bbs-div").removeClass("hidden");
		}

		if($("input[name='atchmnflAt']:checked").val() == "Y"){
			$(".atch-div").removeClass("hidden");
		}

		if($("input[name='ctgryUseAt']:checked").val() == "Y"){
			$(".ctgry-use-at-div").removeClass("hidden");
		}

		if($("input[name='bbsCopyAt']:checked").val() == "Y"){
			$(".show_bbs_copy_view").removeClass("hidden");
		}

		if($("input[name='indvdlinfoColctAgreAt']:checked").val() == "Y"){
			$(".indvdlinfo-div").removeClass("hidden");
		}

		if($("input[name='etcIemAt']:checked").val() == "Y"){
			$(".etcIem-button").show();
			if($("#etcTotalRow").val() > 0){
				$(".etcIem-div").show();
			}
		}

		if($("input[name='unityBbsUseAt']:checked").val() == "Y"){
			$("#unityBbsSiteTy").removeClass("hidden");
		}

		// 신규 게시물 이미지 사용여부
		if($("input[name='newNttImageUseAt']:checked").val() == "Y"){
			$(".ntt-img-div").removeClass("hidden");
			<c:if test="${fn:length(bbsSettingVO.nttNewImgFileList) > 0 }">
			<c:set var="nttImgFile" value="${bbsSettingVO.nttNewImgFileList[0]}" />

			$("label[for=" + $("input[name=newNttImageUseAt]").eq(1).attr("id") + "]").html(
					$("label[for=" + $("input[name=newNttImageUseAt]").eq(1).attr("id") + "]").text() +
					"(<img src='/comm/getImage?srvcId=${nttImgFile.srvcId }&amp;upperNo=${nttImgFile.upperNo }&amp;fileTy=${nttImgFile.fileTy }&amp;fileNo=${nttImgFile.fileNo }' width='30' height='30' alt='신규이미지'/>)"
					)
			</c:if>
		}
		else if($("input[name='newNttImageUseAt']:checked").val() == "D"){
			$(".ntt-img-div-new").addClass("hidden");
			$(".ntt-img-div").removeClass("hidden");
		}

		if($("input[name='popularNttUseAt']:checked").val() == "Y"){
			$(".pop-ntt-div").removeClass("hidden");
		}

		$("input[name='bbsTy']").on("change", function(){
			if(this.value == "3" || this.value == "4"){
				$("#nttListOutptCo").html("<c:forEach begin='6' end='30' step='6' var='value'><option value='${value}'>${value}</option></c:forEach>");
			}
			else{
				$("#nttListOutptCo").html("<c:forEach begin='10' end='50' step='10' var='value'><option value='${value}'>${value}</option></c:forEach>");
			}
			$("#groupBbsNo option").each(function () {$(this).remove();});//그룹게시판 초기화
		});

	})

		function f_SetupBoard(){
			<c:choose>
				<c:when test="${bbsSettingVO.crud eq 'CREATE' }">
			var bbsTy = $(':radio[name="bbsTy"]:checked').val();
			$('input:radio[name="openAt"]:input[value="N"]').attr("checked", true);
			$("#typeVIewImg > td > div").html("<img src=\"${globalAdminAssets}/images/bbstype/"+bbsTy+".PNG\" style=\"width:100%;border:3px solid gray; float:right;\">");
				</c:when>
				<c:otherwise>
			var bbsTy = $('#bbsTy').val();
				</c:otherwise>
			</c:choose>


			switch(bbsTy) {
				case "2"://답글형
					f_ReplyBbsAuth("Y");
					f_QnaBbsAuth("N");
					f_FaqBbsAuth("N");
					f_ThumbAuth("Y");
					f_HashTagAuth("Y");
					f_RecomendOppsAuth("Y");
					$("input[name='openAt']").attr("disabled", false);
				break;

				case "3"://이미지형
					f_ReplyBbsAuth("N");
					f_QnaBbsAuth("N");
					f_FaqBbsAuth("N");
					f_ThumbAuth("N");
					f_HashTagAuth("Y");
					f_RecomendOppsAuth("Y");
					$("input[name='openAt']").attr("disabled", true);
				break;

				case "4"://동영상
					f_ReplyBbsAuth("N");
					f_QnaBbsAuth("N");
					f_FaqBbsAuth("N");
					f_ThumbAuth("N");
					f_HashTagAuth("Y");
					f_RecomendOppsAuth("Y");
					$("input[name='openAt']").attr("disabled", true);
				break;

				case "5"://Q&A
					f_ReplyBbsAuth("Q");
					f_QnaBbsAuth("Y");
					f_FaqBbsAuth("N");
					f_ThumbAuth("N");
					f_HashTagAuth("N");
					$("input[name='openAt']").attr("disabled", false);
				break;

				case "6"://FAQ
					f_ReplyBbsAuth("N");
					f_QnaBbsAuth("N");
					f_FaqBbsAuth("Y");
					f_ThumbAuth("N");
					f_HashTagAuth("N");
					f_RecomendOppsAuth("Y");
					$("input[name='openAt']").attr("disabled", true);
				break;

				case "7"://일정형
					f_ReplyBbsAuth("N");
					f_QnaBbsAuth("N");
					f_FaqBbsAuth("Y");
					f_ThumbAuth("N");
					f_HashTagAuth("Y");
					f_RecomendOppsAuth("Y");
					$("input[name='openAt']").attr("disabled", true);
				break;

				case "8"://링크형
					f_ReplyBbsAuth("N");
					f_QnaBbsAuth("N");
					f_FaqBbsAuth("N");
					f_ThumbAuth("N");
					f_HashTagAuth("N");
					f_RecomendOppsAuth("N");
					$("input[name='openAt']").attr("disabled", true);
					$('input:radio[name="editrUseAt"]:input[value="N"]').attr("checked", true);
				break;

				default:
					f_ReplyBbsAuth("N");
					f_QnaBbsAuth("N");
					f_FaqBbsAuth("N");
					f_ThumbAuth("Y");
					f_HashTagAuth("Y");
					f_RecomendOppsAuth("Y");
					$("input[name='openAt']").attr("disabled", false);
				break;
			}

			fn_bbs_copy_ajax(bbsTy);
		}

		function fn_bbs_copy_ajax(){
			var bbsNo = null;
			<c:choose>
				<c:when test="${bbsSettingVO.crud eq 'CREATE' }">
			var bbsTy = $(':radio[name="bbsTy"]:checked').val();
				</c:when>
				<c:otherwise>
			var bbsTy = $('#bbsTy').val();
			var bbsNo = $('#bbsNo').val();
				</c:otherwise>
			</c:choose>
			$("#group_id").find("option").remove();

			$.ajax({
				   url : "/admin/ajax/loadBbsList.json"
				   , data : {
					   searchBbsName : $("#search_bbs_name").val(),
					   bbsTy : bbsTy,
					   bbsNo : bbsNo
					   }
				   , type : "POST"
				   , dataType : "json"
				   , contentType: "application/x-www-form-urlencoded; charset=UTF-8"
				   , async : false
				   , success : function(data) {
					  // console.log(data);
					   data = data.result;
					   if(data.length)
					   {
						   for(var i=0; i<data.length; i++)
							{
							   $("#group_id").append("<option value='" + data[i].bbsNo + "'>"+ data[i].bbsSj +"</option>");
							}
					   }
		    		},
					error: function(data, status, err) {
						console.log('error forward : ' + data);
					},
					complete : function(data) {
					// $("#group_id").focus();
					}
			});
		}

		function load_menugroupdata()
		{
			<c:choose>
				<c:when test="${bbsSettingVO.crud eq 'CREATE' }">
					var bbsTy = $(':radio[name="bbsTy"]:checked').val();
				</c:when>
				<c:otherwise>
					var bbsTy = $('#bbsTy').val();
				</c:otherwise>
			</c:choose>

			$("#menu_group_id").find("option").remove();

			$.ajax({
				   url : "/admin/ajax/loadBbsGroupList.json"
				   , data : {
					   bbsNo : $('#bbsNo').val(),
					   bbsTy : bbsTy,
					   }
				   , type : "POST"
				   , dataType : "json"
				   , contentType: "application/x-www-form-urlencoded; charset=UTF-8"
				   , async : false
				   , success : function(data) {
					   //console.log(data);
					   data = data.result;
					   if(data.length)
					   {
						   for(var i=0; i<data.length; i++)
							{
							   $("#menu_group_id").append("<option value='" + data[i].bbsNo + "'>"+ data[i].bbsSj +"</option>");
							}
					   }

		    		},
					error: function(data, status, err) {
						console.log('error forward : ' + data);
					},
					complete : function(data) {
					//	$("#menu_group_id").focus();
					}

			});
		}

		function add_group_option()
		{

			if($("#group_id").val())
			{
				var v = $("#group_id option:selected").val();
				var t = $("#group_id option:selected").text();

				var cnt = 0;

				//console.log(v + "/" + t);
				$("#menu_group_id").find("option").each(function(){
					if(this.value== v){
						alert("해당 게시판은 이미 추가되어 있습니다.");
						cnt++;
					}else{

					}
				});

				if(cnt > 0){

				}else{
					$("#menu_group_id").append("<option value='" + v + "'>"+ t +"</option>");

					$("#group_id option:selected").remove();
				}

			}
		}

		function del_group_option()
		{
			if($("#menu_group_id").val())
			{
				var v = $("#menu_group_id option:selected").val();
				var t = $("#menu_group_id option:selected").text();

				//console.log(v + "/" + t);

				var cnt = 0;

				$("#group_id").find("option").each(function(){
					if(this.value== v){
						cnt++;
					}else{

					}
				});

				if(cnt > 0){
					$("#menu_group_id option:selected").remove();
				}else{
					$("#group_id").append("<option value='" + v + "'>"+ t +"</option>");

					$("#menu_group_id option:selected").remove();
				}

			}
		}

		function f_save(){
			if( $("#bbsSj").val() == "") {
				alert("게시판 제목을 입력하여 주십시요");
				$("#bbsSj").focus();
				return;
			}

			if( $("#bbsSknTy").val() == "") {
				alert("게시판스킨경로를 입력하여 주십시요");
				$("#bbsSknTy").focus();
				return;
			}

			$("#ctgry option").each(function(){
				var ctgryValue 	= $(this).val();
				var ctgryText 	= $(this).text();
				var html = getCtgryForm(ctgryValue, ctgryText);
				$("#frmBbsSt").append( html );
			});

			var atchAt = $(':radio[name="atchmnflAt"]:checked').val();
			if( atchAt == 'Y' ) {
				if( $("#atchmnflCo").val() == "" || $("#atchmnflCo").val() < 1 ) {
					alert("첨부파일 갯수를 입력하여 주십시요");
					$("#atchmnflCo").focus();
					return;
				}
			}
			var bbsCopyAt = $(':radio[name="bbsCopyAt"]:checked').val();
			if(bbsCopyAt == 'Y'){
				$("#menu_group_id").attr('multiple', 'multiple');
				$("#menu_group_id > option").attr("selected", "selected");
	    		// console.log('menu_group_id > ' + $("#menu_group_id").val());
	    		// var menu_group_id = $.map($('#menu_group_id option'), function(e) { return e.value; });
	    		// menu_group_id.join(',');

	    		if($("#menu_group_id").val() == null || $("#menu_group_id").val() == ""){
	    		// if(menu_group_id == null || menu_group_id == ""){
					alert("게시글 복사할 게시판을 선택해주세요.");
					return;
				}
	    		$("#menu_group_id > option").attr("selected", true);
	    	}

			/* 기타항목 사용일 경우 체크 */
			if($(":input:radio[name=etcIemAt]:checked").val() == "Y"){

				/* 기타항목 갯수만큼 체크 */
				for(var row = 1; row <= $("#etcTotalRow").val(); row++){

					/* 기타항목 사용 여부 체크 */
					if($(":input:radio[name=etcIemUseAt" + row + "]:checked").val() == "Y"){

						/* 기타항목명 입력 체크 */
						if( $.trim($("#etcIemNm" + row).val()) == "" ){
							alert("기타" + row + "의 기타항목명을 입력해 주세요.");
							return;
						}

						/* 기타항목 사용 여부 체크 */
						if(!$("input:radio[name='etcIemUseAt" + row + "']").is(":checked")){
							alert("기타" + row + "의 사용여부를 선택해 주세요.");
							return;
						}

						/* 기타항목 데이터 입력 형식 체크 */
						if(!$("input:radio[name='dataInputTy" + row + "']").is(":checked")){
							alert("기타" + row + "의 데이터 입력 형식을 선택해 주세요.");
							return;
						}

						/* 기타항목 데이터 보기 항목 체크 */
						var checkValue = $("input[name='dataInputTy" + row + "']:checked").val();
						if(checkValue == "select" || checkValue == "radio" || checkValue == "checkbox"){
							if($("#etcItem" + row +" > option").length == 0){
								alert("기타" + row + "의 데이터 보기 항목을\n1개 이상 입력해 주세요.");
								return;
							}
						}
					}
				}

				/* 기타항목 hidden폼 변환 */
				for(var row = 1; row <= $("#etcTotalRow").val(); row++){

					/* 기타항목 사용 여부 체크 */
					if($(":input:radio[name=etcIemUseAt" + row + "]:checked").val() == "Y"){
						$("#etcItem" + row + " option").each(function(){
							var etcItemValue 	= $(this).val();
							var etcItemText 	= $(this).text();
							var html = getEtcItemForm(etcItemValue, etcItemText, row);
							$("#frmBbsSt").append( html );
						});
					}
				}
			}

			// 에디터 값 적용
			smEditor.submit("bbsInfo");
			smEditor.submit("indvdlinfoColctAgreWords");

			//색상 적용
			$("#popularNttColor").val($("#hideAfterPaletteSelect").spectrum("get").toHexString());
			document.frmBbsSt.submit();
		}

		function f_RecomendOppsAuth(authStatus) {
			if(authStatus == "Y") {
				$('#recomendOppsAt_tr').removeClass('hidden');
			} else {
				$('#recomendOppsAt_tr').addClass('hidden');
			}
		}

		function f_HashTagAuth(authStatus) {
			if(authStatus == "Y") {
				$('#hashTagAt_tr').removeClass('hidden');
			} else {
				$('#hashTagAt_tr').addClass('hidden');
			}
		}

		function f_ThumbAuth(authStatus) {
			if(authStatus == "Y") {
				$('#thumbAt_tr').removeClass('hidden');
			} else {
				$('#thumbAt_tr').addClass('hidden');
			}
		}

		function f_ReplyBbsAuth(authStatus){
			if(authStatus == "Y"){
				$(".author_reply input").each(function(){
					$(this).removeAttr("disabled");
					$(this).parent().parent('div').removeClass("disabled");
				});

			} else if(authStatus == "Q"){
				$(".author_reply input").each(function(index, item){

					if(index == 0){
						$(this).removeAttr("disabled");
						$(this).parent().parent('div').removeClass("disabled");
					}else{
						$(this).attr("disabled", "true");
						$(this).parent().parent('div').addClass("disabled");
					}

				});

			} else {
				$(".author_reply input").each(function(){
					$(this).attr("disabled", "true");
					$(this).parent().parent('div').addClass("disabled");
				});
			}
		}

		function f_QnaBbsAuth(authStatus){
			if(authStatus == "Y"){
				$("input:checkbox[name='mngrAuthor']:input[value='_writing']").attr("disabled", true);
				$("input:checkbox[name='mngrAuthor']:input[value='_writing']").parent().parent('div').addClass("disabled");

			} else {
				$("input:checkbox[name='mngrAuthor']:input[value='_writing']").removeAttr("disabled", true);
				$("input:checkbox[name='mngrAuthor']:input[value='_writing']").parent().parent('div').removeClass("disabled");
			}
		}

		function f_FaqBbsAuth(authStatus){
			if(authStatus == "Y"){
				$("input:checkbox[name='mberAuthor']:input[value='_writing']").attr("disabled", true);
				$("input:checkbox[name='mberAuthor']:input[value='_writing']").parent().parent('div').addClass("disabled");
				$("input:checkbox[name='nmbrAuthor']:input[value='_writing']").attr("disabled", true);
				$("input:checkbox[name='nmbrAuthor']:input[value='_writing']").parent().parent('div').addClass("disabled");

			} else {
				$("input:checkbox[name='mberAuthor']:input[value='_writing']").removeAttr("disabled", true);
				$("input:checkbox[name='mberAuthor']:input[value='_writing']").parent().parent('div').removeClass("disabled");
				$("input:checkbox[name='nmbrAuthor']:input[value='_writing']").removeAttr("disabled", true);
				$("input:checkbox[name='nmbrAuthor']:input[value='_writing']").parent().parent('div').removeClass("disabled");
			}
		}

		/* 기타 세부 항목 사용, 사용안함  */
		function f_showDataInput(row) {
			var etcFieldInput = $("input[name='etcIemUseAt" + row + "']:checked").val();
			if( etcFieldInput == "Y" ) {
				$(".etc_field_idx"+ row + " th").first().attr("rowspan", "3");
				$(".etc_input" + row + ":eq(0), .etc_input" + row + ":eq(1)").show();
				f_showDataEx(row);
			} else {
				$(".etc_field_idx"+ row + " th").first().attr("rowspan", "1");
				$(".etc_input" + row).hide();
				$(".etc_data_ex"+row).hide();
			}
		}

		/* 데이터 보기 항목 영역 보기, 감추기 */
		function f_showDataEx(row){
			var checkValue = $("input[name='dataInputTy" + row + "']:checked").val();
			switch(checkValue) {
				case "select" :
					$(".etc_field_idx"+ row + " th").first().attr("rowspan", "4");
					$(".etc_data_ex"+row).show();
				break;

				case "radio" :
					$(".etc_field_idx"+ row + " th").first().attr("rowspan", "4");
					$(".etc_data_ex"+row).show();
				break;

				case "checkbox" :
					$(".etc_field_idx"+ row + " th").first().attr("rowspan", "4");
					$(".etc_data_ex"+row).show();
				break;

				case "text" :
					$(".etc_data_ex"+row).hide();
					$(".etc_field_idx"+ row + " th").first().attr("rowspan", "3");
				break;

				case "textarea" :
					$(".etc_data_ex"+row).hide();
					$(".etc_field_idx"+ row + " th").first().attr("rowspan", "3");
				break;
			}
		}

		/* 데이터 보기 추가 */
		function f_EtcItemExAdd(row) {
			if( $("#etcIemExNm" + row).val() == "" ) {
				alert("보기항목명을 입력하여 주십시요");
				$("#etcIemExNm" + row).focus();
				return;
			}
			if( $("#etcIemExValue" + row).val() == "" ) {
				var optLength = $("#etcItem"+row+" > option").length;
				var text = $("#etcIemExNm" + row).val();
				$("#etcItem" + row).append( new Option( text , "C-" + (optLength + 1), false, false  ) );

			} else {
				var selectValue = $("#etcIemExValue" + row).val();
				var values = selectValue.split("-");
				$("#etcItem"+row+" option").each(function(){
					if($(this).val() == selectValue) {
						$(this).text( $("#etcIemExNm" + row).val() );
						$(this).val( "U-" + values[1]);
					}
				});
				$("#btnEtcItemEx" + row).html("추가");
				$("#etcIemExValue" + row).val("");
			}
			$("#etcIemExNm" + row).val("");
		}

		/* 데이터 보기 수정 */
		function f_EtcItemExMod(row) {
			var option = $("#etcItem" + row + " option:selected");
			if( option.length != 1 ) {
				alert("수정할 항목을 하나만 선택하여 주십시요");
				return;
			}
			$("#etcIemExNm" + row).val(option.text());
			$("#etcIemExValue" + row).val(option.val());
			$("#btnEtcItemEx" + row).html("수정");
		}

		/* 데이터 보기 삭제 */
		function f_EtcItemExDel(row) {
			$("#etcItem"+row+" option:selected").each(function(){
				var values = $(this).val().split("-");
				if( "C" == values[0]) {
					$(this).remove();
					return;
				} else {
					var html = getEtcItemForm( "D-" + values[1], $(this).text(), row );
					$("#frmBbsSt").append( html );
					$(this).remove();
				}
			});
		}

		/* 기타필드 폼 변환 */
		function getEtcItemForm(value, text, row) {
			var html  = "<input type='hidden' name='etcItemValues" + row + "' value='" + value  + "' />";
	    		html += "<input type='hidden' name='etcItemTexts" + row +"'  value='" + text + "' />";
	    	return html;
		}

		/* 기타항목 폼 추가 */
		function f_addEtcForm(){
			var index = eval($("#etcTotalRow").val());

			if(index == 0)
				$(".etcIem-div").show();

			index++;
			$("#etcTotalRow").val(index);
			var etcHtml =   "<tr class=\"etc_field" + index + " etc_field_idx" + index + "\">";
			  	  etcHtml += "		<th rowspan=\"4\">기타항목" + index + "</th>";
				  etcHtml += "		<th>기타항목명</th>";
				  etcHtml += "		<td class=\"form-inlin\">";
				  etcHtml += "		<div class=\"control-group\">";
				  etcHtml += "		<input type=\"text\" name=\"etcIemNm" + index + "\" id=\"etcIemNm" + index + "\" class=\"form-control\" value=\"\" maxlength=\"20\" placeholder=\"기타항목명\"/>";
				  etcHtml += "		<div class=\"checkbox-custom checkbox-text-primary checkbox-inline\">";
				  etcHtml += "		<input type=\"checkbox\" name=\"userHideAt" + index + "\" id=\"userHideAt" + index + "\"/ value=\"Y\" class=\"form-control\"><label for=\"userHideAt" + index + "\">숨김(사용자 상세 화면)</label>";
				  etcHtml += "		</div></div>";
				  etcHtml += "		</td>";
				  etcHtml += "		<th>사용여부</th>";
				  etcHtml += "		<td>";
				  etcHtml += "		<div class=\"radio-group\">";
				  <c:forEach items="${useAt}" var="useAt" varStatus="status">
				  etcHtml += "		<span class=\"radio-custom radio-inline radio-primary\">";
				  etcHtml += "		<input type=\"radio\" name=\"etcIemUseAt" + index + "\" id=\"etcIemUseAt" + index + "_${useAt.key}\" value=\"${useAt.key}\" onclick=\"f_showDataInput('" + index + "');\" <c:if test='${status.first}'>checked=\"checked\"</c:if> class=\"form-control\"/><label for=\"etcIemUseAt" + index + "_${useAt.key}\">${useAt.value}</label>";
				  etcHtml += "		</span>";
				  </c:forEach>
				  etcHtml += "		</div>";
				  etcHtml += "		</td>";
				  etcHtml += "</tr>";
				  etcHtml += "<tr class=\"etc_field" + index + " etc_field_idx" + index + " etc_input" + index + "\">";
				  etcHtml += "		<th>데이터 필수입력 여부</th>";
				  etcHtml += "		<td colspan=\"3\">";
				  etcHtml += "		<div class=\"radio-group\">";
				  <c:forEach items="${useAt}" var="useAt">
				  etcHtml += "		<span class=\"radio-custom radio-inline radio-primary\">";
				  etcHtml += "		<input type=\"radio\" name=\"essntlInputAt" + index + "\" id=\"essntlInputAt" + index + "_${useAt.key}\" value=\"${useAt.key}\" <c:if test="${useAt.key eq 'N'}">checked=\"checked\"</c:if> class=\"form-control\"/><label for=\"essntlInputAt" + index + "_${useAt.key}\">${useAt.value}</label>";
				  etcHtml += "		</span>";
				  </c:forEach>
				  etcHtml += "		</div>";
				  etcHtml += "		</td>";
				  etcHtml += "</tr>";
				  etcHtml += "<tr class=\"etc_field" + index + " etc_field_idx" + index + " etc_input" + index + "\">";
				  etcHtml += "		<div class=\"radio-group\"><span>";
				  etcHtml += "		<th>데이터 입력 형식</th>";
				  etcHtml += "		<td colspan=\"3\">";
				  etcHtml += "		<div class=\"radio-group\">";
				  <c:forEach items="${etcIemDataInputTy}" var="dataInputTy" varStatus="status">
				  etcHtml += "		<span class=\"radio-custom radio-inline radio-primary\">";
				  etcHtml += "		<input type=\"radio\" name=\"dataInputTy" + index + "\" id=\"dataInputTy" + index + "_${dataInputTy.value }\" value=\"${dataInputTy.key}\" onclick=\"f_showDataEx('" + index + "');\" <c:if test='${status.first}'>checked=\"checked\"</c:if> class=\"form-control\"/><label for=\"dataInputTy" + index + "_${dataInputTy.value }\">${dataInputTy.value }</label>";
				  etcHtml += "		</span>";
				  </c:forEach>
				  etcHtml += "		</div>";
				  etcHtml += "		</td>";
				  etcHtml += "</tr>";
				  etcHtml += "<tr class=\"etc_field" + index + " etc_field_idx" + index + " etc_input" + index + " etc_data_ex" + index + "\">";
				  etcHtml += "		<th>데이터 보기 항목</th>";
				  etcHtml += "		<td colspan=\"3\">";
				  etcHtml += "			<div style=\"border:solid 1px #ccc; margin-top:10px;\">";
				  etcHtml += "				<div class=\"control-group\" style=\"padding:5px 10px;\">";
				  etcHtml += "				    <div class=\"controls\" style=\"margin-left:0px;\">";
				  etcHtml += "						<div class=\"input-append\" style=\"vertical-align: top;\">";
				  etcHtml += "							<input type=\"text\" name=\"etcIemExNm" + index + "\" id=\"etcIemExNm" + index + "\" class=\"form-control\" placeholder=\"보기항목명\" />";
				  etcHtml += "							<button class=\"btn\" type=\"button\" onclick=\"f_EtcItemExAdd('" + index + "'); return false;\"><i class=\"icon icon-plus\"></i> 추가</button>";
				  etcHtml += "							<input type=\"hidden\" name=\"etcIemExValue" + index + "\" id=\"etcIemExValue" + index + "\">";
				  etcHtml += "						</div>";
				  etcHtml += "						<div class=\"input-append\">";
				  etcHtml += "						<select id=\"etcItem" + index + "\" name=\"etcItem" + index + "\" style=\"width:309px;height:100px\" class=\"form-control\" multiple=\"multiple\"></select>";
				  etcHtml += "						<button class=\"btn\" type=\"button\" onclick=\"f_EtcItemExMod('" + index + "'); return false;\">수정</button>";
				  etcHtml += "						<button class=\"btn\" type=\"button\" onclick=\"f_EtcItemExDel('" + index + "'); return false;\">삭제</button>";
				  etcHtml += "						</div>";
				  etcHtml += "					</div>";
				  etcHtml += "				</div>";
				  etcHtml += "			</div>";
				  etcHtml += "		</td>";
				  etcHtml += "</tr>";
			$("#etcBody").append(etcHtml).trigger("create");
		}

		/* 기타항목 폼 삭제 */
		function f_delEtcForm(){
			var index = eval($("#etcTotalRow").val());

			if(index > 0){
				$(".etc_field" + index).remove();
				$("#etcTotalRow").val(index - 1);
			}else{
				alert("기타항목이 없습니다.");
			}

			if(eval($("#etcTotalRow").val()) == 0)
				$(".etcIem-div").hide();
		}

		function delFile(fileNo, type){
			if(confirm("삭제하시겠습니까?")){
				if(type == "NTTNEWIMG"){
					if($("#delnttNewImgFileNo").val()==""){
						$("#delnttNewImgFileNo").val(fileNo);
					}else{
						$("#delnttNewImgFileNo").val($("#delnttNewImgFileNo").val()+","+fileNo);
					}
					$("#nttNewImgFileDelSpan").remove();
					$("#nttNewImgFile").show();
				}
			}
		}

		//그룹게시판 목록
		function fn_bbsList(){
			<c:choose>
				<c:when test="${bbsSettingVO.crud == 'CREATE' }">
				var bbsTy = $("input[name='bbsTy']:checked").val();
				</c:when>
				<c:otherwise>
				var bbsTy = $("input[name='bbsTy']").val();
				</c:otherwise>
			</c:choose>

			var url = "/admin/bbs/popup/bbsList?srchBbsTy=" + bbsTy;
			var width = 1150;
		    var height = 630;
			var top = (screen.availHeight - height) / 2;
		    var left = (screen.availWidth - width) / 2;
			var bbsWin = window.open(url, "bbsPopup", "width=" + width + ",height=" + height + ", scrollbars=yes, top=" + top + ", left=" + left);
			bbsWin.focus();
		}

		//그룹게시판 추가
		function fn_addBbs(params){

			if($("#" + params.uniqueId).length == 0){
				var bbsRow = '<tr>';
				bbsRow += '<td>';
				bbsRow += '<input type="hidden" name="groupBbsNo" id="groupBbsNo" value="' + params.bbsNo + '"/>';
				bbsRow += '<input type="hidden" name="groupSiteNtceNo" id="siteNtceNo" value="' + params.siteNtceNo + '"/>';
				bbsRow += '<input type="hidden" name="groupCtgryNo" id="ctgryNo" value="' + params.ctgryNo + '"/>';
				bbsRow += '<input type="checkbox" id="' + params.uniqueId + '" name="arrUniqueId" data-style="checkbox"></td>';
				bbsRow += '<td>' + params.bbsSj + '</td>';
				bbsRow += '<td>' + params.siteNtceNm + '</td>';
				bbsRow += '<td>' + params.ctgryNm + '</td>';
				bbsRow += '</tr>';
				$("#groupBbsTable tbody").append(bbsRow);
				$("#groupBbsTable tbody tr td input[data-style='checkbox']").last().uniform();
			}
		}

		//그룹게시판 삭제
		function fn_delBbs(){
			if($("input[name=arrUniqueId]:checked").length == 0){
				alert("선택된 건이 없습니다.");
			}
			else{
				$("input[name=arrUniqueId]:checked").each(function() {
					$(this).closest("tr").remove();
				});
			}
		}
	</script>








			<!-- Start Breadcrumb -->
			<jsp:include page="/WEB-INF/jsp/admin/layout/breadcrumb.jsp">
				<jsp:param name="pageName" value="게시판 관리"/>
			</jsp:include>
			<!-- End Breadcrumb -->

            <!-- start: page -->
			<div class="row">
				<f:form name="frmBbsSt" id="frmBbsSt" modelAttribute="bbsSettingVO" method="post" action="./action" class="form-horizontal" enctype="multipart/form-data">
				<f:hidden path="crud" />
				<f:hidden path="bbsNo" />
				<f:hidden path="popularNttColor" />
				<f:hidden path="trgtTable" />
				<f:hidden path="detailOutpt" />
				<input type="hidden" name="cmmnTableAt" value="Y"/>
				<input type="hidden" name="etcTotalRow" id="etcTotalRow" value="0"/>
				<input type="hidden" name="delnttNewImgFileNo" id="delnttNewImgFileNo" value=""/>

				<div class="col-md-9">

					<section class="panel panel-featured panel-featured-primary">
						<header class="panel-heading">
							<h2 class="panel-title">게시판 <c:if test="${bbsSettingVO.crud eq 'UPDATE'}">[${bbsSettingVO.bbsSj}]</c:if> 등록/수정</h2>
						</header>
						<div class="panel-body">

						    <!--new -->
						    <div class="panel-group" id="accordion">
						    <div class="panel panel-accordion">
								<div class="panel-heading">
									<h4 class="panel-title">
										<a class="accordion-toggle" >
											<i class="fa fa-edit"></i> 기본정보
										</a>
									</h4>
								</div>
								<div id="collapseOne" >
									<div class="panel-body p-none">
										<table class="table table-bordered mb-none">
											<colgroup>
												<col style="width:150"/>
												<col />
												<col style="width:150"/>
												<col />
											</colgroup>
											<tbody>
												<tr>
													<th>게시판명 <span class="required">*</span></th>
													<td colspan="3">
														<f:input path="bbsSj" class="form-control" placeholder="게시판명" maxlength="250"/>
													</td>
												</tr>
												<tr>
													<th>게시판스킨경로 <span class="required">*</span></th>
													<td colspan="3">
														<%--
														<f:input path="bbsSknTy" class="input-large" placeholder="게시판스킨경로" maxlength="100"/>
														<a href="javascript:$('#bbsSknTy').val('/commBbs/bbs');" class="btn" style="margin-left: 5px;">공통스킨</a>
														<a href="javascript:$('#bbsSknTy').val('/bbs');" class="btn" style="margin-left: 5px;">사이트스킨</a>
														<span class="help-block">ex) 공통스킨(부산대표) : <strong>/commBbs/bbs</strong>, 각 사이트스킨 : <strong>/bbs</strong></span>
														--%>

														<select name="bbsSknTy" id="bbsSknTy" class="form-control">
															<option value="0" <c:if test="${bbsSettingVO.bbsSknTy eq '0' or empty bbsSettingVO.bbsSknTy }">selected</c:if>>기본 스킨</option>
															<c:forEach var="skin" items="${skinList }" varStatus="status">
																<option value="${skin.skinId }" <c:if test="${bbsSettingVO.bbsSknTy eq skin.skinId }">selected</c:if>>${skin.skinName }</option>
															</c:forEach>
														</select>
													</td>
												</tr>
												<tr>
													<th>게시판 유형 <span class="required">*</span></th>
													<td colspan="3">
														<div class="radio-group">
														<c:choose>
														<c:when test="${bbsSettingVO.crud == 'CREATE' }">
														<f:radiobuttons path="bbsTy" items="${boardTy}" onclick="f_SetupBoard()" element="span class='radio-custom radio-inline radio-primary' " cssClass="form-control" />
														</c:when>
														<c:otherwise>
														${boardTy[bbsSettingVO.bbsTy]}
														<f:hidden path="bbsTy" />
														</c:otherwise>
														</c:choose>
														</div>
													</td>
												</tr>
												<c:if test="${bbsSettingVO.crud eq 'CREATE' }">
												<tr id="typeVIewImg">
													<th></th>
													<td colspan="3">
														<div></div>
													</td>
												</tr>
												</c:if>
												<tr>
													<th>사용여부 <span class="required">*</span></th>
													<td>
														<div class="radio-group">
														<f:radiobuttons path="useAt" items="${useAt}" element="span class='radio-custom radio-inline radio-primary' " cssClass="form-control" />
														</div>
													</td>

													<th>검색 수집 허용 여부 <span class="required">*</span></th>
													<td>
														<div class="radio-group">
														<f:radiobuttons path="searchColctPermAt" items="${useAt}" element="span class='radio-custom radio-inline radio-primary' " cssClass="form-control" />
														</div>
													</td>

													<!--
													<th>공통 테이블 사용 여부<span class="required">*</span></th>
													<td>
														<div class="radio-group">
														<c:choose>
														<c:when test="${bbsSettingVO.crud == 'CREATE' }">
														<f:radiobuttons path="cmmnTableAt" items="${useAt}"/>
														</c:when>
														<c:otherwise>
															<c:if test="${bbsSettingVO.cmmnTableAt == 'Y'}">
																공통 테이블 사용 (테이블 명 : ${bbsSettingVO.trgtTable})
															</c:if>
															<c:if test="${bbsSettingVO.cmmnTableAt == 'N'}">
																별도 테이블 사용 (테이블 명 : ${bbsSettingVO.trgtTable})
															</c:if>
														<f:hidden path="cmmnTableAt" />
														<f:hidden path="trgtTable" />
														</c:otherwise>
														</c:choose>
														</div>
													</td>
													-->
												</tr>
												<tr>
													<th title="게시글 작성 시, 공개 / 비공개 글 선택할 수 있는 항목을 제공합니다.">공개/비공개<span class="required">*</span></th>
													<td>
														<div class="radio-group">
														<f:radiobuttons path="openAt" items="${useAt}" element="span class='radio-custom radio-inline radio-primary' " cssClass="form-control" />
														</div>
													</td>
													<th title="이메일 항목 사용여부를 설정합니다."> 이메일 <span class="required">*</span></th>
													<td>
														<div class="radio-group">
														<f:radiobuttons path="emailUseAt" items="${useAt}" element="span class='radio-custom radio-inline radio-primary' " cssClass="form-control" />
														</div>
													</td>
												</tr>
												<tr>
													<th title="부서 항목 사용여부를 설정합니다.">부서 사용 여부 <span class="required">*</span></th>
													<td>
														<div class="radio-group">
														<f:radiobuttons path="nttOrgUseAt" items="${useAt}" element="span class='radio-custom radio-inline radio-primary' " cssClass="form-control" />
														</div>
													</td>
													<th title="담당기관 항목 사용여부를 설정합니다.">담당기관 <span class="required">*</span></th>
													<td>
														<div class="radio-group">
														<f:radiobuttons path="positionUseAt" items="${useAt}" element="span class='radio-custom radio-inline radio-primary' " cssClass="form-control" />
														</div>
													</td>
												</tr>
												<tr>
													<th title="전화번호 항목 사용여부를 설정합니다.">전화번호 <span class="required">*</span></th>
													<td>
														<div class="radio-group">
														<f:radiobuttons path="tellUseAt" items="${useAt}" element="span class='radio-custom radio-inline radio-primary' " cssClass="form-control" />
														</div>
													</td>
													<th title="작성자 실명 공개 사용여부를 선택합니다.">작성자 실명 공개 <span class="required">*</span></th>
													<td>
														<div class="radio-group">
														<f:radiobuttons path="wrterIndict" items="${openTy}" element="span class='radio-custom radio-inline radio-primary' " cssClass="form-control" />
														</div>
													</td>
												</tr>
												<tr>
													<th title="RSS 버튼 노출을 설정 합니다.">RSS 여부 <span class="required">*</span></th>
													<td>
														<div class="radio-group">
														<f:radiobuttons path="rssAt" items="${useAt}" element="span class='radio-custom radio-inline radio-primary' " cssClass="form-control" />
														</div>
													</td>
													<th title="신고 버튼 노출 사용유무를 선택합니다.">신고사용 여부<span class="required">*</span></th>
													<td>
														<div class="radio-group">
														<f:radiobuttons path="reportAt" items="${useAt}" element="span class='radio-custom radio-inline radio-primary' " cssClass="form-control" />
														</div>
													</td>
												</tr>
												<tr id="hashTagAt_tr">
													<th title="해시태그 사용여부를 설정합니다.">해시태그 여부<span class="required">*</span></th>
													<td>
														<div class="radio-group">
														<f:radiobuttons path="hashTagAt" items="${useAt}" element="span class='radio-custom radio-inline radio-primary' " cssClass="form-control" />
														</div>
													</td>
													<th>CCL 사용 <a href="http://www.cckorea.org/xe/ccl" target="_blank"><i class="icon-question-sign"></i></a></th>
													<td>
														<div class="radio-group">
														<f:radiobuttons path="cclAt" items="${useAt}" element="span class='radio-custom radio-inline radio-primary' " cssClass="form-control" />
														</div>
													</td>
												</tr>
												<tr>
													<th>에디터 사용 <span class="required">*</span></th>
													<td>
														<div class="radio-group">
														<f:radiobuttons path="editrUseAt" items="${useAt}" element="span class='radio-custom radio-inline radio-primary' " cssClass="form-control" />
														</div>
													</td>
													<th title="관련글  등록 여부를 설정합니다.">관련글 등록 <span class="required">*</span></th>
													<td>
														<div class="radio-group">
														<f:radiobuttons path="nearNttAt" items="${useAt}" element="span class='radio-custom radio-inline radio-primary' " cssClass="form-control" />
														</div>
													</td>
												</tr>
												<tr>
													<th>사용자 인증방식 <span class="required">*</span></th>
													<td>
														<div class="radio-group">
														<f:radiobuttons path="crtfcMthd" items="${crtfcTy}" element="span class='radio-custom radio-inline radio-primary' " cssClass="form-control" />
														</div>
													</td>
													<th>이전글 다음글 여부 <span class="required">*</span></th>
													<td>
														<div class="radio-group">
														<f:radiobuttons path="brftrNttAt" items="${useAt}" element="span class='radio-custom radio-inline radio-primary' " cssClass="form-control" />
														</div>
													</td>
												</tr>
												<tr>
													<th title="(관리자제공)&#10;게시글 등록 시, 다른 게시판에 게시글 복사 기능을 설정합니다.">게시글 복사</th>
													<td colspan="3">
														<div class="radio-group">
															<f:radiobuttons path="bbsCopyAt" items="${useAt}" element="span class='radio-custom radio-inline radio-primary' " cssClass="form-control" />
														</div>
														<div id="show_bbs_copy_view" class="show_bbs_copy_view hidden">
														<div class="control-group ntt-img-div-time form-inline">
															<div class="form-group" style="padding:5px 10px;">
																<label for="newNttApplcPd">검색 <span class="required">*</span></label>
																	<input id="search_bbs_name" name="search_bbs_name" class="form-control search-query" type="text" value="">
			                                               			<button class="btn btn-default" type="button" onclick="fn_bbs_copy_ajax('N');">검색</button>
															</div>
														</div>
														<table style="width: 100%">
															<tr>
																<td style="width:40%">
				                                                    <select id="group_id" name="group_id" data-placeholder="게시판선택" class="form-control" style="width:100%;" size="10" ondblclick="add_group_option();">
				                                                    </select>
																</td>
																<td style="text-align:center;vertical-align: middle;padding: 0 0 0 0;width:20%">
																	<span><a href="#none;" onclick="add_group_option();" style="padding: 4px;" class="btn btn-primary">추가&nbsp;<i class="fa fa-angle-right"></i></a></span>
																	<br/><br/>
																	<span><a href="#none;" onclick="del_group_option();" style="padding: 4px;" class="btn btn-danger" style="margin-top:10px;"><i class="fa fa-angle-left"></i>&nbsp;삭제</a></span>
																</td>
																<td style="width:40%">
				                                                     <select id="menu_group_id" name="menu_group_id"  data-placeholder="게시판" class="form-control" style="width:100%; min-width: 300px;" size="10" ondblclick="del_group_option();">
				                                                    </select>
				                                                 </td>
															</tr>
														</table>
														</div>
													</td>
												</tr>
			<%-- 									<tr>
													<th>통합게시판 사용 여부 <span class="required">*</span></th>
													<td>
														<div class="radio-group">
														<f:radiobuttons path="unityBbsUseAt" items="${useAt}"/>
														<f:select path="unityBbsSiteTy" cssClass="input input-medium hidden">
															<f:option value="A">전체사이트</f:option>
															<f:options items="${siteClCode}" itemLabel="codeNm" itemValue="codeId"/>
														</f:select>
														</div>
													</td>
													<th>RSS 여부 <span class="required">*</span></th>
													<td>
														<div class="radio-group">
														<f:radiobuttons path="rssAt" items="${useAt}"/>
														</div>
													</td>
												</tr>
												<tr>
													<th>그룹게시판 사용 여부 <span class="required">*</span></th>
													<td>
														<div class="radio-group">
														<f:radiobuttons path="groupBbsUseAt" items="${useAt}"/>
														</div>
														<div class="group-bbs-div hidden" style="border:solid 1px #ccc; margin-top:10px;">
															<div class="control-group ntt-img-div-time" style="padding:5px 10px;">
																<label class="control-label" style="width:100px;">그룹게시판 선택<span class="required">*</span></label>
																<div class="controls" style="margin-left:120px;">
																	<div class="widget">
							                                            <div class="widget-content no-padding">
							                                                <div class="widget-content-inner">
							                                                	<table class="table table-hover" id="groupBbsTable">
																					<colgroup>
																						<col style="width:50px;" />
																						<col />
																						<col style="width:180px;"/>
																						<col style="width:180px;"/>
																					</colgroup>
							                                                        <thead>
							                                                            <tr>
							                                                            	<th><input type="checkbox" id="arrUniqueId" data-style="checkbox"/></th>
							                                                                <th>게시판명</th>
							                                                                <th>사이트구분</th>
							                                                                <th>게시글 카테고리</th>
							                                                            </tr>
							                                                        </thead>
							                                                        <tbody>
							                                                        	<c:forEach items="${bbsSettingVO.groupBbsList}" var="groupBbsList" varStatus="status">
																						<tr>
																							<input type="hidden" name="groupBbsNo" id="groupBbsNo" value="${groupBbsList.groupBbsNo}"/>
																							<input type="hidden" name="groupSiteNtceNo" id="siteNtceNo" value="${groupBbsList.siteNtceNo}"/>
																							<input type="hidden" name="groupCtgryNo" id="ctgryNo" value="${groupBbsList.ctgryNo}"/>
																							<td><input type="checkbox" id="arrUniqueId${groupBbsList.groupBbsNo}_${groupBbsList.siteNtceNo}_${groupBbsList.ctgryNo}" data-style="checkbox" name="arrUniqueId"/></td>
							                                                                <td>${groupBbsList.bbsSj}</td>
							                                                                <td>${groupBbsList.siteNm}</td>
							                                                                <td>${groupBbsList.ctgryNm}</td>
							                                                            </tr>
																						</c:forEach>
							                                                        </tbody>
							                                                    </table>
							                                                </div>
							                                            </div>
							                                        </div>
																	<button type="button" class="btn btn-success" onclick="javascript:fn_bbsList();">추가</button>
																	<button type="button" class="btn btn-danger" onclick="javascript:fn_delBbs();">삭제</button>
																</div>
															</div>
														</div>
													</td>
													<th>마일리지 <span class="required">*</span></th>
													<td>
														<div class="radio-group">
														<f:input path="mlg" class="input-small" />
														</div>
													</td>
												</tr> --%>
												<tr>
													<th>게시물 목록 출력 건수 <span class="required">*</span></th>
													<td>
														<f:select path="nttListOutptCo" cssClass="form-control" cssStyle="width: 100px">
															<c:choose>
															<c:when test="${bbsSettingVO.bbsTy eq '3' or bbsSettingVO.bbsTy eq '4'}">
																<c:forEach begin="6" end="20" step="2" var="value">
																<f:option value="${value}">${value}</f:option>
																</c:forEach>
															</c:when>
															<c:otherwise>
																<c:forEach begin="10" end="50" step="10" var="value">
																<f:option value="${value}">${value}</f:option>
																</c:forEach>
															</c:otherwise>
															</c:choose>
														</f:select>
													</td>
													<th>게시기간 사용여부 <span class="required">*</span></th>
													<td>
														<div class="radio-group">
														<f:radiobuttons path="noticeTermYn" items="${useAt}" element="span class='radio-custom radio-inline radio-primary' " cssClass="form-control" />
														</div>
													</td>
												</tr>
												<tr style="display:none;">
													<th>게시판 상단글 </th>
													<td colspan="3">
														<f:textarea path="bbsInfo" cssClass="form-control" cssStyle="height:150px" />
													</td>
												</tr>
											</tbody>
										</table>
									</div>
								</div>
							</div>
							<div class="panel panel-accordion">
								<div class="panel-heading" data-plugin-toggle>
									<h4 class="panel-title">
										<a class="accordion-toggle" data-toggle="collapse"  href="#collapseTwo" >
											<i class="fa fa-plus-square"></i> 추가 옵션
										</a>
									</h4>
								</div>
								<div id="collapseTwo" class="accordion-body collapse">
									<div class="panel-body p-none">
									<table class="table table-bordered mb-none">
											<colgroup>
												<col style="width:150px"/>
												<col />
											</colgroup>
											<tbody>
												<tr>
													<th>신규 게시물 표시<br/>사용 여부 <span class="required">*</span></th>
													<td>
														<div class="radio-group">
														<f:radiobuttons path="newNttImageUseAt" items="${newNttImgTy}" element="span class='radio-custom radio-inline radio-primary' " cssClass="form-control" />
														</div>
														<div class="ntt-img-div hidden" style="border:solid 1px #ccc; margin-top:10px;">
															<!--
															<div class="control-group ntt-img-div-new" style="padding:5px 10px;">
															<label class="control-label" style="width:100px;">신규 이미지 <span class="required">*</span></label>
																<div class="controls" style="margin-left:120px;">
																	<input type="file" id="nttNewImgFile" name="nttNewImgFile" <c:if test="${fn:length(bbsSettingVO.nttNewImgFileList) > 0 }">style="display: none;"</c:if>/>
																	<c:if test="${fn:length(bbsSettingVO.nttNewImgFileList) > 0 }">
																	<span id="nttNewImgFileDelSpan">
																	<c:set var="nttImgFile" value="${bbsSettingVO.nttNewImgFileList[0]}" />
																	<img src='/comm/getImage?srvcId=${nttImgFile.srvcId }&amp;upperNo=${nttImgFile.upperNo }&amp;fileTy=${nttImgFile.fileTy }&amp;fileNo=${nttImgFile.fileNo }' width='30' height='30' alt='신규이미지'/>
																	<a href="javascript:delFile('${nttImgFile.fileNo}', 'NTTNEWIMG');" class="btn btn-danger">삭제</a>
																	</span>
																	</c:if>
																</div>
															</div>
															 -->
															<div class="control-group ntt-img-div-time form-inline" style="padding:5px 10px;">
																<div class="form-group" style="padding:5px 10px;">
																	<label for="newNttApplcPd">적용 기간 <span class="required">*</span></label>
																		<f:input path="newNttApplcPd" cssClass="form-control mx-sm-3" />시간
																</div>
															</div>
														</div>
													</td>
												</tr>
												<tr>
													<th>인기 게시물 사용 여부 <span class="required">*</span></th>
													<td>
														<div class="radio-group">
														<f:radiobuttons path="popularNttUseAt" items="${useAt}" element="span class='radio-custom radio-inline radio-primary' " cssClass="form-control" />
														</div>
														<div class="pop-ntt-div hidden" style="border:solid 1px #ccc; margin-top:10px;">
															<div class="control-group form-inline" style="padding:5px 10px;">
															<label for="popularNttApplcCo">인기 게시물 건수 <span class="required">*</span></label>
																<f:input path="popularNttApplcCo" cssClass="form-control mx-sm-3" />
															</div>
															<div class="control-group form-inline" style="padding:5px 10px;">
															<label for="hideAfterPaletteSelect">인기 게시물 색상</label>
																<input type='text' name='hideAfterPaletteSelect' id='hideAfterPaletteSelect' class="form-control mx-sm-3"  />
																<font class="pop-ntt-font" color="<c:out value="${bbsSettingVO.popularNttColor}"/>"><strong>인기 게시물 입니다.</strong></font>
																</div>
															</div>
														</div>
													</td>
												</tr>
												<tr>
													<th>카테고리 사용</th>
													<td>
														<div class="radio-group">
														<f:radiobuttons path="ctgryUseAt" items="${useAt}" element="span class='radio-custom radio-inline radio-primary' " cssClass="form-control" />
														</div>
														<div class="ctgry-use-at-div hidden" style="border:solid 1px #ccc; margin-top:10px;">
		                                                    <div class="control-group form-inline" style="padding:5px 10px;height:200px">
		                                                        <label for="ctgryNm">카테고리</label>
		                                                        <div class="controls" style="margin-left:120px;">
			                                                        <div class="input-append col-sm-6" style="vertical-align: top;">
																		<input type="text" name="ctgryNm" id="ctgryNm" class="form-control" placeholder="카테고리명" />
																		<button class="btn" type="button" onclick="f_ctgryAdd(); return false;"><i class="icon icon-plus"></i> 추가</button>
																		<input type="hidden" name="ctgryValue" id="ctgryValue" />
																	</div>
																	<div class="input-append col-sm-6">
																		<f:select path="ctgry" cssClass="form-control" cssStyle="height:100px;width:100%" items="${bbsSettingVO.ctgryList}" itemLabel="ctgryNm" itemValue="ctgryValue"></f:select>
																		<div>
																		<button class="btn" type="button" onclick="f_ctgryMod(); return false;">수정</button>
																		<button class="btn" type="button" onclick="f_ctgryRemove(); return false;">삭제</button>
																		</div>
																	</div>
		                                                        </div>
		                                                    </div>
		                                                </div>
													</td>
												</tr>
												<tr>
													<th>개인정보 수집 이용동의 사용 <span class="required">*</span></th>
													<td>
														<div class="radio-group">
															<f:radiobuttons path="indvdlinfoColctAgreAt" items="${useAt}" element="span class='radio-custom radio-inline radio-primary' " cssClass="form-control" />
															<div class="indvdlinfo-div hidden" style="border:solid 1px #ccc; margin-top:10px;">
																<div class="control-group form-inline" style="padding:5px 10px;">
																<label for="indvdlinfoColctAgreWords">개인정보 수집 이용동의 문구</label>
																	<f:textarea path="indvdlinfoColctAgreWords" cssClass="form-control" cssStyle="width:80%;height:150px;"/>
																</div>
															</div>
														</div>
													</td>
												</tr>
												<tr>
													<th>첨부파일 사용 <span class="required">*</span></th>
													<td>
														<div class="radio-group">
															<f:radiobuttons path="atchmnflAt" items="${useAt}" element="span class='radio-custom radio-inline radio-primary' " cssClass="form-control" />
														</div>
														<div class="atch-div hidden" style="border:solid 1px #ccc; margin-top:10px;">
															<div class="control-group form-inline" style="padding:5px 10px;">
																<label for="atchmnflCo">첨부파일 개수</label>
																<f:input path="atchmnflCo" class="input-small" cssClass="form-control" />
															</div>
															<div class="control-group form-inline" style="padding:5px 10px;">
																<label for="atchmnflSize">사이즈 제한</label>
																<f:input path="atchmnflSize" class="input-small" cssClass="form-control" /> MB (0일 경우 제한 없음)
															</div>
															<div class="control-group" style="padding:5px 10px;">
																<label class="form-check-label">확장자 제한</label>
																<f:checkboxes path="atchmnflExtsn" items="${ext}" cssClass="form-control" cssStyle="vertical-align: top;" element="span class='checkbox-custom checkbox-text-primary checkbox-inline'" />
																<span class="help-block">(선택하지 않을 경우 제한 없음)</span>
															</div>
														</div>
													</td>
												</tr>
												<tr>
													<th>기타항목 사용</th>
													<td>
														<div class="radio-group form-inline">
														<f:radiobuttons path="etcIemAt" items="${useAt}" element="span class='radio-custom radio-inline radio-primary' " cssClass="form-control" />
														<span class="etcIem-button" style="display: none;">
															<a href="javascript:f_addEtcForm();" class="btn btn-primary">추가</a>
															<a href="javascript:f_delEtcForm();" class="btn btn-danger">삭제</a>
															<span class="etcIem-button checkbox-custom checkbox-text-primary checkbox-inline" style="display: none;">
															<input type="checkbox" name="etcIndictLineFeedAt" id="etcIndictLineFeedAt" <c:if test="${bbsSettingVO.etcIndictLineFeedAt eq 'Y'}">checked</c:if> value="Y" class="form-control" /><label for="etcIndictLineFeedAt">1열에 한개씩 출력(기본 2개)</label>
															</span>
														</span>
														</div>
														<div class="etcIem-div" style="border:solid 1px #ccc; margin-top:10px; display: none;">
															<table class="table table-bordered table-hover mb-none">
																<colgroup id="etcColGroup">
																<col style="width:10%"/>
																<col style="width:15%"/>
																<col style="width:30%"/>
																<col style="width:15%"/>
																<col style="width:30%"/>
																</colgroup>
															<tbody id="etcBody">

																<c:forEach items="${boardEtcItemList}" var="etcList" varStatus="status">
																<c:set var="index" value="${status.index + 1}"/>
																<c:if test="${status.last}"><script>$("#etcTotalRow").val(${index});</script></c:if>
																<tr class="etc_field${index} etc_field_idx${index}">
																	<th rowspan="${(etcList.dataInputTy eq 'text' or etcList.dataInputTy eq 'textarea') ? 3 : 4}">기타항목${index}</th>
																	<th>기타항목명</th>
																	<td class="form-inline">
																		<div class="control-group">
																			<input type="text" name="etcIemNm${index }" id="etcIemNm${index }" class="form-control" value="${etcList.etcIemNm}" maxlength="20"/>
																			<div class="checkbox-custom checkbox-text-primary checkbox-inline">
																				<input type="checkbox" name="userHideAt${index }" id="userHideAt${index }" <c:if test="${etcList.userHideAt eq 'Y'}">checked</c:if> value="Y" class="form-control" /><label for="userHideAt${index }">숨김(사용자 상세 화면)</label>
																			</div>
																		</div>
																	</td>
																	<th>사용여부</th>
																	<td>
																		<div class="radio-group">
																		<c:forEach items="${useAt}" var="useAt">
																			<span class="radio-custom radio-inline radio-primary">
																			<input type="radio"
																					  name="etcIemUseAt${index }"
																			  		  id="etcIemUseAt${index }_${useAt.key}"
																					  value="${useAt.key}"
																					  onclick="f_showDataInput('${index }');"
																					  <c:if test="${empty etcList.useAt and 'N' eq useAt.key}">checked="checked"</c:if>
																					  <c:if test="${etcList.useAt eq useAt.key}">checked="checked"</c:if>
																					  class="form-control"
																					  />
																			<label for="etcIemUseAt${index}_${useAt.key}">${useAt.value}</label>
																			</span>
																		</c:forEach>
																		</div>
																	</td>
																</tr>
																<tr class="etc_field${index} etc_field_idx${index} etc_input${index}">
																	<th>데이터 필수입력 여부</th>
																	<td colspan="3">
																		<div class="radio-group">
																		<c:forEach items="${useAt}" var="useAt">
																			<span class="radio-custom radio-inline radio-primary">
																			<input type="radio"
																					  name="essntlInputAt${index }"
																			  		  id="essntlInputAt${index }_${useAt.key}"
																					  value="${useAt.key}"
																					  <c:if test="${empty etcList.essntlInputAt and 'N' eq useAt.key}">checked="checked"</c:if>
																					  <c:if test="${etcList.essntlInputAt eq useAt.key}">checked="checked"</c:if>
																					  class="form-control"
																					  />
																			<label for="essntlInputAt${index }_${useAt.key}">${useAt.value}</label>
																			</span>
																		</c:forEach>
																		</div>
																	</td>
																</tr>
																<tr class="etc_field${index} etc_field_idx${index} etc_input${index}">
																	<th>데이터 입력 형식</th>
																	<td colspan="3">
																		<div class="radio-group">
																		<c:forEach items="${etcIemDataInputTy}" var="dataInputTy">
																			<span class="radio-custom radio-inline radio-primary">
																			<input type="radio" name="dataInputTy${index }"
																			         id="dataInputTy${index }_${dataInputTy.value }" value="${dataInputTy.key }"
																					<c:if test="${etcList.dataInputTy eq dataInputTy.key}">checked="checked"</c:if>
																					onclick="f_showDataEx('${index }');"
																					class="form-control"
																					/>
																			<label for="dataInputTy${index}_${dataInputTy.value }">${dataInputTy.value }</label>
																			</span>
																		</c:forEach>
																		</div>
																	</td>
																</tr>
																<tr class="etc_field${index} etc_field_idx${index} etc_input${index} etc_data_ex${index}">
																	<th>데이터 보기 항목</th>
																	<td colspan="3">
																		<div style="border:solid 1px #ccc; margin-top:10px;">
																			<div class="control-group" style="padding:5px 10px;">
																			    <div class="controls" style="margin-left:0px;">
																					<div class="input-append" style="vertical-align: top;">
																						<input type="text" name="etcIemExNm${index}" id="etcIemExNm${index}" class="form-control" placeholder="보기항목명" />
																						<button class="btn" type="button" onclick="f_EtcItemExAdd('${index}'); return false;"><i class="icon icon-plus"></i> 추가</button>
																						<input type="hidden" name="etcIemExValue${index}" id="etcIemExValue${index}" />
																					</div>
																					<div class="input-append">
																						<select id="etcItem${index}" name="etcItem${index}" class="form-control" style="width:309px;height:100px" multiple="multiple">
																						<c:forEach items="${etcList.itemExList }" var="itemExList">
																							<option value="L-${itemExList.etcIemExNo}">${itemExList.etcIemExNm }</option>
																						</c:forEach>
																						</select>
																						<button class="btn" type="button" onclick="f_EtcItemExMod('${index}'); return false;">수정</button>
																						<button class="btn" type="button" onclick="f_EtcItemExDel('${index}'); return false;">삭제</button>
																					</div>
																				</div>
																			</div>
																		</div>
																	</td>
																</tr>
																</c:forEach>
															</tbody>
			      										</table>
			            								</div>
													</td>
												</tr>
											</tbody>
										</table>
									</div>
								</div>
							</div>


							<div class="panel panel-accordion">
								<div class="panel-heading" data-plugin-toggle>
									<h4 class="panel-title">
										<a class="accordion-toggle" data-toggle="collapse"  href="#collapseTree" >
											<i class="fa fa-key"></i> 권한/보안설정
										</a>
									</h4>
								</div>
								<div id="collapseTree" class="accordion-body collapse">
									<div class="panel-body p-none">
									<table class="table table-bordered mb-none">
											<colgroup>
												<col style="width:150px"/>
												<col />
											</colgroup>
											<tbody>
												<tr>
													<th>권한</th>
													<td>
														<div class="widget-content" style="border:none;">
															<table class="table table-bordered table-hover mb-none">
																<colgroup>
																	<col style="width:60">
																	<col style="width:14.2%">
																	<col style="width:14.2%">
																	<col style="width:14.2%">
																	<col style="width:14.2%">
																	<col style="width:14.2%">
																	<col />
																</colgroup>
																<thead>
																	<tr>
																		<th rowspan="2" style="vertical-align:middle;">구분</th>
																		<th colspan="2">읽기권한</th>
																		<th colspan="2">쓰기권한</th>
																		<th colspan="2">파일권한</th>
																	</tr>
																	<tr>
																		<th>목록</th>
																		<th>상세</th>
																		<th>원글</th>
																		<th>답글</th>
																		<th>업로드</th>
																		<th>다운로드</th>
																	</tr>
																</thead>
																<tbody>
																	<tr>
																		<th><span id="mngrAll" style="cursor:pointer;">관리자</span></th>
																		<td class="author_list"><f:checkbox path="mngrAuthor" value="_list" class="form-control" checked="checked"/></td>
																		<td class="author_view"><f:checkbox path="mngrAuthor" value="_view" class="form-control" checked="checked"/></td>
																		<td class="author_writing"><f:checkbox path="mngrAuthor" value="_writing" class="form-control" checked="checked"/></td>
																		<td class="author_reply"><f:checkbox path="mngrAuthor" value="_reply" class="form-control"/></td>
																		<td class="author_upload"><f:checkbox path="mngrAuthor" value="_upload" class="form-control" checked="checked"/></td>
																		<td class="author_dwld"><f:checkbox path="mngrAuthor" value="_dwld" class="form-control" checked="checked"/></td>
																	</tr>
																	<tr>
																		<th><span id="mberAll" style="cursor:pointer;">회원</span></th>
																		<td class="author_list"><f:checkbox path="mberAuthor" value="_list" class="form-control" checked="checked"/></td>
																		<td class="author_view"><f:checkbox path="mberAuthor" value="_view" class="form-control" checked="checked"/></td>
																		<td class="author_writing"><f:checkbox path="mberAuthor" value="_writing" class="form-control" /></td>
																		<td class="author_reply"><f:checkbox path="mberAuthor" value="_reply" class="form-control"/></td>
																		<td class="author_upload"><f:checkbox path="mberAuthor" value="_upload" class="form-control"/></td>
																		<td class="author_dwld"><f:checkbox path="mberAuthor" value="_dwld" class="form-control" checked="checked"/></td>
																	</tr>
																	<tr>
																		<th><span id="nmbrAll" style="cursor:pointer;">비회원</span></th>
																		<td class="author_list"><f:checkbox path="nmbrAuthor" value="_list" class="form-control" checked="checked"/></td>
																		<td class="author_view"><f:checkbox path="nmbrAuthor" value="_view" class="form-control" checked="checked"/></td>
																		<td class="author_writing"><f:checkbox path="nmbrAuthor" value="_writing" class="form-control" /></td>
																		<td class="author_reply"><f:checkbox path="nmbrAuthor" value="_reply" class="form-control"/></td>
																		<td class="author_upload"><f:checkbox path="nmbrAuthor" value="_upload" class="form-control"/></td>
																		<td class="author_dwld"><f:checkbox path="nmbrAuthor" value="_dwld" class="form-control" checked="checked"/></td>
																	</tr>
																</tbody>
															</table>
														</div>
													</td>
												</tr>
												<tr>
													<th>별명금지어</th>
													<td><f:textarea path="ncnmPrhibtWrd" cssClass="form-control" /></td>
												</tr>
												<tr>
													<th>본문금지어</th>
													<td><f:textarea path="bdtPrhibtWrd" cssClass="form-control" cssStyle="width:70%"/></td>
												</tr>
												<tr>
													<th>접근차단IP</th>
													<td><f:textarea path="intrcpIp" cssClass="form-control" cssStyle="width:70%"/></td>
												</tr>
												<tr>
													<th>접근허용IP</th>
													<td><f:textarea path="permIp" cssClass="form-control" cssStyle="width:70%"/></td>
												</tr>
												<tr>
													<th>반복게시 제한 시간</th>
													<td><div class="control-group ntt-img-div-time form-inline" style="padding:5px 10px;">
														<div class="form-group" style="padding:5px 10px;">
															<label for="newNttApplcPd">적용 기간 <span class="required">*</span></label>
																<f:input path="reptitNtceTime" cssClass="form-control" />초
														</div>
													</div></td>
												</tr>
											</tbody>
										</table>
									</div>
								</div>
							</div>
							</div>
						</div>
						<footer class="panel-footer">
							<div class="row">
								<div class="col-sm-6">
									<a href="../list" class="btn btn-default">목록</a>
								</div>
								<div class="col-sm-6 text-right">
									<button onclick="f_save(); return false;" class="btn btn-primary">저장</button>
								</div>
							</div>
						</footer>
					</section>
				</div>


				<div class="col-sm-3 pr-none">
					<section class="panel panel-featured panel-featured-primary">
						<header class="panel-heading">
							<div class="panel-actions">
								<a href="#" class="panel-action" onclick="f_menuSrch(); return false;" ><i class="fa fa-cogs"></i> 설정</a>
							</div>
							<h2 class="panel-title">메뉴 연결</h2>
						</header>
						<div class="panel-body">
							<table class="table table-hover" id="mnMapngTable">
								<tbody>
									<c:if test="${empty siteMenuList }">
									<tr class="emptyTr">
										<td>연결된 메뉴가 없습니다.</td>
									</tr>
									</c:if>
									<c:forEach var="menuList" items="${siteMenuList}" varStatus="menuStatus">
									<tr>
										<td>
											<input type="hidden" name="arrMenuNo" value="${menuList.menuNo }" />
											<code><small>${menuList.siteNm}</small></code>
											<br />
											${fn:replace(menuList.menuNmPath, '>Home', '홈')}
										</td>
										<td><a href="#DEL" class="badge badge-important delBtn">X</a></td>
									</tr>
									</c:forEach>
								</tbody>
							</table>
						</div>
						<footer class="panel-footer">
						</footer>
					</section>
				</div>
				</f:form>
		</div>