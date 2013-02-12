$(document).ready(function() {
  	var mapOptions = {
    	center: new google.maps.LatLng(-34.397, 150.644),
    	zoom: 8,
    	mapTypeId: google.maps.MapTypeId.ROADMAP
    };
    
	if (document.getElementById("map_canvas")) {
		var map = new google.maps.Map(document.getElementById("map_canvas"),
	    	mapOptions);
	};


    var marker = new google.maps.Marker({
	    position: map.getCenter(),
	    map: map,
	    title: 'Click to zoom'
	});
});
