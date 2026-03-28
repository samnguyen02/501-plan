require "csv"

class ManagerController < ApplicationController
     layout "ideathon"

     def index
          @sort = params[:sort] == "name" ? "name" : "team"

          @registered_attendees = base_scope
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

     def view_pdf
          pdf_path = Rails.root.join("private", "documents", "document.pdf")
          send_file pdf_path, type: "application/pdf", disposition: "inline"
     end

     def export_participants
          attendees = base_scope.includes(:team, :ideathon_year)

          csv = CSV.generate(headers: true) do |rows|
               rows << [ "Name", "Email", "Phone", "Major", "Class", "Team", "Year" ]
               attendees.find_each do |a|
                    rows << [
                      a.attendee_name,
                      a.attendee_email,
                      a.attendee_phone,
                      a.attendee_major,
                      a.attendee_class,
                      a.team&.team_name,
                      a.ideathon_year&.name
                    ]
               end
          end

          send_data csv, filename: "participants-#{Time.zone.today}.csv", type: "text/csv; charset=utf-8"
     end

     def export_teams
          attendees = base_scope.includes(:team, :ideathon_year)
          grouped = attendees.group_by { |a| a.team&.team_name || "Unassigned" }

          csv = CSV.generate(headers: true) do |rows|
               rows << [ "Team", "Year", "Member Name", "Email", "Major", "Class" ]
               grouped.each do |team_name, members|
                    members.each do |m|
                         rows << [
                           team_name,
                           m.ideathon_year&.name,
                           m.attendee_name,
                           m.attendee_email,
                           m.attendee_major,
                           m.attendee_class
                         ]
                    end
               end
          end

          send_data csv, filename: "teams-#{Time.zone.today}.csv", type: "text/csv; charset=utf-8"
     end

  private

       def base_scope
            sort = params[:sort] == "name" ? "name" : "team"

            scope = if params[:query].present?
                 RegisteredAttendee.search_by_name_or_team(params[:query])
            else
                 RegisteredAttendee.all
            end

            scope = scope.sorted_by_team if sort == "team"
            scope
       end
end
