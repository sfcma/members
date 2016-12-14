require 'test_helper'

class PerformanceSetDatesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @performance_set_date = performance_set_dates(:one)
  end

  test "should get index" do
    get performance_set_dates_url
    assert_response :success
  end

  test "should get new" do
    get new_performance_set_date_url
    assert_response :success
  end

  test "should create performance_set_date" do
    assert_difference('PerformanceSetDate.count') do
      post performance_set_dates_url, params: { performance_set_date: {  } }
    end

    assert_redirected_to performance_set_date_url(PerformanceSetDate.last)
  end

  test "should show performance_set_date" do
    get performance_set_date_url(@performance_set_date)
    assert_response :success
  end

  test "should get edit" do
    get edit_performance_set_date_url(@performance_set_date)
    assert_response :success
  end

  test "should update performance_set_date" do
    patch performance_set_date_url(@performance_set_date), params: { performance_set_date: {  } }
    assert_redirected_to performance_set_date_url(@performance_set_date)
  end

  test "should destroy performance_set_date" do
    assert_difference('PerformanceSetDate.count', -1) do
      delete performance_set_date_url(@performance_set_date)
    end

    assert_redirected_to performance_set_dates_url
  end
end
