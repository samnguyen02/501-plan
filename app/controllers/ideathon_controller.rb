##
# Controller for the public Ideathon landing page.
# Shows the current active year and its events.
class IdeathonController < ApplicationController
     # Allow public access to the index page (no admin required)
     skip_before_action :authenticate_admin!, only: :index

     # GET /ideathon
     # Shows the main Ideathon page with the active year and its events
     def index
          @ideathon_year = IdeathonYear.find_by(is_active: true)
          @events = @ideathon_year&.ideathon_events&.order(:event_date, :event_time) || []
          render layout: "ideathon"
     end
end
