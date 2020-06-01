<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/taglibs.jsp" %>
<%@ page trimDirectiveWhitespaces="true" %>

		<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
		<c:if test="${!empty positionId}">
		<script type="text/javascript" src="//apis.daum.net/maps/maps3.js?apikey=${apikey}&libraries=services"></script>
		</c:if>
		
		<!-- Start Main Content -->		
		<section class="panel panel-primary">
			<header class="panel-heading">
				<div class="panel-actions">
					<button class="btn btn-default" title="선택완료(닫기)" onclick="window.close(); return false;"><i class="fa fa-remove"></i> 선택완료(닫기)</button>
				</div>
				<h2 class="panel-title">주소검색 (DAUM API)</h2>
			</header>
			<div class="panel-body">
				<div id="wrap" class="widget-content-inner"></div>
			</div>		
		</section>
        <!-- End Main Content -->			
		

		<c:set var="postfix" value=""/>
		<c:if test="${languageId ne 'ko'}">
			<c:set var="postfix" value="English"/>
		</c:if>

		<script>
			// 우편번호 찾기 찾기 화면을 넣을 element
			var element_wrap = document.getElementById('wrap');
			<c:if test="${!empty positionId}">
			var geocoder = new daum.maps.services.Geocoder();
			</c:if>

		    function execDaumPostcode() {

		        new daum.Postcode({
		            oncomplete: function(data) {
		                // 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

		                // 각 주소의 노출 규칙에 따라 주소를 조합한다.
		                // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
		                var fullAddr = data.address${postfix}; // 최종 주소 변수
		                var extraAddr = ''; // 조합형 주소 변수

		                // 기본 주소가 도로명 타입일때 조합한다.
		                if(data.addressType === 'R'){
		                    //법정동명이 있을 경우 추가한다.
		                    if(data.bname !== ''){
		                        extraAddr += data.bname;
		                    }
		                    // 건물명이 있을 경우 추가한다.
		                    if(data.buildingName !== ''){
		                        extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
		                    }
		                    // 조합형주소의 유무에 따라 양쪽에 괄호를 추가하여 최종 주소를 만든다.
		                    fullAddr += (extraAddr !== '' ? ' ('+ extraAddr +')' : '');
		                }else{
		                    if(data.buildingName !== ''){
		                        extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
		                    }
		                	fullAddr = data.roadAddress${postfix} + (extraAddr !== '' ? ' ('+ extraAddr +')' : '');
		                }
		             	// 우편번호와 주소 정보를 해당 필드에 넣는다.

		             	<c:if test="${!empty zoneTagtId}">
		                var zoneTagtId = "${zoneTagtId}".split("|");
		                opener.document.getElementById(zoneTagtId[0]).value = data.zonecode; //5자리 새우편번호 사용
		                opener.document.getElementById(zoneTagtId[1]).value = fullAddr;
		                </c:if>

		                <c:if test="${!empty postTagtId}">
		                var postTagtId = "${postTagtId}".split("|");
		                opener.document.getElementById(postTagtId[0]).value = data.postcode; //구 우편번호
		                if(data.jibunAddress${postfix} == ""){
		                	opener.document.getElementById(postTagtId[1]).value = data.autoJibunAddress${postfix};
		                }else{
		                	opener.document.getElementById(postTagtId[1]).value = data.jibunAddress${postfix};
		                }

		                </c:if>

		                <c:if test="${!empty positionId}">
		                var positionId = "${positionId}".split("|");
		             	// 주소로 좌표를 검색
		                geocoder.addr2coord(data.address, function(status, result) {
		                    // 정상적으로 검색이 완료됐으면
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
		            // 우편번호 찾기 화면 크기가 조정되었을때 실행할 코드를 작성하는 부분. iframe을 넣은 element의 높이값을 조정한다.
		            onresize : function(size) {
		                element_wrap.style.height = size.height+'px';
		            },
		            width : '100%',
		            height : '100%'
		        }).embed(element_wrap);

		        // iframe을 넣은 element를 보이게 한다.
		        element_wrap.style.display = 'block';
		    }

		    $(function() {
		    	var timeoutID =window.setTimeout(function(){execDaumPostcode();}, 100);
		    });
		</script>