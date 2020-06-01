<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp" %>
<%@ page trimDirectiveWhitespaces="true" %>

		<c:set var="closeAt" value="N"/>
		<jsp:include page="../common/cm_respond_stat.jsp" />
		<div class="post-block post-leave-comment ${param.mapngAt}-comments-post">
			<h3 class="heading-primary"><i class="fa fa-gift"></i>선물세트 선택</h3>

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
				<input type="hidden" name="cntPerPage" value="20"/>
				<input type="hidden" name="totalPage" value=""/>
				<input type="hidden" name="respondAt" value="Y"/>
				<input type="hidden" name="loginAt" value="${HUMAN_MEMBER ne null}"/>
				<c:if test="${HUMAN_MEMBER eq null }">
				<div class="row">
					<div class="form-group">
						<div class="col-md-4">
							<label for="cm-wrter">이름 *</label>
							<input type="text" value="" maxlength="100" class="form-control" name="wrter" id="cm-wrter" placeholder="둘리" autocomplete="off">
						</div>
						<div class="col-md-4">
							<label for="cm-emailAdres">email *</label>
							<input type="email" value="" maxlength="100" class="form-control" name="emailAdres" id="cm-emailAdres" placeholder="dooly@yooncoms.com" autocomplete="off">
						</div>
						<div class="col-md-4">
							<label for="cm-password">password *</label>
							<input type="password" value="" maxlength="100" class="form-control" name="password" id="cm-password" placeholder="password" autocomplete="off">
						</div>
					</div>
				</div>
				</c:if>
				<div class="row">
					<div class="form-group mt-md">
						<div class="col-md-4">
							<label for="cm-answer">선물세트 선택 *</label>
							<select data-plugin-selecttwo class="form-control populate" name="respondAnswer" id="cm-answer">
								<option value=''>받고 싶은 선물을 골라주세요</option>
								<%-- 
								<option value='A'>01. 청정원 종합L 1호(SET)</option>
								<option value='B'>02. 안심특선S17gh 선물세트</option>
								<option value='C'>03. 양반김 특선6호 세트</option>
								<option value='D'>04. CJ 비비고 토종김세트 8호</option>
								<option value='E'>05. 상주정성곶감 특 반건시 명품 선물세트 1.5kg(50g x 30개)</option>
								<option value='F'>06. [빛과나무]한아름 사과.배 혼합선물세트 6호/보자기포장</option>
								<option value='G'>07. 국내산 돼지 LA식 갈비세트 (냉동)(2KG)</option>
								<option value='H'>08. 국내산 돼지 갈비혼합 세트 (냉동)(2KG)</option>
								<option value='I'>09. 오뚜기 참치햄6 S호(SET)</option>
								<option value='J'>10. 동원 리챔 6호(200G*9입)</option>
								<option value='K'>11. [우리명가]한아름 특선멸치 3호</option>
								<option value='L'>12. 이동삼 죽염안동 간고등어(6손/12마리)/손당 300g</option>
								<option value='M'>13. 나비 쿠션 마사지기 DWH-630</option>
								<option value='N'>14. 장성농협 드림빌 배 7.5kg(7-10과) 특대과 (제수용) 최상품+ 황금보자기 포</option>
								<option value='O'>15. [아리알찬]사각사각 품격높은 사과 5kg (21-23과)</option>
								<option value='P'>16. [아리알찬]제주오렌지 제주천혜향세트 3kg (16~20입)</option>
								<option value='Q'>17. [교동한과]전통식품명인 하늘연달세트</option>
								<option value='R'>18. 정관장 홍삼원기 (50ML*30입)</option>
								<option value='S'>19. 신세계상품권 3만원 (1만원*3매)</option>
								<option value='T'>20. 롯데상품권 3만원 (1만원*3매)</option>
								--%>
							</select>
						</div>
						<div class="col-md-4">
							<label for="cm-nm">받는 분 성함 *</label>
							<input type="text" value="" maxlength="100" class="form-control" name="respondNm" id="cm-nm" placeholder="고길동" autocomplete="off">
						</div>
						<div class="col-md-4">
							<label for="cm-telno">받는 분 연락처 *</label>
							<input type="text" value="" maxlength="100" class="form-control" name="respondTelno" id="cm-telno" placeholder="010-1234-5678" autocomplete="off">
						</div>
					</div>
				</div>
				<div class="row">
					<div class="form-group mt-md">
						<div class="col-md-12">
							<label for="cm-adres">받는 분 주소 *</label>
							<textarea maxlength="200" rows="3" class="form-control" name="respondAdres" id="cm-adres" placeholder="서울특별시 도봉구 노해로 731 쌍문아파트 203동 2903호 (쌍문동)"></textarea>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-md-12 mt-md">
						<input type="submit" value="이거 주세요!" class="btn btn-primary btn-lg">
					</div>
				</div>
			</form>
		</div>


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
								<span class="text-sm"></span>
								<span class="date pull-right">2017-12-27 21:23</span>
							</span>
							<table class="table table-hover mt-md">
								<colgroup><col width="100px"/><col/></colgroup>
								<tbody>
									<tr>
										<th>선물세트</th>
										<td class="respond-answer data"></td>
									</tr>
									<tr>
										<th>받는 분</th>
										<td class="respond-name data"></td>
									</tr>
									<tr>
										<th>연락처</th>
										<td class="respond-telno data"></td>
									</tr>
									<tr>
										<th>주소</th>
										<td class="respond-adres data" style="white-space: pre-wrap;"></td>
									</tr>
								</tbody>
							</table>
							<p class="cm">
							</p>
							<span class="pull-right">
								<span class="modify"> <a href="#" data-toggle="modal" data-target="#passwordModal" data-whatever="modify"><i class="fa fa-edit"></i> Modify</a></span>
								<c:if test="${closeAt ne 'Y'}">
								<span class="delete"> <a href="#" data-toggle="modal" data-target="#passwordModal" data-whatever="delete"><i class="fa fa-remove"></i> Delete</a></span>
								</c:if>
							</span>
						</div>
					</div>
				</li>
			</ul>
			<button class="btn btn-block btn-primary" type="button" onclick="getCmList('more');return false;" style="display:hidden">read more</button>
		</div>

		<div class="modal fade" id="passwordModal" tabindex="-1" role="dialog" aria-labelledby="passwordModalLabel" aria-hidden="true">
			<div class="modal-dialog">
				<div class="modal-content">
					<form id="password-form" class="form-horizontal mb-lg" novalidate="novalidate">
					<input type="hidden" name="cmNo" value="" />
					<input type="hidden" name="crud" value="" />
					<input type="hidden" name="wrter" value="" />
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
						<h4 class="modal-title" id="passwordModalLabel">비밀번호를 입력하세요.</h4>
					</div>
					<div class="modal-body">
							<div class="form-group mt-lg">
								<label class="col-sm-3 control-label">Password</label>
								<div class="col-sm-9">
									<input type="password" name="password" class="form-control" autocomplete="off" placeholder="Type your password..." required/>
								</div>
							</div>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
						<button type="submit" class="btn btn-primary">Submit</button>
					</div>
					</form>
				</div>
			</div>
		</div>

		<div class="modal fade" id="updateModal" tabindex="-1" role="dialog" aria-labelledby="updateModalLabel" aria-hidden="true">
			<div class="modal-dialog">
				<div class="modal-content">
					<form id="update-form" class="form-horizontal mb-lg" novalidate="novalidate">
					<input type="hidden" name="cmNo" value="" />
					<input type="hidden" name="crud" value="UPDATE" />
					<input type="hidden" name="password" value="" />
					<input type="hidden" name="wrter" value="" />
					<input type="hidden" name="emailAdres" value="" />
					<input type="hidden" name="respondAt" value="Y" />
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
						<h4 class="modal-title" id="updateModalLabel">코멘트를 수정하세요</h4>
					</div>
					<div class="modal-body">

						<div class="form-group mt-lg">
							<label class="col-sm-3 control-label">작성자</label>
							<div class="col-sm-9">
								<input type="text" name="wrter-email" class="form-control" readonly/>
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-3 control-label">선물세트</label>
							<div class="col-sm-9">
								<select data-plugin-selecttwo class="form-control populate" name="respondAnswer">
									<option value=''>받고 싶은 선물을 골라주세요</option>
									<%-- 
									<option value='A'>01. 청정원 종합L 1호(SET)</option>
									<option value='B'>02. 안심특선S17gh 선물세트</option>
									<option value='C'>03. 양반김 특선6호 세트</option>
									<option value='D'>04. CJ 비비고 토종김세트 8호</option>
									<option value='E'>05. 상주정성곶감 특 반건시 명품 선물세트 1.5kg(50g x 30개)</option>
									<option value='F'>06. [빛과나무]한아름 사과.배 혼합선물세트 6호/보자기포장</option>
									<option value='G'>07. 국내산 돼지 LA식 갈비세트 (냉동)(2KG)</option>
									<option value='H'>08. 국내산 돼지 갈비혼합 세트 (냉동)(2KG)</option>
									<option value='I'>09. 오뚜기 참치햄6 S호(SET)</option>
									<option value='J'>10. 동원 리챔 6호(200G*9입)</option>
									<option value='K'>11. [우리명가]한아름 특선멸치 3호</option>
									<option value='L'>12. 이동삼 죽염안동 간고등어(6손/12마리)/손당 300g</option>
									<option value='M'>13. 나비 쿠션 마사지기 DWH-630</option>
									<option value='N'>14. 장성농협 드림빌 배 7.5kg(7-10과) 특대과 (제수용) 최상품+ 황금보자기 포</option>
									<option value='O'>15. [아리알찬]사각사각 품격높은 사과 5kg (21-23과)</option>
									<option value='P'>16. [아리알찬]제주오렌지 제주천혜향세트 3kg (16~20입)</option>
									<option value='Q'>17. [교동한과]전통식품명인 하늘연달세트</option>
									<option value='R'>18. 정관장 홍삼원기 (50ML*30입)</option>
									<option value='S'>19. 신세계상품권 3만원 (1만원*3매)</option>
									<option value='T'>20. 롯데상품권 3만원 (1만원*3매)</option>
									--%>
								</select>
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-3 control-label">받는 분 성함</label>
							<div class="col-sm-9">
								<input type="text" name="respondNm" class="form-control" required/>
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-3 control-label">받는 분 연락처</label>
							<div class="col-sm-9">
								<input type="text" name="respondTelno" class="form-control" required/>
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-3 control-label">받는 분 주소</label>
							<div class="col-sm-9">
								<textarea rows="3" name="respondAdres" class="form-control" required></textarea>
							</div>
						</div>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
						<c:if test="${closeAt ne 'Y'}">
						<button type="submit" class="btn btn-primary">Submit</button>
						</c:if>
					</div>
					</form>
				</div>
			</div>
		</div>


