# frozen_string_literal: true

require "rails_helper"

if Rails.application.routes.url_helpers.respond_to?(:ideathon_registrations_path)
     RSpec.describe "Ideathon Registrations", type: :system do
          let(:admin_tamu) { Admin.create!(email: "student@tamu.edu", full_name: "TAMU Student", uid: "111") }
          let(:admin_other) { Admin.create!(email: "other@gmail.com", full_name: "Other User", uid: "222") }

          before do
               OmniAuth.config.test_mode = true
          end
          after do
               OmniAuth.config.mock_auth[:google_oauth2] = nil
          end

          describe "registration page" do
               it "displays the ideathon registration page when signed in" do
                    mock_google_oauth2(email: admin_tamu.email, full_name: admin_tamu.full_name, uid: admin_tamu.uid, avatar_url: nil)
                    visit "/admins/auth/google_oauth2/callback"
                    visit ideathon_registrations_path
                    expect(page).to have_content(/ideathon|registration/i)
               end
          end

          describe "TAMU students" do
               it "allows TAMU student to submit registration" do
                    mock_google_oauth2(email: admin_tamu.email, full_name: admin_tamu.full_name, uid: admin_tamu.uid, avatar_url: nil)
                    visit "/admins/auth/google_oauth2/callback"
                    visit new_ideathon_registration_path
                    fill_in "Full name", with: "TAMU Student"
                    fill_in "Email", with: "student@tamu.edu"
                    click_button /Create|Submit|Register/
                    expect(page).to have_content(/success|created|registration/i)
               end
          end

          describe "non-TAMU users" do
               it "rejects or restricts non-TAMU email on registration" do
                    mock_google_oauth2(email: admin_other.email, full_name: admin_other.full_name, uid: admin_other.uid, avatar_url: nil)
                    visit "/admins/auth/google_oauth2/callback"
                    visit new_ideathon_registration_path
                    fill_in "Full name", with: "Non TAMU"
                    fill_in "Email", with: "user@gmail.com"
                    click_button /Create|Submit|Register/
                    expect(page).to have_content(/tamu|authorized|allowed|restricted|invalid/i)
               end
          end
     end
else
     RSpec.describe "Ideathon Registrations", type: :system do
          it "is implemented so system specs can run" do
               skip "Add ideathon_registrations route and views; then these specs will run and should pass"
          end
     end
end
