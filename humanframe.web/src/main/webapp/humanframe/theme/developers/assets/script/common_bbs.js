
/**
 * 트랙백 URL 클립보드에 복사
 */
function f_ClipUrl(loc){
	var IE=(document.all) ? true : false;
	if (IE) {
    	window.clipboardData.setData('Text',loc);
    	alert("트랙백 URL이 클립보드에 복사되었습니다!\n트랙백을 지원하는 모든 블로그에 트랙백 또는 엮인글에 주소를 넣고 작성하시면 됩니다.");
	}
	else {
		temp = prompt("이 글의 트랙백 주소입니다. Ctrl+C를 눌러 클립보드로 복사하세요", loc);
	}
}

/**
 * 비밀번호 입력 Dialog
 */
function f_showPasswordDialog(goUrl, bbsNo, nttNo, actionTy) {

	$('#actionTy').val(actionTy);
	$('#bbsNo').val(bbsNo);
	$('#nttNo').val(nttNo);
	$('#bbsPasswordChkFrm').attr('action', goUrl);
	$('#password').val('');

	$("#inputPassword").dialog({
    	modal: true
    	, title: "비밀번호 입력"
    	, resizable : false
    	, width : 450
    });
}

/**
 * 비밀번호 조회
 */
function f_bbsPasswordChk() {
	var password = $('#password').val();
	if($.trim(password) == "") {
		alert($("#password").prop("title") + "은(는) 필수 입력값입니다.");
		return false;
	}

	$.ajax({
    	url: '/ajax/bbs/bbsPasswordChk.json',
		data : $('#bbsPasswordChkFrm').serialize(),
		type : 'POST',
        success: function(result) {
			if(result) {
				var actionTyVal = $('#actionTy').val();
				// 삭제일 경우 삭제 ajax 한번 더 호출
				if(actionTyVal == 'DELETE') {
					f_deleteNtt();
				} else {
					$('#bbsPasswordChkFrm').submit();
				}
			} else {
				$("#password").focus();
				alert("비밀번호가 일치 하지 않습니다.");
			}
        }
    });
}

/**
* 게시글 삭제
*/
function f_deleteNtt() {
	$.ajax({
    	url: '/ajax/bbs/deleteNtt.json',
		data : $('#bbsPasswordChkFrm').serialize(),
		type : 'POST',
        success: function(result) {
			alert(result.message);
			$('#bbsPasswordChkFrm').submit();
        }
    });
}

/**
* 게시글 삭제(회원)
*/
function f_deleteNttMber() {
	if( confirm("삭제 하시겠습니까?") ) {
		$("#frmNtt > #crud").val("DELETE");
		$("#frmNtt").attr("action", "action").submit();
	}
}

/**
 * 게시글 줄바꿈
 */
function nl2br(str) {
	return str.replace(/\n\r/g,'<br>');
}