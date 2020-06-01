<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" 	uri="http://www.springframework.org/tags" %>

	<script type="text/javascript" src="https://www.google.com/jsapi"></script>
    <script type="text/javascript">
	google.load("visualization", "1", {
		packages : [ "corechart" ]
	});
	//google.setOnLoadCallback(drawChart);

	function drawChart() {
		if( $("#siteNo option:selected").val()=="" ){
			alert("사이트를 선택하세요");
			$("#siteNo").focus();
			return;
		}
		$("#statusList").html("");
		$("#statusHeader").html("");

		var srchData = $("form[name=srchFrm]").serialize();
		$.ajax({
			dataType: "json",
			data : srchData,
			url: "/admin/stats/analytics.json",
			success:function(result) {
				draw(result.dataArray);
			}
		});
	}

	function draw(jsonArray) {
		var data = google.visualization.arrayToDataTable(jsonArray);
		var options = {
			hAxis : {
				titleTextStyle : {
					color : '#333'
				}
			},
			vAxis : {
				minValue : 0,
				gridlines : {
					count : 10
				}
			},
			seriesType : "bars",
			series : {
				2 : {
					type : "line"
				}
			}
		};
		//console.log(data);
		var chart = new google.visualization.ComboChart(document.getElementById('google_graph'));
		chart.draw(data, options);

		if (data) {
			var titleData = data.Ff;
			var header = "<tr>";
			for(var i = 0; i < titleData.length; i++ ) {
				var title = titleData[i];
				header += "<th>" + title.label + "</th>";
			}
			header += "</tr>";
			$("#statusHeader").append(header);

			var listData = data.Gf;

			for(var i = 0; i < listData.length ;i++) {
				var obj = listData[i];
				console.log(obj.c);
				var html = "<tr>";
				for(var j = 0; j < obj.c.length; j++ ) {
					html += "<td>" + obj.c[j].v + "</td>";
				}
				html += "</tr>";

				$("#statusList").append(html);
			}
		}
	}

	$(function(){
        $('input[name="srchStartDay"],[name="srchEndDay"]').datepicker();
        if($('input[name="srchStartDay"]').val() == ""){
        	$('input[name="srchStartDay"]').datepicker("update", new Date((new Date()).valueOf() - (1000*3600*24*7)));
        }
        if($('input[name="srchEndDay"]').val() == ""){
        	$('input[name="srchEndDay"]').datepicker("update", new Date());
        }
	});

	</script>

			<!-- Start Breadcrumb -->
			<jsp:include page="/WEB-INF/jsp/admin/layout/breadcrumb.jsp">
				<jsp:param name="pageName" value="접속통계(구글)"/>
			</jsp:include>
			<!-- End Breadcrumb -->

            <!-- start: page -->
			<div class="row">
				<div class="col-md-12">
				<section class="panel panel-featured panel-featured-primary">
					<header class="panel-heading">
						<div class="panel-actions">

						</div>
						<h2 class="panel-title">접속통계 조회</h2>
 						<p class="panel-subtitle">
							Google Analytics
						</p>
					</header>
					<div class="panel-body">
						<form name="srchFrm" method="post" action="#">
						<table class="table">
							<colgroup>
								<col style="width:100"/>
								<col />
							</colgroup>
							<tbody>
							<tr>
								<th>조회일자</th>
								<td>
								<div class="form-group">
									<div class="form-inline">
									<input type="text" id="srchStartDay" name="srchStartDay" class="form-control" readonly="readonly" value="" /> ~
									<input type="text" id="srchEndDay" name="srchEndDay" class="form-control" readonly="readonly" value="" />
									</div>
								</div>
								</td>

							</tr>
							<tr>
								<th>사이트</th>
								<td>
									<select name="siteNo" id="siteNo" class="form-control"  style="width: 150px">
									<option value="">사이트 선택</option>
									<c:forEach var="site" items="${listSite}" varStatus="status" >
										<c:set var="isSelected" value="${ (site.siteNo eq param.siteNo ) ? ' selected=\"selected\"' : '' }" />
										<option value="${site.siteNo}" ${isSelected}>${site.siteNm}</option>
									</c:forEach>
									</select>
								</td>
							</tr>
							<tr>
								<th>측정항목</th>
								<td>
									<div class="form-horizontal">
									<c:forEach items="${dimension}" var="ds" varStatus="status">
										<span class="radio-custom radio-inline radio-primary">
											<input type="radio" class="form-control" name="srchDemension" id="srchDemension${status.count}" value="${ds.key}"  <c:if test="${ds.key == srchDimension }"> checked</c:if>/>
											<label for="srchDemension${status.count}">${ds.value}</label>
										</span>
									</c:forEach>
									<button type="button" class="btn btn-default" onclick="drawChart();return false;"><i class="fa fa-search"></i> 검색</button>
									</div>
								</td>
							</tr>
						</tbody>
						</table>
						</form>

						<div id="chart_div" style="border:1px solid #d6d6d6;height:350px;width:100%;">
							<div id="google_graph" style="width:98%;height:340px;"></div>
						</div>

						<div class="table-responsive">

						<table class="table">
							<colgroup>
								<col />
								<col style="width:150px">
								<col style="width:150px">
							</colgroup>
							<thead id="statusHeader">

							</thead>
							<tbody id="statusList" class="board">

							</tbody>
						</table>

					<!--테이블-->
						</div>
					</div>
<!-- 					<footer class="panel-footer">
						<div class="row">
							<div class="col-sm-12">
							</div>
						</div>
					</footer> -->
				</section>
				</div>

			</div>
