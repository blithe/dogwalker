$(document).ready(function() {
  	var mapOptions = {
    	center: new google.maps.LatLng(33.850145, -84.332256),
    	zoom: 10,
    	max_zoom: 16,
    	mapTypeId: google.maps.MapTypeId.ROADMAP,
    	MapTypeControlOptions: {
    		MapTypeIds: [google.maps.MapTypeId.ROADMAP]
    	}
    };
    
	if (document.getElementById("map_canvas")) {
		var map = new google.maps.Map(document.getElementById("map_canvas"),
	    	mapOptions);
	};

	for (var i in dog_locations) {
	    var marker = new google.maps.Marker({
		    position: new google.maps.LatLng(dog_locations[i].address.latitude, dog_locations[i].address.longitude),
		    map: map,
		    title: 'Dog!'
		});
	}
});
