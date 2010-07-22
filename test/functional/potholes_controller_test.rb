require 'test_helper'

class PotholesControllerTest < ActionController::TestCase
  setup do
    @pothole = potholes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:potholes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create pothole" do
    assert_difference('Pothole.count') do
      post :create, :pothole => @pothole.attributes
    end

    assert_redirected_to pothole_path(assigns(:pothole))
  end

  test "should show pothole" do
    get :show, :id => @pothole.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @pothole.to_param
    assert_response :success
  end

  test "should update pothole" do
    put :update, :id => @pothole.to_param, :pothole => @pothole.attributes
    assert_redirected_to pothole_path(assigns(:pothole))
  end

  test "should destroy pothole" do
    assert_difference('Pothole.count', -1) do
      delete :destroy, :id => @pothole.to_param
    end

    assert_redirected_to potholes_path
  end
end
