$(document).ready(function(){

})

var navigation = {
	$gnbMenu:null,
	$menuItems:null,
	$selectMenuItme:null,

	//요소초기화
	init:function(){
		this.$gnbMenu = $('.gnb li');
		this.$menuItems = this.$gnbMenu.find('>a')
	},

	initEvent:function(){
		var	Width = window.innerWidth || document.documentElement.clientWidth || document.body.clientWidth;
		var objThis = this;
		if(Width < 1199){

		} else if(Width > 1199){
			this.$menuItems.on('mouseleave focusin',function(){
				if($('header').hasClass('on')){

				} else{
					$('header').addClass('on');
				}
			})
		}
		
	}
}