<script>

$('#passwordModal').on('show.bs.modal', function (e) {
	var btn = $(e.relatedTarget);
	var crud = ("modify" == btn.data('whatever')) ? "UPDATE" : "DELETE";
	var cmNo = btn.data('cmNo');
	var wrter = btn.data('wrter');
	var modal = $(this);
	modal.find('input[name="cmNo"]').val(cmNo);
	modal.find('input[name="crud"]').val(crud);
	modal.find('input[name="wrter"]').val(wrter);
	modal.find('input[name="password"]').val("");
});

<c:if test="${closeAt ne 'Y'}">
function deleteCm (data, pass) {
	$.ajax({
		url: '/ajax/cmRespondAction.json',
		type: 'post',
		data: 'crud=DELETE&cmNo='+data.cm.cmNo+'&wrter='+data.cm.wrter+'&emailAdres='+data.cm.emailAdres+'&password='+pass,
		success: function(result){
			if(result.process==1){
				$.each($(".comment-block"),function(){
					if(data.cm.cmNo == $(this).data('comments-no')){
						$(this).closest("li").fadeOut(function(){
							$(this).remove();
						})
					}
				});
			} else {
				alert(data.msg);
			}
			$('#passwordModal').modal('hide');
		}
	})
}
</c:if>

function updateModalOpen(data, pass){
	$('#passwordModal').modal('hide');
	$('#updateModal').modal('show');
	$('#updateModal').find("select[name='respondAnswer']").val(data.cm.respondAnswer);
	$('#updateModal').find("input[name='respondNm']").val(data.cm.respondNm);
	$('#updateModal').find("input[name='respondTelno']").val(data.cm.respondTelno);
	$('#updateModal').find("textarea[name='respondAdres']").val(data.cm.respondAdres);
	$('#updateModal').find("input[name='cmNo']").val(data.cm.cmNo);
	$('#updateModal').find("input[name='wrter']").val(data.cm.wrter);
	$('#updateModal').find("input[name='password']").val(pass);
	$('#updateModal').find("input[name='emailAdres']").val(data.cm.emailAdres);
	$('#updateModal').find("input[name='wrter-email']").val(data.cm.wrter + " (" + data.cm.emailAdres + ")");
}

