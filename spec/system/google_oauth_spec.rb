require "rails_helper"

# Specs for existing Google OAuth flow in the app (no ideathon code).
RSpec.describe "Google OAuth Authentication", type: :system do
  before { OmniAuth.config.test_mode = true }
  after { OmniAuth.config.mock_auth[:google_oauth2] = nil }

  context "when user is not authenticated" do
    it "shows sign in page with Google option" do
      visit root_path
      expect(page).to have_content("Log in")
      expect(page).to have_button("Sign in with Google")
    end
  end

  context "when authentication is successful" do
    before do
      mock_google_oauth2(email: "test@example.com", full_name: "Test User", uid: "123", avatar_url: "https://example.com/a.jpg")
      visit "/admins/auth/google_oauth2/callback"
    end

    it "creates admin and redirects to root" do
      expect(Admin.find_by(email: "test@example.com")).to be_present
      expect(page).to have_current_path(root_path)
    end
  end
end
