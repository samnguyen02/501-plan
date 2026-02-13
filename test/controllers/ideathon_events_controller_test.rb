require "test_helper"

class IdeathonEventsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @ideathon_event = ideathon_events(:one)
  end

  test "should get index" do
    get ideathon_events_url
    assert_response :success
  end

  test "should get new" do
    get new_ideathon_event_url
    assert_response :success
  end

  test "should create ideathon_event" do
    assert_difference("IdeathonEvent.count") do
      post ideathon_events_url, params: { ideathon_event: { event_date: @ideathon_event.event_date, event_description: @ideathon_event.event_description, event_name: @ideathon_event.event_name, event_time: @ideathon_event.event_time, ideathon_year_id: @ideathon_event.ideathon_year_id } }
    end

    assert_redirected_to ideathon_event_url(IdeathonEvent.last)
  end

  test "should show ideathon_event" do
    get ideathon_event_url(@ideathon_event)
    assert_response :success
  end

  test "should get edit" do
    get edit_ideathon_event_url(@ideathon_event)
    assert_response :success
  end

  test "should update ideathon_event" do
    patch ideathon_event_url(@ideathon_event), params: { ideathon_event: { event_date: @ideathon_event.event_date, event_description: @ideathon_event.event_description, event_name: @ideathon_event.event_name, event_time: @ideathon_event.event_time, ideathon_year_id: @ideathon_event.ideathon_year_id } }
    assert_redirected_to ideathon_event_url(@ideathon_event)
  end

  test "should destroy ideathon_event" do
    assert_difference("IdeathonEvent.count", -1) do
      delete ideathon_event_url(@ideathon_event)
    end

    assert_redirected_to ideathon_events_url
  end
end
