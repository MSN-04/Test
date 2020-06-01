/**
 *
 */

/** 라인 변수* */
var drawingFlag = false; // 선이 그려지고 있는 상태를 가지고 있을 변수입니다
var moveLine; // 선이 그려지고 있을때 마우스 움직임에 따라 그려질 선 객체 입니다
var clickLine; // 마우스로 클릭한 좌표로 그려질 선 객체입니다
var distanceOverlay; // 선의 거리정보를 표시할 커스텀오버레이 입니다
var dots = {}; // 선이 그려지고 있을때 클릭할 때마다 클릭 지점과 거리를 표시하는 커스텀 오버레이 배열입니다.

/** 폴리곤 변수* */
var polydrawingFlag = false; // 다각형이 그려지고 있는 상태를 가지고 있을 변수입니다
var drawingPolygon; // 그려지고 있는 다각형을 표시할 다각형 객체입니다
var polygon; // 그리기가 종료됐을 때 지도에 표시할 다각형 객체입니다
var areaOverlay; // 다각형의 면적정보를 표시할 커스텀오버레이 입니다


// Map 위치초기값
var latlng = new daum.maps.LatLng(35.179825, 129.075086);
var mapContainer = document.getElementById('map'); // 지도를 표시할 div
var mapOption = {
	center : loadMarker(), // 지도의 중심좌표
	level : 5 // 지도의 확대 레벨
};

var map = new daum.maps.Map(mapContainer, mapOption); // 지도를 생성합니다

/**
 * 마커이미지 넣기
 * var imageSrc = 'http://i1.daumcdn.net/localimg/localimages/07/mapapidoc/marker_red.png', //마커이미지의 주소
 * imageSize = new daum.maps.Size(64, 69), // 마커이미지의 크기입니다
 * imageOption = {offset: new daum.maps.Point(27, 69)}; // 마커이미지의 옵션입니다. 마커의 좌표와 일치시킬 이미지 안에서의 좌표를 설정합니다.
 *
 * //마커의 이미지정보를 가지고 있는 마커이미지를 생성합니다
 * var markerImage = new daum.maps.MarkerImage(imageSrc, imageSize, imageOption);
 */

// 지도를 클릭한 위치에 표출할 마커입니다
var marker = new daum.maps.Marker({
	position : loadMarker() // 지도 중심좌표에 마커를 생성합니다
	// image: markerImage // 마커이미지 설정
});

//지도에 클릭 이벤트를 제거합니다.
daum.maps.event.addListener(map, 'click', function(mouseEvent) {
	return false;
});

/** 검색한 주소값 좌표변환 후 마커표기 */
$("#map").ready(function() {
	// 검색창에 엔터 입력시 좌표 검색
	$("#txtAddress").keydown(function(e) {
		if (e.keyCode == 13) {
			Search();
		}
	});

	oneMarker();
});

// 지도에 마커를 표시합니다
marker.setMap(map);

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
/**
 * Map controller
 * // 지도 확대, 축소 컨트롤에서 확대 버튼을 누르면 호출되어 지도를 확대하는 함수입니다
 * function zoomIn() { map.setLevel(map.getLevel() - 1); }
 * // 지도 확대, 축소 컨트롤에서 축소 버튼을 누르면 호출되어 지도를 확대하는 함수입니다
 * function zoomOut() { map.setLevel(map.getLevel() + 1); }
 *
 * //지도 확대 축소를 제어할 수 있는 줌 컨트롤을 생성합니다
 * var zoomControl = new daum.maps.ZoomControl(); map.addControl(zoomControl, daum.maps.ControlPosition.RIGHT);
 * // 지도가 확대 또는 축소되면 마지막 파라미터로 넘어온 함수를 호출하도록 이벤트를 등록합니다
 * daum.maps.event.addListener(map, 'zoom_changed', function() { var level = map.getLevel(); });
 * // 지도의 현재 레벨을 얻어옵니다
 *
 * /** Map controller End
 */

