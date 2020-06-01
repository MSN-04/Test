$(function() {

	window.trim = function(txt) {
		return txt.replace(/(^\s*)|(\s*$)/gi, "");
	};

	/** 도로명 주소(www.juso.go.kr) URL팝업 연계 관련 주소검색#1; 팝업 페이지 호출 **/
	var objectAddr = "";
	window.fn_searchAddress = function(id) {
		objectAddr = $('#'+id);
		var url = "/comm/searchAddress";
		var name = "SearchAddress";
		var option = "width=570, height=420, top=100, left=100, fullscreen=no, menubar=no, status=no, toolbar=no, titlebar=yes, location=no, resizable=yes, scrollbars=yes";
		window.open(url, name, option);
	};

	/** 도로명 주소(www.juso.go.kr) URL팝업 연계 관련 주소검색#2; 팝업 페이지 정보 입력 및 등록 **/
	window.fn_jusoCallBack = function(
			roadFullAddr,	// 전체 도로명주소
			roadAddrPart1,	// 도로명주소; 기본
			addrDetail,		// 사용자 입력 상세주소
			roadAddrPart2,	// 참고주소
			engAddr,		// 도로명주소; 영문
			jibunAddr,		// 지번주소
			zipNo			// 우편번호
			) {
		var addr1 = roadAddrPart1;
		var addr2 = (trim(addrDetail) != "") ? ", " + addrDetail : "";
		var addr3 = (trim(roadAddrPart2) != "") ? " " + roadAddrPart2: "";
		var fullAddr = "(" + zipNo + ") " + addr1 + addr2 + addr3;
		objectAddr.val(trim(fullAddr));
	};
});

/*
 * 	example
 *
 * <select id="selectSiteMenu" name="selectSiteMenu" class="input-small">
 *		<option value="">사이트 선택</option>
 * </select>
 *
 * 	$(function() {
 *		f_createMenuSelectbox('selectSiteMenu', 'srchMenuNo');
 *	});
 *
 * 실행시 입력받은 inputId의 이름으로 target앞에 hidden 생성
 */
var g_menuData = [];
var g_menuSelectedData = [];
function f_createMenuSelectbox(target, inputId, compressMenus){
	var targetSelectBox = $("#" + target);

	$.ajax({
		type : "post",
		url: '/admin/site/siteMenu.json',
		dataType: 'json',
		contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
		success: function(data) {
			//console.log('data: ' + data.siteMenuListAll.length);
			$.each(data.siteMenuListAll, function(index, value){
				//console.log("index :: " + index + ": " + value.siteNo);
				if(value.siteMenuList.length > 1){
					$.each(value.siteMenuList, function(index, value){
						//console.log("menu :: " + value.menuNo + ": " + value.menuNo + ": " + value.levelNo);
						g_menuData.push(value);
					});
				}
				targetSelectBox.append($("<option></option>").attr("value", value.siteNo).text(value.siteNm));
			});

			targetSelectBox.bind("change", function() {
				// 값 저장
				var $targetInput = $("#" + inputId);
				var selVal = $("select[name=" + target + "] option:selected").val();
				if ($targetInput.length > 0) {
					var $targetInputVal = $targetInput.val();
					var arrTargetInputVal = ($.trim($targetInputVal) != "") ? $targetInputVal.split("^") : null;
					if (arrTargetInputVal != null) {
						if (arrTargetInputVal != selVal) {
							$targetInput.val("");
						}
					}
					$targetInput.val(selVal);
				} else {
					$("<input type='hidden' id='" + inputId + "' name='" + inputId + "' value='" + selVal + "' />").insertBefore(targetSelectBox);
				}

				// 하위 <select> 생성
				f_addMenuSelectbox(targetSelectBox, selVal, "", 2, inputId);
			});

			if (compressMenus != null && compressMenus != undefined) {
				g_menuSelectedData = compressMenus.split("^");
				f_decompressMenuSelectBox(target);
			}
		},
		error: function(data, status, err) {
			//console.log('error forward : ' + data);
		}
	});
}


function f_addMenuSelectbox(target, siteNo, menuNo, levelNo, inputId){
	var selName = "selMenu_"+ levelNo;
	var nextSelName = selName;
	if ($.trim(menuNo) != "" && menuNo != null && menuNo != undefined) {
		nextSelName += "_" + menuNo;
	}

	$("select[name^="+ selName +"]").nextAll("select").remove();
	$("select[name^="+ selName +"]").remove();
	if(siteNo != ""){
		optTxt = menuNo != "" ? (levelNo + "DEPTH 메뉴선택") : "메뉴선택";

    	target.after("<select id='" + nextSelName + "' name='" + nextSelName + "' class='form-control' style='margin-left:5px'><option value=''>" + optTxt + "</option></select>");
    	var cnt = 0;
    	$.each(g_menuData, function(index, value){
    		if (siteNo == value.siteNo && levelNo == value.levelNo) {
        		//console.log("index !! " + index + ": " + value.menuNo + ": " + value.menuNm);
        		if (menuNo != "" && value.upperMenuNo == menuNo) {
        			cnt++;
        			$("#" + nextSelName).append($("<option></option>").attr("value", value.menuNo).text(value.menuNm));
        		} else if (menuNo == "") {
        			cnt++;
        			$("#" + nextSelName).append($("<option></option>").attr("value", value.menuNo).text(value.menuNm));
        		}
    		}
    	});
    	
    	if(cnt == 0){
    		$("select[name^="+ nextSelName +"]").remove()
    	} else  {
    		$("#" + nextSelName).bind("change", function(){
				var $targetInput = $("#" + inputId); 
				
				var $targetInputVal = $targetInput.val();
				var arrTargetInputVal = ($.trim($targetInputVal) != "") ? $targetInputVal.split("^") : null;
				var selVal = $("select[name=" + nextSelName + "] option:selected").val();
				if (arrTargetInputVal != null) {
					if (arrTargetInputVal[levelNo] != selVal) {
						$targetInput.val("");
						for (var i = 0, iCnt = levelNo - 1 ; i < iCnt ; i++) {
							if (i == 0) {
								$targetInput.val(arrTargetInputVal[0]);
							} else {
								$targetInput.val($targetInput.val() + "^" + arrTargetInputVal[i]);
							}
						}
					}
				}
    			if ($(this).val() != "") {
    				$targetInput.val($targetInput.val() + "^" + selVal);
    				f_addMenuSelectbox($("#" + nextSelName), siteNo, $("select[name=" + nextSelName + "] option:selected").val(), (levelNo + 1), inputId);
    			} else{
    				$("select[name^="+ selName +"]").nextAll("select").remove();
    			}
			});
    	}

		$("#" + nextSelName + " > option").each(function (index, opt) {
			var $entity = $(opt);
			if (g_menuSelectedData[levelNo - 1] == $entity.val()) {
				$entity.attr("selected", "selected");
				$("#" + nextSelName).trigger("change");
				return false;
			}
		});
	}
}

function f_decompressMenuSelectBox(target) {
	$("#" + target + " > option").each(function (index, opt) {
		var $entity = $(opt);
		if (g_menuSelectedData[0] == $entity.val()) {
			$entity.attr("selected", "selected");
			$("#" + target).trigger("change");
			return false;
		}
	});
}