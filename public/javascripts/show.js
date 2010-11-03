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
    
  var 
    confirmPothole = function(evt) {
      evt.preventDefault();
      var me = this;
      
      $.ajax({ url: "/report/"+ pothole.id, method:'POST', success: function(){
        $('#mamufas_selected').fadeOut('fast');
        $('p.confirm_tooltip').fadeIn();
        $('p.confirm_tooltip').delay(4000).fadeOut();
        $.mask.close();
        $(me).fadeOut('fast');
      }});
    },
    addInfoWindow = function(){
      if (!pothole || !pothole.thumb_url) { return; };
      var 
          infowindow_div = $('div#pothole_info').clone().attr("id", null),
          infowindow_opts = {
            content: infowindow_div.remove()[0],
            position: mapLatLon,
            map: map
          };
      infowindow_div.find('img').load(function(){
        var dimensions = $(this).clone().objectSize(), width = dimensions.width, height = dimensions.height;

        if (width > height) {
          new vizzuality.maps.horizontal_infobox(infowindow_opts);
        }else{
          new vizzuality.maps.vertical_infobox(infowindow_opts);
        };
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