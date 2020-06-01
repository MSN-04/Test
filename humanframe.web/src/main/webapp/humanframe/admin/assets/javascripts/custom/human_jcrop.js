var jcropApi;
var boxMaxWidth = 600;
var boxMaxHeight = 400;

var thumbObj = {

		initCropDiv : function(imgSrc){
			var cropDivTag = '<img alt="이미지편집" id="cropImg" src="' + imgSrc + '"/>';
			return cropDivTag;
		},

		initPreviewDiv : function(imgSrc){
			var previewDivTag = '<div id="preview-pane" style="display:' + ($(':radio[name="thumbType"]:checked').val() == "org" ? "none" : "block") + ';">';
				  previewDivTag += '<div class="preview-container"><img src="' + imgSrc + '" class="jcrop-preview" alt="Preview" /></div></div>';
			return previewDivTag;
		},

		thumbTypeChk : function(){

			if($(':radio[name="thumbType"]:checked').val() == "org")
			{
				jcropApi.release();
				jcropApi.disable();
			}
		}
};

function f_ShowImg()
{
	if($(':radio[name="thumbType"]:checked').val() == "org")
	{
		$("[id^=preview-pane]").hide();
		jcropApi.release();
		jcropApi.disable();
	}
	else
	{
		$("[id^=preview-pane]").show();
		jcropApi.enable();
		jcropApi.animateTo([0,0,400,300]);
	}
}

function f_ThumbnailFileChk(){

	var fileNm = $("#mediaThumbFile").val();
	var fileExt = fileNm.substring(fileNm.lastIndexOf(".") + 1);

	var reg = /gif|jpg|jpeg|png|bmp/i;

	if(reg.test(fileExt) == false)
	{
		alert("썸네일이미지는 확장자가 gif, jpg, png, bmp로 된\n파일만 첨부 가능합니다.");
		$("#mediaThumbFile").val('');
		return false;
	}

	return true;
}


function f_ImgPreview() {

	var formData = new FormData();
	formData.append("mediaThumbFile", $("input[name=mediaThumbFile]")[0].files[0]);

	if(f_ThumbnailFileChk())
	{

		$.ajax({
	        url: '/admin/ajax/media/imgUploadAjax.json',
	        type: "post",
	        dataType: "text",
	        data: formData,
	        // cache: false,
	        processData: false,
	        contentType: false,
	        success : function(result) {
	        	var jsonObj = JSON.parse(result);
	        	f_ChangeImg(jsonObj.thumbPath, jsonObj.thumbImgNm);
	        	$(".thumbEdit").show();
	        }, error : function(e){
				alert(e.messages);
			}
	    });

	}
}

function f_ChangeImg(filePath, fileNm)
{
	console.log(filePath+fileNm);
	$(".cropDiv").empty();
	$(".cropDiv").append(thumbObj.initCropDiv(filePath + fileNm));
	$("#thumbOrgFileNm").val(fileNm);
	$("#cropImg").attr("src", filePath + fileNm);
	$("#cropImg").append(thumbObj.initPreviewDiv(filePath + fileNm));

	if(typeof(jcropApi) == "object")
	{
		jcropApi.destroy();
	}

	var $preview = $('#preview-pane');
	var $pcnt = $('#preview-pane .preview-container');
	var $pimg = $('#preview-pane .preview-container img');
	var xsize = $pcnt.width();
	var ysize = $pcnt.height();

	$('#cropImg').Jcrop({
		onChange: updatePreview
		, onSelect: updatePreview
	    , onRelease:  clearCoords
	    , aspectRatio: xsize / ysize
	    , boxWidth: boxMaxWidth
	    , boxHeight: boxMaxHeight

    },function(){
      bounds = this.getBounds();
      boundx = bounds[0];
      boundy = bounds[1];

      jcropApi = this;
      thumbObj.thumbTypeChk();
      $preview.appendTo(jcropApi.ui.holder);
    });

    function updatePreview(c)
    {
      if (parseInt(c.w) > 0)
      {
        var rx = xsize / c.w;
        var ry = ysize / c.h;

        $pimg.css({
          width: Math.round(rx * boundx) + 'px',
          height: Math.round(ry * boundy) + 'px',
          marginLeft: '-' + Math.round(rx * c.x) + 'px',
          marginTop: '-' + Math.round(ry * c.y) + 'px'
        });

        $('#thumbStartWidth').val(parseInt(c.x));
        $('#thumbStartHeight').val(parseInt(c.y));
        $('#thumbEndWidth').val(parseInt(c.w));
        $('#thumbEndHeight').val(parseInt(c.h));
      }
    };

    function clearCoords()
    {
    	$('#thumbStartWidth').val('0');
        $('#thumbStartHeight').val('0');
        $('#thumbEndWidth').val('0');
        $('#thumbEndHeight').val('0');
    };
}