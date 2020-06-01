var smEditor = {
		oEditors : []
		, init : function(editorId){ //초기화
			nhn.husky.EZCreator.createInIFrame({
				oAppRef: smEditor.oEditors,
				elPlaceHolder: editorId,
				htParams: { fOnBeforeUnload : function(){}}
			});
		}
		, getVal : function(editorId){ //에디터 값
			return smEditor.oEditors.getById[editorId].getIR();
		}
		, setVal : function(editorId, value){ //에디터 값 수정
			smEditor.oEditors.getById[editorId].exec("PASTE_HTML", [value]);
		}
		, clearAll : function(editorId){ //에디터 값 초기화 - 부산의료관광
			smEditor.oEditors.getById[editorId].exec("SET_IR", [""]);
		}
		, submit : function(editorId){ //에디터에 있는 값을 Textarea로
			smEditor.oEditors.getById[editorId].exec("UPDATE_CONTENTS_FIELD", []);
		}
		, getMode : function(editorId){ //에디터 현재 활성 모드 : {Editor 모드 : WYSIWYG, HTML 모드 : HTMLSrc, TEXT 모드 : TEXT}
			return smEditor.oEditors.getById[editorId].getEditingMode();
		}
		, autoWidth : function(editorId){ // 자동 크기 조절
			$("#ifrm_" + editorId).css("height", parseInt($("#ifrm_" + editorId).contents().find('html').height() + 12));
		}
}

if(typeof window.nhn=='undefined') window.nhn = {};
if (!nhn.husky) nhn.husky = {};

/**
 * @fileOverview This file contains application creation helper function, which would load up an HTML(Skin) file and then execute a specified create function.
 * @name HuskyEZCreator.js
 */
nhn.husky.EZCreator = new (function(){
	this.nBlockerCount = 0;

	this.createInIFrame = function(htOptions){
		if(arguments.length == 1){
			var oAppRef = htOptions.oAppRef;
			var elPlaceHolder = htOptions.elPlaceHolder;
			var sSkinURI = "/humanframe/admin/assets/smarteditor/SmartEditor2Skin.html";
			var fCreator = "createSEditor2";
			var fOnAppLoad = htOptions.fOnAppLoad;
			var bUseBlocker = htOptions.bUseBlocker;
			var htParams = htOptions.htParams || null;
		}else{
			// for backward compatibility only
			var oAppRef = arguments[0];
			var elPlaceHolder = arguments[1];
			var sSkinURI = arguments[2];
			var fCreator = arguments[3];
			var fOnAppLoad = arguments[4];
			var bUseBlocker = arguments[5];
			var htParams = arguments[6];
		}

		if(bUseBlocker) nhn.husky.EZCreator.showBlocker();

		var attachEvent = function(elNode, sEvent, fHandler){ 
			if(elNode.addEventListener){
				elNode.addEventListener(sEvent, fHandler, false);
			}else{
				elNode.attachEvent("on"+sEvent, fHandler);
			}
		} 

		if(!elPlaceHolder){
			alert("Placeholder is required!");
			return;
		}
		
		var elPlaceHolderId = elPlaceHolder;

		if(typeof(elPlaceHolder) != "object")
			elPlaceHolder = document.getElementById(elPlaceHolder);

		var elIFrame, nEditorWidth, nEditorHeight;
		 
		 
		try{
			elIFrame = document.createElement("<iframe frameborder=0 scrolling=no id=\"ifrm_" + elPlaceHolderId + "\">");
		}catch(e){
			elIFrame = document.createElement("iframe");
			elIFrame.setAttribute("frameborder", "0");
			elIFrame.setAttribute("scrolling", "no");
			elIFrame.setAttribute("id", "ifrm_" + elPlaceHolderId);
		}
		
		elIFrame.style.width = "1px";
		elIFrame.style.height = "1px";
		elPlaceHolder.parentNode.insertBefore(elIFrame, elPlaceHolder.nextSibling);
		
		attachEvent(elIFrame, "load", function(){
			fCreator = elIFrame.contentWindow[fCreator] || elIFrame.contentWindow.createSEditor2;
			
//			top.document.title = ((new Date())-window.STime);
//			window.STime = new Date();
			
			try{
			
				nEditorWidth = elIFrame.contentWindow.document.body.scrollWidth || "500px";
				nEditorHeight = elIFrame.contentWindow.document.body.scrollHeight + 12;
				elIFrame.style.width =  "100%";
				elIFrame.style.height = nEditorHeight+ "px";
				elIFrame.contentWindow.document.body.style.margin = "0";
			}catch(e){
				nhn.husky.EZCreator.hideBlocker(true);
				elIFrame.style.border = "5px solid red";
				elIFrame.style.width = "500px";
				elIFrame.style.height = "500px";
				alert("Failed to access "+sSkinURI);
				return;
			}
			
			var oApp = fCreator(elPlaceHolder, htParams);	// oEditor
			

			oApp.elPlaceHolder = elPlaceHolder;

			oAppRef[oAppRef.length] = oApp;
			if(!oAppRef.getById) oAppRef.getById = {};
			
			if(elPlaceHolder.id) oAppRef.getById[elPlaceHolder.id] = oApp;

			oApp.run({fnOnAppReady:fOnAppLoad}); 
			
//			top.document.title += ", "+((new Date())-window.STime);
			nhn.husky.EZCreator.hideBlocker();
			
		});
//		window.STime = new Date();
		elIFrame.src = sSkinURI;
		this.elIFrame = elIFrame;
	};
	
	this.showBlocker = function(){
		if(this.nBlockerCount<1){
			var elBlocker = document.createElement("DIV");
			elBlocker.style.position = "absolute";
			elBlocker.style.top = 0;
			elBlocker.style.left = 0;
			elBlocker.style.backgroundColor = "#FFFFFF";
			elBlocker.style.width = "100%";

			document.body.appendChild(elBlocker);
			
			nhn.husky.EZCreator.elBlocker = elBlocker;
		}

		nhn.husky.EZCreator.elBlocker.style.height = Math.max(document.body.scrollHeight, document.body.clientHeight)+"px";
		
		this.nBlockerCount++;
	};
	
	this.hideBlocker = function(bForce){
		if(!bForce){
			if(--this.nBlockerCount > 0) return;
		}
		
		this.nBlockerCount = 0;
		
		if(nhn.husky.EZCreator.elBlocker) nhn.husky.EZCreator.elBlocker.style.display = "none";
	}
})();