require "test_helper"

class RegisteredAttendeesControllerTest < ActionDispatch::IntegrationTest
     include Devise::Test::IntegrationHelpers

     setup do
          @registered_attendee = registered_attendees(:one)
          @admin = admins(:one)
     end

     test "should get index" do
          sign_in @admin
          get registered_attendees_url
          assert_response :success
     end

     test "should get new" do
          get new_registered_attendee_url
          assert_response :success
     end

     test "should create registered_attendee" do
          assert_difference("RegisteredAttendee.count") do
               post registered_attendees_url, params: {
                    registered_attendee: {
                         attendee_class: @registered_attendee.attendee_class,
                         attendee_email: @registered_attendee.attendee_email,
                         attendee_major: @registered_attendee.attendee_major,
                         attendee_name: @registered_attendee.attendee_name,
                         attendee_phone: @registered_attendee.attendee_phone,
                         ideathon_year_id: @registered_attendee.ideathon_year_id
                    },
                    team_choice: "unassigned"
               }
          end

          assert_redirected_to success_registered_attendees_path
     end

     test "should show registered_attendee" do
          sign_in @admin
          get registered_attendee_url(@registered_attendee)
          assert_response :success
     end

     test "should get edit" do
          sign_in @admin
          get edit_registered_attendee_url(@registered_attendee)
          assert_response :success
     end

     test "should update registered_attendee" do
          sign_in @admin
          patch registered_attendee_url(@registered_attendee), params: {
               registered_attendee: {
                    attendee_class: @registered_attendee.attendee_class,
                    attendee_email: @registered_attendee.attendee_email,
                    attendee_major: @registered_attendee.attendee_major,
                    attendee_name: @registered_attendee.attendee_name,
                    attendee_phone: @registered_attendee.attendee_phone,
                    ideathon_year_id: @registered_attendee.ideathon_year_id
               },
               team_choice: "unassigned"
          }
          assert_redirected_to manager_index_path
     end

     test "should destroy registered_attendee" do
          sign_in @admin
          assert_difference("RegisteredAttendee.count", -1) do
               delete registered_attendee_url(@registered_attendee)
          end

          assert_redirected_to registered_attendees_url
     end
end
