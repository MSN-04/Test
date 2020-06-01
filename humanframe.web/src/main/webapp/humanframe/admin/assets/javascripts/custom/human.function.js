function f_move_page (msg, page) {
    msg = (msg != "" && typeof(msg) == "string" && msg != undefined) ? msg : "";
    page = (page != undefined) ? page : "/";

    if (msg != "") {
        alert(msg);
    }
    document.location.href = page;
}

function f_eval (obj) {
	var eObj = null;
	if (obj != null) {
		eObj = eval('(' + obj + ')');
	}
	return eObj;
}

function f_exec_ajax (uri, type, dataType, param, callback, async, failCallback, args) {
	if(async === undefined) {
		async = true;
	}

    $.ajax({
          type : type
        , dataType : dataType
        , data : param
        , url : uri
        , async : async
    }).done(function (data) {
        if (typeof(callback) == "function") {
            callback(data, args);
        }
    }).fail(function (data) {
    	if (typeof(failCallback) == "function") {
    		failCallback(data, args);
        } else {
        	alert("Network Error!");
        }
    });
}

function f_ajax (cfg, args) {
	var ajax_config = {
			  uri : ""
			, type : "POST"
			, dataType : "json"
			, param : ""
			, callback : null
			, async : false
			, fail : null
			, args : args
	};
	ajax_config = $.extend(ajax_config, cfg);

	f_exec_ajax(ajax_config.uri, ajax_config.type, ajax_config.dataType, ajax_config.param, ajax_config.callback, ajax_config.async, ajax_config.fail, ajax_config.args);
}

function f_reset_below_form (element) {
	element.find("input, select, textarea").each(function () {
		var ele = $(this).get(0);
		var tagName = ele.tagName.toLowerCase();
		var tagType = $(ele).attr("type");

		if (tagName == "select") {
			$(ele).find("option").eq(0).attr("selected", "selected");
			$(ele).trigger("change");
		} else if (tagName == "input") {
			if (tagType != undefined) {
				if (tagType == "checkbox") {
					$(ele).prop("checked", false);
				} else if (tagType == "radio") {
					$(ele.attr("name")).eq(0).prop("checked", false);
				} else if (tagType == "file") {
					$(ele).replaceWith($(ele).clone(true)); // for ie.
					$(ele).val(""); // for others.
				} else {
					if ((tagType != "button") && (tagType != "submit") && (tagType != "reset")) {
						$(ele).val("");
					}
				}
			}
		} else if (tagName == "textarea") {
			$(ele).val("").trigger("keyup");
		}
	});
}

function f_do_submit(strURL, arrData, strMethod, strEnctype) {
	var objTime = new Date();
	var strFormID = "frm" + objTime.getTime();

	var formEL = $("<form />").attr("id", strFormID).attr("name", strFormID).attr("action", strURL);

	if(!strMethod) {
		strMethod = "post";
	}
	formEL.attr("method", strMethod);

	if(!strEnctype) {
		strEnctype = "application/x-www-form-urlencoded";
	}
	formEL.attr("enctype", strEnctype);

	for(index in arrData) {
		var strType = arrData[index].type;
		if(!strType) {
			strType = "hidden";
		}
		var strName = arrData[index].name;
		var strValue = arrData[index].value;
		$("<input />").attr("type", strType).attr("name", strName).val(strValue).appendTo(formEL);
	}
	formEL.appendTo("body");
	formEL.submit();
}

//parseUri 1.2.2
//(c) Steven Levithan <stevenlevithan.com>
//MIT License
function parseUri (str) {
	var	o   = parseUri.options,
		m   = o.parser[o.strictMode ? "strict" : "loose"].exec(str),
		uri = {},
		i   = 14;

	while (i--) uri[o.key[i]] = m[i] || "";

	uri[o.q.name] = {};
	uri[o.key[12]].replace(o.q.parser, function ($0, $1, $2) {
		if ($1) uri[o.q.name][$1] = $2;
	});

	return uri;
};

