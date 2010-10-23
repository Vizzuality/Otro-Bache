$(document).ready(function() {
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
  var zoomInControlDiv = document.createElement('DIV');
  var zoomInControl = new ZoomInControl(zoomInControlDiv, map);
  zoomInControlDiv.index = 1;
  var zoomOutControlDiv = document.createElement('DIV');
  var zoomOutControl = new ZoomOutControl(zoomOutControlDiv, map);
  zoomOutControlDiv.index = 2;
  map.controls[google.maps.ControlPosition.TOP_LEFT].push(zoomInControlDiv);
  map.controls[google.maps.ControlPosition.LEFT].push(zoomOutControlDiv);
  
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
      var dimensions     = infowindow_div.objectSize();

      var info_window    = new vizzuality.maps.infobox({
        content: infowindow_div.remove()[0],
        width: dimensions.width,
        height: dimensions.height,
        position: mapLatLon,
        map: map
      });
    };
  

  var circle = new google.maps.Circle ({
    map: map,
    radius: 100,
    fillColor: "#f2c2ad",
    fillOpacity: 0.5,
    strokeColor: "#ff6734"
  });
  
  circle.bindTo('center', marker, 'position')
  
  $('#confirm_pothole').click(confirmPothole);
  
  addInfoWindow();

});