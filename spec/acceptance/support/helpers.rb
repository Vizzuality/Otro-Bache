module HelperMethods
  # Put here any helper method you need to be available in all your acceptance tests
  def peich
    save_and_open_page
  end
  
  def enable_javascript
    Capybara.current_driver = :selenium
  end
  
  def disable_javascript
    Capybara.current_driver = :rack_test
  end
  
  def click_map_center
    page.evaluate_script(<<-EOF
      google.maps.event.trigger(map, 'click', {latLng: map.getCenter()});
    EOF
    )
  end
  
  def should_add_a_new_marker
    marker_added = page.evaluate_script('add_marker != null ? true : false');
    marker_added.should be(true)
  end
  
end

Rspec.configuration.include(HelperMethods)
