<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/taglibs.jsp" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%--
<jsp:useBean id="toDay" class="java.util.Date" />
<fmt:formatDate value="${toDay}" pattern="yyyyMMdd" var="today"/>
<script type="text/javascript">
	$(function(){

		$(".bx-prev").on("click", function(){
			$("#monthPrevNext").val("prev");
			$("#searchFrm").submit();
		});

		$(".bx-next").on("click", function(){
			$("#monthPrevNext").val("next");
			$("#searchFrm").submit();
		});

		$("select[name='srchYear'], select[name='srchMonth']").on("change", function(){
			$("#searchFrm").submit();
		});

		$(".cal_top_add").on("click", function(){
			$(".addworklayerWrap").show();
		});

		$("#btn_close").on("click", function(){
			$(".addworklayerWrap").hide();
		});

		var createCalendarLayer = function(calendarDate, nttNo, sj){
			if ( $("#layer" + calendarDate).length > 0 ) {
				var creatHtml = "<div id=\"layer" + calendarDate + "\" class=\"addworklayerWrap\">";
				creatHtml += "	<div class=\"addwork\">";
				creatHtml += "		<h3 class=\"tit\">" + calendarDate + " 일정</h3>";
				creatHtml += "		<div class=\"cal_mid addworkBox\"><span class=\"icoCircle\">아이콘</span> <a href=\"/${currUri}/" + nttNo + "\" class=\"cal_work\">" + sj + "</a></div>";
				creatHtml += "		<a href=\"javascript:hideCalendarLayer('" + calendarDate + "');\" class=\"close\" id=\"btn_close\">레이어닫기</a>";
				creatHtml += "	</div>";
				creatHtml += "</div>";
				$("#calendarWrap").append(creatHtml);
			}
			else{
				var creatHtml = "<div class=\"cal_mid addworkBox\"><span class=\"icoCircle\">아이콘</span> <a href=\"/${currUri}/" + nttNo + "\" class=\"cal_work\">" + sj + "</a></div>";
				$("#layer" + calendarDate + " > .addwork").append(creatHtml);
			}
		}

		var showCalendarLayer = function(calendarDate){
			$("#layer" + calendarDate).show();
		}

		var hideCalendarLayer = function(calendarDate){
			$("#layer" + calendarDate).hide();
		}
	})


</script>

