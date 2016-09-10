require 'test_helper'

class MemberNotesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @member_note = member_notes(:one)
  end

  test "should get index" do
    get member_notes_url
    assert_response :success
  end

  test "should get new" do
    get new_member_note_url
    assert_response :success
  end

  test "should create member_note" do
    assert_difference('MemberNote.count') do
      post member_notes_url, params: { member_note: { member_id: @member_note.member_id, note: @member_note.note, user_id: @member_note.user_id } }
    end

    assert_redirected_to member_note_url(MemberNote.last)
  end

  test "should show member_note" do
    get member_note_url(@member_note)
    assert_response :success
  end

  test "should get edit" do
    get edit_member_note_url(@member_note)
    assert_response :success
  end

  test "should update member_note" do
    patch member_note_url(@member_note), params: { member_note: { member_id: @member_note.member_id, note: @member_note.note, user_id: @member_note.user_id } }
    assert_redirected_to member_note_url(@member_note)
  end

  test "should destroy member_note" do
    assert_difference('MemberNote.count', -1) do
      delete member_note_url(@member_note)
    end

    assert_redirected_to member_notes_url
  end
end
