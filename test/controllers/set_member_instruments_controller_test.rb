require 'test_helper'

class SetMemberInstrumentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @set_member_instrument = set_member_instruments(:one)
  end

  test "should get index" do
    get set_member_instruments_url
    assert_response :success
  end

  test "should get new" do
    get new_set_member_instrument_url
    assert_response :success
  end

  test "should create set_member_instrument" do
    assert_difference('SetMemberInstrument.count') do
      post set_member_instruments_url, params: {
        set_member_instrument: {
          member_instrument_id: @set_member_instrument.member_instrument_id,
          member_set_id: @set_member_instrument.member_set_id,
        },
      }
    end

    assert_redirected_to set_member_instrument_url(SetMemberInstrument.last)
  end

  test "should show set_member_instrument" do
    get set_member_instrument_url(@set_member_instrument)
    assert_response :success
  end

  test "should get edit" do
    get edit_set_member_instrument_url(@set_member_instrument)
    assert_response :success
  end

  test "should update set_member_instrument" do
    patch set_member_instrument_url(@set_member_instrument), params: {
      set_member_instrument: {
        member_instrument_id: @set_member_instrument.member_instrument_id,
        member_set_id: @set_member_instrument.member_set_id,
      },
    }
    assert_redirected_to set_member_instrument_url(@set_member_instrument)
  end

  test "should destroy set_member_instrument" do
    assert_difference('SetMemberInstrument.count', -1) do
      delete set_member_instrument_url(@set_member_instrument)
    end

    assert_redirected_to set_member_instruments_url
  end
end