/** Marker */
function oneMarker() {

	loadMap();

	// 지도를 클릭한 위치에 표출할 마커입니다
	var marker = new daum.maps.Marker({
		position : loadMarker()
	});

	// 지도에 마커를 표시합니다
	marker.setMap(this.map);

	daum.maps.event.addListener(this.map, 'click', function(mouseEvent) {
		// 클릭한 위도, 경도 정보를 가져옵니다
		var latlng = mouseEvent.latLng;
		// 마커 위치를 클릭한 위치로 옮깁니다
		marker.setPosition(latlng);

		var setMk = document.getElementById('setMk');
		setMk.onclick = function() {
			document.getElementById('markerX').value = latlng.getLat();
			document.getElementById('markerY').value = latlng.getLng();
		}
	});
}

/** Line */
function lineMarker(col_l) {

	loadMap();
	setLoadMarker('line_conf');

	// 지도에 클릭 이벤트를 등록합니다
	// 지도를 클릭하면 선 그리기가 시작됩니다 그려진 선이 있으면 지우고 다시 그립니다
	daum.maps.event.addListener(map, 'click', function(mouseEvent) {

		// 마우스로 클릭한 위치입니다
		var clickPosition = mouseEvent.latLng;
		// 클릭한 위도, 경도 정보를 가져옵니다
		var latlng = mouseEvent.latLng;

		// 지도 클릭이벤트가 발생했는데 선을 그리고있는 상태가 아니면
		if (!drawingFlag) {
			// 상태를 true로, 선이 그리고있는 상태로 변경합니다
			drawingFlag = true;
			// 지도 위에 선이 표시되고 있다면 지도에서 제거합니다
			deleteClickLine();
			// 지도 위에 커스텀오버레이가 표시되고 있다면 지도에서 제거합니다
			deleteDistnce();
			// 지도 위에 선을 그리기 위해 클릭한 지점과 해당 지점의 거리정보가 표시되고 있다면 지도에서 제거합니다
			deleteCircleDot();

			// 클릭한 위치를 기준으로 선을 생성하고 지도위에 표시합니다
			clickLine = new daum.maps.Polyline({
				map : map, // 선을 표시할 지도입니다
				path : [ clickPosition ], // 선을 구성하는 좌표 배열입니다 클릭한 위치를 넣어줍니다
				strokeWeight : 3, // 선의 두께입니다
				strokeColor : col_l, // 선의 색깔입니다
				strokeOpacity : 1, // 선의 불투명도입니다 0에서 1 사이값이며 0에 가까울수록 투명합니다
				strokeStyle : 'solid' // 선의 스타일입니다
			});

			// 선이 그려지고 있을 때 마우스 움직임에 따라 선이 그려질 위치를 표시할 선을 생성합니다
			moveLine = new daum.maps.Polyline({
				strokeWeight : 3, // 선의 두께입니다
				strokeColor : col_l, // 선의 색깔입니다
				strokeOpacity : 0.5, // 선의 불투명도입니다 0에서 1 사이값이며 0에 가까울수록 투명합니다
				strokeStyle : 'solid' // 선의 스타일입니다
			});

			// 클릭한 지점에 대한 정보를 지도에 표시합니다
			displayCircleDot(clickPosition, 0);

		} else { // 선이 그려지고 있는 상태이면
			// 그려지고 있는 선의 좌표 배열을 얻어옵니다
			var path = clickLine.getPath();
			// 좌표 배열에 클릭한 위치를 추가합니다
			path.push(clickPosition);
			// 다시 선에 좌표 배열을 설정하여 클릭 위치까지 선을 그리도록 설정합니다
			clickLine.setPath(path);
			var distance = Math.round(clickLine.getLength());
			displayCircleDot(clickPosition, distance);
		}

		// 위도경도 넣어줌
		document.getElementById('markerS').value = path;
	});

	// 지도에 마우스무브 이벤트를 등록합니다
	// 선을 그리고있는 상태에서 마우스무브 이벤트가 발생하면 그려질 선의 위치를 동적으로 보여주도록 합니다
	daum.maps.event.addListener(
			map,
			'mousemove',
			function(mouseEvent) {

				// 지도 마우스무브 이벤트가 발생했는데 선을 그리고있는 상태이면
				if (drawingFlag) {
					// 마우스 커서의 현재 위치를 얻어옵니다
					var mousePosition = mouseEvent.latLng;
					// 마우스 클릭으로 그려진 선의 좌표 배열을 얻어옵니다
					var path = clickLine.getPath();
					// 마우스 클릭으로 그려진 마지막 좌표와 마우스 커서 위치의 좌표로 선을 표시합니다
					var movepath = [ path[path.length - 1], mousePosition ];
					moveLine.setPath(movepath);
					moveLine.setMap(map);
					var distance = Math.round(clickLine.getLength() + moveLine.getLength()), // 선의 총 거리를 계산합니다
					content = '<div class="dotOverlay distanceInfo">총거리 <span class="number">' + distance + '</span>m</div>'; // 커스텀오버레이에 추가될 내용입니다

					// 거리정보를 지도에 표시합니다
					showDistance(content, mousePosition);
				}
			});

	// 지도에 마우스 오른쪽 클릭 이벤트를 등록합니다
	// 선을 그리고있는 상태에서 마우스 오른쪽 클릭 이벤트가 발생하면 선 그리기를 종료합니다
	daum.maps.event.addListener(map, 'rightclick', function(mouseEvent) {

		// 지도 오른쪽 클릭 이벤트가 발생했는데 선을 그리고있는 상태이면
		if (drawingFlag) {

			// 마우스무브로 그려진 선은 지도에서 제거합니다
			moveLine.setMap(null);
			moveLine = null;

			// 마우스 클릭으로 그린 선의 좌표 배열을 얻어옵니다
			var path = clickLine.getPath();
			// 선을 구성하는 좌표의 개수가 2개 이상이면
			if (path.length > 1) {

				// 마지막 클릭 지점에 대한 거리 정보 커스텀 오버레이를 지웁니다
				if (dots[dots.length - 1].distance) {
					dots[dots.length - 1].distance.setMap(null);
					dots[dots.length - 1].distance = null;
				}
				var distance = Math.round(clickLine.getLength()); // 선의 총 거리를 계산합니다
			} else {
				// 선을 구성하는 좌표의 개수가 1개 이하이면 지도에 표시되고 있는 선과 정보들을 지도에서 제거합니다.
				deleteClickLine();
				deleteCircleDot();
				deleteDistnce();
			}
			// 상태를 false로, 그리지 않고 있는 상태로 변경합니다
			drawingFlag = false;

			var revMkLine = document.getElementById('revMkLine');
			revMkLine.disabled = false;
		}
	});

	// 마우스 드래그로 그려지고 있는 선의 총거리 정보를 표시하거
	// 마우스 오른쪽 클릭으로 선 그리가 종료됐을 때 선의 정보를 표시하는 커스텀 오버레이를 생성하고 지도에 표시하는 함수입니다
	function showDistance(content, position) {

		if (distanceOverlay) { // 커스텀오버레이가 생성된 상태이면
			// 커스텀 오버레이의 위치와 표시할 내용을 설정합니다
			distanceOverlay.setPosition(position);
			distanceOverlay.setContent(content);

		} else { // 커스텀 오버레이가 생성되지 않은 상태이면
			// 커스텀 오버레이를 생성하고 지도에 표시합니다
			distanceOverlay = new daum.maps.CustomOverlay({
				map : map, // 커스텀오버레이를 표시할 지도입니다
				content : content, // 커스텀오버레이에 표시할 내용입니다
				position : position, // 커스텀오버레이를 표시할 위치입니다.
				xAnchor : 0,
				yAnchor : 0,
				zIndex : 3
			});
		}
	}

	// 선이 그려지고 있는 상태일 때 지도를 클릭하면 호출하여
	// 클릭 지점에 대한 정보 (동그라미와 클릭 지점까지의 총거리)를 표출하는 함수입니다
	function displayCircleDot(position, distance) {

		// 클릭 지점을 표시할 빨간 동그라미 커스텀오버레이를 생성합니다
		var circleOverlay = new daum.maps.CustomOverlay({
			content : '<span class="dot"></span>',
			position : position,
			zIndex : 1
		});

		// 지도에 표시합니다
		circleOverlay.setMap(map);

		if (distance > 0) {
			// 클릭한 지점까지의 그려진 선의 총 거리를 표시할 커스텀 오버레이를 생성합니다
			var distanceOverlay = new daum.maps.CustomOverlay({
				content : '<div class="dotOverlay">거리 <span class="number">' + distance + '</span>m</div>',
				position : position,
				yAnchor : 1,
				zIndex : 2
			});
		}
		// 배열에 추가합니다
		dots.push({
			circle : circleOverlay
		});
	}
}

