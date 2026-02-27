class ApplicationController < ActionController::Base
     before_action :authenticate_admin!, unless: :public_page?

     rescue_from ActionController::InvalidAuthenticityToken do
          reset_session
          redirect_to new_admin_session_path, alert: "Your session expired or cookies were cleared. Please sign in again."
     end

  private

       def public_page?
            return true if controller_name == "ideathon" && action_name == "index"
            if controller_name == "registered_attendees"
                 return true if %w[new create show success teams_for_year].include?(action_name)
            end
            false
       end
end