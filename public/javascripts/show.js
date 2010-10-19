var map;
var FUSION_TABLES_ID = 272266;

$(document).ready(function() { 
	
    var mapLatLon = new google.maps.LatLng($("#lat").text(), $("#lon").text());

    var myOptions = {
      zoom: 16,
      center: mapLatLon,
      mapTypeId: google.maps.MapTypeId.ROADMAP,
      disableDefaultUI: false,
      scrollwheel: false
    }
    map = new google.maps.Map(document.getElementById("main_map"), myOptions);
    
    var marker = new google.maps.Marker ({
      map: map,
      position: mapLatLon,
      draggable: false,
    });

    var circle = new google.maps.Circle ({
      map: map,
      radius: 100,
      fillColor: "#f2c2ad",
      fillOpacity: 0.5,
      strokeColor: "#ff6734"
    });

    circle.bindTo('center', marker, 'position')

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