/** Polygon */
function polyMarker(col_p) {

	loadMap();
	setLoadMarker('poly_conf');
	// 지도에 마우스 클릭 이벤트를 등록합니다
	// 지도를 클릭하면 다각형 그리기가 시작됩니다 그려진 다각형이 있으면 지우고 다시 그립니다
	daum.maps.event.addListener(map, 'click', function(mouseEvent) {

		// 마우스로 클릭한 위치입니다
		var clickPosition = mouseEvent.latLng;
		// 클릭한 위도, 경도 정보를 가져옵니다
		var latlng = mouseEvent.latLng;

		// 지도 클릭이벤트가 발생했는데 다각형이 그려지고 있는 상태가 아니면
		if (!polydrawingFlag) {

			// 상태를 true로, 다각형을 그리고 있는 상태로 변경합니다
			polydrawingFlag = true;

			// 지도 위에 다각형이 표시되고 있다면 지도에서 제거합니다
			if (polygon) {
				polygon.setMap(null);
				polygon = null;
			}

			// 지도 위에 면적정보 커스텀오버레이가 표시되고 있다면 지도에서 제거합니다
			if (areaOverlay) {
				areaOverlay.setMap(null);
				areaOverlay = null;
			}

			// 그려지고 있는 다각형을 표시할 다각형을 생성하고 지도에 표시합니다
			drawingPolygon = new daum.maps.Polygon({
				map : map, // 다각형을 표시할 지도입니다
				path : [ clickPosition ], // 다각형을 구성하는 좌표 배열입니다 클릭한 위치를 넣어줍니다
				strokeWeight : 3, // 선의 두께입니다
				strokeColor : col_p, // 선의 색깔입니다
				strokeOpacity : 1, // 선의 불투명도입니다 0에서 1 사이값이며 0에 가까울수록 투명합니다
				strokeStyle : 'solid', // 선의 스타일입니다
				fillColor : col_p, // 채우기 색깔입니다
				fillOpacity : 0.2 // 채우기 불투명도입니다
			});

			// 그리기가 종료됐을때 지도에 표시할 다각형을 생성합니다
			polygon = new daum.maps.Polygon({
				path : [ clickPosition ], // 다각형을 구성하는 좌표 배열입니다 클릭한 위치를 넣어줍니다
				strokeWeight : 3, // 선의 두께입니다
				strokeColor : col_p, // 선의 색깔입니다
				strokeOpacity : 1, // 선의 불투명도입니다 0에서 1 사이값이며 0에 가까울수록 투명합니다
				strokeStyle : 'solid', // 선의 스타일입니다
				fillColor : col_p, // 채우기 색깔입니다
				fillOpacity : 0.2 // 채우기 불투명도입니다
			});
		} else { // 다각형이 그려지고 있는 상태이면

			// 그려지고 있는 다각형의 좌표에 클릭위치를 추가합니다
			// 다각형의 좌표 배열을 얻어옵니다
			var drawingPath = drawingPolygon.getPath();

			// 좌표 배열에 클릭한 위치를 추가하고
			drawingPath.push(clickPosition);

			// 다시 다각형 좌표 배열을 설정합니다
			drawingPolygon.setPath(drawingPath);

			// 그리기가 종료됐을때 지도에 표시할 다각형의 좌표에 클릭 위치를 추가합니다
			// 다각형의 좌표 배열을 얻어옵니다
			var path = polygon.getPath();

			// 좌표 배열에 클릭한 위치를 추가하고
			path.push(clickPosition);

			// 다시 다각형 좌표 배열을 설정합니다
			polygon.setPath(path);
		}

		// 위도경도 넣어줌
		document.getElementById('markerP').value = path;
	});

	// 지도에 마우스무브 이벤트를 등록합니다
	// 다각형을 그리고있는 상태에서 마우스무브 이벤트가 발생하면 그려질 다각형의 위치를 동적으로 보여주도록 합니다
	daum.maps.event.addListener(map, 'mousemove', function(mouseEvent) {

		// 지도 마우스무브 이벤트가 발생했는데 다각형을 그리고있는 상태이면
		if (polydrawingFlag) {

			// 마우스 커서의 현재 위치를 얻어옵니다
			var mousePosition = mouseEvent.latLng;
			// 그려지고있는 다각형의 좌표배열을 얻어옵니다
			var path = drawingPolygon.getPath();
			// 마우스무브로 추가된 마지막 좌표를 제거합니다
			if (path.length > 1) {
				path.pop();
			}
			// 마우스의 커서 위치를 좌표 배열에 추가합니다
			path.push(mousePosition);
			// 그려지고 있는 다각형의 좌표를 다시 설정합니다
			drawingPolygon.setPath(path);
		}
	});

	// 지도에 마우스 오른쪽 클릭 이벤트를 등록합니다
	// 다각형을 그리고있는 상태에서 마우스 오른쪽 클릭 이벤트가 발생하면 그리기를 종료합니다
	daum.maps.event.addListener(map, 'rightclick', function(mouseEvent) {

		// 지도 오른쪽 클릭 이벤트가 발생했는데 다각형을 그리고있는 상태이면
		if (polydrawingFlag) {

			// 그려지고있는 다각형을 지도에서 제거합니다
			drawingPolygon.setMap(null);
			drawingPolygon = null;

			// 클릭된 죄표로 그릴 다각형의 좌표배열을 얻어옵니다
			var path = polygon.getPath();
			// 다각형을 구성하는 좌표의 개수가 3개 이상이면
			if (path.length > 2) {
				// 지도에 다각형을 표시합니다
				polygon.setMap(map);

				var area = Math.round(polygon.getArea()), // 다각형의 총면적을 계산합니다
				content = '<div class="info">총면적 <span class="number"> ' + area
						+ '</span> m<sup>2</sup></div>'; // 커스텀오버레이에 추가될
															// 내용입니다

				// 면적정보를 지도에 표시합니다
				areaOverlay = new daum.maps.CustomOverlay({
					map : map, // 커스텀오버레이를 표시할 지도입니다
					content : content, // 커스텀오버레이에 표시할 내용입니다
					xAnchor : 0,
					yAnchor : 0,
					position : path[path.length - 1]
				// 커스텀오버레이를 표시할 위치입니다. 위치는 다각형의 마지막 좌표로 설정합니다
				});
			} else {
				// 다각형을 구성하는 좌표가 2개 이하이면 다각형을 지도에 표시하지 않습니다
				polygon = null;
			}
			// 상태를 false로, 그리지 않고 있는 상태로 변경합니다
			polydrawingFlag = false;

			var revMkPoly = document.getElementById('revMkPoly');
			revMkPoly.disabled = false;
		}
	});
}

