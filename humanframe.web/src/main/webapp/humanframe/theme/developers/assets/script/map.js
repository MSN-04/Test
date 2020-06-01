
var map;
var markerArr = [], infoWindowArr = [];

function init(provider, id, lat, lng, option){
	
	if(provider == "GOOGLE"){
		map = new google.maps.Map(document.getElementById(id), {
	          center:  {lat: lat, lng: lng},
	          zoom: 14,
	    });	
	} 
	if(provider == "NAVER"){
		map = new naver.maps.Map(id, {
			center: new naver.maps.LatLng(lat, lng),
			zoom:10
		});
	}
	if(provider == "DAUM"){
		map = new daum.maps.Map(document.getElementById(id), { 
		    center: new daum.maps.LatLng(lat, lng),
		    level: 5
        }); 
	}
	
	if(option.makerList != null && option.makerList.length > 0){
		for(var i=0; option.makerList.length > i; i++){
			makeMarker(provider, map, option.makerList[i], option);
		}
	}
	if(provider == "NAVER"){
		for (var i=0, ii=markerArr.length; i<ii; i++) {
		    naver.maps.Event.addListener(markerArr[i], 'click', getClickHandler(i));
		}
	}
	
	return map;
}


function makeMarker(provider, mapId, data, option){
	var marker;
	var infowindow;
	var icon = option.image ;
	
	if(provider == "GOOGLE"){
		
		marker = new google.maps.Marker({
	          position: {lat: data.lat, lng: data.lng}
	        , map: mapId
	        , icon: {
				  url: icon
				, iconsize: [26, 46]
				, iconanchor: [12, 46]
			}
	    });
		infowindow = new google.maps.InfoWindow({
		      content: data.html
		});
        google.maps.event.addListener(marker, 'click', function () {
            infowindow.open(map, marker)
        });
	} 
	if(provider == "NAVER"){
		marker = new naver.maps.Marker({
			  position:  new naver.maps.LatLng(data.lat, data.lng)
			, map: mapId
	        , icon: {
	        	  url: icon
	            , size: new naver.maps.Size(26, 46)
	            , anchor: new naver.maps.Point(12, 46)
	        }
	    });
		
		infoWindow = new naver.maps.InfoWindow({
	        content:   data.html
	    });
		
		markerArr.push(marker);
		infoWindowArr.push(infoWindow);
	}
	if(provider == "DAUM"){
		marker = new daum.maps.Marker({
	        map: mapId
	      , position: new daum.maps.LatLng(data.lat, data.lng)
	      , image : new daum.maps.MarkerImage(icon, new daum.maps.Size(26,46),  {offset: new daum.maps.Point(12, 46)})
	    }); 
		
		infowindow = new daum.maps.InfoWindow({
    	    content: data.html
    	  , removable : true
		});
		daum.maps.event.addListener(marker, 'click', function(e) {
			infowindow.open(map, marker);
		});
	}
	
	return marker
}

function getClickHandler(seq) {
    return function(e) {
        var marker = markerArr[seq],
            infoWindow = infoWindowArr[seq];

        if (infoWindow.getMap()) {
            infoWindow.close();
        } else {
            infoWindow.open(map, marker);
        }
    }
}




