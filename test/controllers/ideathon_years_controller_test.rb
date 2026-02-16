require "test_helper"

class IdeathonYearsControllerTest < ActionDispatch::IntegrationTest
     setup do
          @ideathon_year = ideathon_years(:one)
     end

     test "should get index" do
          get ideathon_years_url
          assert_response :success
     end

     test "should get new" do
          get new_ideathon_year_url
          assert_response :success
     end

     test "should create ideathon_year" do
          assert_difference("IdeathonYear.count") do
               post ideathon_years_url, params: { ideathon_year: { description: @ideathon_year.description, end_date: @ideathon_year.end_date, is_active: @ideathon_year.is_active, location: @ideathon_year.location, name: @ideathon_year.name, start_date: @ideathon_year.start_date } }
          end

          assert_redirected_to ideathon_year_url(IdeathonYear.last)
     end

     test "should show ideathon_year" do
          get ideathon_year_url(@ideathon_year)
          assert_response :success
     end

     test "should get edit" do
          get edit_ideathon_year_url(@ideathon_year)
          assert_response :success
     end

     test "should update ideathon_year" do
          patch ideathon_year_url(@ideathon_year), params: { ideathon_year: { description: @ideathon_year.description, end_date: @ideathon_year.end_date, is_active: @ideathon_year.is_active, location: @ideathon_year.location, name: @ideathon_year.name, start_date: @ideathon_year.start_date } }
          assert_redirected_to ideathon_year_url(@ideathon_year)
     end

     test "should destroy ideathon_year" do
          assert_difference("IdeathonYear.count", -1) do
               delete ideathon_year_url(@ideathon_year)
          end

          assert_redirected_to ideathon_years_url
     end
end