$(function() {
	<c:if test="${closeAt ne 'Y'}">
	$("#updateModal form").validate({
		rules : {
	    	crud		: { required : true },
	    	wrter		: { required : true },
	    	password	: { required : true },
	    	respondAnswer : { required : true },
	    	respondNm     : { required : true },
	    	respondTelno  : { required : true },
	    	respondAdres  : { required : true }
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
				url: "/ajax/cmRespondAction.json",
				type: "post",
				data: $("#updateModal form#update-form").serialize(),
				success: function(data){
					if(data.process==1) {
						$('#updateModal').modal('hide');
						getCmList('new');
					}
					else {
						alert("코멘트 수정에 실패했습니다.");
					}
				},
				error: function(xhr, status, err){
					alert("[error] " + ":" + err + "(" + status + ")" + xhr);
				}
			});
			return false;
	    }
	})
	</c:if>

	$("#passwordModal form").validate({
		rules : {
			crud    : {required : true},
			cmNo    : {required : true},
			password: {required : true}
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
				url: "/ajax/checkCmPassword.json",
				type: "post",
				data: $("#passwordModal form#password-form").serialize(),
				success: function(data){
					if(data.process==1) {
						var crud = $("#passwordModal input[name='crud']").val();
						var cmNo = $("#passwordModal input[name='cmNo']").val();
						var pass = $("#passwordModal input[name='password']").val();
						if(crud=="UPDATE"){
							updateModalOpen(data, pass);
						}
						else {
							deleteCm(data, pass);
						}
					}
					else {
						alert("비밀번호가 틀렸습니다.");
					}
				},
				error: function(xhr, status, err){
					alert("[error] " + ":" + err + "(" + status + ")" + xhr);
				}
			});
			return false;
	    }
	});

	<c:choose>
	<c:when test="${closeAt eq 'Y'}">
	$("form[name='cmFrm'] input,form[name='cmFrm'] textarea,form[name='cmFrm'] select").on("click",function(e){
		e.preventDefault();
		alert("접수가 종료되었습니다.");
	});
	</c:when>
	<c:otherwise>
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
	    	respondAnswer : { required : true },
	    	respondNm     : { required : true },
	    	respondTelno  : { required : true },
	    	respondAdres  : { required : true }
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
				url: "/ajax/cmRespondAction.json",
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
	</c:otherwise>
	</c:choose>
	
	// 선물목록
	$.ajax({
		url : '/ajax/getCmRespondAnswerList.json',
		type: "post",
		data: $(".${param.mapngAt}-comments-post form[name='cmFrm']").serialize(),
		success: function(data){
            
            if(data.list!==undefined){
            	for(var i in data.list) {
            		var keyNm = data.list[i].answer,
            			value = data.list[i].detail;
            		gifts.set(keyNm, value);
            	}
            	$.each(data.list, function (index, value) {
            		var detailHead = (index < 9 ? "0" : "") + (index+1) + ". ";
            		gifts.set(value.answer, detailHead + value.detail);
            		$("select[name='respondAnswer']").append($('<option/>', { 
                        value: value.answer,
                        text : detailHead + value.detail 
                    }));
            	});
            	
            	// 댓글 목록 가져오기
            	getCmList('');
            }
        }
    });

});