/** Marker Controller */

// 배열에 추가된 마커들을 지도에 표시하거나 삭제하는 함수입니다
function setMarker(map) {
	marker.setMap(map);
}
// "마커 보이기" 버튼을 클릭하면 호출되어 배열에 추가된 마커를 지도에 표시하는 함수입니다
function showMarker() {
	setMarker(map);
}
// "마커 감추기" 버튼을 클릭하면 호출되어 배열에 추가된 마커를 지도에서 삭제하는 함수입니다
function hideMarker() {
	setMarker(null);
}
// 마커 지우기
function removeMarker() {
	hideMarker();
	marker = '';
}

/** Line Controller */

// 배열에 Dots 와 거리를 지도에 표시하거나 삭제
function setDots(map) {
	for (var i = 0; i < dots.length; i++) {
		if (dots[i].circle) {
			dots[i].circle.setMap(map);
		}
		if (dots[i].distance) {
			dots[i].distance.setMap(map);
		}
	}
}
// dots 와 거리정보 보이기
function showDot() {
	setDots(map);
}
// dots 와 거리정보 감추기
function hideDot() {
	setDots(null);
}

// 클릭으로 그려진 선을 지도에서 제거하는 함수입니다
function deleteClickLine() {
	if (clickLine) {
		clickLine.setMap(null);
		clickLine = null;
	}
}
// 클릭 지점에 대한 정보 (동그라미와 클릭 지점까지의 총거리)를 지도에서 모두 제거하는 함수입니다
function deleteCircleDot() {
	var i;

	for (i = 0; i < dots.length; i++) {
		if (dots[i].circle) {
			dots[i].circle.setMap(null);
		}
		if (dots[i].distance) {
			dots[i].distance.setMap(null);
		}
	}
	dots = [];
}
// 그려지고 있는 선의 총거리 정보와 선 그리가 종료됐을 때 선의 정보를 표시하는 커스텀 오버레이를 삭제하는 함수입니다
function deleteDistnce() {
	if (distanceOverlay) {
		distanceOverlay.setMap(null);
		distanceOverlay = null;
	}
}
// 제거
function removeLine() {
	if (!drawingFlag) { // 그려지고 있는상태가 아닐때 라인제거
		loadMap();
		deleteClickLine();
		deleteCircleDot();
		deleteDistnce();
	}
	document.getElementById('markerS').value = '';
	lineMarker();
}

