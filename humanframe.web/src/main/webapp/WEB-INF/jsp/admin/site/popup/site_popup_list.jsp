<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ include file="/common/taglibs.jsp" %>
	<script type="text/javascript">
	$(document).ready(function(){
// 		$("#table-check1").selectRow({
// 			classname : 'grey'
// 		});

		$("#siteNo option", opener.document).each(function(){
			$('<input>').attr('type', 'hidden').attr('name', 'excludeSiteNo').attr('value', $(this).val()).appendTo($("#searchFrm"));
		 });
		
		$("#checkAll").on('change',function(){
			$("input[name='arrUniqueId']").prop("checked",$("input#checkAll").prop("checked"));
		});
	});

	function fn_selectSite(){
		$("input[name=arrUniqueId]:checked").each(function() {
			var siteInfo = $(this).val().split("||");
			opener.fn_addSite(siteInfo[0], siteInfo[1]);
		});
		window.close();
	}
	</script>


			<section class="panel panel-primary">
				<header class="panel-heading">
					<div class="panel-actions">
					</div>
					<h2 class="panel-title">사이트 리스트</h2>
				</header>
				<div class="panel-body">
					<form id="searchFrm" name="searchFrm" class="form-inline" method="post" action="./siteListSearch">
						<select id="srchKey" name="srchKey" class="form-control">
							<option value="siteNm">사이트명</option>
						</select>
						<select id="bannerCodeId" name="bannerCodeId" class="form-control">
							<option value="" <c:if test="${param.siteNo eq ''}">selected="selected"</c:if>>배너구분</option>
							<c:forEach items="${bannerTy}" var="banner">
							<option value="${banner.codeId}" <c:if test="${param.bannerCodeId eq banner.codeId}">selected="selected"</c:if>>${banner.codeNm}</option>
							</c:forEach>
						</select>
						<input type="text" id="srchText" name="srchText" value="${param.srchText}" class="form-control">
						<button type="submit" class="btn">Search</button>
						<p>(배너구분 검색 시 해당 배너에 맵핑된 사이트만 검색됩니다.)</p>
					</form>
					
					<!-- Start Selectable Table Row -->
					<form id="listFrm" name="listFrm" method="post">
					<input type="hidden" id="listUseAt" name="listUseAt" value="" />
					<table class="table table-hover" id="table-check1">
						<colgroup>
							<col style="width:50px;" />
							<col style="width:70px;" />
							<col style="width:70px;" />
							<col style="width:250px;" />
							<col />
						</colgroup>
						<thead>
							<tr>
								<th>
									<div class="checkbox-custom">
									<input type="checkbox" data-style="checkbox" id="checkAll"/>
									<label for="checkAll"></label>
									</div>
								</th>
								<th>순번</th>
								<th>분류</th>
								<th>사이트명</th>
								<th>URL</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach items="${listVO.listObject}" var="resultList" varStatus="status">
							<c:set var="pageParam" value="siteNo=${resultList.siteNo}&amp;curPage=${listVO.curPage}${!empty(listVO.urlParam)? '&amp;' : ''}${listVO.urlParam}" />
							<tr>
								<td>
									<div class="checkbox-custom checkbox-text-primary">
									<input type="checkbox" data-style="checkbox" id="arrUniqueId${resultList.siteNo }" name="arrUniqueId" value="${resultList.siteNo}||${resultList.siteNm}" />
									<label for="arrUniqueId${resultList.siteNo }"></label>
									</div>
								</td>
								<td>${listVO.startNo - status.index}</td>
								<td>${resultList.clCodeNm}</td>
								<td>${resultList.siteNm}</td>
								<td>${resultList.siteUrl } <c:if test="${resultList.firstUriDivYn eq 'Y'}">/${resultList.firstUri }</c:if></td>
							</tr>
							</c:forEach>
							<c:if test="${empty listVO.listObject}">
							<tr>
								<td colspan="5" style="height:50px; text-align:center; vertical-align:middle;">등록된 데이터가 없습니다.</td>
							</tr>
							</c:if>
						</tbody>
					</table>
					</form>
				
				</div>
				<footer class="panel-footer">
					<div class="row">
						<div class="col-sm-7">
							<c:if test="${not empty listVO}"><cms:paging listVO="${listVO}"  /></c:if>
						</div>
						<div class="col-sm-5">
							<div class="btns">
							<button onclick="fn_selectSite()" class="btn btn-primary">선택</button>
							</div>
						</div>
					</div>
				</footer>
			</section>

