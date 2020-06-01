<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<meta http-equiv="Content-Style-Type" content="text/css">
<title>:: 사진 첨부하기 ::</title>

<link type="text/css" rel="stylesheet" href="/humanframe/global/assets/smarteditor/css/smart_editor2_uploader.css"/>
<script type="text/javascript" src="/humanframe/global/assets/script/jquery-3.1.1.min.js"></script>

<script type="text/javascript" charset="UTF-8">
//<![CDATA[
$(document).ready(function() {
	window.fn_photoUpload = function(tempFile) {
		var formData = new FormData();
		formData.append('dir', 'smartEditor');
    	formData.append('files', tempFile);
    	jQuery.ajax({
		    url: "/comm/editor/uploadFile",
		    type: "post",
		    data: formData,
		    processData: false,
		    contentType: false,
		    dataType: 'json',
		    async: false,
		    success: function(data) {
		    	if (data != null & data != undefined) {
		    		var params = new Array();
		    		params.push("bNewLine=true^sFileName=" + data.realname[0] + "^sFileURL=/ImagePrint.do?");
		    		params.push("dir|smartEditor&savename|" + data.savename[0] + "&realname|" + data.realname[0].toString().replace(" ", ""));
		    		params.push("&fileext|" + data.fileext[0] + "&filetype|" + data.filetype[0] + "&filesize|" + data.filesize[0]);
		    		makeArrayFromString(params.join(""));
		    	}
		    },
		    error: function() {
		    	jindo.$Fn(onAjaxError, this).bind();
		    }
		});
	};
});
//]]>
</script>
</head>
<body>
<div id="pop_wrap">
	<!-- header -->
    <div id="pop_header">
        <h1>사진 첨부하기</h1>
    </div>
    <!-- //header -->
    <!-- container -->

    <!-- [D] HTML5인 경우 pop_container 클래스와 하위 HTML 적용
	    	 그밖의 경우 pop_container2 클래스와 하위 HTML 적용      -->
	<div id="pop_container2" class="pop_container2">
    	<!-- content -->
		<form id="editor_upimage" name="editor_upimage" action="/UploadFile.do" method="post" enctype="multipart/form-data" onSubmit="return false;">
			<input type="hidden" name="dir" value="smartEditor">
        <div id="pop_content2">
			<input type="file" class="upload" id="uploadInputBox" name="files">
            <p class="dsc" id="info"><strong>10MB</strong>이하의 이미지 파일만 등록할 수 있습니다.<br>(JPG, GIF, PNG, BMP)</p>
        </div>
		</form>
        <!-- //content -->
    </div>
    <div id="pop_container" class="pop_container" style="display:none;">
    	<!-- content -->
        <div id="pop_content">
	        <p class="dsc"><em id="imageCountTxt">0장</em>/10장 <span class="bar">|</span> <em id="totalSizeTxt">0MB</em>/50MB</p>
        	<!-- [D] 첨부 이미지 여부에 따른 Class 변화
            	 첨부 이미지가 있는 경우 : em에 "bg" 클래스 적용 //첨부 이미지가 없는 경우 : em에 "nobg" 클래스 적용   -->

            <div class="drag_area" id="drag_area">
				<ul class="lst_type" >
				</ul>
            	<em class="blind">마우스로 드래그해서 이미지를 추가해주세요.</em><span id="guide_text" class="bg"></span>
            </div>
			<div style="display:none;" id="divImageList"></div>
            <p class="dsc dsc_v1"><em>한 장당 10MB, 1회에 50MB까지, 10개</em>의 이미지 파일을<br>등록할 수 있습니다. (JPG, GIF, PNG, BMP)</p>
        </div>
        <!-- //content -->
    </div>

    <!-- //container -->
    <!-- footer -->
    <div id="pop_footer">
	    <div class="btn_area">
            <a href="#"><img src="/humanframe/global/assets/smarteditor/img/photoQuickPopup/btn_confirm.png" width="49" height="28" alt="확인" id="btn_confirm"></a>
            <a href="#"><img src="/humanframe/global/assets/smarteditor/img/photoQuickPopup/btn_cancel.png" width="48" height="28" alt="취소" id="btn_cancel"></a>
        </div>
    </div>
    <!-- //footer -->
</div>

<script type="text/javascript" src="/humanframe/global/assets/smarteditor/photo_uploader/popup/jindo.min.js" charset="utf-8"></script>
<script type="text/javascript" src="/humanframe/global/assets/smarteditor/photo_uploader/popup/jindo.fileuploader.js" charset="utf-8"></script>
<script type="text/javascript" src="/humanframe/global/assets/smarteditor/photo_uploader/popup/attach_photo.js" charset="utf-8"></script>

</body>
</html>