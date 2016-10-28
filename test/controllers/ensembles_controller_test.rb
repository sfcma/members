require 'test_helper'

class EnsemblesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @ensemble = ensembles(:one)
  end

  test "should get index" do
    get ensembles_url
    assert_response :success
  end

  test "should get new" do
    get new_ensemble_url
    assert_response :success
  end

  test "should create ensemble" do
    assert_difference('Ensemble.count') do
      post ensembles_url, params: { ensemble: { description: @ensemble.description, name: @ensemble.name } }
    end

    assert_redirected_to ensemble_url(Ensemble.last)
  end

  test "should show ensemble" do
    get ensemble_url(@ensemble)
    assert_response :success
  end

  test "should get edit" do
    get edit_ensemble_url(@ensemble)
    assert_response :success
  end

  test "should update ensemble" do
    patch ensemble_url(@ensemble), params: { ensemble: { description: @ensemble.description, name: @ensemble.name } }
    assert_redirected_to ensemble_url(@ensemble)
  end

  test "should destroy ensemble" do
    assert_difference('Ensemble.count', -1) do
      delete ensemble_url(@ensemble)
    end

    assert_redirected_to ensembles_url
  end
end
