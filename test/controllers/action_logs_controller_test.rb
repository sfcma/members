require 'test_helper'

class ActionLogsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @action_log = action_logs(:one)
  end

  test "should get index" do
    get action_logs_url
    assert_response :success
  end

  test "should get new" do
    get new_action_log_url
    assert_response :success
  end

  test "should create action_log" do
    assert_difference('ActionLog.count') do
      post action_logs_url, params: { action_log: { action: @action_log.action, member_id: @action_log.member_id, user_id: @action_log.user_id } }
    end

    assert_redirected_to action_log_url(ActionLog.last)
  end

  test "should show action_log" do
    get action_log_url(@action_log)
    assert_response :success
  end

  test "should get edit" do
    get edit_action_log_url(@action_log)
    assert_response :success
  end

  test "should update action_log" do
    patch action_log_url(@action_log), params: { action_log: { action: @action_log.action, member_id: @action_log.member_id, user_id: @action_log.user_id } }
    assert_redirected_to action_log_url(@action_log)
  end

  test "should destroy action_log" do
    assert_difference('ActionLog.count', -1) do
      delete action_log_url(@action_log)
    end

    assert_redirected_to action_logs_url
  end
end
