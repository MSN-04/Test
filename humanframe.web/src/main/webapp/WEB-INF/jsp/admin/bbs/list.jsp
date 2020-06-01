<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ include file="/common/taglibs.jsp" %>
	<style type="text/css">
	#selectOutptList option{ height:21px; margin:5px 5px 4px 5px; }
	.ui-sortable { list-style-type: none; margin: 0; padding: 0; width: 90%; }
	.ui-sortable li { margin: 1px; padding: 1px; border: 1px solid #cccccc; color: #0088cc; background: #eeeeee; width:330px;}
	.ui-sortable li span { position: absolute; margin-left: -1.3em; }
	.ui-sortable li input { padding:0 0 0 10px; margin:0; font-size:12px; height:28px; }
	.ui-state-highlight { height: 2.5em; line-height: 1.2em; }
	</style>

	<script type="text/javascript">
	$(document).ready(function(){

		//출력항목설정
	    $( "#listOutpt" ).sortable({
	    	placeholder: "ui-state-highlight"
	    });
	    $( "#listOutpt" ).disableSelection();

		$("#selectOutptList").click(function(){
			var _val = $("#selectOutptList option:selected").val();
			var _text = $("#selectOutptList option:selected").text();
			var _html = "";
			var _chk = true;

			 $(":input[name='listOutptVal']").each(function(){
				if( _val == $(this).val() ){
					_chk = false;
					return false;
				}
			});
			if( _chk==false ){ return false; }

			_html = f_setStringOutpt(_val,_text);
			$("#listOutpt").append(_html);
		});


		//출력항목설정 아이템 삭제
		$(document).on("click",".del-item",function(){
			$(this).parent().remove();
		});

	});

	function fnSearchUseAt(at){
		$("#useAt").val(at);
		$("#searchFrm").submit();
	}

	function f_getOutputList(bbsNo, outputMode){

		$("#bbsNo").val(bbsNo);

		$.ajax({
			type : "POST",
			url : "/admin/ajax/board/getOutputList.json",
			data : {
				"bbsNo" : bbsNo
			},
			success: function(result) {
				f_outptArea('list');
				$("#selectOutptList, #listOutpt, #viewOutpt").empty();
				f_initBoardOutptList(result.bbsOutptList);
				f_initEtcOutpt(result.bbsEtcItemList);
				f_initListOutpt(result.bbsSettingVO.listOutpt);
				f_initBoardOutptView(result.bbsOutptView, result.bbsEtcItemList);

				//$('#list-title-config').modal('show');
				//modal open
				$.magnificPopup.open({
					items:{src:'#list-title-config'},
					type: 'inline',
					preloader: false,
					modal: false
				});
			}
		});
	}

	function f_saveOutputList(){

		var mode = $("#viewTy").val();
		var arrListVal = new Array();
		var arrListText = new Array();

		$("input[name=" + mode + "OutptVal]").each(
	        function(index, item){
	            arrListVal.push(item.value);
	        }
	    );

		$("input[name=" + mode + "OutptText]").each(
	        function(index, item){
	        	arrListText.push(item.value);
	        }
		);

		$.ajax({
			type : "POST",
			url : "/admin/ajax/board/saveOutputList.json",
			data :  {
				"bbsNo" : $("#bbsNo").val()
				, "listVal" : arrListVal
				, "listText" : arrListText
				, "mode" : mode
			},
			success: function(result) {
				alert("<spring:message code='action.complete.insert'/>");
				$.magnificPopup.close();
			}
		});
	}

	function f_setStringOutpt(val, text){
		var html="";
		if( val && text ){

			var disabledTag = "";

			if(val.indexOf("etcData") != -1){
				disabledTag = "disabled";
			}

			html+='<li class="ui-state-medium form-inline ml-md">';
			html+='<i class="fa fa-arrows" style="margin:0 5px 0 5px;"></i>';
			html+='<input type="hidden" name="listOutptVal" value="' + val + '"/>';

			if(val.indexOf("etcData") != -1){
				html+='<input type="hidden" name="listOutptText" value="' + $('#selectOutptList > option[value=' + val + ']').text() + '"/>';
				html+='<input type="text" class="form-control form-control-sm" value="' + $('#selectOutptList > option[value=' + val + ']').text() + '" ' + disabledTag + '/>';
				html+='<button class="btn btn-danger del-item" style="margin-left:10px;"><i class="fa fa-trash" style="color: white;"></i></button>';
				html+='<span style="margin-left:15px;margin-top:5px;text-overflow:ellipsis;white-space: nowrap;width:80px;overflow: hidden;">' + $('#selectOutptList > option[value=' + val + ']').text() + '</span>';
			}else{
				html+='<input type="text" class="form-control form-control-sm" name="listOutptText" value="' + text + '" ' + disabledTag + '/>';
				html+='<button class="btn btn-danger del-item" style="margin-left:10px;"><i class="fa fa-trash" style="color: white;"></i></button>';
				html+='<span style="margin-left:15px;margin-top:5px;">' + $('#selectOutptList > option[value=' + val + ']').text() + '</span>';
			}
			html+='</li>';
		}
		return html;
	}
	
	function f_initBoardOutptList(boardOutputList){
		$.each(boardOutputList, function(fieldId, fieldNm){
			$("#selectOutptList").append( new Option( fieldNm , fieldId, false, false  ) );
		});
	}

	function f_initBoardOutptView(boardOutputView, etcOutput){
		var html = "";
		html += '<tr>';
		html += '		<th class="control-label">필드명</th>';
		html += '		<th class="control-label">출력명</th>';
		html += '</tr>';

		$.each(boardOutputView, function(fieldId, fieldObj){

			var orgNm, outptNm;

			$.each(fieldObj, function(val1, val2){
				orgNm = val1;
				outptNm = val2;
			});

			html += '<tr>';
			html += '		<td class="control-label" style="vertical-align: middle;">' + orgNm + '</td>;';
			html += '		<td class="control-label">';
			html += '			<input type="hidden" name="viewOutptVal" value="' + fieldId + '"/>';
			html += '			<input type="text" class="form-control form-control-sm" name="viewOutptText" value="' + outptNm + '">';
			html += '		</td>';
			html += '</tr>';
		});

		$.each(etcOutput, function(idx, item){
			html += '<tr>';
			html += '		<td class="control-label" style="vertical-align: middle;">기타필드' + item.etcIemNo +'</td>;';
			html += '		<td class="control-label">';
			html += '			<input type="text" class="form-control form-control-sm" disabled value="' + item.etcIemNm + '">';
			html += '		</td>';
			html += '</tr>';
		});

		$("#viewOutpt").append(html);
	}

	function f_initEtcOutpt(etcOutput){

		$.each(etcOutput, function(idx, item){
			$("#selectOutptList").append( new Option( item.etcIemNm, "etcData"+item.etcIemNo, false, false  ) );
		});
	}

	function f_initListOutpt(listOutput){
		var _html="";

		$.each(listOutput.split("|"), function(idx, val){
			var outputData = val.split(":");
			_html += f_setStringOutpt(outputData[0], outputData[1]);
		});

		$("#listOutpt").append(_html);
	}

	function f_outptArea(mode){

		$("#viewTy").val(mode);

		if(mode == "list"){
			$("#listOutptArea").show();
			$("#viewOutptArea").hide();
			$("#listTab").addClass("active");
			$("#viewTab").removeClass("active");
		}else{
			$("#viewOutptArea").show();
			$("#listOutptArea").hide();
			$("#viewTab").addClass("active");
			$("#listTab").removeClass("active");
		}
	}

	</script>

			<!-- Start Breadcrumb -->
			<jsp:include page="/WEB-INF/jsp/admin/layout/breadcrumb.jsp">
				<jsp:param name="pageName" value="게시판 관리"/>
			</jsp:include>
			<!-- End Breadcrumb -->


			<!-- start: page -->
			<div class="row">
				<div class="col-md-12">
				<section class="panel panel-featured panel-featured-primary">
					<header class="panel-heading">
						<div class="panel-actions">
							<c:if test="${empty param.useAt || param.useAt eq 'Y' }">
							<button class="btn btn-default" title="사용 데이터" onclick="fnSearchUseAt('N'); return false;"><i class="fa fa-th-list"></i> 사용중</button>
							</c:if>
							<c:if test="${param.useAt eq 'N' }">
							<button class="btn btn-default" title="사용안함 데이터" onclick="fnSearchUseAt('Y'); return false;"><i class="fa fa-trash"></i> 사용안함</button>
							</c:if>
						</div>
						<h2 class="panel-title">게시판 목록</h2>
						<p class="panel-subtitle">
							총 ${listVO.totalCount}건
						</p>
					</header>
					<div class="panel-body">

						<form id="searchFrm" name="searchFrm" class="form-horizontal form-bordered mb-md" method="get" action="./list">
							<input type="hidden" id="bbsNo"/>
							<input type="hidden" id="viewTy" value="list"/>
							<input type="hidden" id="useAt" name="useAt" value="${empty param.useAt ? 'Y' : param.useAt}" />
							<div class="form-group">
	                    		<div class="form-inline ml-md">
			                        <select id="srchBbsTy" name="srchBbsTy" class="form-control">
										<option value="">전체(게시판 유형)</option>
										<c:forEach items="${bbsTyCode}" var="bbsTy">
										<option value="${bbsTy.key}" <c:if test="${param.srchBbsTy eq bbsTy.key}">selected="selected"</c:if>>${bbsTy.value}</option>
										</c:forEach>
									</select>
									<select id="srchSiteNo" name="srchSiteNo" class="form-control">
										<option value="">전체(사용중 사이트)</option>
										<c:forEach items="${siteList}" var="siteList">
										<option value="${siteList.siteNo}" <c:if test="${param.srchSiteNo eq siteList.siteNo}">selected="selected"</c:if>>${siteList.siteNm}</option>
										</c:forEach>
									</select>
									<input type="text" id="srchText" name="srchText" value="<c:out value='${param.srchText}'/>" class="form-control" placeholder="검색어 입력">
									<button type="submit" class="btn btn-default"><i class="fa fa-search"></i> 검색</button>
	                        	</div>
	                        </div>
						</form>

						<div class="table-responsive">
							<form id="listFrm" name="listFrm" method="get">
									<table class="table table-bordered table-hover mb-none">
										<thead>
											<tr>
												<th style="text-align: center;">순번</th>
												<th style="text-align: center;">게시판 유형</th>
												<th style="text-align: center;">사용중인 메뉴</th>
												<th style="text-align: center;">게시판명</th>
												<th style="text-align: center;">사용여부</th>
												<th style="text-align: center;">관리</th>
											</tr>
										</thead>
										<tbody>
											<c:forEach items="${listVO.listObject}" var="resultList" varStatus="status">
											<tr>
												<td style="text-align: center;">${listVO.startNo - status.index }</td>
												<td style="text-align: center;">${bbsTyCode[resultList.bbsTy]}</td>
												<td>
													<c:forEach items="${resultList.useMenuList }" var="menuList" varStatus="status">
														${menuList.menuNm}<c:if test="${!status.last}"><br/></c:if>
													</c:forEach>
												</td>
												<td>${resultList.bbsSj}</td>
												<td style="text-align: center;">${useAt[resultList.useAt]}</td>
												<td style="text-align: center;">
													<div class="btn-group-sm">
													<button onclick="location.href='/admin/bbs/setting/form?bbsNo=${resultList.bbsNo}';return false;" class="btn btn-success">설정</button>
													<c:if test="${empty resultList.groupBbsUseAt or resultList.groupBbsUseAt eq 'N'}">
													<button onclick="f_getOutputList('${resultList.bbsNo}', 'list');return false;" class="btn btn-danger">출력</button>
													<button onclick="location.href='/admin/bbs/type${resultList.bbsTy}/list?bbsNo=${resultList.bbsNo}';return false;" class="btn">게시물</button>
													</c:if>
													</div>
												</td>
											</tr>
											</c:forEach>
											<c:if test="${empty listVO.listObject}">
											<tr>
												<td colspan="6" style="height:50px; text-align:center; vertical-align:middle;">등록된 데이터가 없습니다.</td>
											</tr>
											</c:if>
										</tbody>
									</table>
									</form>
						</div>
					</div>
					<footer class="panel-footer">
						<div class="row">
							<div class="col-sm-7">
								<cms:paging listVO="${listVO}" />
							</div>
							<div class="col-sm-5">
								<div class="btns">
									<a href="/admin/bbs/setting/form" class="btn btn-primary">게시판 추가</a>
								</div>
							</div>
						</div>
					</footer>
				</section>
				</div>

			</div>



			<!-- BEGIN SAMPLE PORTLET CONFIGURATION MODAL FORM-->
			<div class="modal-block modal-block-primary mfp-hide" id="list-title-config" style="height:600px; width:600px;">
				<section class="panel panel-featured panel-featured-primary">
						<div class="panel-heading">
							<div class="panel-actions">
								<div class="btn-group" data-toggle="buttons-radio" style="padding-right : 20px;">
									<button id="listTab" class="btn btn-default btn-secondary active" onclick="f_outptArea('list'); return false;">목록</button>
									<button id="viewTab" class="btn btn-default btn-secondary" onclick="f_outptArea('view'); return false;">상세</button>
								</div>
							</div>
							<h2 class="panel-title">출력 항목 설정</h2>
						</div>

						<div class="panel-body">
							<div id="listOutptArea">
								<table class="table table-bordered mb-none">
								<colgroup>
									<col style="width:150" />
									<col />
								</colgroup>
								<tbody>
									<tr>
										<th class="control-label">게시판항목</th>
										<th class="control-label">출력명</th>
									</tr>
									<tr>
										<td class="control-label">
											<select multiple="multiple" class="form-control" style="height:280px;width:150px" id="selectOutptList"></select>
										</td>
										<td class="control-label">
											<ul id="listOutpt" class="ui-sortable"></ul>
										</td>
									</tr>
								</tbody>
								</table>
							</div>

							<div  id="viewOutptArea" style="display: none;overflow-y:scroll;">
								<table class="table table-bordered mb-none">
								<tbody id="viewOutpt"></tbody>
								</table>
								<strong>※기타필드는 게시판 세부 설정에서 수정 가능합니다.</strong>
							</div>
						</div>
						<div class="panel-footer">
						<div class="row">
							<div class="col-sm-12 text-right">
								<button type="button" class="btn btn-success" onclick="javascript:f_saveOutputList();">저장</button>
							</div>
						</div>
						</div>
					</section>
					<!-- /.modal-content -->
			</div>
			<!-- /.modal -->