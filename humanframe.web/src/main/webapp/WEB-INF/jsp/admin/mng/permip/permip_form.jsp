<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/taglibs.jsp" %>
<%@ page trimDirectiveWhitespaces="true" %>
	<script type="text/javascript">
	//<![CDATA[
		 function fnModifyForm(obj, ipNo) {
			var trobj = $(obj).parent().parent().parent();
			var ipobjs = $("td:eq(3)", trobj).html();
			var memoobjs = $("td:eq(4)", trobj).html();
	        var cell = $("<input type=\"text\" id=\"ip1"+ipNo+"\" name=\"ip1\" class=\"form-control\" value=\""+ipobjs+"\" />");
	        var cell2 = $("<input type=\"text\" id=\"memo1"+ipNo+"\" name=\"memo1\" class=\"form-control\" value=\""+memoobjs+"\" />");
			$("td:eq(3)", trobj).html(cell);
			$("td:eq(4)", trobj).html(cell2);
			$("#ipinsarea"+ipNo).css("display", "block");
			$("#ipmodarea"+ipNo).css("display", "none");
		}

		//ip 수정 취소
		function fnCancelForm(obj, ipNo, ip, memo) {
			var trobj = $(obj).parent().parent().parent();
			$("td:eq(3)", trobj).html(ip);
			$("td:eq(4)", trobj).html(memo);
			$("#ipinsarea"+ipNo).css("display", "none");
			$("#ipmodarea"+ipNo).css("display", "block");
		}

		//ip 수정
		function fnModify(obj, permIpNo, ip) {
			$("#permIp").val("");
			$("#permIpNo").val("");
			var trobj = $(obj).parent().parent().parent();
			var ipobjs = $("td:eq(3)", trobj).html();
			var ipRegExp = /\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b/;

			//if(!$("td:eq(3) input", trobj).val().match(ipRegExp)) {
			if($("td:eq(3) input", trobj).val() == "") {
				alert("입력하신 IP를 확인해주시기 바랍니다.");
				$("td:eq(3) input", trobj).focus();
			} else {
				if(confirm("저장하시겠습니까?")) {
					$("#permIp").val($("td:eq(3) input", trobj).val().trim());
					$("#memo").val($("td:eq(4) input", trobj).val().trim());
					$("#permIpNo").val(permIpNo);
					$("#listForm").attr("action", "permipMngModify");
					$("#listForm").submit();
				}
			}
		}

		//ip 신규등록
		function fnInsPermip() {
			var ipRegExp = /\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b/;
			//if(!$("#permIpReg").val().match(ipRegExp)) {
			if($("#permIpReg").val() == "") {
				alert("입력하신 IP를 확인해주시기 바랍니다.");
				$("#permIpReg").focus();
			} else {
				$("#permIp").val($("#permIpReg").val());
				$("#memo").val($("#memoReg").val());
				$("#listForm").attr("action", "permipMngSave");
				$("#listForm").submit();
			}
		}

		//ip 신규등록 초기화
		function fnInitPermip() {
			location.href = "list";
		}

		function f_useAtChg(at){
			$("#listUseAt").val(at);
			$("#listForm").attr("action", "permipMngUseModify");
			$("#listForm").submit();
		}

		function f_searchUseAt(at){
			$("#useAt").val(at);
			$("#listForm").submit();
		}

		//검색
		function f_searchText(at){
			if(at == ''){$("#useAt").val('Y');}
			$("#listForm").attr("action", "list");
			$("#listForm").submit();
		}

		//페이지 로딩
		$(document).ready(function(){

			var totalCnt = $(":checkbox[name='checkIpNo']").length;

			//전체 선택 체크박스 클릭시
			$(":checkbox[name='chkAll']").click(function(){
				var isChecked = $(this).is(":checked");
				$(":checkbox[name='checkIpNo']").prop("checked",isChecked);
				$(":checkbox[name='chkAll']").prop("checked",isChecked);
			});

			//리스트 체크박스 클릭시
			$(":checkbox[name='checkIpNo']").click(function(){
				checkedCnt = $(":checkbox[name='checkIpNo']:checked").length;

				if( totalCnt==checkedCnt ){
					$(":checkbox[name='chkAll']").prop("checked",true);
				}else{
					$(":checkbox[name='chkAll']").prop("checked",false);
				}
			});


			var duplCheck = "<c:out value="${duplCheck}" />";
			if(duplCheck == "true") {
				alert("이미 등록된 아이피 입니다.");
			}
		});

	//]]>
	</script>


			<!-- Start Breadcrumb -->
			<jsp:include page="/WEB-INF/jsp/admin/layout/breadcrumb.jsp">
				<jsp:param name="pageName" value="허용IP 관리"/>
			</jsp:include>
			<!-- End Breadcrumb -->

            <!-- start: page -->
			<div class="row">
				<div class="col-md-12">
				<section class="panel panel-featured panel-featured-primary">
					<header class="panel-heading">
						<div class="panel-actions">
							<div class="btn-group">
								<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">With Selected <span class="caret"></span></button>
								<ul class="dropdown-menu" role="menu">
									<c:if test="${empty param.useAt || param.useAt eq 'Y' }">
									<li><a tabindex="-1" href="#listUpdate" onclick="f_useAtChg('N'); return false;"><i class="fa fa-trash"></i> 선택 삭제</a></li>
									</c:if>
									<c:if test="${param.useAt eq 'N' }">
									<li><a tabindex="-1" href="#listUpdate" onclick="f_useAtChg('Y'); return false;"><i class="fa fa-repeat"></i> 선택 복구</a></li>
									</c:if>
								</ul>
							</div>
							<c:if test="${empty param.useAt || param.useAt eq 'Y' }">
							<button class="btn btn-default" title="사용 데이터" onclick="f_searchUseAt('N'); return false;"><i class="fa fa-th-list"></i> 사용중</button>
							</c:if>
							<c:if test="${param.useAt eq 'N' }">
							<button class="btn btn-default" title="사용안함 데이터" onclick="f_searchUseAt('Y'); return false;"><i class="fa fa-trash"></i> 사용안함</button>
							</c:if>
						</div>
						<h2 class="panel-title">허용IP 관리</h2>
						<p class="panel-subtitle">총 ${listVO.totalCount}건</p>
					</header>
					<div class="panel-body">
						<form id="listForm" name="listForm" method="post" action="" class="form-horizontal form-bordered mb-md">
		                <input type="hidden" id="permIp" name="permIp" value="" />
		                <input type="hidden" id="memo" name="memo" value="" />
						<input type="hidden" id="permIpNo" name="permIpNo" value="" />
						<input type="hidden" id="listUseAt" name="listUseAt" value="" />
	                    <input type="hidden" id="useAt" name="useAt" value="${param.useAt}" />

									<blockquote class="primary rounded b-thin">
							<div class="form-group">
								<div class="form-inline ml-md">
										<p>현재 접속 IP : ${remoteIp }</p>
                                   <input class="form-control" id="permIpReg" name="permIpReg" type="text" placeholder="___.___.___.___" onkeydown="if( event.keyCode==13 ){fnInsPermip();return false;}"/>
                                   <input class="form-control" id="memoReg" name="memoReg" type="text" placeHolder="메모" onkeydown="if( event.keyCode==13 ){fnInsPermip();return false;}"/>
                                   <button onclick="fnInsPermip();return false;" class="btn btn-primary">등록</button>
                                   <button onclick="fnInitPermip();return false;" class="btn btn-default">초기화</button>
                               	</div>
							</div>
									</blockquote>

							<div class="form-group pb-none" style="border-bottom:none;">
	                    		<div class="form-inline ml-md">
									<input type="text" id="searchText" name="searchText" value="${param.searchText}" class="form-control" placeholder="키워드" onkeydown="if( event.keyCode==13 ){f_searchText('${param.useAt}');return false;}">
									<button class="btn btn-default" onclick="f_searchText('${param.useAt}'); return false;"><i class="fa fa-search"></i> 검색</button>
								</div>
							</div>

						<div class="table-responsive">

							<table class="table table-bordered table-hover mb-none" id="table-check1">
								<colgroup>
									<col style="width:55px;" />
									<col style="width:60px;" />
									<col style="width:100px;" />
									<col style="width:160px;" />
									<col />
									<col style="width:100px;" />
									<col style="width:150px;" />
								</colgroup>
								<thead>
									<tr>
										<th style="text-align: center;">
											<div class="checkbox-custom chekbox-primary ml-sm">
											<input type="checkbox" name="chkAll" id="chkAllTop" /><label></label>
											</div>
										</th>
										<th style="text-align: center;">순번</th>
										<th style="text-align: center;">사용여부</th>
										<th style="text-align: center;">승인IP</th>
										<th style="text-align: center;">메모</th>
										<th style="text-align: center;">등록일</th>
										<th style="text-align: center;">수정</th>
									</tr>
								</thead>
								<tbody>
									<c:forEach items="${listVO.listObject}" var="resultList" varStatus="status">
									<tr>
										<td style="text-align: center;">
											<div class="checkbox-custom chekbox-primary ml-sm">
											<input type="checkbox" id="checkIpNo${status.index}" name="checkIpNo" value="<c:out value="${resultList.ipNo}"/>" /><label></label>
											</div>
										</td>
										<td style="text-align: center;">${listVO.startNo - status.index }</td>
										<td style="text-align: center;">
											<c:choose>
												<c:when test="${resultList.useAt eq 'Y'}">사용</c:when>
												<c:otherwise>사용안함</c:otherwise>
											</c:choose>
										</td>
										<td><c:out value="${resultList.ip}"/></td>
										<td>${resultList.memo}</td>
										<td style="text-align: center;"><fmt:formatDate pattern="yyyy-MM-dd" value="${resultList.creatDttm}" /></td>
										<td style="text-align: center;">
											<div id="ipmodarea${status.index}" style="display: block;">
												<a href="#" class="btn btn-sm btn-warning" onclick="fnModifyForm(this, '${status.index}');return false;">수정</a>
											</div>
											<div id="ipinsarea${status.index}" style="display: none;">
												<a href="#" id="btnSave" class="btn btn-sm btn-success" onclick="fnModify(this, '${resultList.ipNo}', '${resultList.ip}');return false;"><span>저장</span></a>
												<a href="#" class="btn btn-sm btn-default" onclick="fnCancelForm(this, '${status.index}', '${resultList.ip}', '${resultList.memo}');return false;"><span>취소</span></a>
											</div>
										</td>
									</tr>
									</c:forEach>
									<c:if test="${empty listVO.listObject}">
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
							<div class="col-sm-12">
								<cms:paging listVO="${listVO}" />
							</div>
						</div>
					</footer>
				</section>
				</div>

			</div>