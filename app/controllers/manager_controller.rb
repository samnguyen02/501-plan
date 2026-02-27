class ManagerController < ApplicationController
     layout "ideathon"

     def index
          @sort = params[:sort] == "name" ? "name" : "team"

          @registered_attendees = if params[:query].present?
               RegisteredAttendee.search_by_name_or_team(params[:query])
          else
               RegisteredAttendee.all
          end

          @registered_attendees = @registered_attendees.sorted_by_team if @sort == "team"

          @teams_count = Team.where(unassigned: false).count

          active_year = IdeathonYear.find_by(is_active: true)
          @events = active_year ? IdeathonEvent.where(ideathon_year: active_year).order(event_date: :asc, event_time: :asc) : IdeathonEvent.none
     end

     def destroy
          @registered_attendee = RegisteredAttendee.find(params[:id])
          @registered_attendee.destroy

          respond_to do |format|
               format.turbo_stream { render turbo_stream: turbo_stream.remove("registered_attendee_#{@registered_attendee.id}") }
               format.html { redirect_to manager_index_path, notice: "Attendee removed." }
          end
     end
end
