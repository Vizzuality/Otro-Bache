// The official id is 272266
// The developer id is 225314
var FUSION_TABLES_ID = 272266;

var selected_height;
var max_potholes = 31;
var map;
var map2;
var marker;
var add_marker;
var geocoder;
var layer;
var reported_potholes;
var id_pothole;
var map_enabled = false;
var info_window;
var marker_address;

$(document).ready(function() {
  initializeMaps();
  reported_potholes = [];
  $('a#addPothole').click(function(ev){
    ev.stopPropagation();
    ev.preventDefault();
    $("div.main_map_left").expose({
          color: "#000",
          onBeforeLoad: function() {
            map_enabled = true;
            $('div.main_map_left img.shadow').css('display','none');
            $('div.main_map_left').css('padding-bottom','0');
            $('div.outer_layout.list div.sort p').css('padding-top','42px');
            $('div.main_map_left div.border_map p.click ').fadeIn();
            $('div.main_map_left div.border_map div#map_search').fadeIn();
            $('div.main_map_left div.border_map div.geocorder div.steps').hide();
            $('#create_pothole').show();
            $('div.main_map_left div.border_map div.geocorder div.uploadify').hide();
          },
          onBeforeClose: function() {
            map_enabled = false;
            !add_marker || add_marker.setMap(null);
            $('div.main_map_left div.border_map p.click ').fadeOut();
            $('div.main_map_left div.border_map div#map_search').hide();
            $('div.main_map_left div.border_map div.geocorder').fadeOut();
          },
          onClose: function() {
            $('div.main_map_left div.border_map p.click ').text('Pulsa en cualquier parte del mapa para añadir el marker');
            $('div.main_map_left img.shadow').css('display','block');
            $('div.main_map_left').css('padding-bottom','12px');
            $('div.outer_layout.list div.sort p').css('padding-top','30px');
            !info_window || info_window.remove();
          }
        });
  });
  
  selected_height = $('li.selected').height();
  $('li.selected').height(0);

  //show confirm pothole
  $('div.pothole_inf').click(function(ev){
    ev.stopPropagation();
    ev.preventDefault();
    var me = this;
    var pothole_data = getPotholeData(me);
    if (marker!=null) {
      marker.setMap(null);
    }
    
    if ($('li.selected').height() > 0) {
      
      $('li.selected').animate({
            height: 0
          }, 250, function() {
            map2.setCenter(new google.maps.LatLng(pothole_data.lat,pothole_data.lon));
            map2.setZoom(16);
            marker = addCustomMarker(marker, map2, map2.getCenter());
            $('p.confirm_tooltip').hide();
            $('li.selected').find('p.days').text(pothole_data.days);
            $('li.selected').find('p.reported').html(pothole_data.reported);
            $('li.selected').find('p.place').text(pothole_data.address);
            $("ul#pothole_list li").each( function(i) {
                $(this).css('display','block');
            });
            $(me).parent().parent().css('display','none');
            var selected_item = $('li.selected');
            $('li.selected').remove();
            $(me).parent().parent().after(selected_item);
            if (checkIfConfirmed(marker.getPosition().lat(),marker.getPosition().lng())) {
              $('#confirm_pothole').hide();
            } else {
              $('#confirm_pothole').show();
            }
            $('li.selected').animate({height: selected_height}, 300);
          });
    } else {
      map2.setCenter(new google.maps.LatLng(pothole_data.lat,pothole_data.lon));
      map2.setZoom(16);
      $('li.selected').find('p.days').text(pothole_data.days);
      $('li.selected').find('p.reported').html(pothole_data.reported);
      $('li.selected').find('p.place').text(pothole_data.address);
      marker = addCustomMarker(marker, map2, map2.getCenter());
      $('p.confirm_tooltip').hide();
      $(me).parent().parent().css('display','none');
      var selected_item = $('li.selected');
      $('li.selected').remove();
      $(me).parent().parent().after(selected_item);
      if (checkIfConfirmed(pothole_data.lat,pothole_data.lon)) {
        $('a#confirm_pothole').hide();
      } else {
        $('a#confirm_pothole').show();
      }
      $('li.selected').animate({height: selected_height}, 300);
    }
  });
});

  function initializeMaps() {
    
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
    
    var myLatlng = new google.maps.LatLng(40.463667, -3.74922);
    var myOptions = {
      zoom: 8,
      center: myLatlng,
      mapTypeControl: false,
      navigationControl: false,
      navigationControlOptions: {style: google.maps.NavigationControlStyle.SMALL},
      mapTypeId: google.maps.MapTypeId.ROADMAP,
      disableDefaultUI: false,
      scrollwheel: false,
      streetViewControl: false
    };
    geocoder = new google.maps.Geocoder();

    map = new google.maps.Map(document.getElementById("main_map"), myOptions);
    var zoomInControlDiv = document.createElement('DIV');
    var zoomInControl = new ZoomInControl(zoomInControlDiv, map);
    zoomInControlDiv.index = 1;
    var zoomOutControlDiv = document.createElement('DIV');
    var zoomOutControl = new ZoomOutControl(zoomOutControlDiv, map);
    zoomOutControlDiv.index = 2;
    map.controls[google.maps.ControlPosition.TOP_LEFT].push(zoomInControlDiv);
    map.controls[google.maps.ControlPosition.LEFT].push(zoomOutControlDiv);
  
    map2 = new google.maps.Map(document.getElementById("selected_map"), myOptions);
    zoomInControlDiv = document.createElement('DIV');
    zoomInControl = new ZoomInControl(zoomInControlDiv, map2);
    zoomOutControlDiv = document.createElement('DIV');
    zoomOutControl = new ZoomOutControl(zoomOutControlDiv, map2);
    map2.controls[google.maps.ControlPosition.TOP_LEFT].push(zoomInControlDiv);
    map2.controls[google.maps.ControlPosition.LEFT].push(zoomOutControlDiv);
    
    geocoder.geocode( { 'address': $('#location').text()}, function(results, status) {
      if (status == google.maps.GeocoderStatus.OK) {
        map.fitBounds(results[0].geometry.viewport); 

        $.ajax({
          url: "/api/get_near_localities/",
          type: "GET",
          data: ({lat: results[0].geometry.location.lat(), lon: results[0].geometry.location.lng() }),
          dataType: "json",
          success: function(result){
              for (var i=0; i<result.length; i++) {
                $('ul#locations_list').append(
                  '<li>' +
                    '<a class="stat" href="/in/'+result[i].name+'">' +
                      '<span>'+(result[i].name).substr(0,18)+'</span>' +
                      '<p class="number">'+result[i].num_baches+'</p>' +
                    '</a>'+
                  '</li>'
                );
              }

              $('ul#locations_list li').each(function(ev){
                var number = $(this).children('a').children('p.number').text();
                $(this).children('a').children('span').attr('alt',getBarPosition(number)+'px 0px');
                 $(this).children('a').children('span').css('background-position', getBarPosition(number)+'px 0px');
              });

              // To show over background to the right side
              $('ul#locations_list li a').hover(function(ev){
                var number = $(this).children('p.number').text();
                $(this).children('span').css('background-position', getBarPosition(number)+'px -23px');

              },function(ev){
                $(this).children('span').css('background-position',$(this).children('span').attr('alt'));
              });

              $('ul#locations_list li a span').hover(function(ev){
                $(this).css('background-position','0 -23px');

              },function(ev){
                $(this).css('background-position',$(this).attr('alt'));
              });

              $('ul#locations_list').append('<li class="others"><a href="/cities">Otros lugares</a></li>');
          }
        });
      } else {
        alert("Geocode was not successful for the following reason: " + status);
      }
    });
    
    layer = new google.maps.FusionTablesLayer(FUSION_TABLES_ID);
    layer.setMap(map);
    
    google.maps.event.addListener(map, 'click', function(event) {
      if (map_enabled) {
        $('div.main_map_left div.border_map div.geocorder').fadeIn();
        $('div.main_map_left div.border_map p.click').text('Ahora puedes arrastrar el "marker" donde quieras...');
        
        add_marker = addCustomMarker(add_marker, map, event.latLng);

        geocodeMarkerPosition(event);
      }
    });
  }
  
  function addCustomMarker(marker, map, latLong){
    !marker || marker.setMap(null);
    
    var image = new google.maps.MarkerImage(
      '/images/marker.png',
      new google.maps.Size(30, 38),
      new google.maps.Point(0,0),
      new google.maps.Point(15, 38)
    );

    marker = new google.maps.Marker({
        position: latLong,
        map: map,
        icon: image,
        draggable: true
    });
    
    google.maps.event.addListener(marker, 'dragend', geocodeMarkerPosition);
    
    
    return marker;
  }
  
  function geocodeMarkerPosition(event){
    !geocoder || geocoder.geocode({'latLng': event.latLng}, function(results, status){
      if (results && results[0] && results[0].formatted_address) {
        marker_address = results[0];
        var
          paragraph = $('div.main_map_left div.border_map div.geocorder div.left p'),
          font_size = 15;
        paragraph.css('font-size', font_size).find('span.address').text(results[0].formatted_address);
        while(paragraph.width() > 400){
          font_size -= 1;
          paragraph.css('font-size', font_size);
        }
        paragraph.fadeIn();
      };
    });
  }

  // DEPRECATED
  //Calculate location bar width
  function getBarLocationWith(num) {
    if (num<max_potholes) {
      return (185*num)/max_potholes;
    } else {
      return 185;
    }
  }
  
  //Calculate location bar width
  function getBarPosition(num) {
    if (num<max_potholes) {
      var position = 185 - (num * 2);
      return (position * -1);
    } else {
      return 0;
    }
  }
  
  //Get pothole data
  function getPotholeData(element) {
    var data = new Object();

    data.address = $(element).find('p.place').text();
    data.reported = $(element).find('p.reported').html();
    data.lat = $(element).find('p.lat').text();
    data.lon = $(element).find('p.lon').text();
    data.days = $(element).find('p.days').text();
    
    
    return data;
  }

  //Find location in main map
  function geocorder() {
     var address = $('input[type="text"]').val();
     address += ', España';
     if (geocoder) {
       geocoder.geocode( { 'address': address}, 
        function(results, status) {
          var country = results.formatted_address;
          if (status == google.maps.GeocoderStatus.OK) {
            if (results[0].geometry.bounds) {
              map.fitBounds(results[0].geometry.bounds);
            };
            map.setCenter(results[0].geometry.location);
          } else {
            alert('Lo siento no hemos encontrado tu localidad');
          }
        });
     }
   }
  
  //Close selected pothole
  function closeSelectedItem() {
    $('li.selected').animate({
          height: 0
        }, 350, function() {
          $("ul#pothole_list li").each( function(i) {
              if (!$(this).is(':visible')) {
                var height_ = $(this).height();
                $(this).height(0);
                $(this).animate({height: height_}, 250);
                return;
              }
          });
        });
  }
  
  //Check if the pothole has already confirmed.
  function checkIfConfirmed(lat,lon) {
    for (var i=0; i<reported_potholes.length; i++) {
      if (reported_potholes[i].lat==lat && reported_potholes[i].lon==lon) {
        return true;
      }
    }
    return false;
  }
  
  //Confirm pothole showed in the list
  function confirmPothole() {
    
    id_pothole = $('p.id_pothole').html();
    
    $("li.selected").expose({
        closeOnClick: false,
        closeOnEsc: false,
        color: "#000",
        onBeforeLoad: function() {
          $('#mamufas_selected').fadeIn('fast');
          $('#confirm_pothole').fadeOut('fast');
          $('#close_selected').fadeOut('fast');
        }
     });
    
      $.ajax({ url: "/report/"+ id_pothole, method:'POST', success: function(){
      $('#mamufas_selected').fadeOut('fast');
      $('p.confirm_tooltip').fadeIn();
      $('p.confirm_tooltip').delay(4000).fadeOut();
      $.mask.close();
      $('#close_selected').fadeIn('fast');
      var counts = parseInt($('li.selected').find('strong.count').text()) + 1;
      $('li.selected').find('p.reported').text(counts +  ' veces reportado.');
      
      $("ul#pothole_list li").each( function(i) {
          if (!$(this).is(':visible')) {
            $(this).find('p.reported').text(counts +  ' veces reportado.');
            $(this).find('div.image img').attr('src','/images/reported.png');
            return;
          }
      });
      
      var pothole_ = new Object();
      pothole_.lat = marker.getPosition().lat();
      pothole_.lon = marker.getPosition().lng();
      reported_potholes.push(pothole_);
    }});
    
  }
  
  //Confirm pothole showed in the list
  function addNewPothole() {
    if (add_marker !=null && add_marker.getMap() !=null ) {
      $('#create_pothole').fadeOut('fast', function(){
        $('#sending_pothole').fadeIn('fast');
      });
      
      $('div.main_map_left div.border_map p.click').fadeOut();
      $.ajax({
        url: "/potholes",
        data: decodeMarkerAddress(),
        dataType: 'json',
        type: 'post',
        success: function(objJson){
          if (!objJson || !objJson['pothole']) {return;};
          
          addPotholeMarker(objJson['pothole']);
          setupUploadify(objJson['pothole']);

        },
        error: function(){
          alert('Hubo un error con la dirección del punto especificada.');
          $('div.geocorder div.steps').hide();
          $('#create_pothole').fadeIn('fast');
        }
      });
    } else {
      alert('No hay ningún punto marcado en el mapa');
    }
  }
  
  function decodeMarkerAddress(){
    var
      data = {},
      decodedAddress = vizzuality.maps.decode_address(marker_address);

    data['lat']            = decodedAddress.lat();
    data['long']           = decodedAddress.lng();
    data['full_address']   = decodedAddress.full_address();
    data['street_address'] = decodedAddress.street();
    data['city']           = decodedAddress.city();
    data['zip']            = decodedAddress.postal_code();
    data['country']        = decodedAddress.country();
    data['country_code']   = decodedAddress.country_code();
    return data;
  }
  
  function addPotholeMarker(pothole){
    var showInfowindow = function(latLong, map, infowindow_content, dimensions){
      !add_marker || add_marker.setMap(null);
    
      var image = new google.maps.MarkerImage(
        '/images/fusion_marker.png',
        new google.maps.Size(14, 14),
        new google.maps.Point(0,0),
        new google.maps.Point(7, 7)
      );

      var marker = new google.maps.Marker({
          position: latLong,
          map: map,
          icon: image
      });
      !info_window || info_window.setMap(null);
      info_window = new vizzuality.maps.infobox({
        content: infowindow_content.remove()[0],
        width: dimensions.width,
        height: dimensions.height,
        position: latLong,
        map: map
      });
    }

    var
      infowindow_content = $('div#pothole_info').clone().attr('id', null),
      dimensions = infowindow_content.objectSize(),
      latLong = new google.maps.LatLng(pothole['lat'], pothole['lon']);

    if (pothole.photo_url) {
      infowindow_content.find('div.text').before($('<img>').attr('src', pothole.photo_url).load(function(){
        dimensions = infowindow_content.objectSize();
        showInfowindow(latLong, map, infowindow_content, dimensions);
      }));
      
    }else{
      showInfowindow(latLong, map, infowindow_content, dimensions);
    };


  }
  
  function setupUploadify(pothole){
    $('div.main_map_left div.border_map div.geocorder div.uploadify').show();
    $('#sending_pothole').fadeOut('fast', function(){
      $('#add_photo').fadeIn('fast');
    });
    
    if ($('div.main_map_left div.border_map div.geocorder div.uploadify object').length > 0) { return; };
    
    var
      csrf_param = $('meta[name=csrf-param]').attr('content'),
      csrf_token = $('meta[name=csrf-token]').attr('content');

    uploadify_script_data[csrf_param] = encodeURI(encodeURIComponent(csrf_token));

    $('#fileInput').uploadify({
      'uploader'      : '/flash/uploadify.swf',
      'script'        : '/potholes/'+pothole.id+'/add_photo',
      'scriptData'    : uploadify_script_data,
      'fileDataName'  : 'pothole[photo]',
      'auto'          : true,
      'hideButton'    : true,
      'wmode'         : 'transparent',
      'width'         : 128,
      'height'        : 20,
      'onOpen'      : function(){
        $('#add_photo, #change_photo').fadeOut('fast');
        $('#fileInputQueue span.fileName').text('Añadiendo...');
      },
      'onError'       : function(event, queueID, fileObj, errorObj){
        alert('Se produjo un error al añadir la imagen.');
        $('#fileInput'+queueID).remove();
        $('div.geocorder div.steps').hide();
        $('#add_photo').fadeIn('fast');
      },
      'onComplete'    : function(event, queueID, fileObj, response, data){
        $('#change_photo').fadeIn('fast');
        var objJson = eval('('+response+')');
        addPotholeMarker(objJson.pothole);
      }
    });
  }
  
  function closeExpose(){
    !$.mask || $.mask.close();
  }
