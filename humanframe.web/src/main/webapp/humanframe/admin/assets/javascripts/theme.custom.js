/* Add here all your JS customizations */


/*
Modal Dismiss
*/
$(document).on('click', '.modal-dismiss', function (e) {
	e.preventDefault();
	$.magnificPopup.close();
});

/*
Modal Confirm
*/
$(document).on('click', '.modal-confirm', function (e) {
	e.preventDefault();
	$.magnificPopup.close();
});

/*
 *  .cn-wrapper 클래스 사용시 panel-body보다 사이즈 클경우
 *  max-width panel-body 보다 작게함(콘텐츠, 게시판 상세사용)
 */
$(document).ready(function (){
	var regex = /[^0-9.]/g;
	var widthFix = $(".panel-body").css('width').replace(regex,'')-140;
	$(".cn-wrapper *").each(function(){
		var text = $(this).css('width').replace(regex,'');
		if( text > widthFix ){
			$(".cn-wrapper *").css('max-width', (text-(text-widthFix)));
		}
	});
})

$(window).resize(function() {
	var regex = /[^0-9.]/g;
	var widthFix = $(".panel-body").css('width').replace(regex,'')-140;
	$(".cn-wrapper *").each(function(){
		var text = $(this).css('width').replace(regex,'');
		if( text > widthFix ){
			$(".cn-wrapper *").css('max-width', (text-(text-widthFix)));
		}
	});
});