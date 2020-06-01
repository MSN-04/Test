<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp" %>
<%@ page trimDirectiveWhitespaces="true" %>


<script>
	// 스케쥴 리스트 호출
	function f_callSchdulList(date){
		var data = {
				schdulDate : date
        }
		$.ajax({
			type : "post",
			url: '/admin/mng/schdul/list.json',
			data: data,
			dataType: 'json', //전송받을 데이터의 타입
			contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
			success: function(data) {
				$("#listUl").html("");
				$("#date").html(data.schdulDate);
				if(data.notifyListVO != null){
					//공지리스트
					f_schdulListHtml(data.notifyListVO);
				}
				if(data.listVO != null){
					//스케쥴리스트
					f_schdulListHtml(data.listVO);
				}
			},
			error: function(data, status, err) {
				alert("<spring:message code='fail.common.network' />");
			}
		});
	}

	function f_schdulListHtml(data){
		var html = "";
		if(data.length > 0){
			for(var i=0; data.length >i; i++){
				html += '<li>';
				//html += '<input type="checkbox" id="arrSchdulNo'+data[i].schdulNo+'" name="arrSchdulNo" value='+data[i].schdulNo+' />';
				if(data[i].notifyAt == "Y"){
					html += '<small class="highlight"><i class="fa fa-volume-up text-danger"></i> 공지일정</small><br>';
				}else{
					html += '<small class="highlight">나의일정</small><br>';
				}
				html += '<a><span onclick="f_callSchdulView('+data[i].schdulNo+'); return false;">' + data[i].schdulCn + '</a></span>';
				html += '</li>';
			}
		}
		$("#listUl").append(html);
	}

	// 등록/수정 팝업
	function f_showSchdulPop(crud){
		if(crud == "CREATE"){
			$(".hiddenTr").css("display", "none");
			$(".hiddenNotiTr").css("display", "");
			$(".deleteBtn").css("display", "none");
			f_schdulPopHtmlReset();
		}else{
			$(".hiddenTr").css("display", "");
			$(".deleteBtn").css("display", "");
		}
		//modal open
		$.magnificPopup.open({
			items:{src:'#schdulModal'},
			type: 'inline',
			preloader: false,
			modal: false
		});

		$("#crud").val(crud);
	}

	//수정
	function f_callSchdulView(schdulNo){
		 var data = {
				 schdulNo : schdulNo
        }
		$.ajax({
			type : "post",
			url: '/admin/mng/schdul/view.json',
			data: data,
			dataType: 'json', //전송받을 데이터의 타입
			contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
			success: function(data) {
				if(data.mngSchdulVO != null){
					f_showSchdulPop("UPDATE");
					f_schdulPopHtml(data.mngSchdulVO);
				}
			},
			error: function(data, status, err) {
				alert("<spring:message code='fail.common.network' />");
			}
		});
	}

	function f_schdulPopHtml(data){
 		$("#schdulNo").val(data.schdulNo);
 		$("#schdulDate").val(data.schdulDate);
 		$("#schdulCn").val(data.schdulCn);
 		$("#creatDttm").val(data.creatDttm);
 		$("#crtrId").val(data.crtrNm +"("+ data.crtrId +")");
 		$("#updtDttm").val(data.updtDttm);
 		$("#updusrId").val(data.updusrNm +"("+ data.updusrId +")");
 		if(data.notifyAt == "Y"){
 			$("#notifyAtY").prop("checked", true);
 		} else {
 			$("#notifyAtN").prop("checked", true);
 		}
		// 공지일정일경우 작성자면 변경가능
 		if(('${HUMAN_ADMIN.mngrId}' != data.crtrId)){
 			$(".hiddenNotiTr").css("display", "none");
 		} else {
 			$(".hiddenNotiTr").css("display", "");
 		}
	}

	function f_schdulPopHtmlReset(){
 		$("#schdulNo").val("");
 		$("#schdulDate").val($("#schdulDay").val());
 		$("#schdulCn").val("");
 		$("#creatDttm").val("");
 		$("#crtrId").val("");
 		$("#updtDttm").val("");
 		$("#updusrId").val("");
 		$("#notifyAtN").prop("checked", true);
	}

	// 스케쥴 등록/수정
	function f_schdulAction(){
		if($("#schdulDate").val() =="" || $("#schdulCn").val() == ""){
			alert("일자와 내용을 입력해주세요")
			return
		}
        var data = {
        		 schdulNo : $("#schdulNo").val()
        	   , schdulDate : $("#schdulDate").val()
        	   , schdulCn : $("#schdulCn").val()
        	   , notifyAt : $('input:radio[name=notifyAt]:checked').val()
        	   , crud : $("#crud").val()
        }
		$.ajax({
			type : "post",
			url: '/admin/mng/schdul/action.json',
			data: data,
			dataType: 'json', //전송받을 데이터의 타입
			contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
			success: function(data) {
				if(data.rtnVal == "SUCCESS"){
					f_closeSchdulPop();
					//등록 수정
					f_callSchdulList();
				}else{
					alert("오류가발생했습니다. 다시시도해주세요");
				}
			},
			error: function(data, status, err) {
				alert("<spring:message code='fail.common.network' />");
			}
		});
	}

	function f_schdulDelete(){
		$("#crud").val("DELETE");
		 f_schdulAction();
	}
	function f_closeSchdulPop(){
		$.magnificPopup.close();
		f_schdulPopHtmlReset();
	}

	$(document).ready(function (){
		//f_callSchdulList();
		$('#schdulDatepicke').datepicker().on("changeDate", function(e) {
	    	f_callSchdulList($("#schdulDay").val());
	    });
	});


