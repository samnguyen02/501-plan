require "rails_helper"

# Admins do not "register" via Google — they sign in. Only emails on the allowlist (ALLOWED_ADMIN_EMAILS)
# are pre-authorized for admin privileges. Everyone else gets an error when trying to sign in.
RSpec.describe "Google OAuth sign-in (admin)", type: :system do
  before { OmniAuth.config.test_mode = true }
  after { OmniAuth.config.mock_auth[:google_oauth2] = nil }

  context "when user is not signed in" do
    it "shows home page with login and register options" do
      visit root_path
      expect(page).to have_content(/Login|Log in|Register/i)
    end
  end

  context "when email is on the admin allowlist (pre-validated)" do
    before do
      allow(ENV).to receive(:fetch).with("ALLOWED_ADMIN_EMAILS", "").and_return("admin@tamu.edu")
      mock_google_oauth2(email: "admin@tamu.edu", full_name: "Admin User", uid: "123", avatar_url: "https://example.com/a.jpg")
      visit "/admins/auth/google_oauth2/callback"
    end

    it "signs them in as admin and redirects to root" do
      expect(Admin.find_by(email: "admin@tamu.edu")).to be_present
      expect(page).to have_current_path(root_path)
    end
  end

  context "when email is not on the admin allowlist" do
    before do
      allow(ENV).to receive(:fetch).with("ALLOWED_ADMIN_EMAILS", "").and_return("other@tamu.edu")
      mock_google_oauth2(email: "user@gmail.com", full_name: "Regular User", uid: "456", avatar_url: nil)
      visit "/admins/auth/google_oauth2/callback"
    end

    it "does not grant access and shows error about admin privileges" do
      expect(Admin.find_by(email: "user@gmail.com")).to be_nil
      expect(page).to have_content(/not authorized|admin|sign in/i)
    end
  end
end