/** Polygon Controller */

// 지도에서 다각형을 제거한다
function removePolygon() {
	loadMap();
	// 지도 위에 다각형이 표시되고 있다면 지도에서 제거합니다
	if (polygon) {
		polygon.setMap(null);
		polygon = null;
	}
	// 지도 위에 면적정보 커스텀오버레이가 표시되고 있다면 지도에서 제거합니다
	if (areaOverlay) {
		areaOverlay.setMap(null);
		areaOverlay = null;
	}
	document.getElementById('markerP').value = '';
	polyMarker();
}

/** Etc Controller */

function loadMap() { // 지도 새로 생성
	var m_x = document.getElementById('markerX').value;
	var m_y = document.getElementById('markerY').value;
	var temp = new daum.maps.LatLng(m_x, m_y);

	map = new daum.maps.Map(mapContainer, mapOption); // 지도를 생성합니다

	/** Map controller */

	// 지도 확대, 축소 컨트롤에서 확대 버튼을 누르면 호출되어 지도를 확대하는 함수입니다
	function zoomIn() {
		map.setLevel(map.getLevel() - 1);
	}

	// 지도 확대, 축소 컨트롤에서 축소 버튼을 누르면 호출되어 지도를 확대하는 함수입니다
	function zoomOut() {
		map.setLevel(map.getLevel() + 1);
	}

	// 지도 확대 축소를 제어할 수 있는 줌 컨트롤을 생성합니다
	var zoomControl = new daum.maps.ZoomControl();
	map.addControl(zoomControl, daum.maps.ControlPosition.RIGHT);

	// 지도가 확대 또는 축소되면 마지막 파라미터로 넘어온 함수를 호출하도록 이벤트를 등록합니다
	daum.maps.event.addListener(map, 'zoom_changed', function() {
		// 지도의 현재 레벨을 얻어옵니다
		var level = map.getLevel();
		if (level < 4) { // 맵확대 제한
			map.setZoomable(false);
			map.setLevel(4);
		} else {
			map.setZoomable(true);
		}
	});

	/** Map controller End */

	if (m_x) {// 등록한 마커값이 있다면
		map.panTo(temp);
	} else {
		return false;
	}
}

