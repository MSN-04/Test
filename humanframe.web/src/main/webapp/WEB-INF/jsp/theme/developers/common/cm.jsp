<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp" %>
<%@ page trimDirectiveWhitespaces="true" %>

		<div class="post-block post-comments clearfix ${param.mapngAt}-comments-wrap">
			<h3 class="heading-primary"><i class="fa fa-comments"></i>Comments <span class="${param.mapngAt}-comments-cnt"></span></h3>

			<ul class="comments">
				<li class="hidden tmplat">
					<div class="comment">
						<div class="img-thumbnail">
							<img class="avatar" alt="" src="">
						</div>
						<div class="comment-block">
							<div class="comment-arrow"></div>
							<span class="comment-by">
								<strong>.</strong>
								<span class="date pull-right">2017-12-27 21:23</span>
							</span>
							<p>...</p>
							<span class="pull-right">
								<span class="delete"> <a href="#" data-toggle="confirmation" data-title="삭제하시겠습니까?"><i class="fa fa-remove"></i> Delete</a></span>
							</span>
						</div>
					</div>
				</li>
			</ul>
			<button class="btn btn-block btn-primary" type="button" onclick="getCmList('more');return false;" style="display:hidden">read more</button>
		</div>

		<div class="post-block post-leave-comment ${param.mapngAt}-comments-post">
			<h3 class="heading-primary">Leave a comment</h3>

			<form id="cmFrm" name="cmFrm" method="post">
				<input type="hidden" name="crud" id="crud" value="CREATE" />
				<input type="hidden" name="mapngAt" value="${param.mapngAt }" />
				<input type="hidden" name="siteNo" value="${curMenuVO.siteNo }"/>
				<input type="hidden" name="menuNo" value="${curMenuVO.menuNo }"/>
				<c:choose>
				<c:when test="${param.mapngAt eq 'bbs' }">
				<input type="hidden" name="bbsNo" value="${bbsTypeVO.bbsNo }"/>
				<input type="hidden" name="nttNo" value="${bbsTypeVO.nttNo }"/>
				</c:when>
				<c:when test="${param.mapngAt eq 'cntnts' }">
				<c:choose>
				<c:when test="${not empty param.cntntsNo}">
				<input type="hidden" name="cntntsNo" value="${param.cntntsNo }"/>
				</c:when>
				<c:otherwise>
				<input type="hidden" name="cntntsNo" value="${article.cntntsNo }"/>
				</c:otherwise>
				</c:choose>
				</c:when>
				</c:choose>
				<input type="hidden" name="siteNm" value="${curSiteVO.siteNm }"/>
				<input type="hidden" name="menuNmPath" value="${curMenuVO.menuNmPath }"/>
				<input type="hidden" name="cmUrl" value="${uriPath }"/>
				<input type="hidden" name="curPage" value="1"/>
				<input type="hidden" name="cntPerPage" value="5"/>
				<input type="hidden" name="totalPage" value=""/>
				<input type="hidden" name="loginAt" value="${HUMAN_MEMBER ne null}"/>
				<c:if test="${HUMAN_MEMBER eq null }">
				<div class="row">
					<div class="form-group">
						<div class="col-md-4">
							<label for="cm-wrter">Your name *</label>
							<input type="text" value="" maxlength="100" class="form-control" name="wrter" id="cm-wrter" autocomplete="off">
						</div>
						<div class="col-md-4">
							<label for="cm-emailAdres">Your email address *</label>
							<input type="email" value="" maxlength="100" class="form-control" name="emailAdres" id="cm-emailAdres" autocomplete="off">
						</div>
						<div class="col-md-4">
							<label for="cm-password">Your password *</label>
							<input type="password" value="" maxlength="100" class="form-control" name="password" id="cm-password" autocomplete="off">
						</div>
					</div>
				</div>
				</c:if>
				<div class="row">
					<div class="form-group">
						<div class="col-md-12">
							<label for="cm-cn">Comment *</label>
							<textarea maxlength="20000" rows="3" class="form-control" name="cn" id="cm-cn"></textarea>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-md-12">
						<input type="submit" value="Post Comment" class="btn btn-primary btn-lg">
					</div>
				</div>
			</form>
		</div>

