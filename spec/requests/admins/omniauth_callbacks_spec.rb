require "rails_helper"

RSpec.describe "Admins::OmniauthCallbacks", type: :request do
  describe "GET /admins/auth/google_oauth2/callback" do
    let(:auth_hash) do
      OmniAuth::AuthHash.new(
        provider: "google_oauth2",
        uid: "123456789",
        info: { email: "test@example.com", name: "Test User", image: "https://example.com/avatar.jpg" },
        credentials: { token: "mock_token", expires_at: 1.week.from_now }
      )
    end

    before { OmniAuth.config.test_mode = true; OmniAuth.config.mock_auth[:google_oauth2] = auth_hash }
    after { OmniAuth.config.mock_auth[:google_oauth2] = nil }

    it "creates a new admin when one does not exist" do
      expect { get "/admins/auth/google_oauth2/callback" }.to change(Admin, :count).by(1)
    end

    it "redirects after successful authentication" do
      get "/admins/auth/google_oauth2/callback"
      expect(response).to redirect_to(root_path)
    end
  end
end