function loadMarker() { // 마커위치값 반환
	var m_x = document.getElementById('markerX').value;
	var m_y = document.getElementById('markerY').value;
	var temp = new daum.maps.LatLng(m_x, m_y);
	if (m_x && map) {
		// temp에 입력된 좌표값을 중심으로 지도 이동
		map.panTo(temp);
		return temp;
	} else {
		return this.latlng
	}
}

function setLoadMarker(conf) { // 생성했던 라인 불러옴
	var m_p = document.getElementById('markerS').value; // 라인 값
	var m_p2 = document.getElementById('markerP').value; // 폴리곤 값
	if (m_p && m_p != 0) {
		if (conf == 'line_conf') {
			var m_path = new Array(m_p);
			var p_data = m_path[0].split(",");

			// 라인을 만들기 위한 좌표를 차곡차곡 쌓을 배열생성
			var line = [];
			// 자른 좌표의 길이만큼 돌립니다 (앞자리는 짝수이므로 >2씩증가)
			for (var i = 0; i < p_data.length; i += 2) {
				// 변수에 좌표를 찍는 함수를 담습니다
				eval("line.push(new daum.maps.LatLng" + p_data[i] + "," + p_data[i + 1] + ");");
			}
			// 선을 구성하는 좌표 배열입니다. 이 좌표들을 이어서 선을 표시합니다
			var linePath = [ line ];

			// 지도에 표시할 선을 생성합니다
			var polyline = new daum.maps.Polyline({
				path : linePath, // 선을 구성하는 좌표배열 입니다
				strokeWeight : 5, // 선의 두께 입니다
				strokeColor : '#F00', // 선의 색깔입니다
				strokeOpacity : 0.7, // 선의 불투명도 입니다 1에서 0 사이의 값이며 0에 가까울수록 투명합니다
				strokeStyle : 'solid' // 선의 스타일입니다
			});
			// 지도에 선을 표시합니다
			polyline.setMap(map);
		}
	} else {
		// console.log("등록한 라인마커값이 없음");
	}

	if (m_p2) {
		if (conf == 'poly_conf') { // 폴리라인
			var m_path = new Array(m_p2);
			var p_data = m_path[0].split(",");
			var polygon = [];

			// 자른 좌표의 길이만큼 돌립니다 (앞자리는 짝수이므로 >2씩증가)
			for (var i = 0; i < p_data.length; i += 2) {
				eval("polygon.push(new daum.maps.LatLng" + p_data[i] + ","
						+ p_data[i + 1] + ");");
			}
			// 다각형을 구성하는 좌표 배열입니다. 이 좌표들을 이어서 다각형을 표시합니다
			var polygonPath = [ polygon ];

			// 지도에 표시할 다각형을 생성합니다
			var polygon = new daum.maps.Polygon({
				path : polygonPath, // 그려질 다각형의 좌표 배열입니다
				strokeWeight : 3, // 선의 두께입니다
				strokeColor : '#F00', // 선의 색깔입니다
				strokeOpacity : 0.8, // 선의 불투명도 입니다 1에서 0 사이의 값이며 0에 가까울수록 투명합니다
				strokeStyle : 'solid', // 선의 스타일입니다
				fillColor : '#FFD8D8', // 채우기 색깔입니다
				fillOpacity : 0.7 // 채우기 불투명도 입니다
			});
			// 지도에 다각형을 표시합니다
			polygon.setMap(map);
		}
	} else {
		// console.log("등록한 폴리곤마커값이 없음");
	}
}

