##
# Model for Ideathon administrators.
# Handles authentication via Google OAuth and admin allowlist logic.
class Admin < ApplicationRecord
     # Use Devise for authentication, with Google OAuth2 as the provider
     devise :omniauthable, omniauth_providers: [ :google_oauth2 ]

     has_many :manager_action_logs, dependent: :nullify
     has_many :activity_logs, dependent: :nullify

     enum :role, { admin: "admin", editor: "editor", unauthorized: "unauthorized" }, prefix: :role
     validates :email, format: { with: /\A[^@\s]+@tamu\.edu\z/i, message: "must end with @tamu.edu" }, allow_blank: true

     # Only emails in the allowlist can sign in as admin.
     # Returns true if the email is in the allowed admin list (from ENV)
     def self.allowed_email?(email)
          normalized_email = email.to_s.strip.downcase
          return false if normalized_email.blank?

          # Accept comma, semicolon, or newline separated env values
          raw = ENV.fetch("ALLOWED_ADMIN_EMAILS", "")
          list = raw.split(/[,\n;]+/).map { |e| e.to_s.strip.downcase }.reject(&:blank?)
          list.include?(normalized_email)
     end

     # Finds or creates an admin from Google OAuth data, if allowed
     def self.from_google(email:, full_name:, uid:, avatar_url:)
          return nil unless allowed_email?(email)
          admin = find_or_initialize_by(email: email)
          admin.assign_attributes(uid: uid, full_name: full_name, avatar_url: avatar_url)
          admin.role = "editor" if admin.new_record?
          admin.save!
          admin
     end

     def authorized?
          !role_unauthorized?
     end
end
