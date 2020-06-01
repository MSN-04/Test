<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/taglibs.jsp" %>
<%@ page trimDirectiveWhitespaces="true" %>
			<script>

			var inqireAt = true;
			var writngAt = true;
			function f_groupAllCheck(tar){
				if(tar == "inqire"){
					$(".mng-menu-table input[id^='"+ tar +"']").prop("checked", inqireAt);
					inqireAt = inqireAt ? false: true;

				}else if(tar == "writng"){
					$(".mng-menu-table input[id^='"+ tar +"']").prop("checked", writngAt);
					writngAt = writngAt ? false: true;
				}

				$(".mng-menu-table input[id^='"+ tar +"']").each(function(){
					var target = $(".mng-menu-table input[id='arrMenuNo_"+ $(this).val()+"']");
					if($(this).prop("checked")){
						if(target.val().indexOf(tar+"|") < 0){
							target.val(target.val() + tar+"|");
						}
					}else{
						target.val(target.val().replace(tar+"|", ""));
					}
				});
			}

			function f_groupCheck(tar, upperNo, no){
				//console.log(tar+" // "+ upperNo +" // "+ no)

				if($(".mng-menu-table input[id^='"+ tar +"_"+ upperNo +"']:checked").size() > 0){
					$(".mng-menu-table input[id^='"+ tar +"'][value='"+ upperNo +"']").prop("checked", true);
				}else{
					$(".mng-menu-table input[id^='"+ tar +"'][value='"+ upperNo +"']").prop("checked", false);
				}

				if($(".mng-menu-table input[id^='"+ tar +"'][value='"+ no +"']").prop("checked")){
					$(".mng-menu-table input[id^='"+ tar +"_"+ no +"']").prop("checked", true);
				}else{
					$(".mng-menu-table input[id^='"+ tar +"_"+ no +"']").prop("checked", false);
				}

			}

			$(function() {

				$(".mng-menu-table input[id^='inqire']").bind("click", function(){
					$(".mng-menu-table input[id^='inqire']").each(function(){
						var target = $(".mng-menu-table input[id='arrMenuNo_"+ $(this).val()+"']");
						if($(this).prop("checked")){
							if(target.val().indexOf("inqire|") < 0){
								target.val(target.val() + "inqire|");
							}
						}else{
							target.val(target.val().replace("inqire|", ""));
						}
					});
				});

				$(".mng-menu-table input[id^='writng']").bind("click", function(){
					$(".mng-menu-table input[id^='writng']").each(function(){
						var target = $(".mng-menu-table input[id='arrMenuNo_"+ $(this).val()+"']");
						if($(this).prop("checked")){
							if(target.val().indexOf("writng|") < 0){
								target.val(target.val() + "writng|");
							}
						}else{
							target.val(target.val().replace("writng|", ""));
						}
					});
				});

				$("form[name='frmMngAuthor']").validate({
				    ignore: "input[type='text']:hidden",
				    rules : {
				    	authorNm		: { required : true },
				    	memo				: { required : false, maxlength : 200 }
				    },
				    messages : {
				    	authorNm		: { required : "권한그룹명을 입력하세요" },
				    memo				: { required : false, maxlength : "{0}자 까지 입력 가능합니다." }
				    },
				    errorElement: 'span',
				    errorClass: 'help-block error',
				    highlight:function(element, errorClass, validClass) {
				        $(element).addClass('error');
				    },
				    unhighlight: function(element, errorClass, validClass) {
				        $(element).removeClass('error');
				    },
				    submitHandler: function (frm) {
				    	frm.submit();
				    }
				});
			});

			function f_mngrSearch(){
				window.open("/admin/mng/mngr/popup/mngrList", "popMngr", "width=400, height=500");
			}

			function f_chngSuper(arg){
				if(arg.checked){
					$("input[name=arrSiteNo]").removeAttr("checked");
					$("input[name=arrSiteNo]").parent().parent().addClass("disabled");
					$("input[name=arrSiteNo]").parent().removeClass("checked");
					$("input[name=arrSiteNo]").attr("disabled", "disabled");
				}else{
					$("input[name=arrSiteNo]").removeAttr("disabled");
					$("input[name=arrSiteNo]").parent().parent().removeClass("disabled");
				}
			}
			</script>

			<!-- Start Breadcrumb -->
			<jsp:include page="/WEB-INF/jsp/admin/layout/breadcrumb.jsp">
				<jsp:param name="pageName" value="권한그룹 관리"/>
			</jsp:include>
			<!-- End Breadcrumb -->

            <!-- start: page -->
			<div class="row">
				<div class="col-md-12">
				<section class="panel panel-featured panel-featured-primary">
					<f:form name="frmMngAuthor" id="frmMngAuthor" modelAttribute="mngAuthorVO" method="post" action="./action" >
					<f:hidden path="crud" />
					<f:hidden path="authorNo" />
					<input type="hidden" name="arrMenuNo" value="1|inqire|writng|" />
					<header class="panel-heading">
						<h2 class="panel-title">권한그룹 등록/수정</h2>
					</header>
					<div class="panel-body">

						<div class="table-responsive">
							<table class="table table-bordered mb-none">
								<colgroup>
									<col style="width:100px;"/>
									<col />
								</colgroup>
								<tbody>
									<tr>
										<th>권한명 <span class="required">*</span></th>
										<td>
											<f:input path="authorNm" class="form-control"/>
										</td>
									</tr>
									<tr>
										<th>권한설명</th>
										<td>
											<f:textarea path="memo" class="form-control"/>
										</td>
									</tr>
									<tr>
										<th>메뉴설정 <span class="required">*</span></th>
										<td>
											<div class="span12" style="border:solid 1px #ccc; max-height:500px; overflow:auto;">
												<table class="table table-bordered mb-none mng-menu-table">
													<thead>
													<tr>
														<th style="text-align: center;">1DEPTH</th>
														<th style="text-align: center;">2DEPTH</th>
														<th style="text-align: center;">3DEPTH</th>
														<th style="text-align: center;">4DEPTH</th>
														<th style="text-align: center; width:80px;"><a href="#" onclick="f_groupAllCheck('inqire');">조회(R)</a></th>
														<th  style="text-align: center; width:80px;""><a href="#" onclick="f_groupAllCheck('writng');">작성(CUD)</a></th>
													</tr>
													</thead>
													<tbody>
													<c:forEach var="mngMenuList" items="${mngMenuList}" varStatus="status">
													<c:if test="${mngMenuList.levelNo > 1 }">
													<tr>
														<td><c:if test="${mngMenuList.levelNo == 2}">${mngMenuList.menuNm }</c:if></td>
														<td><c:if test="${mngMenuList.levelNo == 3}">${mngMenuList.menuNm }</c:if></td>
														<td><c:if test="${mngMenuList.levelNo == 4}">${mngMenuList.menuNm }</c:if></td>
														<td><c:if test="${mngMenuList.levelNo == 5}">${mngMenuList.menuNm }</c:if></td>
														<td>
															<input type="hidden" id="arrMenuNo_${mngMenuList.menuNo }" name="arrMenuNo" value="${mngMenuList.menuNo }|<c:if test="${mngMenuList.inqireAt eq 'Y' }">inqire|</c:if><c:if test="${mngMenuList.writngAt eq 'Y' }">writng|</c:if>" />
															<div class="checkbox-custom checkbox-default">
															<input type="checkbox" onclick="f_groupCheck('inqire', '${mngMenuList.upperMenuNo}', '${mngMenuList.menuNo}'); " id="inqire_${mngMenuList.upperMenuNo}_${mngMenuList.menuNo }" name="inqire" value="${mngMenuList.menuNo }" <c:if test="${mngMenuList.inqireAt eq 'Y' }">checked="checked"</c:if> />
															<label></label>
															</div>
														</td>
														<td>
															<div class="checkbox-custom checkbox-default">
															<input type="checkbox" onclick="f_groupCheck('writng', '${mngMenuList.upperMenuNo}', '${mngMenuList.menuNo}'); " id="writng_${mngMenuList.upperMenuNo}_${mngMenuList.menuNo }" name="writng" value="${mngMenuList.menuNo }" <c:if test="${mngMenuList.writngAt eq 'Y' }">checked="checked"</c:if> />
															<label></label>
															</div>
														</td>
													</tr>
													</c:if>
													</c:forEach>
													</tbody>
												</table>
											</div>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					<footer class="panel-footer">
						<div class="row">
							<div class="col-sm-6">
								<c:set var="pageParam" value="curPage=${param.curPage }&amp;srchKey=${param.srchKey}&amp;srchText=${param.srchText}" />
								<a href="./list?${pageParam}" class="btn btn-default">목록</a>
							</div>
							<div class="col-sm-6 text-right">
								<cmsBtn2:btn btnTy="save" path="${curPath}" mngrSession="${mngrSession }" >저장</cmsBtn2:btn>
							</div>
						</div>
					</footer>
					</f:form>
				</section>
				</div>
			</div>