function getCmList(mode){
	$(".${param.mapngAt}-comments-post input[name='crud']").val("READ");
	if(mode == "new"){ resetCmList(); }
	$.ajax({
		url : '/ajax/getCmRespondList.json',
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
					cloning.find(".comment-by span.text-sm").text("("+data.list.listObject[oname].email+")");
					cloning.find(".comment-block p.cm").text(data.list.listObject[oname].cn);
				} else {
					cloning.find(".comment-by strong").text("*blind*").addClass("text-muted"); //author
					cloning.find(".comment-block p.cm").text("관리자에 의해 블라인드 처리된 댓글입니다.").addClass("text-muted");
				}
				cloning.find("td.respond-answer.data").text(gifts.get(data.list.listObject[oname].respondAnswer));
				cloning.find("td.respond-name.data").text(data.list.listObject[oname].respondNm.replace(/[^\s\n\r]/gi, "*"));
				cloning.find("td.respond-telno.data").text(data.list.listObject[oname].respondTelno.replace(/[^\s\n\r]/gi, "*"));
				cloning.find("td.respond-adres.data").html(data.list.listObject[oname].respondAdres.replace(/[^\s\n\r]/gi, "*"));
				if(data.list.listObject[oname].usrMd5!=undefined){
					cloning.find(".img-thumbnail .avatar").attr("src","https://www.gravatar.com/avatar/"+data.list.listObject[oname].usrMd5+"?d=robohash&amp;f=y");
				}
// 				if(!data.list.listObject[oname].isMine){
// 					cloning.find(".comment-block .delete").remove();
// 				}
				cloning.find(".comment-block").data('commentsNo',data.list.listObject[oname].cmNo);
				cloning.find(".pull-right a").data('cmNo',data.list.listObject[oname].cmNo);
				cloning.find(".pull-right a").data('wrter',data.list.listObject[oname].wrter);
				cloning.appendTo(".${param.mapngAt}-comments-wrap .comments");
			}
		}
	})
}
var gifts = new Map();
// var gifts = { 'A':'01. 청정원 종합L 1호(SET)'
// 			, 'B':'02. 안심특선S17호 선물세트'
// 			, 'C':'03. 양반김 특선6호 세트'
// 			, 'D':'04. CJ 비비고 토종김세트 8호'
// 			, 'E':'05. 상주정성곶감 특 반건시 명품 선물세트 1.5kg(50g x 30개)'
// 			, 'F':'06. [빛과나무]한아름 사과.배 혼합선물세트 6호/보자기포장'
// 			, 'G':'07. 국내산 돼지 LA식 갈비세트 (냉동)(2KG)'
// 			, 'H':'08. 국내산 돼지 갈비혼합 세트 (냉동)(2KG)'
// 			, 'I':'09. 오뚜기 참치햄6 S호(SET)'
// 			, 'J':'10. 동원 리챔 6호(200G*9입)'
// 			, 'K':'11. [우리명가]한아름 특선멸치 3호'
// 			, 'L':'12. 이동삼 죽염안동 간고등어(6손/12마리)/손당 300g'
// 			, 'M':'13. 나비 쿠션 마사지기 DWH-630'
// 			, 'N':'14. 장성농협 드림빌 배 7.5kg(7-10과) 특대과 (제수용) 최상품+ 황금보자기 포장'
// 			, 'O':'15. [아리알찬]사각사각 품격높은 사과 5kg (21-23과)'
// 			, 'P':'16. [아리알찬]제주오렌지 제주천혜향세트 3kg (16~20입)'
// 			, 'Q':'17. [교동한과]전통식품명인 하늘연달세트'
// 			, 'R':'18. 정관장 홍삼원기 (50ML*30입)'
// 			, 'S':'19. 신세계상품권 3만원 (1만원*3매)'
// 			, 'T':'20. 롯데상품권 3만원 (1만원*3매)'
// 			};

function resetCmList(){
	$(".${param.mapngAt}-comments-post input[name='curPage']").val(1);
	$(".${param.mapngAt}-comments-wrap button.btn").prop("disabled",true);
	$(".${param.mapngAt}-comments-wrap button.btn").hide();
	$(".${param.mapngAt}-comments-wrap .comments li").not(".tmplat").remove();
}

function resetCmFrm(){
	$(".${param.mapngAt}-comments-post form[name='cmFrm']")[0].reset();
}

</script>