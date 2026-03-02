class IdeathonController < ApplicationController
     skip_before_action :authenticate_admin!, only: :index

     def index
          @ideathon_year = IdeathonYear.find_by(is_active: true)
          @events = @ideathon_year&.ideathon_events&.order(:event_date, :event_time) || []
          render layout: "ideathon"
     end
end
