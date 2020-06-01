<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp" %>
<%@ page trimDirectiveWhitespaces="true" %>

		<div class="clearfix post-block" id="stsfdgContainer">
			<h3 class="heading-primary mb-xs">
				<i class="fa fa-star"></i>Contents Rating
			</h3>
			<p class="ml-xlg mb-xs">이 페이지에서 제공하는 정보에 대하여 만족하십니까?</p>
			
			<form id="stsfdgForm" name="stsfdgForm" method="post" class="ml-xlg">
				<input type="hidden" name="crud" value="">
				<input type="hidden" name="siteNo" value="${curSiteVO.siteNo }" title="사이트번호">
				<input type="hidden" name="menuNo" value="${curMenuVO.menuNo }" title="메뉴번호">
				<div class="form-group">
				<div class="radio-custom radio-inline "><input type="radio" name="score" id="c1" value="1" class=""> <label for="c1">매우불만족</label></div>
				<div class="radio-custom radio-inline "><input type="radio" name="score" id="c2" value="2" class=""> <label for="c2">불만족</label></div>
				<div class="radio-custom radio-inline "><input type="radio" name="score" id="c3" value="3" class=""> <label for="c3">보통</label></div>
				<div class="radio-custom radio-inline "><input type="radio" name="score" id="c4" value="4" class=""> <label for="c4">만족</label></div>
				<div class="radio-custom radio-inline "><input type="radio" name="score" id="c5" value="5" class=""> <label for="c5">매우만족</label></div>
				<div class="radio-custom radio-inline "></div>
				<button type="submit" class="btn btn-primary btn-xs">평점주기</button>
				</div>
			</form>
		</div>
		<script>
		$(function(){
		<c:choose>
		<c:when test="${HUMAN_MEMBER ne null}">
			//save saticsfaction degree 
			$(document).on('submit', 'form[name="stsfdgForm"]', function(e){
				e.preventDefault();
				if($("form[name='stsfdgForm'] input[name='score']:checked").length > 0
						&& $("form[name='stsfdgForm'] input[name='score']:checked").val() ) {
					$("form[name='stsfdgForm'] input[name='crud']").val('CREATE');
					$.ajax({
						url: "/ajax/stsfdgAction.json", // 의견 추가,삭제
						type: "post",
						data: $("form[name='stsfdgForm']").serialize(),
						success: function(data){
							if (data.process!=undefined&&data.process==1) {
								alert(data.msg);
							} else if (data.errorMessage!=undefined) {
								alert(data.errorMessage);
							} else {
								alert("처리에 오류가 발생했습니다.");
							}
						},
						error: function(xhr, status, err){
							alert("[error] " + ":" + err + "(" + status + ")");
						}
					});
				} else {
					alert("만족도 점수를 선택해주세요");
					$("form[name='stsfdgForm'] input[name='score']#c5").focus();
				}
			});
		</c:when>
		<c:otherwise>
			$(document).on('click', 'form[name="stsfdgForm"]', function(e){
				e.preventDefault();
				if(confirm("만족도 평가를 위해 로그인하시겠습니까?")){
					location.href = "/member/login?";
				}
			});
		</c:otherwise>
		</c:choose>
		})
		</script>