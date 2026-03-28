##
# Base controller for the application.
# Handles authentication, session security, and public page logic.
class ApplicationController < ActionController::Base
     include ManagerActionLogging
     # Require admin authentication for all pages except public ones
     before_action :authenticate_admin!, unless: :public_page?

     # Handle invalid authenticity token (CSRF error) by resetting session and redirecting
     rescue_from ActionController::InvalidAuthenticityToken do
          reset_session
          redirect_to new_admin_session_path, alert: "Your session expired or cookies were cleared. Please sign in again."
     end

  private

       # Determines if the current page is public (no admin required)
       # Public pages: ideathon#index, registered_attendees#new/create/show/success/teams_for_year
       def public_page?
            return true if controller_name == "ideathon" && action_name == "index"
            if controller_name == "registered_attendees"
                 return true if %w[new create show success teams_for_year].include?(action_name)
            end
            false
       end
end