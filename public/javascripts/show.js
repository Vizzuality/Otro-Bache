var reported_potholes;

$(document).ready(function() {
  reported_potholes = [];
  function ZoomInControl(controlDiv, map) {

    controlDiv.setAttribute('class', 'map_zoom_in');

    google.maps.event.addDomListener(controlDiv, 'click', function() {
      map.setZoom(map.getZoom() + 1);
    });
  };

  function ZoomOutControl(controlDiv, map) {

    controlDiv.setAttribute('class', 'map_zoom_out');

    google.maps.event.addDomListener(controlDiv, 'click', function() {
      map.setZoom(map.getZoom() - 1);
    });
  };

  var mapLatLon = new google.maps.LatLng(pothole.lat, pothole.lon);
  
  var myOptions = {
    zoom: 16,
    center: mapLatLon,
    mapTypeId: google.maps.MapTypeId.ROADMAP,
    disableDefaultUI: false,
    scrollwheel: false,
    mapTypeControl: false,
    navigationControl: false,
    streetViewControl: false
  };

  var map    = new google.maps.Map(document.getElementById("main_map"), myOptions);
    
  var marker = new google.maps.Marker ({
    map: map,
    position: mapLatLon,
    draggable: false,
    visible: false
  });
    
  var confirmPothole = function(evt) {
      evt.preventDefault();

      $.ajax({ url: "/report/"+ pothole.id, method:'POST', success: function(){
        $('#mamufas_selected').fadeOut('fast');
        $('p.confirm_tooltip').fadeIn();
        $('p.confirm_tooltip').delay(4000).fadeOut();
        $.mask.close();
      }});
    },
    addInfoWindow = function(){
      if (!pothole || !pothole.photo_url) { return; };
      var infowindow_div = $('div#pothole_info').clone().attr("id", null);
      
      // We need to wait to image load in order to get the correct size of the entire div
      infowindow_div.find('img').load(function(){
        var dimensions     = infowindow_div.objectSize();
        var info_window    = new vizzuality.maps.infobox({
          content: infowindow_div.remove()[0],
          width: dimensions.width,
          height: dimensions.height,
          position: mapLatLon,
          map: map,
          offsetHorizontal: -112
        });
      });
      var pothole_ = new Object();
      pothole_.lat = pothole.lat;
      pothole_.lon = pothole.lon;
      reported_potholes.push(pothole_);
    };
  

  var circle = new google.maps.Circle ({
    map: map,
    radius: 100,
    fillColor: "#f2c2ad",
    fillOpacity: 0.5,
    strokeColor: "#ff6734"
  });
  
  circle.bindTo('center', marker, 'position')
  
  function checkIfConfirmed(lat,lon) {
    for (var i=0; i<reported_potholes.length; i++) {
      if (reported_potholes[i].lat==lat && reported_potholes[i].lon==lon) {
        return true;
      }
    }
    return false;
  }
  
  if (checkIfConfirmed(pothole.lat,pothole.lon)) {
    $('#confirm_pothole').hide();
  } else {
    $('#confirm_pothole').click(confirmPothole).show();
  }
  
  //$('#confirm_pothole').click(confirmPothole);
  
  addInfoWindow();

});