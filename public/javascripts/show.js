var map;
var FUSION_TABLES_ID = 272266;

$(document).ready(function() { 
	
    var mapLatLon = new google.maps.LatLng($("#lat").text(), $("#lon").text());
    var myOptions = {
      zoom: 14,
      center: mapLatLon,
      mapTypeId: google.maps.MapTypeId.ROADMAP,
			disableDefaultUI: false,
			scrollwheel: false
    }
    
    var marker = new google.maps.Marker ({
      map: myOptions,
      position: new google.maps.LatLng($("#lat").text(), $("#lon").text()),
      draggable: true,
    });

    var circle = new google.maps.Circle ({
      map: myOptions,
      radius: 1
    });

    circle.bindTo('center', marker, 'position')
   
    geocoder = new google.maps.Geocoder();
    
    map = new google.maps.Map(document.getElementById("main_map"), myOptions);
	
	
});


//Confirm pothole showed in the list
function confirmPothole() {
	
	id_pothole = $('p.id_pothole').html();
  
  $.ajax({ url: "/report/"+ id_pothole, method:'POST', success: function(){
    $('#mamufas_selected').fadeOut('fast');
    $('p.confirm_tooltip').fadeIn();
    $('p.confirm_tooltip').delay(4000).fadeOut();
    $.mask.close();
      
    var pothole_ = new Object();
    pothole_.lat = marker.getPosition().lat();
    pothole_.lon = marker.getPosition().lng();
    reported_potholes.push(pothole_);
  }});

}