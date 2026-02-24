class Admin < ApplicationRecord
  devise :omniauthable, omniauth_providers: [ :google_oauth2 ]

  # Only emails in the allowlist can sign in as admin.
  def self.allowed_email?(email)
    return false if email.blank?
    list = ENV.fetch("ALLOWED_ADMIN_EMAILS", "").split(",").map(&:strip).reject(&:blank?)
    list.include?(email)
  end

  def self.from_google(email:, full_name:, uid:, avatar_url:)
    return nil unless allowed_email?(email)
    admin = find_or_initialize_by(email: email)
    admin.assign_attributes(uid: uid, full_name: full_name, avatar_url: avatar_url)
    admin.save!
    admin
  end
end
2