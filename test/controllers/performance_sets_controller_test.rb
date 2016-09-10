require 'test_helper'

class PerformanceSetsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @performance_set = performance_sets(:one)
  end

  test "should get index" do
    get performance_sets_url
    assert_response :success
  end

  test "should get new" do
    get new_performance_set_url
    assert_response :success
  end

  test "should create performance_set" do
    assert_difference('PerformanceSet.count') do
      post performance_sets_url, params: { performance_set: { end_date: @performance_set.end_date, performance_id: @performance_set.performance_id, start_date: @performance_set.start_date } }
    end

    assert_redirected_to performance_set_url(PerformanceSet.last)
  end

  test "should show performance_set" do
    get performance_set_url(@performance_set)
    assert_response :success
  end

  test "should get edit" do
    get edit_performance_set_url(@performance_set)
    assert_response :success
  end

  test "should update performance_set" do
    patch performance_set_url(@performance_set), params: { performance_set: { end_date: @performance_set.end_date, performance_id: @performance_set.performance_id, start_date: @performance_set.start_date } }
    assert_redirected_to performance_set_url(@performance_set)
  end

  test "should destroy performance_set" do
    assert_difference('PerformanceSet.count', -1) do
      delete performance_set_url(@performance_set)
    end

    assert_redirected_to performance_sets_url
  end
end
