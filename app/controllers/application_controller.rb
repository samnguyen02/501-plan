class ApplicationController < ActionController::Base
  before_action :authenticate_admin!, unless: :public_page?

  private

  def public_page?
    controller_name == "registered_attendees" && %w[new create].include?(action_name)
  end
end