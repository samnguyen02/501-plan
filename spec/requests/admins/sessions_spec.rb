# frozen_string_literal: true

require "rails_helper"

# Admin sign-in is Google-only: user clicks Login → sees the Google button → clicks it →
# Google’s page lets them choose which account/email → callback returns to the app.
# This spec only checks that the page with the Google button loads (GET /admins/sign_in).
RSpec.describe "Admins::Sessions", type: :request do
  describe "GET /admins/sign_in" do
    it "returns success (page with Google sign-in button; email choice happens on Google’s side)" do
      get new_admin_session_path
      expect(response).to have_http_status(:ok)
    end
  end
end
