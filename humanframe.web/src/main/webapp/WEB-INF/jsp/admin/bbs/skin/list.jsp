<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ include file="/common/taglibs.jsp" %>
	<script type="text/javascript">
	$(function() {
		$("#cntPerPage").on("change", function() {
			$("#searchFrm").submit();
		});

		$('#searchFrm').submit(function() {

 		});

	});

	function selectCntPerPage(obj){
		$("#cntPerPage").val(obj.value);
	}

	function f_update(skin_id){
		$("#skinId").val(skin_id);
		$("#crud").val("UPDATE");
		$("#searchFrm").attr("action","./form");
		$("#searchFrm").submit();
	}

	function f_insert(){
		$("#crud").val("CREATE");
		$("#searchFrm").attr("action","./form");
		$("#searchFrm").submit();
	}

	function f_delete(){
		if($(".skinIds:checked").length == 0){
			alert("선택된 내역이 없습니다.");
			return;
		}
		if( confirm("<spring:message code='action.confirm.delete' />") ) {
			$("#crud").val("DELETE");
			$("#searchFrm").attr("action","./action");
			document.searchFrm.submit();
		}
	}
	</script>

				<!-- Start Breadcrumb -->
			<jsp:include page="/WEB-INF/jsp/admin/layout/breadcrumb.jsp">
				<jsp:param name="pageName" value="스킨 관리"/>
			</jsp:include>
			<!-- End Breadcrumb -->


			<!-- start: page -->
			<div class="row">
				<div class="col-md-12">
				<section class="panel panel-featured panel-featured-primary">
					<header class="panel-heading">
						<div class="panel-actions">
						</div>
						<h2 class="panel-title">스킨 목록</h2>
						<p class="panel-subtitle">
							총  ${skinList.totalCount}건
						</p>
					</header>
					<div class="panel-body">


						<form id="searchFrm" name="searchFrm"  class="form-horizontal form-bordered mb-md" method="post" action="./list">
						<input type="hidden" name="crud" 			id="crud" 			value="" />
						<input type="hidden" name="skinId" 		id="skinId" 			value="0" />
						<input type="hidden" name="cntPerPage" id="cntPerPage" 	value="10" />
						<div class="form-group">
                    		<div class="form-inline ml-md">
		                        <input type="text" id="srchText" name="srchText" value="<c:out value='${param.srchText}'/>" class="form-control" placeholder="스킨명 입력">
								<button type="submit" class="btn btn-default"><i class="fa fa-search"></i> 검색</button>
                        	</div>
                        </div>

						<div class="table-responsive">

							<table class="table table-bordered table-hover mb-none">
								<colgroup>
									<col style="width:50px;" />
									<col style="width:80px;" />
									<col style="" />
									<col style="" />
									<col style="" />
									<!-- <col style="width:80px;" /> -->
									<!-- <col style="" /> -->
								</colgroup>
								<thead>
									<tr>
										<th style="text-align: center;"><div class="control-group"><span class="checkbox-custom checkbox-text-primary">
										<input type="checkbox" name="checkall" id="humanCheckall" />
										<label></label>
										</span></div></th>
										<th style="text-align: center;" >순번</th>
										<th style="text-align: center;">스킨명</th>
										<th style="text-align: center;">이미지</th>
										<th style="text-align: center;">CSS</th>
										<!-- <th style="text-align: center;">적용개수</th> -->
										<!-- <th style="text-align: center;">설명</th> -->
									</tr>
								</thead>
								<tbody>
									<c:forEach items="${skinList.listObject}" var="listOutpt" varStatus="status">
										<tr>
											<td style="text-align: center;"><div class="control-group"><span class="checkbox-custom checkbox-text-primary">
											<input type="checkbox" data-style="checkbox" name="skinIds" class="skinIds" value="${listOutpt.skinId}" />
											<label></label>
											</span></div></td>
											<td style="text-align: center;">${(skinList.totalCount + 1) - listOutpt.rnum}</td>
											<td><a href="javascript:;" onclick="f_update('${listOutpt.skinId}');">${listOutpt.skinName}</a></td>
											<td>${listOutpt.imageDocbase}</td>
											<td>${listOutpt.cssDocbase}</td>
											<!-- <td></td> -->
											<%-- <td>${listOutpt.description}</td> --%>
										</tr>
									</c:forEach>
									<c:if test="${skinList.totalCount == 0}">
										<tr>
											<td colspan="7" style="height:50px; text-align:center; vertical-align:middle;">등록된 데이터가 없습니다.</td>
										</tr>
									</c:if>

								</tbody>
							</table>
						</div>
						</form>
					</div>
					<footer class="panel-footer">
						<div class="row">
							<div class="col-sm-5">
								<cms:paging listVO="${skinList}" />
							</div>
							<div class="col-sm-7 text-right">
								<div class="btns">
									<a href="#" onclick="javascript:f_delete(); return false;" class="btn btn-danger">선택 삭제</a>
									<a href="#" onclick="javascript:f_insert();" class="btn btn-primary">스킨 등록</a>
								</div>
							</div>
						</div>
					</footer>
				</section>
				</div>

			</div>
