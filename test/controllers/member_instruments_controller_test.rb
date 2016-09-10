require 'test_helper'

class MemberInstrumentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @member_instrument = member_instruments(:one)
  end

  test "should get index" do
    get member_instruments_url
    assert_response :success
  end

  test "should get new" do
    get new_member_instrument_url
    assert_response :success
  end

  test "should create member_instrument" do
    assert_difference('MemberInstrument.count') do
      post member_instruments_url, params: { member_instrument: { instrument: @member_instrument.instrument, member_id: @member_instrument.member_id } }
    end

    assert_redirected_to member_instrument_url(MemberInstrument.last)
  end

  test "should show member_instrument" do
    get member_instrument_url(@member_instrument)
    assert_response :success
  end

  test "should get edit" do
    get edit_member_instrument_url(@member_instrument)
    assert_response :success
  end

  test "should update member_instrument" do
    patch member_instrument_url(@member_instrument), params: { member_instrument: { instrument: @member_instrument.instrument, member_id: @member_instrument.member_id } }
    assert_redirected_to member_instrument_url(@member_instrument)
  end

  test "should destroy member_instrument" do
    assert_difference('MemberInstrument.count', -1) do
      delete member_instrument_url(@member_instrument)
    end

    assert_redirected_to member_instruments_url
  end
end
