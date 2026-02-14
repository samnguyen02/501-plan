class ApplicationController < ActionController::Base
  before_action :authenticate_admin!, unless: :public_page?

  private

  def public_page?
    return true if controller_name == "ideathon" && action_name == "index"
    if controller_name == "registered_attendees"
      return true if %w[new create show success teams_for_year].include?(action_name)
    end
    false
  end
end