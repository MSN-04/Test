<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/taglibs.jsp" %>
<%@ page trimDirectiveWhitespaces="true" %>

<c:set var="isForeign" value="0"/>
<c:forEach items="${listVO.listObject}" var="resultList" varStatus="status">
	<c:if test="${not empty resultList.nationality}">
		<c:set var="isForeign" value="${isForeign + 1}"/>
	</c:if>
</c:forEach>

<script>
		function f_delprivacy(qestnarNo){
			$.ajax({
				type : "post",
				url: './delprivacy',
				data: 'qestnarNo='+ qestnarNo,
				dataType: 'text', //전송받을 데이터의 타입
				contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
				success: function(data) {
					if(data=="true"){
						alert("개인정보가 삭제되었습니다.");
						location.reload();
					}else{
						alert("개인정보 삭제에 실패하였습니다\n\n잠시후 다시 시도해 주시기 바랍니다.");
					}
				},
				error: function(data, status, err) {
					console.log('error forward : ' + data);
				}
			});

		}


		function f_excel(){
			$("#excelDown").submit();
		}
		</script>


		<jsp:include page="/WEB-INF/jsp/admin/layout/breadcrumb.jsp">
			<jsp:param name="pageName" value="설문조사 관리"/>
		</jsp:include>
		<!-- End Breadcrumb -->


		<div class="row">
			<div class="col-md-12">
				<section class="panel panel-featured panel-featured-primary">
					<header class="panel-heading">
						<div class="panel-actions">
							<div class="btn-group">
							</div>
						</div>
						<h2 class="panel-title">설문조사 개인별 설문 목록</h2>
						<p class="panel-subtitle">총 ${listVO.totalCount}건</p>
					</header>

					<div class="panel-body">

						<c:if test="${qestnarVO.crud eq 'UPDATE' }">
							<c:import url="/WEB-INF/jsp/admin/fnct/qestnar/include/qestnar_tab.jsp" >
								<c:param name="tabKind" value="personal" />
							</c:import>
						</c:if>

						<div class="tab-content">
							<div class="form-inline">
							<form id="searchFrm" name="searchFrm" class="form-horizontal form-bordered mb-md" method="get" action="./list">
	                        	<select id="srchType" name="srchType" class="form-control">
	                             	<option value="" <c:if test="${param.srchKey eq ''}">selected="selected"</c:if>>전체분류</option>
	                         		<option value="cl" <c:if test="${param.srchKey eq 'cl'}">selected="selected"</c:if>>ID</option>
	                         		<option value="nm" <c:if test="${param.srchKey eq 'nm'}">selected="selected"</c:if>>성명</option>
	                         		<option value="email" <c:if test="${param.srchKey eq 'email'}">selected="selected"</c:if>>이메일</option>
	                         		<option value="telno" <c:if test="${param.srchKey eq 'telno'}">selected="selected"</c:if>>전화번호</option>
	                        	</select>
	                        	<input type="text" id="srchText" name="srchText" value="${param.srchText}" class="form-control" >
	                         	<button type="submit" class="btn btn-default"><i class="fa fa-search"></i>검색</button>
                            </form>
                            </div>


	                        <div class="table-responsive">
								<form id="listFrm" name="listFrm" method="post">
								<table class="table table-bordered table-hover mb-none">
									<colgroup>
										<col style="width:80px;" />
										<col style="width:150px;">
										<col style="width:200px;" />
										<col style="width:100px;" />
										<c:if test="${isForeign > 0}">
										<col style="width:200px;" />
										<col style="width:200px;" />
										</c:if>
										<col style="width:200px;" />
										<col style="width:200px;" />
										<col style="width:200px;" />
									</colgroup>
									<thead>
										<tr>
											<th>번호</th>
											<th>구분<small>(uniqueId)</small></th>
											<th>성명</th>
											<th>국가</th>
											<c:if test="${isForeign > 0}">
											<th>주소</th>
											<th>국적</th>
											</c:if>
											<th>이메일</th>
											<th>전화번호</th>
											<th>참여일</th>
										</tr>
									</thead>
									<tbody>
										<c:forEach items="${listVO.listObject}" var="resultList" varStatus="status">
										<c:set var="pageParam" value="qestnarNo=${param.qestnarNo}&amp;crtrUniqueId=${resultList.crtrUniqueId}&amp;curPage=${listVO.curPage}${!empty(listVO.urlParam)? '&amp;' : ''}${listVO.urlParam}" />
										<tr>
											<td>${listVO.startNo - status.index}</td>
											<td><a href="./personalView?${pageParam}">${resultList.crtrUniqueId}</a></td>
											<td>${resultList.nm}</td>
											<td>${empty resultList.countryKo ? resultList.country : resultList.countryKo}</td>
											<c:if test="${isForeign > 0}">
												<td>${resultList.address}</td>
												<td>${empty resultList.nationalityKo ? resultList.nationality : resultList.nationalityKo}</td>
											</c:if>
											<td>${resultList.email}</td>
											<td>${resultList.telno}</td>
											<td>${resultList.creatDttm}</td>
										</tr>
										</c:forEach>
										<c:if test="${empty listVO.listObject}">
										<tr>
											<td colspan="${isForeign > 0 ? 9 : 7}" style="height:50px; text-align:center; vertical-align:middle;">등록된 데이터가 없습니다.</td>
										</tr>

										</c:if>
									</tbody>
								</table>
								</form>
							</div>
						</div>
					</div>
					<!--탭내용-->
					<footer class="panel-footer">
						<div class="row">
							<div class="col-sm-7">
								<a href="./list" class="btn btn-default">목록</a>
							</div>
							<div class="col-md-5 text-right">
								<a href="#none" class="btn btn-primary" onclick="f_excel();return false;">결과 엑셀 받기</a>
								<a href="#f_useAtChg" class="btn btn-danger" onclick="f_delprivacy('${param.qestnarNo}'); return false">개인정보 삭제</a>
							</div>

							<form name="excelDown" id="excelDown" action="./personalExcel" method='post' enctype="application/octet-stream" target="popForm">
								<input type="hidden" name="qestnarNo" id="qestnarNo" value="${qestnarVO.qestnarNo}" />
							</form>
						</div>
					</footer>
				</section>
			</div>
		</div>







