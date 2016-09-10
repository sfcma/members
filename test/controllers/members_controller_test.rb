require 'test_helper'

class MembersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @member = members(:one)
  end

  test "should get index" do
    get members_url
    assert_response :success
  end

  test "should get new" do
    get new_member_url
    assert_response :success
  end

  test "should create member" do
    assert_difference('Member.count') do
      post members_url, params: { member: { address_1: @member.address_1, address_2: @member.address_2, city: @member.city, email_1: @member.email_1, email_2: @member.email_2, emergency_name: @member.emergency_name, emergency_phone: @member.emergency_phone, emergency_relation: @member.emergency_relation, first_name: @member.first_name, last_name: @member.last_name, phone_1: @member.phone_1, phone_1_type: @member.phone_1_type, phone_2: @member.phone_2, phone_2_type: @member.phone_2_type, playing_status: @member.playing_status, state: @member.state, zip: @member.zip } }
    end

    assert_redirected_to member_url(Member.last)
  end

  test "should show member" do
    get member_url(@member)
    assert_response :success
  end

  test "should get edit" do
    get edit_member_url(@member)
    assert_response :success
  end

  test "should update member" do
    patch member_url(@member), params: { member: { address_1: @member.address_1, address_2: @member.address_2, city: @member.city, email_1: @member.email_1, email_2: @member.email_2, emergency_name: @member.emergency_name, emergency_phone: @member.emergency_phone, emergency_relation: @member.emergency_relation, first_name: @member.first_name, last_name: @member.last_name, phone_1: @member.phone_1, phone_1_type: @member.phone_1_type, phone_2: @member.phone_2, phone_2_type: @member.phone_2_type, playing_status: @member.playing_status, state: @member.state, zip: @member.zip } }
    assert_redirected_to member_url(@member)
  end

  test "should destroy member" do
    assert_difference('Member.count', -1) do
      delete member_url(@member)
    end

    assert_redirected_to members_url
  end
end