</script>

		<aside id="sidebar-right" class="sidebar-right">
			<div class="nano">
				<div class="nano-content">
					<a href="#" class="mobile-close visible-xs">
						Collapse <i class="fa fa-chevron-right"></i>
					</a>

					<div class="sidebar-right-wrapper">

						<div class="sidebar-widget widget-calendar">
							<h6>Upcoming Tasks</h6>
							<div id="schdulDatepicke" data-plugin-datepicker data-plugin-skin="dark" >
								<input type="hidden" id="schdulDay" name="schdulDate">
							</div>
							<button class="btn btn-xs btn-warning btn-block" onclick="f_showSchdulPop('CREATE'); return false;">일정등록</button>
							<ul>
								<li>
									<time datetime="2016-04-19T00:00+00:00" id="date"></time>
									<ul id="listUl">
										<!-- ajax -->
									</ul>
								</li>
							</ul>
						</div>
					</div>
				</div>
			</div>
		</aside>



		<!-- 일정등록/상세 모달 -->
		<div id="schdulModal" class="modal-block modal-block-primary mfp-hide" style="width:640px;">
			<section class="panel panel-featured panel-featured-primary">
            	<input type="hidden" id="crud" name="crud">
            	<input type="hidden" id="schdulNo" name="schdulNo">
				<header class="panel-heading">
					<h2 class="panel-title">일정 등록/수정</h2>
				</header>
				<div class="panel-body">
					<table class="table table-bordered mb-none">
						<colgroup>
							<col style="width:100px" />
							<col />
							<col style="width:100px" />
							<col />
						</colgroup>
						<tbody>
							<tr>
								<th>일자 <span class="required">*</span></th>
								<td colspan="3">
									<input type="text" id="schdulDate" name="schdulDate" data-plugin-datepicker class="form-control" readonly="readonly">
								</td>
							</tr>
							<tr>
								<th>내용 <span class="required">*</span></th>
								<td colspan="3">
									<textarea id="schdulCn" name="schdulCn" class="form-control"></textarea>
								</td>
							</tr>
							<tr class="hiddenTr" style="display:none;">
								<th>등록일</th>
								<td>
									<input type="text" id="creatDttm" name="creatDttm" class="form-control" readonly="readonly">
								</td>
								<th>등록자</th>
								<td>
									<input type="text" id="crtrId" name="crtrId" class="form-control" readonly="readonly">
								</td>
							</tr>
							<tr class="hiddenTr" style="display:none;">
								<th>수정일</th>
								<td>
									<input type="text" id="updtDttm" name="updtDttm" class="form-control" readonly="readonly">
								</td>
								<th>수정자</th>
								<td>
									<input type="text" id="updusrId" name="updusrId" class="form-control" readonly="readonly">
								</td>
							</tr>
							<tr>
							</tr>
							<tr class="hiddenNotiTr">
								<th>공지등록여부 </th>
								<td colspan="3">
								<div class="control-group">
									<span class="radio-custom">
										<input type="radio" id="notifyAtY" name="notifyAt" value="Y"><label for="notifyY">Y</label>
									</span>
									<span class="radio-custom">
										<input type="radio" id="notifyAtN" name="notifyAt" value="N" checked="checked"><label  for="notifyN">N</label>
									</span>
								</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<footer class="panel-footer">
					<div class="row">
						<div class="col-sm-6">
	                    	<button class="btn btn-default" onclick="f_closeSchdulPop(); return false;">닫기</button>
	                    </div>
	                    <div class="col-sm-6 text-right">
	                    	<button class="btn btn-danger deleteBtn" onclick="f_schdulDelete(); return false;">삭제</button>
	                    	<button class="btn btn-primary" onclick="f_schdulAction(); return false;">저장</button>
	                    </div>
                    </div>
				</footer>
			</section>
           </div>

