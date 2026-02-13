require "test_helper"

class RegisteredAttendeesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @registered_attendee = registered_attendees(:one)
  end

  test "should get index" do
    get registered_attendees_url
    assert_response :success
  end

  test "should get new" do
    get new_registered_attendee_url
    assert_response :success
  end

  test "should create registered_attendee" do
    assert_difference("RegisteredAttendee.count") do
      post registered_attendees_url, params: { registered_attendee: { attendee_class: @registered_attendee.attendee_class, attendee_email: @registered_attendee.attendee_email, attendee_major: @registered_attendee.attendee_major, attendee_name: @registered_attendee.attendee_name, attendee_phone: @registered_attendee.attendee_phone, ideathon_year_id: @registered_attendee.ideathon_year_id, team_id: @registered_attendee.team_id } }
    end

    assert_redirected_to registered_attendee_url(RegisteredAttendee.last)
  end

  test "should show registered_attendee" do
    get registered_attendee_url(@registered_attendee)
    assert_response :success
  end

  test "should get edit" do
    get edit_registered_attendee_url(@registered_attendee)
    assert_response :success
  end

  test "should update registered_attendee" do
    patch registered_attendee_url(@registered_attendee), params: { registered_attendee: { attendee_class: @registered_attendee.attendee_class, attendee_email: @registered_attendee.attendee_email, attendee_major: @registered_attendee.attendee_major, attendee_name: @registered_attendee.attendee_name, attendee_phone: @registered_attendee.attendee_phone, ideathon_year_id: @registered_attendee.ideathon_year_id, team_id: @registered_attendee.team_id } }
    assert_redirected_to registered_attendee_url(@registered_attendee)
  end

  test "should destroy registered_attendee" do
    assert_difference("RegisteredAttendee.count", -1) do
      delete registered_attendee_url(@registered_attendee)
    end

    assert_redirected_to registered_attendees_url
  end
end
