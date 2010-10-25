require File.dirname(__FILE__) + '/acceptance_helper'

feature "Pothole reporting", %q{
  In order to fix all potholes in my city
  As a citizen
  I want to report new potholes I see on the street
} do
  
  scenario "Reporting a new pothole" do
    visit homepage
    page.should have_content('otrobache.com')
    page.should have_css('#main_map')
    page.should have_css('div.border_map p.click', :visible => false)
    click_link('addPothole')
    page.should have_css('#exposeMask', :visible => true)
    within('div.border_map') do
      page.should have_css('p.click', :visible => true)
      fill_in('Busca cerca de', :with => 'Calle Hortaleza 2, Madrid')
      click_button('do_map_search')
      click_map_center
      should_add_a_new_marker
      page.should have_content('Bache en Calle de Hortaleza, 2, 28004 Madrid, España')
      assert_difference "Pothole.count", 1 do
        click_link('send_pothole')
        page.should have_css('div#add_photo a:first-child', :text => 'Añadir una foto', :visible => true)
      end
    end
  end
  
end