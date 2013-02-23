$(document).ready(function() {
	var mapOptions = {
    	center: new google.maps.LatLng(user_location.addresses[0].latitude, user_location.addresses[0].longitude),
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
		    title: dog_locations[i].name
		});

		google.maps.event.addListener(marker, 'click', (function(marker, i) {
			return function() {	
				map.setZoom(8);
				map.setCenter(marker.getPosition());
				var infowindow = new google.maps.InfoWindow({
					content: '<a href="' + "/users/" + dog_locations[i].user_id + '">' + dog_locations[i].name + '</a><br>' +
								dog_locations[i].address.street
				});
				infowindow.open(map, marker)
			}
		})(marker, i));
	}
});
