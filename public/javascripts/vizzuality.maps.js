var vizzuality = {
  maps: {
  
    infobox: function(opts) {
      if (!opts || !opts.content) {return;};
      google.maps.OverlayView.call(this);

      this.latlng_           = opts.position;
      this.map_              = opts.map;
      this.content_          = opts.content;
      this.height_           = opts.height;
      this.width_            = opts.width;
      this.offsetVertical_   = (opts.offsetVertical || -20) - opts.height;
      this.offsetHorizontal_ = opts.offsetHorizontal || -20;

      var me = this;
      this.boundsChangedListener_ = google.maps.event.addListener(this.map_, "bounds_changed", function() {
        return me.panMap.apply(me);
      });

      this.setMap(this.map_);
    },
    
    decode_address: function(address){
      vizzuality.maps.decode_address.address = address;

      return {
        lat: function(){
          var address = vizzuality.maps.decode_address.address;
          if (address.geometry && address.geometry.location && address.geometry.location.b) {
            return address.geometry.location.b;
          };
          return null;
        },
        
        lng: function(){
          var address = vizzuality.maps.decode_address.address;
          if (address.geometry && address.geometry.location && address.geometry.location.c) {
            return address.geometry.location.c;
          };
          return null;
        },
        
        full_address: function(){
          var address = vizzuality.maps.decode_address.address;
          return address.formatted_address;
        },
        
        street: function(){
          var address = vizzuality.maps.decode_address.address;
          for (var i = address.address_components.length - 1; i >= 0; i--){
            address_component = address.address_components[i];
            if ($.inArray('route', address_component.types) > -1) {
              return address_component.long_name;
            }
          };
          return null;
        },
        
        street_number: function(){
          var address = vizzuality.maps.decode_address.address;
          for (var i = address.address_components.length - 1; i >= 0; i--){
            address_component = address.address_components[i];
            if ($.inArray('street_number', address_component.types) > -1) {
              return address_component.long_name;
            }
          };
          return null;
        },
    
        city: function(){
          var address = vizzuality.maps.decode_address.address;
          for (var i = address.address_components.length - 1; i >= 0; i--){
            address_component = address.address_components[i];
            if ($.inArray('locality', address_component.types) > -1) {
              return address_component.long_name;
            }
          };
          return null;
        },
    
        substate: function(){
          var address = vizzuality.maps.decode_address.address;
          for (var i = address.address_components.length - 1; i >= 0; i--){
            address_component = address.address_components[i];
            if ($.inArray('administrative_area_level_2', address_component.types) > -1) {
              return address_component.long_name;
            }
          };
          return null;
        },

        state: function(){
          var address = vizzuality.maps.decode_address.address;
          for (var i = address.address_components.length - 1; i >= 0; i--){
            address_component = address.address_components[i];
            if ($.inArray('administrative_area_level_1', address_component.types) > -1) {
              return address_component.long_name;
            }
          };
          return null;
        },

        postal_code: function(){
          var address = vizzuality.maps.decode_address.address;
          for (var i = address.address_components.length - 1; i >= 0; i--){
            address_component = address.address_components[i];
            if ($.inArray('postal_code', address_component.types) > -1) {
              return address_component.long_name;
            }
          };
          return null;
        },

        country: function(){
          var address = vizzuality.maps.decode_address.address;
          for (var i = address.address_components.length - 1; i >= 0; i--){
            address_component = address.address_components[i];
            if ($.inArray('country', address_component.types) > -1) {
              return address_component.long_name;
            }
          };
          return null;
        },

        country_code: function(){
          var address = vizzuality.maps.decode_address.address;
          for (var i = address.address_components.length - 1; i >= 0; i--){
            address_component = address.address_components[i];
            if ($.inArray('country', address_component.types) > -1) {
              return address_component.short_name;
            }
          };
          return null;
        }
      }
    }
  }
}

vizzuality.maps.infobox.prototype = new google.maps.OverlayView();

vizzuality.maps.infobox.prototype.remove = function() {
  if (this.div_) {
    this.div_.parentNode.removeChild(this.div_);
    this.div_ = null;
  }
};

vizzuality.maps.infobox.prototype.draw = function() {
  this.createElement();
  
  if (!this.div_) return;
 
  // Calculate the DIV coordinates of two opposite corners of our bounds to
  // get the size and position of our Bar
  var pixPosition = this.getProjection().fromLatLngToDivPixel(this.latlng_);
  if (!pixPosition) return;
 
  // Now position our DIV based on the DIV coordinates of our bounds
  this.div_.style.width = this.width_ + "px";
  this.div_.style.left = (pixPosition.x + this.offsetHorizontal_) + "px";
  this.div_.style.height = this.height_ + "px";
  this.div_.style.top = (pixPosition.y + this.offsetVertical_) + "px";
  this.div_.style.display = 'block';
};

vizzuality.maps.infobox.prototype.createElement = function() {
  var panes = this.getPanes();
  var div = this.div_;
  if (!div) {
    div                      = this.div_ = document.createElement("div");
    div.setAttribute('class', 'custom_infowindow');

    div.appendChild(this.content_);
    panes.floatPane.appendChild(div);
    this.panMap();
  } else if (div.parentNode != panes.floatPane) {
    div.parentNode.removeChild(div);
    panes.floatPane.appendChild(div);
  } else {
  }
}

vizzuality.maps.infobox.prototype.panMap = function() {
  var map         = this.map_;
  var bounds      = map.getBounds();
  if (!bounds) return;

  var position    = this.latlng_;

  var iwWidth     = this.width_;
  var iwHeight    = this.height_;

  var iwOffsetX   = this.offsetHorizontal_;
  var iwOffsetY   = this.offsetVertical_;

  var padX        = 40;
  var padY        = 40;

  var mapDiv      = map.getDiv();
  var mapWidth    = mapDiv.offsetWidth;
  var mapHeight   = mapDiv.offsetHeight;
  var boundsSpan  = bounds.toSpan();
  var longSpan    = boundsSpan.lng();
  var latSpan     = boundsSpan.lat();
  var degPixelX   = longSpan / mapWidth;
  var degPixelY   = latSpan / mapHeight;

  var mapWestLng  = bounds.getSouthWest().lng();
  var mapEastLng  = bounds.getNorthEast().lng();
  var mapNorthLat = bounds.getNorthEast().lat();
  var mapSouthLat = bounds.getSouthWest().lat();

  var iwWestLng   = position.lng() + (iwOffsetX - padX) * degPixelX;
  var iwEastLng   = position.lng() + (iwOffsetX + iwWidth + padX) * degPixelX;
  var iwNorthLat  = position.lat() - (iwOffsetY - padY) * degPixelY;
  var iwSouthLat  = position.lat() - (iwOffsetY + iwHeight + padY) * degPixelY;

  var shiftLng    = 
      (iwWestLng < mapWestLng ? mapWestLng - iwWestLng : 0) +
      (iwEastLng > mapEastLng ? mapEastLng - iwEastLng : 0);
  var shiftLat    = 
      (iwNorthLat > mapNorthLat ? mapNorthLat - iwNorthLat : 0) +
      (iwSouthLat < mapSouthLat ? mapSouthLat - iwSouthLat : 0);

  var center      = map.getCenter();

  var centerX     = center.lng() - shiftLng;
  var centerY     = center.lat() - shiftLat;

  map.setCenter(new google.maps.LatLng(centerY, centerX));

  if (this.boundsChangedListener_) {
    google.maps.event.removeListener(this.boundsChangedListener_);
    this.boundsChangedListener_ = null;
  };
}