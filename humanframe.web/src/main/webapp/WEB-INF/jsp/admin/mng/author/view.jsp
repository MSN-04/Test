<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/taglibs.jsp" %>
<%@ page trimDirectiveWhitespaces="true" %>
			<script>
			function f_Delete(){
				if(confirm("삭제된 데이터는 복구할 수 없습니다.\n\n선택하신 데이터는 삭제하시겠습니까?")){
					$("#crud").val("DELETE");
					$("#frmMngAuthor").submit();
				}
			}

			$(function() {
				$(".mng-menu-table input[type=checkbox]").prop("disabled", true);
			});
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

					<header class="panel-heading">
						<h2 class="panel-title">권한그룹 상세</h2>
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
										<th>권한그룹명</th>
										<td>
											${mngAuthorVO.authorNm }
										</td>
									</tr>
									<tr>
										<th>권한설명</th>
										<td>${mngAuthorVO.memo }</td>
									</tr>
									<tr>
										<th>메뉴설정</th>
										<td>
											<div class="span12" style="border:solid 1px #ccc; max-height:500px; overflow:auto;">
												<table class="table table-bordered mb-none mng-menu-table">
													<thead>
													<tr>
														<th style="text-align: center;">1DEPTH</th>
														<th style="text-align: center;">2DEPTH</th>
														<th style="text-align: center;">3DEPTH</th>
														<th style="text-align: center;">4DEPTH</th>
														<th style="text-align: center; width:80px;">조회(R)</th>
														<th style="text-align: center; width:80px;">작성(CUD)</th>
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
															<div class="checkbox-custom checkbox-default">
															<input type="checkbox" name="inqire" value="${mngMenuList.menuNo }" <c:if test="${mngMenuList.inqireAt eq 'Y' }">checked="checked"</c:if> />
															<label></label>
															</div>
														</td>
														<td>
															<div class="checkbox-custom checkbox-default">
															<input type="checkbox" name="writng" value="${mngMenuList.menuNo }" <c:if test="${mngMenuList.writngAt eq 'Y' }">checked="checked"</c:if> />
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
								<cmsBtn2:btn btnTy="modify" path="${curPath}" mngrSession="${mngrSession }" modifyParam="?authorNo=${mngAuthorVO.authorNo}&amp;${pageParam}">수정</cmsBtn2:btn>
								<cmsBtn2:btn btnTy="delete" path="${curPath}" mngrSession="${mngrSession }" script="f_Delete(); return false;" >삭제</cmsBtn2:btn>
							</div>
						</div>
					</footer>
					</f:form>
				</section>
				</div>

			</div>