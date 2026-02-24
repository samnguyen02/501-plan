require "rails_helper"

RSpec.describe "Google OAuth sign-in (admin)", type: :system do
     before { OmniAuth.config.test_mode = true }
     after { OmniAuth.config.mock_auth[:google_oauth2] = nil }

     context "when user is not signed in" do
          it "shows home page with login and register options" do
               visit root_path
               expect(page).to have_content(/Login|Log in|Sign in|Register/i)
          end
     end

     context "when email is on the admin allowlist (pre-validated)" do
          before do
               @orig_allowlist = ENV["ALLOWED_ADMIN_EMAILS"]
               ENV["ALLOWED_ADMIN_EMAILS"] = "admin@example.com"
               mock_google_oauth2(email: "admin@example.com", full_name: "Admin User", uid: "123", avatar_url: "https://example.com/a.jpg")
               visit "/admins/auth/google_oauth2/callback"
          end

          after do
               if @orig_allowlist.nil?
                    ENV.delete("ALLOWED_ADMIN_EMAILS")
               else
                    ENV["ALLOWED_ADMIN_EMAILS"] = @orig_allowlist
               end
          end

          it "signs them in as admin and redirects to admin dashboard" do
               expect(Admin.find_by(email: "admin@example.com")).to be_present
               expect(page).to have_current_path(manager_index_path)
          end
     end

     context "when email is not on the admin allowlist" do
          before do
               @orig_allowlist = ENV["ALLOWED_ADMIN_EMAILS"]
               ENV["ALLOWED_ADMIN_EMAILS"] = "other@example.com"
               mock_google_oauth2(email: "user@gmail.com", full_name: "Regular User", uid: "456", avatar_url: nil)
               visit "/admins/auth/google_oauth2/callback"
          end

          after do
               if @orig_allowlist.nil?
                    ENV.delete("ALLOWED_ADMIN_EMAILS")
               else
                    ENV["ALLOWED_ADMIN_EMAILS"] = @orig_allowlist
               end
          end

          it "does not grant access and shows error about admin privileges" do
               expect(Admin.find_by(email: "user@gmail.com")).to be_nil
               expect(page).to have_content(/not authorized|authorized|admin/i)
          end
     end
end
