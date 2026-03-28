##
# Model for Ideathon administrators.
# Handles authentication via Google OAuth and admin allowlist logic.
class Admin < ApplicationRecord
     # Use Devise for authentication, with Google OAuth2 as the provider
     devise :omniauthable, omniauth_providers: [ :google_oauth2 ]

     # Returns true if the email is in the allowed admin list (from ENV)
     def self.allowed_email?(email)
          return false if email.blank?
          list = ENV.fetch("ALLOWED_ADMIN_EMAILS", "").split(",").map(&:strip).reject(&:blank?)
          list.include?(email)
     end

     # Finds or creates an admin from Google OAuth data, if allowed
     def self.from_google(email:, full_name:, uid:, avatar_url:)
          return nil unless allowed_email?(email)
          admin = find_or_initialize_by(email: email)
          admin.assign_attributes(uid: uid, full_name: full_name, avatar_url: avatar_url)
          admin.save!
          admin
     end
end
2