<script>
$(function() {

	$(".${param.mapngAt}-comments-post form[name='cmFrm']").validate({
	    ignore: "input[type='text']:hidden",
	    rules : {
	    	crud		: { required : true },
// 	    	mapngAt     : { required : true },
	    	siteNo		: { required : true },
	    	menuNo		: { required : true },
	    	<c:choose>
	    	<c:when test="${param.cm_mapng eq 'bbs' }">
	    	bbsNo		: { required : true },
	    	nttNo		: { required : true },
	    	</c:when>
	    	<c:when test="${param.cm_mapng eq 'cntnts' }">
	    	cntntsNo	: { required : true },
	    	</c:when>
	    	</c:choose>
	    	siteNm		: { required : true },
	    	menuNmPath	: { required : true },
	    	cmUrl		: { required : true },
	    	wrter		: { required : function(){ return $("input[name='loginAt']").val() == "false"; }},
	    	emailAdres	: { required : true, email : true},
	    	password	: { required : function(){ return $("input[name='loginAt']").val() == "false"; }, minlength: 8},
	    	cn			: { required : true, minlength: 10, maxlength: 10000}
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
			$.ajax({
				url: "/ajax/cmAction.json",
				type: "post",
				data: $(".${param.mapngAt}-comments-post form[name='cmFrm']").serialize(),
				success: function(data){
					getCmList('new');
				},
				error: function(xhr, status, err){
					alert("[error] " + ":" + err + "(" + status + ")" + xhr);
				}
			});

			return false;
	    }
	});

	getCmList('');

	$(document).on('click','.comment-block .delete', function (e) {
		e.preventDefault();
		if(confirm('삭제하시겠습니까?')){
			var cmNo = $(this).closest('.comment-block').data('comments-no');
			$.ajax({
				url: '/ajax/cmAction.json',
				type: 'post',
				data: 'crud=DELETE&loginAt=true&cmNo='+cmNo,
				success: function(data){
					if(data.process==1){
						$.each($(".comment-block"),function(){
							if(cmNo == $(this).data('comments-no')){
								$(this).closest("li").fadeOut(function(){
									$(this).remove();
								})
							}
						});
					} else {
						alert(data.msg);
					}
				}
			})
		}
	});

});

function getCmList(mode){
	$(".${param.mapngAt}-comments-post input[name='crud']").val("READ");
	if(mode == "new"){ resetCmList(); }
	$.ajax({
		url : '/ajax/getCmList.json',
		type: "post",
		data: $(".${param.mapngAt}-comments-post form[name='cmFrm']").serialize(),
		success: function(data){
			resetCmFrm();
			$(".${param.mapngAt}-comments-post input[name='crud']").val("CREATE");
			$(".${param.mapngAt}-comments-wrap button.btn").prop("disabled",false);

			if(data.list.totalCount>0){
				$(".${param.mapngAt}-comments-wrap span.menu-comments-cnt").text("("+data.list.totalCount+")");
				$(".${param.mapngAt}-comments-post input[name='curPage']").val(data.list.curPage+1);
			} else {
				$(".${param.mapngAt}-comments-wrap span.menu-comments-cnt").text("");
				$(".${param.mapngAt}-comments-post input[name='curPage']").val(1);
			}

			if(data.list.curPage < data.list.totalPage){
				$(".${param.mapngAt}-comments-wrap button.btn").show();
			} else {
				$(".${param.mapngAt}-comments-wrap button.btn").hide();
			}

			for(var oname in data.list.listObject){
				var cloning = $(".${param.mapngAt}-comments-wrap .comments .tmplat").clone();
				cloning.removeClass("hidden tmplat");
				cloning.find(".comment-by .date").text(data.list.listObject[oname].creatDttm); //date
				if(data.list.listObject[oname].hideAt=='N'){
					cloning.find(".comment-by strong").text(data.list.listObject[oname].wrter); //author
					cloning.find(".comment-block p").text(data.list.listObject[oname].cn);
				} else {
					cloning.find(".comment-by strong").text("*blind*").addClass("text-muted"); //author
					cloning.find(".comment-block p").text("관리자에 의해 블라인드 처리된 댓글입니다.").addClass("text-muted");
				}
				if(data.list.listObject[oname].usrMd5!=undefined){
					cloning.find(".img-thumbnail .avatar").attr("src","https://www.gravatar.com/avatar/"+data.list.listObject[oname].usrMd5+"?d=monsterid&amp;f=y");
				}
				if(!data.list.listObject[oname].isMine){
					cloning.find(".comment-block .delete").remove();
				}
				cloning.find(".comment-block").data('comments-no',data.list.listObject[oname].cmNo);
				cloning.appendTo(".${param.mapngAt}-comments-wrap .comments");
			}
		}
	})
}

function resetCmList(){
	$(".${param.mapngAt}-comments-post input[name='curPage']").val(1);
	$(".${param.mapngAt}-comments-wrap button.btn").prop("disabled",true);
	$(".${param.mapngAt}-comments-wrap button.btn").hide();
	$(".${param.mapngAt}-comments-wrap .comments li").not(".tmplat").remove();
}

function resetCmFrm(){
	$(".${param.mapngAt}-comments-post form[name='cmFrm']").find("input[type='text']").val("");
	$(".${param.mapngAt}-comments-post form[name='cmFrm']").find("input[type='password']").val("");
	$(".${param.mapngAt}-comments-post form[name='cmFrm']").find("input[type='email']").val("");
	$(".${param.mapngAt}-comments-post form[name='cmFrm']").find("textarea").val("");
}

</script>