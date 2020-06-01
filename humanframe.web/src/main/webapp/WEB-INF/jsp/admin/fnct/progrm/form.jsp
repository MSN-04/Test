<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/taglibs.jsp" %>
<%@ page trimDirectiveWhitespaces="true" %>

			<script>

			$(document).on("click", "#mnMapngTable .delBtn", function(){
				$(this).parents("tr").fadeOut(300, function(){$(this).remove();});
			});

			$(function() {
				$("form[name='frmProgrm']").validate({
		            ignore: "input[type='text']:hidden",
		            rules : {
		            	fnctNm	: { required : true },
		            	svcUrl 	: { required : true}
		            	
		            },
		            messages : {
		            	fnctNm	: { required : "프로그램명을 입력 하세요" },
		            	svcUrl 	: { required : "서비스 URL을 입력하세요"}		            	
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
			function f_remove(){
				$("#crud").val("DELETE");
				$("#frmProgrm").attr("action","action.do").submit();
			}
			//메뉴검색
			function f_menuSrch(){
				window.open("/admin/site/menu/popup/srchMenuList?srchMenuTy=4", "popMenuList", "width=900, height=605");
			}
			</script>


			<!-- Start Breadcrumb -->
			<jsp:include page="/WEB-INF/jsp/admin/layout/breadcrumb.jsp">
				<jsp:param name="pageName" value="프로그램 관리"/>
			</jsp:include>
			<!-- End Breadcrumb -->

            <!-- start: page -->
			<div class="row">				
				<f:form name="frmProgrm" id="frmProgrm" modelAttribute="fnctProgrmVO" method="post" action="./action" class="form-horizontal" enctype="multipart/form-data">
				<f:hidden path="crud" />
				<f:hidden path="fnctNo" />

				<div class="col-sm-8">

					<section class="panel panel-featured panel-featured-primary">
						<header class="panel-heading">
							<h2 class="panel-title">프로그램 등록/수정</h2>
						</header>
						<div class="panel-body">
							<div class="table-responsive">
								<table class="table table-bordered mb-none">
									<colgroup>
										<col style="width:120px"/>
										<col />
									</colgroup>
									<tbody>
										<tr>
											<th>프로그램명 <span class="required">*</span></th>
											<td>
												<f:input path="fnctNm" class="form-control" placeholder="프로그램명" maxlength="200"/>
											</td>
										</tr>
										<tr>
											<th>서비스URL <span class="required">*</span></th>
											<td>
												<f:input path="svcUrl" class="form-control" placeholder="서비스URL" maxlength="200"/>
											</td>
										</tr>
										<tr>
											<th>사용여부 <span class="required">*</span></th>
											<td>
												<f:radiobuttons path="useAt" items="${useAtCode}" element="div class='radio-custom radio-primary'" />
											</td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>
						<footer class="panel-footer">
							<div class="row">
								<div class="col-sm-6">
									<c:set var="pageParam" value="useAt=${param.useAt }&amp;curPage=${param.curPage }&amp;searchText=${param.searchText}" />
									<a href="./list?${pageParam}" class="btn btn-default">목록</a>
								</div>
								<div class="col-sm-6 text-right">
									<cmsBtn2:btn btnTy="save" path="${curPath}" mngrSession="${mngrSession }" >저장</cmsBtn2:btn>
								</div>
							</div>
						</footer>
					</section>

				</div>
				<div class="col-sm-4">

					<section class="panel panel-featured panel-featured-primary">
						<header class="panel-heading">
							<div class="panel-actions">
								<button href="#" class="mb-xs mr-xs btn btn-sm btn-default" onclick="f_menuSrch(); return false;" ><i class="fa fa-cogs"></i> 설정</button>
							</div>
							<h2 class="panel-title">메뉴 연결</h2>
						</header>
						<div class="panel-body">
							<div class="table-responsive">
								<table class="table table-hover mb-none" id="mnMapngTable">
									<tbody>
										<c:if test="${empty siteMenuList }">
										<tr class="emptyTr">
											<td>연결된 메뉴가 없습니다.</td>
										</tr>
										</c:if>
										<c:forEach var="menuList" items="${siteMenuList}" varStatus="menuStatus">
										<tr>
											<td>
												<input type="hidden" name="arrMenuNo" value="${menuList.menuNo }" />
												<code><small>${menuList.siteNm}</small></code><br />
												${fn:replace(menuList.menuNmPath, '>Home', '홈')}
											</td>
											<td class="text-center"><a href="#DEL" class="badge btn-danger hvr-grow delBtn">X</a></td>
										</tr>
										</c:forEach>
									</tbody>
								</table>
							</div>
						</div>
					</section>

				</div>
				</f:form>

			</div>