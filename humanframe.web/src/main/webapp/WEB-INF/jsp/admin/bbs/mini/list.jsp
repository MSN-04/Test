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

		$('#searchFrm').submit(function() {

		});

	});

	function f_update(bbs_list_id){
		$("#bbsListId").val(bbs_list_id);
		$("#crud").val("UPDATE");
		$("#searchFrm").attr("action","./form");
		$("#searchFrm").submit();
	}


	function preview(form, id, bbsNo)
	{
		$("#preview").hide();

		if(id == '') return;
		var length = form.bbsListIds.length;

		if(length == null) {
			form.bbsListIds.checked = true;
		} else {
			for(var i=0; i<length; i++) {
				if( form.bbsListIds[i].value == id)
				{
					var uniform_span = $("#" + form.bbsListIds[i].id).parents('.checker span');
					if(uniform_span !== '') {
						$(uniform_span).addClass('checked');
					}
					$("#" + form.bbsListIds[i].id).attr('checked','checked');
				}
			}
		}

		$.ajax({
			   url : "./getPreviewList.json"
			   , data : {
				   	bbsNo : bbsNo,
				   	bbsListId : id
				   }
			   , type : "POST"
			   , dataType : "json"
			   , async : false
			   , success : function(data) {
				   //console.log( data.title );
				   //console.log( JSON.stringify(data.list, null, 2));
				   var arr = data.list;
				   var mList = '<table>';
				   for(var i in arr){
					   mList += '<tr>';
					   mList += '<td>'+arr[i].num+'</td>';
					   mList += '<td>'+arr[i].sj+'</td>';
					   mList += '<td>'+arr[i].wrter+'</td>';
					   mList += '<td>'+arr[i].creatDttm+'</td>';
					   mList += '</tr>';
				   }
				   mList += '</table>';
				   $("#listOutpt").empty();
				   $("#listOutpt").append('<pre>'+JSON.stringify(data.list, null, 2)+'</pre>');
				   // $("#listOutpt").append(mList);
				   //$('#list-title-config').modal('show');
				   $.magnificPopup.open({
						items:{src:'#list-title-config'},
						type: 'inline',
						preloader: false,
						modal: false
					});

	    		},
	    		beforeSend:function(){},
				error: function(data, status, err) {
					//console.log('error forward : ' + data);
				},
				complete : function(data) {}
		});
	}

	function f_deploy()
	{
		var deployCnt = 0;
		var checkCnt = 0;
		var checkboxValues = [];
	    $("input[name='bbsListIds']:checked").each(function(i) {
	    	if($(this).val().substring(0,1) != "0") {
	    		checkboxValues.push($(this).val());
	    		deployCnt++;
	    	}
	    	checkCnt++;
	    });

	    if(checkCnt == 0) {
	    	alert("배포 하실 리스트를 선택하세요!");
	    	return;
	    }

	    if(checkCnt > deployCnt) {
	    	alert("배포 하실 리스트 중 게시판이 없는 리스트는 배포되지 않습니다.\n선택리스트( " + checkCnt + " ) / 배포 개수 ( " + deployCnt + " )");
	    }

	    if(deployCnt == 0) {
	    	alert("배포 하실 리스트를 선택하세요!");
	    	return;
	    }

	    $("#preview").html("");
	    var allData = { "checkArray": checkboxValues };

		$.ajax({
			   url : "./deploy.json"
			   , data : allData
			   , type : "POST"
			   , dataType : "json"
			   , async : false
			   , success : function(data) {
				   $("#preview").html('<strong><font color="green">'+data.count+'건 배포 완료</font></strong>')
				   .show();
	    		},
	    		beforeSend:function(){},
				error: function(data, status, err) {
					$("#preview").html('<strong><font color="orange">배포가 정상 처리되지 않았습니다.<br>관리자에게 문의하세요.</font><strong>')
					.show();
				},
				complete : function(data) {}
		});
	}

	function f_insert(){
		$("#searchFrm").attr("action","./form");
		$("#searchFrm").submit();
	}

	function f_delete(){
		if($(".bbsListIds:checked").length == 0){
			alert("선택된 내역이 없습니다.");
			return;
		}
		if( confirm("<spring:message code='action.confirm.delete' />") ) {
			$("#crud").val("DELETE");
			$("#searchFrm").attr("action","./action");
			document.searchFrm.submit();
		}
	}

	function f_close() {
		//$('#list-title-config').modal('hide');
		$.magnificPopup.close();
	}

	function f_deploy_all()
	{
		$("#preview").html("");
	    $.ajax({
			   url : "./deployAll.json"
			   , type : "POST"
			   , dataType : "json"
			   , async : false
			   , success : function(data) {
				   $("#preview").html('<strong><font color="green">'+data.count+'건 배포 완료</font></strong>')
				   .show();
	    		},
	    		beforeSend:function(){},
				error: function(data, status, err) {
					$("#preview").html('<strong><font color="orange">배포가 정상 처리되지 않았습니다.<br>관리자에게 문의하세요.</font><strong>')
					.show();
				},
				complete : function(data) {}
		});
	}
	</script>

			<!-- Start Breadcrumb -->
			<jsp:include page="/WEB-INF/jsp/admin/layout/breadcrumb.jsp">
				<jsp:param name="pageName" value="미니게시판 관리"/>
			</jsp:include>
			<!-- End Breadcrumb -->


			<!-- start: page -->
			<div class="row">
				<div class="col-md-12">
				<section class="panel panel-featured panel-featured-primary">
					<header class="panel-heading">
						<div class="panel-actions">
						</div>
						<h2 class="panel-title">미니게시판 목록</h2>
						<p class="panel-subtitle">
							총  ${list.totalCount}건
						</p>
					</header>
					<div class="panel-body">
						<div id="preview" style="width:700;height:200;border:1px solid #e5e1dc;text-align:center;display:none;"></div>
						<form id="searchFrm" name="searchFrm" method="post" action="./list" class="form-horizontal form-bordered mb-md">
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
								<button type="submit" class="btn btn-default" onclick="searchSet('submit'); return false;"><i class="fa fa-search"></i> 검색</button>
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
										<th style="text-align: center;"><div class="control-group"><span class="checkbox-custom checkbox-text-primary">
										<input type="checkbox" name="checkall" id="humanCheckall" />
										<label></label>
										</span></div></th>
										<th style="text-align: center;">순번</th>
										<th style="text-align: center;">출력확인</th>
										<th style="text-align: center;">사이트</th>
										<th style="text-align: center;">카테고리</th>
										<th style="text-align: center;">게시판</th>
										<th style="text-align: center;">리스트명</th>
										<th style="text-align: center;">생성파일</th>
										<th style="text-align: center;">목록수</th>
									</tr>
								</thead>
								<tbody>
									<c:forEach items="${list.listObject}" var="listOutpt" varStatus="status">
										<tr>
											<td style="text-align: center;"><div class="control-group"><span class="checkbox-custom checkbox-text-primary">
											<input type="checkbox" data-style="checkbox" name="bbsListIds" id="bbsListIds_${status.index}" class="bbsListIds" value="${listOutpt.bbsNo}_${listOutpt.bbsListId}" />
											<label></label>
											</span></div></td>
											<td style="text-align: center;">${(list.totalCount + 1) - listOutpt.rnum}</td>
											<td><a href="javascript:;" onclick="preview(document.searchFrm, '${listOutpt.bbsListId}', ${listOutpt.bbsNo});"><span class="iconfugue16-magnifier-left"></span>View</a></td>
											<td>${listOutpt.siteNm}</td>
											<td>${listOutpt.ctgryNm}</td>
											<td>${listOutpt.bbsSj}</td>
											<td><a href="javascript:;" onclick="f_update('${listOutpt.bbsListId}');">${listOutpt.name}</a></td>
											<td>
												<c:if test="${ listOutpt.bbsNo != '' && listOutpt.bbsListId != null }">
													${listOutpt.bbsNo}_${listOutpt.bbsListId}.json
												</c:if>
											</td>
											<td style="text-align: center;">${listOutpt.listCount}</td>
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
							<div class="col-sm-5">
								<cms:paging listVO="${list}" />
							</div>
							<div class="col-sm-7 text-right">
								<div class="btns">
									<a href="#" onclick="f_deploy_all(); return false;" class="btn btn-default">전체 재배포</a>
									<a href="#" onclick="f_deploy(); return false;" class="btn btn-default">선택 재배포</a>
									<a href="#" onclick="javascript:f_insert();" class="btn btn-primary">게시판 등록</a>
									<a href="#" onclick="javascript:f_delete(); return false;" class="btn btn-danger">선택 삭제</a>
								</div>
							</div>
						</div>
					</footer>
				</section>
				</div>
			</div>

			<!-- BEGIN SAMPLE PORTLET CONFIGURATION MODAL FORM-->
			<div class="modal-block modal-block-primary mfp-hide" id="list-title-config" style="height:400px; width:600px;">
				<section class="panel panel-featured panel-featured-primary">
					<div class="panel-heading">
						<h2 class="panel-title">DATA 확인</h2>
					</div>
					<div class="panel-body" id="listOutptArea" style="width:100%; height:400px; overflow:auto">
						<ul id="listOutpt" style="padding-left: 0px"></ul>
					</div>
					<div class="panel-footer">
					<div class="row">
						<div class="col-sm-12 text-right">
							<button type="button" class="btn btn-success" onclick="javascript:f_close();">닫기</button>
							</div>
						</div>
					</div>
				</section>
			</div>