parseUri.options = {
	strictMode: false,
	key: ["source","protocol","authority","userInfo","user","password","host","port","relative","path","directory","file","query","anchor"],
	q:   {
		name:   "queryKey",
		parser: /(?:^|&)([^&=]*)=?([^&]*)/g
	},
	parser: {
		strict: /^(?:([^:\/?#]+):)?(?:\/\/((?:(([^:@]*)(?::([^:@]*))?)?@)?([^:\/?#]*)(?::(\d*))?))?((((?:[^?#\/]*\/)*)([^?#]*))(?:\?([^#]*))?(?:#(.*))?)/,
		loose:  /^(?:(?![^:@]+:[^:@\/]*@)([^:\/?#.]+):)?(?:\/\/)?((?:(([^:@]*)(?::([^:@]*))?)?@)?([^:\/?#]*)(?::(\d*))?)(((\/(?:[^?#](?![^?#\/]*\.[^?#\/.]+(?:[?#]|$)))*\/?)?([^?#\/]*))(?:\?([^#]*))?(?:#(.*))?)/
	}
};

/*
@filename	: jquery.popup.js
@filedesc	: open/close popup
@date		: 2015.06.10
@author		: Jinwoo.Yuk
@use
	-- open
	$.popup(true, {});
	-- close
	$.popup(false);
*/

(function ($)
{
	$.popup = function (action, config) {
		if (action) {
			var def = {
				target: "_blank",
				href: null,
				width: screen.width / 2,
				height: screen.height / 2,
				titlebar: "no",
				status: "no",
				resizable: "no",
				toolbar: "no",
				scrollbars: "yes",
				menubar: "no"
			};
			var options = $.extend(def, config);
			var posY = (parseInt(screen.height / 2)) - (parseInt(options.height / 2));
			var posX = (parseInt(screen.width / 2)) - (parseInt(options.width / 2));
			var win = window.open(options.href, options.target, 'titlebar=' + options.titlebar + ', screenX=' + posX + ', screenY=' + posY + ', left=' + posX + ', top=' + posY + ', status=' + options.status + ', resizable=' + options.resizable + ', toolbar=' + options.toolbar + ', scrollbars=' + options.scrollbars + ', menubar=' + options.menubar + ', width=' + options.width + ', height=' + options.height);

			if (win) {
				win.focus();
			}

			return false;
		} else {
			window.open("", "_self").close();
		}
	};
})(jQuery);

function f_get_current_origin_url() {
	var l = document.location.href;
	var info = parseUri(l);
	return info.protocol + "://" + info.authority;
}

function f_share_twitter(URI, text, hash) {
	URI = encodeURIComponent(f_get_current_origin_url() + URI);
	text = encodeURIComponent(text);
	hash = encodeURIComponent(hash);
	var cfg = {
		target: "twitter_share",
		href: "https://twitter.com/intent/tweet?url=" + URI + "&text=" + text + "&hashtags=" + hash,
		width: 780,
		height: 448,
	};
	$.popup(true, cfg);
}

function f_share_facebook(URI, text) {
	URI = encodeURIComponent(f_get_current_origin_url() + URI);
	text = encodeURIComponent(text);
	var cfg = {
		target: "facebook_share",
		href: "http://www.facebook.com/sharer.php?u=" + URI + "&t=" + text,
		width: 626,
		height: 436,
	};
	$.popup(true, cfg);
}

function f_share_google_plus(URI) {
	URI = encodeURIComponent(f_get_current_origin_url() + URI);
	var cfg = {
		target: "google_share",
		href: "https://plus.google.com/share?url=" + URI,
		width: 496,
		height: 460,
	};
	$.popup(true, cfg);
}

/**
 * 문서변환 스크립트
 */
function f_filePreivew(srvcId, upperNo, fileTy, fileNo){
	$.ajax({
		type : "POST",
		url : "/comm/docPreview",
		data : {
			"srvcId" : srvcId,
			"upperNo" : upperNo,
			"fileTy" : fileTy,
			"fileNo" : fileNo
		},
		success: function(resultMap) {
			if(resultMap){

				// 문서 변환 성공
				if(resultMap.resultCode == 0){
					window.open(resultMap.resultPage);

				// 파일이 없을 경우
				}else if(resultMap.resultCode == 999){
					alert("첨부파일이 존재하지 않습니다.");
				}else{
					alert("지원하지 않는 파일입니다.");
				}


			}else{
				alert("문서변환중 오류가 발생하였습니다.");
			}
		}
	});
}

// 체크박스 전체 선택
$(function(){
    $("#humanCheckall").click(function(){
        var chk = $(this).is(":checked");
        if(chk) $(".table input").prop('checked', true);
        else  $(".table input").prop('checked', false);
    });
});