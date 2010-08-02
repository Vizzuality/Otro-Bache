var selected_height;
var max_potholes = 31;
var map;
var map2;
var marker;
var add_marker;
var geocoder;
var layer;
var reported_potholes;

var map_enabled = false;


$(document).ready(function() {
	reported_potholes = [];
	$('a.add_pothole').click(function(ev){
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
						$('div.main_map_left div.border_map div.geocorder').fadeIn();
					},
					onBeforeClose: function() {
						map_enabled = false;
						if (add_marker!=null) {
							add_marker.setMap(null);
						}
						$('div.main_map_left div.border_map p.click ').fadeOut();
						$('div.main_map_left div.border_map div.geocorder').fadeOut();
					},
					onClose: function() {
						$('div.main_map_left div.border_map p.click ').text('Pulsa en cualquier parte del mapa para añadir el marker');
						$('div.main_map_left img.shadow').css('display','block');
						$('div.main_map_left').css('padding-bottom','12px');
						$('div.outer_layout.list div.sort p').css('padding-top','30px');
					}
				});
	});
	
	
	//List with stats in pothole locations && truncate locations text
	$('ul#locations_list li').each(function(ev){
		if ($(this).children('a').children('span').text().length > 14) {
			var location = $(this).children('a').children('span').text();
			$(this).children('a').children('span').text(location.substring(0,12)+'...');
		}
		var number = $(this).children('a').children('p.number').text();
		$(this).children('a').children('span').attr('alt',getBarLocationWith(number)+'px');
		$(this).children('a').children('span').css('width',getBarLocationWith(number)+'px');
	});
	
	$('ul#locations_list li a span').hover(function(ev){
		$(this).css('width','185px');
	},function(ev){
		$(this).css('width',$(this).attr('alt'));
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
		
		if ($('li.selected').height()>0) {
			
			$('li.selected').animate({
				    height: 0
				  }, 250, function() {
						map2.setCenter(new google.maps.LatLng(pothole_data.lat,pothole_data.lon));
						map2.setZoom(16);
						marker = new google.maps.Marker({
						        position: map2.getCenter(), 
						        map: map2
						    });
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
			marker = new google.maps.Marker({
			        position: map2.getCenter(), 
			        map: map2
			    });
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

	function initialize() {
    var myLatlng = new google.maps.LatLng(40.463667, -3.74922);
    var myOptions = {
      zoom: 8,
      center: myLatlng,
      mapTypeId: google.maps.MapTypeId.ROADMAP,
			disableDefaultUI: false,
			scrollwheel: false
    }
		geocoder = new google.maps.Geocoder();
    map = new google.maps.Map(document.getElementById("main_map"), myOptions);
		map2 = new google.maps.Map(document.getElementById("selected_map"), myOptions);
		
		layer = new google.maps.FusionTablesLayer(136993);
		layer.setMap(map);
		
		google.maps.event.addListener(map, 'click', function(event) {
			if (map_enabled) {
				$('div.main_map_left div.border_map p.click').text('Ahora puedes arrastrar el "marker" donde quieras...');
				if (add_marker!=null) {
					add_marker.setMap(null);
				} 
					add_marker = new google.maps.Marker({position: event.latLng, map: map, draggable: true});
			}
		});
  }


	//Calculate location bar width
	function getBarLocationWith(num) {
		if (num<max_potholes) {
			return (185*num)/max_potholes;
		} else {
			return 185;
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
						var bounds = new google.maps.LatLngBounds();
						bounds.extend(new google.maps.LatLng(results[0].geometry.bounds.ea.b,results[0].geometry.bounds.T.b));
						bounds.extend(new google.maps.LatLng(results[0].geometry.bounds.ea.c,results[0].geometry.bounds.T.c));
						map.fitBounds(bounds);
		        map.setCenter(results[0].geometry.location);
		      } else {
		        alert('Lo siento no hemos encontrado tu localidad');
		      }
				});
	   }
	 }
	
	//Check if the pothole has already confirmed.
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
		
  	$.ajax({ url: "/amfphp/json.php/OtroBache.reportBache/"+marker.getPosition().lat()+"/"+marker.getPosition().lng()+"/web", method:'GET', success: function(){
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
						$(this).find('div.image img').attr('src','images/reported.png');
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
		if (add_marker!=null && add_marker.getMap()!=null) {
			$('#mamufas_main').fadeIn('fast');
			$('div.main_map_left div.border_map p.click').fadeOut();
	  	$.ajax({ url: "/amfphp/json.php/OtroBache.reportBache/"+add_marker.getPosition().lat()+"/"+add_marker.getPosition().lng()+"/web", method:'GET', success: function(){
	  	    	$('#mamufas_main').fadeOut('fast');
	  				$('div.main_map_left div.border_map p.done').fadeIn();
	  				$('div.main_map_left div.border_map p.done').delay(4000).fadeOut();
	  				$.mask.close();
	  	  	}});
			
		} else {
			alert('No hay ningún punto marcado en el mapa');
		}

		
	}
	