<div class="calendarWrap">
	<form id="searchFrm" name="searchFrm" class="form-search" method="post" action="${currUri}">
	<input type="hidden" id="monthPrevNext" name="monthPrevNext"/>
	<div class="calendarTit">
		<a href="#" class="bx-prev">이전</a>
		<span class="cellInDv cellInDvSearch">
			<span class="cellInDvSearchCell srchOption">
				<label for="selcBoardSrchCtg5" class="hidden">검색조건 선택 </label>
				<select id="selcBoardSrchCtg5" name="srchYear" class="selectForm selectDate" style="width:14%;min-width:95px;">
					<c:choose>
						<c:when test="${not empty yearList}">
							<c:forEach var="list" begin="${yearList[0]}" end="${yearList[fn:length(yearList)-1]+5}">
								<option value="${list}" <c:if test="${currYear eq list}">selected="selected"</c:if>>${list}년</option>
							</c:forEach>
						</c:when>
						<c:otherwise>
							<option value="${currYear}">${currYear}년</option>
						</c:otherwise>
					</c:choose>
				</select>
			</span>
			<span class="cellInDvSearchCell srchOption">
				<label for="selcBoardSrchCtg6" class="hidden">검색조건 선택</label>
				<select id="selcBoardSrchCtg6" name="srchMonth" class="selectForm selectDate" style="width:14%;min-width:75px;">
					<c:forEach var="month" begin="1" end="12" step="1">
						<fmt:formatNumber var="months" value="${month}" minIntegerDigits="2"/>
						<option value="${months}" <c:if test="${currMonth eq months}">selected="selected"</c:if>>${months}월</option>
					</c:forEach>
				</select>
			</span>
		</span>
		<a href="#" class="bx-next">다음</a>
	</div>
	</form>
	<div class="calendarTableWrap">
		<table class="calendarTable center " summary="${curMenuVO.menuNm } 캘린더">
			<caption>${curMenuVO.menuNm } 캘린더</caption>
			<colgroup>
				<col style="width:100px;" />
				<col style="width:100px;" />
				<col style="width:100px;" />
				<col style="width:100px;" />
				<col style="width:100px;" />
				<col style="width:100px;" />
				<col style="width:100px;" />
			</colgroup>
			<thead>
				<tr>
					<th class="sun" scope="col">일</th>
					<th scope="col">월</th>
					<th scope="col">화</th>
					<th scope="col">수</th>
					<th scope="col">목</th>
					<th scope="col">금</th>
					<th scope="col" class="sat">토</th>
				</tr>
			</thead>
			<tbody>
				<c:set var="nextDay" value="1"/>
				<c:forEach begin="1" end="42" step="1" varStatus="status">
					<!-- 날짜 변수 Set -->
					<c:set var="Year" value="${calendarMap.Year}"/>
					<c:set var="Month" value="${calendarMap.Month}"/>
					<c:set var="Day" value="${status.count - calendarMap.sDay + 1}"/>
					<c:if test="${status.first}">
						<tr>
					</c:if>

					<td>
					<c:choose>
						<c:when test="${status.count >= calendarMap.sDay && status.count < (calendarMap.sDay + calendarMap.eDay)}">
							<!-- 현재달 달력 -->
							<fmt:parseDate var="thisDay" value="${Day}" pattern="DD"/>
							<fmt:formatDate var="days" value="${thisDay}" pattern="DD"/>
							<c:set value="${Year}${Month}${days}" var="calendarDay"/>
							<a href="#" class="cal_day<c:if test="${(status.index - 1) % 7  eq 6}"> sat</c:if><c:if test="${(status.index - 1) % 7  eq 0}"> sun</c:if><c:if test="${calendarDay eq today}"> todayon</c:if>" style="cursor: default; text-decoration: none;">
								<c:out value="${days}"/>
							</a>
							<c:set value="0" var="dataCnt" />
							<c:forEach var="data" items="${listVO.listObject}" varStatus="listStatus">
								<c:if test="${listStatus.first}">
									<div class="td_scrollX">
								</c:if>
								<fmt:formatNumber var="sdateNum" value="${fn:replace(fn:substring(data.beginDttm, 0, 10), '-', '')}" />
								<fmt:formatNumber var="edateNum" value="${fn:replace(fn:substring(data.endDttm, 0, 10), '-', '')}"/>
								<fmt:formatNumber var="currDateNum" value="${currYear}${currMonth}${days}"/>

								<c:if test="${sdateNum <= currDateNum and edateNum >= currDateNum}">
									<div class="cal_mid">
										<span class="icoCircle"></span><a href="${currUri}/${data.nttNo}?srchYear=${currYear}&srchMonth=${currMonth}" class="cal_work">${data.sj}</a>
									</div>
								</c:if>
								<c:if test="${listStatus.last}">
									</div>
								</c:if>
							</c:forEach>
						</c:when>
						<c:otherwise>
							<!-- 이전달 달력 -->
							<a href="#" class="cal_day before" style="cursor: default; text-decoration: none;">
							<c:if test="${status.count < calendarMap.sDay}">
								<c:out value="${calendarMap.prevDate + Day}"/>
							</c:if>
							<!-- 다음달 달력 -->
							<c:if test="${status.count >= (calendarMap.sDay + calendarMap.eDay)}">
								<c:out value="${nextDay}"/>
								<c:set var="nextDay" value="${nextDay + 1}"/>
							</a>
							</c:if>
						</c:otherwise>
					</c:choose>
					</td>

					<c:if test="${status.count % 7 == 0 and !status.first}">
						</tr>
						<tr>
					</c:if>

					<c:if test="${status.last}">
						</tr>
					</c:if>
				</c:forEach>
			</tbody>
		</table>
	</div>

	<!--
	<div class="addworklayerWrap">
		<div class="addwork">
			<h3 class="tit">2016-09-13 일정</h3>
			<div class="cal_mid addworkBox"><span class="icoCircle">아이콘</span> <a href="#" class="cal_work">11111</a></div>
			<div class="cal_mid addworkBox"><span class="icoCircle">아이콘</span> <a href="#" class="cal_work">22222</a></div>
			<div class="cal_mid addworkBox"><span class="icoCircle">아이콘</span> <a href="#" class="cal_work">33333</a></div>
			<div class="cal_mid addworkBox"><span class="icoCircle">아이콘</span> <a href="#" class="cal_work">44444</a></div>
			<a href="#" class="close" id="btn_close">레이어닫기</a>
		</div>
	</div>
	 -->
</div>
--%>
<link rel="stylesheet" type="text/css" href="${themeAssets}/vendor/fullcalendar/fullcalendar.min.css">
<link rel="stylesheet" type="text/css" href="${themeAssets}/vendor/fullcalendar/fullcalendar.print.css" media="print">
<script src="${themeAssets}/vendor/fullcalendar/moment.min.js"></script>
<script src="${themeAssets}/vendor/fullcalendar/fullcalendar.min.js"></script>
<script src="${themeAssets}/vendor/fullcalendar/ko.js"></script>
<script type="text/javascript">
$(function() {
	$('#calendar').fullCalendar({
		theme: true,
		header: {
			left: 'prev,next today',
			center: 'title',
			right: 'month,agendaWeek,agendaDay'
		},
		height:700,
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
	            },
	            success: function(calList) {
	                var events = [];
	                $.each(calList, function (index, value) {
	            		var desc = "<strong>일정</strong> : " + value.beginDttm + " ~ " + value.endDttm + "<br/>";
	            		if(value.place != "") desc += "<strong>장소</strong> : " + value.place + "<br/>";
	            		if(value.beginAditCn != null) desc += "<strong>시작 추가 내용</strong> : " + nl2br(value.beginAditCn) + "<br/>";
	            		if(value.endAditCn != null) desc += "<strong>종료 추가 내용</strong> : " + nl2br(value.endAditCn) + "<br/>";
	            		if(value.sumry != null) desc += nl2br(value.sumry);
	                	events.push({
	                          title: value.sj
	                        , start : value.beginDttm.replace(" ", "T")
	                        , end : value.endDttm.replace(" ", "T")
	                        , goUrl : "${currUri}/"+value.nttNo
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
</script>
<div class="calendarWrap">
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
	    	<a id="eventLink" target="_self" class="btn">상세보기</a>
	    </p>
	</div>
</div>