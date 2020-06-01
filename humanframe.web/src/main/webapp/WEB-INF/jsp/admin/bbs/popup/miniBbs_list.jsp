<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ include file="/common/taglibs.jsp" %>

	<script type="text/javascript">
	$(function() {
		$("#srchBeginDt, #srchEndDt").datepicker({
			showOn: "button",
            buttonImage: "${globalAdminAssets}/images/calendar.png",
            buttonImageOnly: true
		});

		$("#allCheck").click(function(){
			if($("#allCheck").prop("checked")) {
				$("input[type=checkbox]").prop("checked",true);
			} else {
				$("input[type=checkbox]").prop("checked",false);
			}
		})
	});

	function f_insert(form, id, bbsNo)
	{
		if($("input[name=bbsListIds]:checked").length == 0){
			alert("선택된 건이 없습니다.");
		}
		else{
			$("input[name=bbsListIds]:checked").each(function() {
				var miniBbs = $(this).val().split('_');
				var code = "[minibbs bbsNo=\"" + miniBbs[0] + "\" bbsListId=\"" + miniBbs[1] + "\"]";
				opener.f_insertData(code);
			});
			window.close();
		}

	}
	</script>

	<section class="panel panel-primary">
		<header class="panel-heading">
			<div class="panel-actions">
			<button class="btn btn-default" title="선택완료(닫기)" onclick="window.close(); return false;"><i class="fa fa-remove"></i> 선택완료(닫기)</button>
			</div>
			<h2 class="panel-title">미니게시판 목록 (총  ${list.totalCount}건)</h2>
		</header>
		<div class="panel-body">
			<div id="preview" style="width:700;height:200;border:1px solid #e5e1dc;text-align:center;display:none;"></div>
			<form id="searchFrm" name="searchFrm" method="post" action="/admin/bbs/mini/popup/miniBbsList" class="form-horizontal form-bordered mb-md">
			<input type="hidden" name="crud" id="crud" value="" />
			<input type="hidden" name="bbsListId" 	id="bbsListId" 	value="0" />
			<input type="hidden" name="cntPerPage" id="cntPerPage" 	value="10" />
			<input type="hidden" name="curPage" id="curPage" value="${curPage}"/>
			<div class="form-group">
				<div class="form-inline ml-md">
					<input type="text" id="srchBeginDt" name="srchBeginDt" class="form-control" value="${param.srchBeginDt }" readonly="readonly"> ~
					<input type="text" id="srchEndDt" name="srchEndDt" class="form-control" value="${param.srchEndDt }" readonly="readonly">
						<select id="srchKey" name="srchKey" class="form-control" style="margin-bottom: 0px;">
							<option value="NAME" <c:if test="${param.srchKey eq 'NAME'}">selected="selected"</c:if>>리스트명</option>
							<option value="SITE_NM" <c:if test="${param.srchKey eq 'SITE_NM'}">selected="selected"</c:if>>사이트</option>
							<option value="CTGRY_NM" <c:if test="${param.srchKey eq 'CTGRY_NM'}">selected="selected"</c:if>>카테고리</option>
							<option value="BBS_SJ" <c:if test="${param.srchKey eq 'BBS_SJ'}">selected="selected"</c:if>>게시판</option>
						</select>
					<input type="text" id="srchText" name="srchText" value="<c:out value='${param.srchText}'/>" class="form-control" placeholder="검색어 입력" onkeydown="javascript:if(event.keyCode==13){searchSet('submit'); return false;}">
					<button type="submit" class="btn btn-default" ><i class="fa fa-search"></i> 검색</button>
                </div>
           	</div>

			<div class="table-responsive">

				<table class="table table-bordered table-hover mb-none">
					<colgroup>
						<col style="width:50px;" />
						<col style="width:80px;" />
						<col style="width:100px;" />
						<col style="" />
						<col style="" />
						<col style="" />
						<col style="" />
						<col style="" />
						<col style="" />
						<col style="width:80px;" />
					</colgroup>
					<thead>
						<tr>
							<th><div class="control-group"><span class="checkbox-custom checkbox-text-primary">
							<input type="checkbox" name="allCheck" id="allCheck" />
							<label></label>
							</span></div></th>
							<th class="text-center">순번</th>
							<th class="text-center">사이트</th>
							<th class="text-center">카테고리</th>
							<th class="text-center">게시판</th>
							<th class="text-center">리스트명</th>
							<th class="text-center">삽입코드</th>
							<th class="text-center">목록수</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach items="${list.listObject}" var="listOutpt" varStatus="status">
							<tr>
								<td class="text-center"><div class="control-group"><span class="checkbox-custom checkbox-text-primary">
								<input type="checkbox" data-style="checkbox" name="bbsListIds" id="bbsListIds_${status.index}" class="bbsListIds" value="${listOutpt.bbsNo}_${listOutpt.bbsListId}" />
								<label></label>
								</span></div></td>
								<td class="text-center">${(list.totalCount + 1) - listOutpt.rnum}</td>
								<td>${listOutpt.siteNm}</td>
								<td>${listOutpt.ctgryNm}</td>
								<td>${listOutpt.bbsSj}</td>
								<td>${listOutpt.name}</td>
								<td>
									<p class="text-success font-weight-bold">[minibbs bbsNo="${listOutpt.bbsNo}" bbsListId="${listOutpt.bbsListId}"]</p>
								</td>
								<td class="text-center">${listOutpt.listCount}</td>
							</tr>
						</c:forEach>
						<c:if test="${list.totalCount == 0}">
							<tr>
								<td colspan="9" style="height:50px; text-align:center; vertical-align:middle;">등록된 데이터가 없습니다.</td>
							</tr>
						</c:if>

					</tbody>
				</table>
			</div>
			</form>
		</div>
		<footer class="panel-footer">
			<div class="row">
				<div class="col-sm-7">
					<cms:paging listVO="${list}" />
				</div>
				<div class="col-sm-5 text-right">
					<div class="btns">
						<a href="#" onclick="javascript:f_insert();" class="btn btn-primary">미니게시판삽입</a>
					</div>
				</div>
			</div>
		</footer>
	</section>

