<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/taglibs.jsp" %>
<%@ page trimDirectiveWhitespaces="true" %>

			<script>
			function f_useAtChg(at){
				$.ajax({
					type : "post",
					url: './useAtChg',
					data: 'fnctNo=${fnctProgrmVO.fnctNo}&useAt='+at,
					dataType: 'text', //전송받을 데이터의 타입
					contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
					success: function(data) {
						if(data=="true"){
							alert("사용여부가 변경되었습니다.");
							location.reload();
						}else{
							alert("상태 변경에 실패하였습니다\n\n잠시후 다시 시도해 주시기 바랍니다.");
						}
					},
					error: function(data, status, err) {
						console.log('error forward : ' + data);
					}
				});

			}

			$(function() {
			});
			</script>


			<!-- Start Breadcrumb -->
			<jsp:include page="/WEB-INF/jsp/admin/layout/breadcrumb.jsp">
				<jsp:param name="pageName" value="프로그램 관리"/>
			</jsp:include>
			<!-- End Breadcrumb -->

            <!-- start: page -->
			<div class="row">
				<div class="col-sm-8 p-none">
				<section class="panel panel-featured panel-featured-primary">
					<header class="panel-heading">
						<div class="panel-actions">

						</div>
						<h2 class="panel-title">프로그램 상세</h2>
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
										<th>프로그램명</th>
										<td>${fnctProgrmVO.fnctNm }
										</td>
									</tr>
									<tr>
										<th>서비스URL </th>
										<td>${fnctProgrmVO.svcUrl }
										</td>
									</tr>
									<tr>
										<th>사용여부 </th>
										<td>${useAtCode[fnctProgrmVO.useAt] }
										</td>
									</tr>
								</tbody>
						</table>
						</div>
					</div>
					<footer class="panel-footer">
						<div class="row">
							<div class="col-sm-6">
								<c:set var="pageParam" value="useAt=${param.useAt }&amp;curPage=${param.curPage }&amp;searchKey=${param.searchKey}&amp;searchText=${param.searchText}" />
								<a href="./list?${pageParam}" class="btn btn-default">목록</a>
							</div>
							<div class="col-sm-6 text-right">
                                <cmsBtn2:btn btnTy="modify" path="${curPath}" mngrSession="${mngrSession }" modifyParam="?fnctNo=${fnctProgrmVO.fnctNo}&amp;${pageParam}">수정</cmsBtn2:btn>
								<c:if test="${fnctProgrmVO.useAt eq 'Y'}">
								<cmsBtn2:btn btnTy="use" path="${curPath}" mngrSession="${mngrSession }" script="f_useAtChg('N'); return false;" useAt="N" >사용안함</cmsBtn2:btn>
								</c:if>
								<c:if test="${fnctProgrmVO.useAt eq 'N'}">
								<cmsBtn2:btn btnTy="use" path="${curPath}" mngrSession="${mngrSession }" script="f_useAtChg('Y'); return false;" useAt="Y" >사용</cmsBtn2:btn>
								</c:if>
							</div>
						</div>
					</footer>
				</section>
				</div>

				<div class="col-sm-4 pr-none">
					<section class="panel panel-featured panel-featured-primary">
						<header class="panel-heading">
							<h2 class="panel-title">메뉴 연결</h2>
						</header>
						<div class="panel-body">
							<div class="table-responsive">
								<table class="table table-hover mb-none">
									<c:if test="${empty siteMenuList }">
									<tr class="emptyTr">
										<td>연결된 메뉴가 없습니다.</td>
									</tr>
									</c:if>
									<c:forEach var="menuList" items="${siteMenuList}" varStatus="menuStatus">
									<tr>
										<td><code><small>${menuList.siteNm}</small></code><br />
										${fn:replace(menuList.menuNmPath, '>Home', '홈')}
										</td>
									</tr>
									</c:forEach>
								</table>
							</div>
						</div>
					</section>
				</div>

			</div>