<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/taglibs.jsp" %>
<%@ page trimDirectiveWhitespaces="true" %>

	    <style>
		    .title {font-weight:bold;display:block;}
		    .hAddr {position:absolute;left:40px;top:80px;border-radius: 2px;background:#fff;background:rgba(255,255,255,0.8);z-index:1;padding:1px;}
		    #centerAddr {display:block;margin-top:2px;font-weight: normal;}
		    .bAddr {padding:5px;text-overflow: ellipsis;overflow: hidden;white-space: nowrap;}
		</style>

		<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
		<script type="text/javascript" src="//apis.daum.net/maps/maps3.js?apikey=${apikey}&libraries=services"></script>

		<!-- Start Main Content -->		
		<section class="panel panel-primary">
			<header class="panel-heading">
				<div class="panel-actions">
					<button class="btn btn-default" title="선택완료(닫기)" onclick="window.close(); return false;"><i class="fa fa-remove"></i> 선택완료(닫기)</button>
				</div>
				<h2 class="panel-title">지도검색 (DAUM API)</h2>
			</header>
			<div class="panel-body">
				<div class="row">
					<div class="col-sm-7">
						<div id="map" style="height:520px;"></div>
					</div>
					<div class="col-sm-3">
				    	<div id="wrap"></div>
				    </div>
				 <div class="hAddr">
			        <span class="title">지도중심기준 행정동 주소정보</span>
			        <span id="centerAddr"></span>
			    </div>
			    </div>
			</div>		
		</section>
        <!-- End Main Content -->			

		<script>

		var element_wrap = document.getElementById('wrap');

		var mapContainer = document.getElementById('map'), // 지도를 표시할 div
	    mapOption = {
	        center: new daum.maps.LatLng(35.18047136224503, 129.07557382720248), // 지도의 중심좌표
	        level: 2 // 지도의 확대 레벨
	    };

		// 지도를 생성합니다
		var map = new daum.maps.Map(mapContainer, mapOption);

		// 주소-좌표 변환 객체를 생성합니다
		var geocoder = new daum.maps.services.Geocoder();

		var marker = new daum.maps.Marker(), // 클릭한 위치를 표시할 마커입니다
		infowindow = new daum.maps.InfoWindow({zindex:1}); // 클릭한 위치에 대한 주소를 표시할 인포윈도우입니다

		// 현재 지도 중심좌표로 주소를 검색해서 지도 좌측 상단에 표시합니다
		searchAddrFromCoords(map.getCenter(), displayCenterInfo);

		// 지도를 클릭했을 때 클릭 위치 좌표에 대한 주소정보를 표시하도록 이벤트를 등록합니다
		daum.maps.event.addListener(map, 'click', function(mouseEvent) {
		    searchDetailAddrFromCoords(mouseEvent.latLng, function(status, result) {
		        if (status === daum.maps.services.Status.OK) {
		            var detailAddr = !!result[0].roadAddress.name ? '<div>도로명주소 : ' + result[0].roadAddress.name + '</div>' : '';
		            detailAddr += '<div>지번 주소 : ' + result[0].jibunAddress.name + '</div>';

		            var content = '<div class="bAddr">' +
		                            	'<span class="title">법정동 주소정보</span>' +
		                            	detailAddr +
		                        		'</div>';

				    daum.postcode.load(function(){
				        new daum.Postcode({
				            oncomplete: function(data) {
				                var fullAddr = data.address; // 최종 주소 변수
				                var extraAddr = ''; // 조합형 주소 변수

				                if(data.addressType === 'R'){
				                    if(data.bname !== ''){
				                        extraAddr += data.bname;
				                    }
				                    if(data.buildingName !== ''){
				                        extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
				                    }
				                    fullAddr += (extraAddr !== '' ? ' ('+ extraAddr +')' : '');
				                }else{

				                    if(data.buildingName !== ''){
				                        extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
				                    }

				                	fullAddr = data.roadAddress + (extraAddr !== '' ? ' ('+ extraAddr +')' : '');
				                }

				             	<c:if test="${!empty zoneTagtId}">
				                var zoneTagtId = "${zoneTagtId}".split("|");
				                opener.document.getElementById(zoneTagtId[0]).value = data.zonecode; //5자리 새우편번호 사용
				                opener.document.getElementById(zoneTagtId[1]).value = fullAddr;
				                </c:if>

				                <c:if test="${!empty postTagtId}">
				                var postTagtId = "${postTagtId}".split("|");
				                opener.document.getElementById(postTagtId[0]).value = data.postcode; //구 우편번호
				                if(data.jibunAddress == ""){
				                	opener.document.getElementById(postTagtId[1]).value = data.autoJibunAddress;
				                }else{
				                	opener.document.getElementById(postTagtId[1]).value = data.jibunAddress;
				                }
				                </c:if>

				                <c:if test="${!empty positionId}">
				                var positionId = "${positionId}".split("|");
				                geocoder.addr2coord(data.address, function(status, result) {
				                    console.log("status: " + status);
				                    if (status === daum.maps.services.Status.OK) {
				                    	console.log("status: " + status);
				                    	opener.document.getElementById(positionId[0]).value = result.addr[0].lng;//경도
				                    	opener.document.getElementById(positionId[1]).value = result.addr[0].lat;//위도
				                    	window.close();
				                    }
				                });
				                </c:if>
				                <c:if test="${empty positionId}">
				                window.close();
				                </c:if>
				            },
				            width : '100%'
				        }).embed(element_wrap, {q:result[0].jibunAddress.name});
				    });

		            // 마커를 클릭한 위치에 표시합니다
		            marker.setPosition(mouseEvent.latLng);
		            marker.setMap(map);

		            // 인포윈도우에 클릭한 위치에 대한 법정동 상세 주소정보를 표시합니다
		            infowindow.setContent(content);
		            infowindow.open(map, marker);
		        }
		    });
		});

		// 중심 좌표나 확대 수준이 변경됐을 때 지도 중심 좌표에 대한 주소 정보를 표시하도록 이벤트를 등록합니다
		daum.maps.event.addListener(map, 'idle', function() {
		    searchAddrFromCoords(map.getCenter(), displayCenterInfo);
		});

		function searchAddrFromCoords(coords, callback) {
		    // 좌표로 행정동 주소 정보를 요청합니다
		    geocoder.coord2addr(coords, callback);
		}

		function searchDetailAddrFromCoords(coords, callback) {
		    // 좌표로 법정동 상세 주소 정보를 요청합니다
		    geocoder.coord2detailaddr(coords, callback);
		}

		// 지도 좌측상단에 지도 중심좌표에 대한 주소정보를 표출하는 함수입니다
		function displayCenterInfo(status, result) {
		    if (status === daum.maps.services.Status.OK) {
		        var infoDiv = document.getElementById('centerAddr');
		        infoDiv.innerHTML = result[0].fullName;
		    }
		}

		// 지도타입 컨트롤의 지도 또는 스카이뷰 버튼을 클릭하면 호출되어 지도타입을 바꾸는 함수입니다
		function setMapType(maptype) {
		    var roadmapControl = document.getElementById('btnRoadmap');
		    var skyviewControl = document.getElementById('btnSkyview');
		    if (maptype === 'roadmap') {
		        map.setMapTypeId(daum.maps.MapTypeId.ROADMAP);
		        roadmapControl.className = 'selected_btn';
		        skyviewControl.className = 'btn';
		    } else {
		        map.setMapTypeId(daum.maps.MapTypeId.HYBRID);
		        skyviewControl.className = 'selected_btn';
		        roadmapControl.className = 'btn';
		    }
		}

		// 지도 확대, 축소 컨트롤에서 확대 버튼을 누르면 호출되어 지도를 확대하는 함수입니다
		function zoomIn() {
		    map.setLevel(map.getLevel() - 1);
		}

		// 지도 확대, 축소 컨트롤에서 축소 버튼을 누르면 호출되어 지도를 확대하는 함수입니다
		function zoomOut() {
		    map.setLevel(map.getLevel() + 1);
		}
		</script>