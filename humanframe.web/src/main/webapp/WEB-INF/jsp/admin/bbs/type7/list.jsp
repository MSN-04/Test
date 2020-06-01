<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ include file="/common/taglibs.jsp" %>

	<link rel="stylesheet" type="text/css" href="${globalAdminAssets}/vendor/fullcalendar/fullcalendar.min.css">
	<link rel="stylesheet" type="text/css" href="${globalAdminAssets}/vendor/fullcalendar/fullcalendar.print.css" media="print">
	<script src="${globalAdminAssets}/vendor/fullcalendar/moment.min.js"></script>
	<script src="${globalAdminAssets}/vendor/fullcalendar/fullcalendar.min.js"></script>
	<!-- <script src="${globalAdminAssets}/vendor/fullcalendar/jquery-ui.custom.min.js"></script> -->
	<script src="${globalAdminAssets}/vendor/fullcalendar/ko.js"></script>

	<script type="text/javascript">
	$(function() {

		//$("#table-check1").selectRow({
		//	classname : 'grey'
		//});

		$("#srchKey").on("change", function(){
			if(this.value == "writngDe"){
				$("#srchText").val('').hide();
				$("#srchBeginDt, #srchEndDt").show().datepicker();
			}
			else{
				$("#srchText").show();
				$("#srchBeginDt, #srchEndDt").val('').hide().datepicker('destroy');
			}
		});

		$('#searchFrm').submit(function() {
			if( $("#srchKey").val() == "writngDe" ){
				if($("#srchBeginDt").val() == "" || $("#srchEndDt").val() == ""){
					alert("검색일을 입력하세요.");
					return false;
				}
			}
			$("#calendar").fullCalendar('refetchEvents');
		});

		$('#calendar').fullCalendar({
			theme: true,
			header: {
				left: 'prev,next today',
				center: 'title',
				right: 'month,agendaWeek,agendaDay'
			},
			height:1100,
			editable: false,
			eventLimit: true,
			displayEventTime : false, // 이벤트시간 숨김
			events: function(start, end, timezone, callback) {
		        $.ajax({
		            url: '/ajax/bbs/getCalendarList.json',
		            data: {
		            	  bbsNo : "${bbsSettingVO.bbsNo}"
		                , srchStartDt : moment(start).format('YYYY-MM-DD')
		                , srchEndDt : moment(end).format('YYYY-MM-DD')
		                , srchCtgry : $("#srchCtgry").val()
		                , srchKey : $("#srchKey").val()
		                , srchText : $("#srchText").val()
		                , deleteAt : $("#deleteAt").val()
		            },
		            success: function(calList) {
		                var events = [];
		                $.each(calList, function (index, value) {
		            		var desc = "<strong>일정</strong> : " + value.beginDttm + " ~ " + value.endDttm + "<br/>";
		            		if(value.place != "") desc += "<strong>장소</strong> : " + value.place + "<br/>";
		            		if(value.beginAditCn != null) desc += "<strong>시작 추가 내용</strong> : " + value.beginAditCn + "<br/>";
		            		if(value.endAditCn != null) desc += "<strong>종료 추가 내용</strong> : " + value.endAditCn + "<br/>";
		            		if(value.sumry != null) desc += value.sumry;
		                	events.push({
		                          title: value.sj
		                        , start : value.beginDttm.replace(" ", "T")
		                        , end : value.endDttm.replace(" ", "T")
		                        , goUrl : "./view?bbsNo=" + value.bbsNo + "&nttNo=" + value.nttNo
		                        , description : desc
		                    });
		                });
		                callback(events);
		            }
		        });
		    },
			eventClick:  function(event, jsEvent, view) {
		        $("#eventInfo").html(event.description);
		        $("#eventLink").attr('href', event.goUrl);
		        $("#eventContent").dialog({
		        	modal: true
		        	, title: event.title
		        	, resizable : false
		        	, width : 350
		        });
		    },
		});
	});

	$(document).ready(function(){
		if("${param.srchKey}" == "writngDe"){
			$("#srchText").hide();
			$("#srchBeginDt, #srchEndDt").show().datepicker();
		}
		else{
			$("#srchText").show();
			$("#srchBeginDt, #srchEndDt").hide();
		}


	});

	function fnSearchConfmAt(at){
		$("#searchMode").val("CONFM");
		$("#confmAt").val(at);
		$("#searchFrm").submit();
	}

	function f_nttChg(mode, at){
		if($("input:checkbox[name='arrNttNo']:checked").length > 0){

			var deleteTrue = true;
			if(mode == "delete"){
				deleteTrue = confirm("완전 삭제할 경우 복구할 수 없습니다\n삭제하시겠습니까?");
			}

			if(deleteTrue){
				$("#updateMode").val(mode);
				$("#updateAt").val(at);
				$("#searchFrm").attr("action", "./listAction");
				$("#searchFrm").submit();
			}
		}
		else{
			alert("체크박스를 선택해 1개이상 선택해주세요.");
		}
	}

	function resetSearchFrm(){
		$("#myTab>li").removeClass("active");
		$("#myTab>li").eq(0).addClass("active");
		$("#deleteAt").val("N");
		$("#searchFrm")[0].reset();
		$("#searchFrm").submit();
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

					</div>
					<h2 class="panel-title">[${bbsSettingVO.bbsSj}] 게시판 목록</h2>
					<p class="panel-subtitle">
					</p>
				</header>

				<div class="panel-body">

				<form id="searchFrm" name="searchFrm" class="form-horizontal form-bordered mb-md" method="get" action="./list">
						<input type="hidden" name="bbsTy" id="bbsTy" value="${bbsSettingVO.bbsTy}" />
						<input type="hidden" name="bbsNo" id="bbsNo" value="${bbsSettingVO.bbsNo}" />
						<input type="hidden" id="searchMode" name="searchMode" value="${param.searchMode}" />
						<input type="hidden" id="confmAt" name="confmAt" value="${param.confmAt}" />
						<input type="hidden" id="deleteAt" name="deleteAt" value="${param.deleteAt}" />
						<input type="hidden" id="updateMode" name="updateMode" />
						<input type="hidden" id="updateAt" name="updateAt" />

						<div class="form-group">
                    		<div class="form-inline ml-md">
                    			<c:if test="${bbsSettingVO.ctgryUseAt eq 'Y'}">
									<select id="srchCtgry" name="srchCtgry" class="form-control">
										<option value="">카테고리</option>
										<c:forEach items="${bbsSettingVO.ctgryList}" var="ctgry">
										<option value="${ctgry.ctgryNo}" <c:if test="${ctgry.ctgryNo == param.srchCtgry }">selected</c:if>>${ctgry.ctgryNm}</option>
										</c:forEach>
									</select>
                                </c:if>
                                	<select id="srchKey" name="srchKey" class="form-control">
                                		<option value="sj" <c:if test="${param.srchKey eq 'sj' || param.srchKey eq ''}">selected="selected"</c:if>>제목</option>
                                		<option value="cn" <c:if test="${param.srchKey eq 'cn'}">selected="selected"</c:if>>내용</option>
                                		<option value="ctrtNm" <c:if test="${param.srchKey eq 'ctrtNm'}">selected="selected"</c:if>>작성자</option>
                                	</select>
                                    <input type="text" id="srchText" name="srchText" value="${param.srchText}" class="form-control">
                                    <button type="submit" class="btn btn-default"><i class="fa fa-search"></i> 검색</button>
                            </div>
                        </div>


					<div class="table-responsive">

					<!-- Start Selectable Table Row -->
					<%--
						<table class="table table-bordered table-hover mb-none" id="table-check1">
							<colgroup>
								<col style="width:50px;" />
								<c:forEach var="colHeader" items="${bbsSettingVO.listVal}">
								<c:choose>
									<c:when test="${colHeader eq 'sj'}"><col/></c:when>
									<c:when test="${colHeader eq 'no'}"><col style="width:60px;" /></c:when>
									<c:otherwise><col style="width:100px;" /></c:otherwise>
								</c:choose>
								</c:forEach>
							</colgroup>
							<thead>
								<tr>
									<th><div class="control-group"><span class="checkbox-custom checkbox-text-primary">
									<input type="checkbox" name="checkall" id="humanCheckall" />
									<label></label>
									</span></div></th>
									<c:forEach var="listHeader" items="${bbsSettingVO.listText}">
									<th>${listHeader}</th>
									</c:forEach>
								</tr>
							</thead>
							<tbody>
								<!-- 공지사항 게시물 시작 -->
								<c:forEach items="${noticeListVO.listOutptObject}" var="listOutpt" varStatus="status">
									<c:set var="mapShow" value="${listOutpt.mapShow}"/>
									<c:set var="mapHide" value="${listOutpt.mapHide}"/>
									<tr>
										<td><div class="control-group"><span class="checkbox-custom checkbox-text-primary">
									<input type="checkbox" data-style="checkbox" id="arrNttNo${status.index}" name="arrNttNo" value="${mapHide.nttNo}" />
									<label></label>
									</span></div></td>
										<c:forEach var="item" items="${mapShow}">
											<td>
											<c:choose>

											<c:when test="${ item.key eq 'no' }">
											<img src="${globalAdminAssets}/images/icon/icon_notice.gif" alt="공지사항" style="margin-right: 5px;"/>
											</c:when>

											<c:when test="${ item.key eq 'sj' }">
											<c:if test="${!bbsSettingVO.listVal.contains('no')}"><img src="${globalAdminAssets}/images/icon/icon_notice.gif" alt="공지사항" style="margin-right: 5px;"/></c:if>
											<cmsBtn:view bbsSettingVO="${bbsSettingVO}" detailMap="${noticeListVO.listObject[status.index]}" admin="true">
											<!-- 인기게시물 -->
											<c:choose>
												<c:when test="${bbsSettingVO.popularNttUseAt eq 'Y' and mapShow.rdcnt >= bbsSettingVO.popularNttApplcCo}">
													<font color="${bbsSettingVO.popularNttColor}"><strong>${item.value}</strong></font>
												</c:when>
												<c:otherwise>${item.value}</c:otherwise>
											</c:choose>

											<!-- 신규게시물 -->
											<c:if test="${bbsSettingVO.newNttImageUseAt eq 'Y' and mapHide.timeGap <= bbsSettingVO.newNttApplcPd}">
												<img src='${globalAdminAssets}/images/icon/icon_new.png' width='30' height='30' alt='신규게시물'/>
											</c:if>
											</cmsBtn:view>
											</c:when>

											<c:when test="${ item.key eq 'fileCo' }">
											<c:if test="${ item.value > 0}">
												<img src="${globalAdminAssets}/images/icon/icon_file.gif" alt="첨부파일 있음" />
											</c:if>
											</c:when>

											<c:when test="${ item.key eq 'writngDe' }">
											${ cmsFn:convertDate(item.value, 'yyyy.MM.dd') }
											</c:when>

											<c:when test="${ item.key eq 'secretAt' }">
											${ secretTyCode[item.value] }
											</c:when>

											<c:when test="${ item.key eq 'cclTy' }">
											${ licCode[item.value] }
											</c:when>

											<c:otherwise>
											${item.value}
											</c:otherwise>

											</c:choose>
											</td>
										</c:forEach>
									</tr>
								</c:forEach>
								<!-- 공지사항 게시물 끝 -->
							</tbody>
						</table>
						<!-- End Selectable Table Row -->
						 --%>
						 <!-- Start Full Calendar -->
				            <div class="row-fluid">
				                <div class="span12">
				                    <div class="widget dark">
				                        <div class="widget-content no-padding">
				                            <div class="widget-content-inner">
				                                <div id="calendar" style="padding: 30px;"></div>
				                            </div>
				                        </div>
				                    </div>
				                </div>
				            </div>
				            <!-- End Full Calendar -->

				            <div id="eventContent" title="Event Details" style="display: none;">
							    <div id="eventInfo"></div>
							    <p style="margin-top: 50px; text-align: right;">
							    	<a id="eventLink" target="_self" class="btn btn-primary">상세보기</a>
							    </p>
							</div>

						</div>
					</form>
				</div>
				<footer class="panel-footer">
					<div class="row">
						<div class="col-sm-7">
							<cms:paging listVO="${noticeListVO}" />
						</div>
						<div class="col-sm-5">
							<div class="btns">
								<cmsBtn:insert bbsSettingVO="${bbsSettingVO}" admin="true" cssClass="btn btn-primary">일정 등록</cmsBtn:insert>
							</div>
						</div>
					</div>
				</footer>
			</section>
			</div>
			<!-- end -->
		</div>
		<!-- end -->








