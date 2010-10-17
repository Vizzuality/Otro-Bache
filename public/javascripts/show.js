var map;

$(document).ready(function() { 
	
    var myLatlng = new google.maps.LatLng($("#lat").text(), $("#lon").text());
    var myOptions = {
      zoom: 8,
      center: myLatlng,
      mapTypeId: google.maps.MapTypeId.ROADMAP,
			disableDefaultUI: false,
			scrollwheel: false
    }
	geocoder = new google.maps.Geocoder();
    
    
    map = new google.maps.Map(document.getElementById("show_map"), myOptions);
	
	
});