class Admin < ApplicationRecord
     devise :omniauthable, omniauth_providers: [ :google_oauth2 ]

     # Only emails in the allowlist can sign in as admin. Set ALLOWED_ADMIN_EMAILS (comma-separated) in env.
     def self.allowed_email?(email)
          return false if email.blank?
          list = ENV.fetch("ALLOWED_ADMIN_EMAILS", "").split(",").map(&:strip).reject(&:blank?)
          list.include?(email)
     end

     def self.from_google(email:, full_name:, uid:, avatar_url:)
          return nil unless allowed_email?(email)
          create_with(uid: uid, full_name: full_name, avatar_url: avatar_url).find_or_create_by!(email: email)
     end
end