function setCenter(lat, lng) { // 센터 맞추기
	new daum.maps.LatLng(lat, lng);
	// map.setLevel(5);
	// map.setCenter(latlng);
}

function Search() {
	marker.setMap(null);
	var query = "부산광역시 " + $("#txtAddress").val();
	getPoint(query);
}

//주소->좌표로 변환해주는 api 사용
function getPoint(query) {
	var oScript = document.createElement("script");
	oScript.type = "text/javascript";
	oScript.charset = "utf-8";
	oScript.src = "http://apis.daum.net/local/geo/addr2coord?apikey=92f869e34cc2295d53917d58cac3daa7&output=json&callback=pongSearch&q=" + encodeURI(query);
	document.getElementsByTagName("head")[0].appendChild(oScript);
}

//좌표 변환 후 해당 좌표를 이용해 콜백(클릭시와 동일한 동작)
function pongSearch(data) {
	marker = '';
	if (data.channel.item.length == 0) {
	    alert("결과가 없습니다.");
	} else {
	    if (marker != '') {
	        setMarker(null);
	    }
		var temp = new daum.maps.LatLng(data.channel.item[0].lat, data.channel.item[0].lng);
		$("#latlng").html((data.channel.item[0].lat).toString().substring(0, 10) + ", " + (data.channel.item[0].lng).toString().substring(0, 10));
		map.panTo(temp);
		marker = new daum.maps.Marker({
			position: temp
		});
		marker.setMap(map);
		document.getElementById('markerX').value = data.channel.item[0].lat;
		document.getElementById('markerY').value = data.channel.item[0].lng;
	}
}