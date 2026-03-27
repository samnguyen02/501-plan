class RegisteredAttendeesController < ApplicationController
     skip_before_action :authenticate_admin!, only: %i[new create show success teams_for_year]
     before_action :set_registered_attendee, only: %i[show edit update destroy]
     before_action :set_active_year, only: %i[new create edit update]
     before_action :load_teams, only: %i[new create edit update]
     layout "ideathon", only: %i[new create success edit update]

  # GET /registered_attendees
     def index
          @registered_attendees = RegisteredAttendee.all
     end

  # GET /registered_attendees/1
     def show; end

  # GET /registered_attendees/new
     def new
          @registered_attendee = RegisteredAttendee.new
          @registered_attendee.ideathon_year = @active_year
          load_teams
     end

  # GET /registered_attendees/1/edit
     def edit; end

  # GET /registered_attendees/success
     def success; end

  # POST /registered_attendees
     def create
          @registered_attendee = RegisteredAttendee.new(registered_attendee_params)
          @registered_attendee.ideathon_year = @active_year

          apply_team_selection!(@registered_attendee, enforce_limit: true)

          respond_to do |format|
               if @registered_attendee.errors.any?
                    load_teams
                    format.html { render :new, status: :unprocessable_entity }
                    format.json { render json: @registered_attendee.errors, status: :unprocessable_entity }
               elsif @registered_attendee.save
                    if admin_signed_in? && params[:return_to] == "manager"
                         log_manager_action(
                           action: "attendee.created",
                           record: @registered_attendee,
                           metadata: { record_name: @registered_attendee.attendee_name, attendee_email: @registered_attendee.attendee_email, source: "manager" }
                         )
                    end
                    format.html { redirect_to params[:return_to] == "manager" ? manager_index_path : success_registered_attendees_path, status: :see_other }
                    format.json { render :show, status: :created, location: @registered_attendee }
               else
                    load_teams
                    format.html { render :new, status: :unprocessable_entity }
                    format.json { render json: @registered_attendee.errors, status: :unprocessable_entity }
               end
          end
     end

  # PATCH/PUT /registered_attendees/1
     def update
          @registered_attendee.assign_attributes(registered_attendee_params)
          apply_team_selection!(@registered_attendee)

          respond_to do |format|
               if @registered_attendee.errors.any?
                    load_teams
                    format.html { render :edit, status: :unprocessable_entity }
                    format.json { render json: @registered_attendee.errors, status: :unprocessable_entity }
               elsif @registered_attendee.save
                    changes = @registered_attendee.saved_changes.slice(
                      "attendee_name",
                      "attendee_phone",
                      "attendee_email",
                      "attendee_major",
                      "attendee_class",
                      "team_id"
                    )
                    log_manager_action(
                      action: "attendee.updated",
                      record: @registered_attendee,
                      metadata: { record_name: @registered_attendee.attendee_name, changes: changes }
                    )
                    format.html { redirect_to manager_index_path, notice: "Attendee updated successfully.", status: :see_other }
                    format.json { render :show, status: :ok, location: @registered_attendee }
               else
                    load_teams
                    format.html { render :edit, status: :unprocessable_entity }
                    format.json { render json: @registered_attendee.errors, status: :unprocessable_entity }
               end
          end
     end

  # DELETE /registered_attendees/1
     def destroy
          @registered_attendee.destroy!
          log_manager_action(
            action: "attendee.deleted",
            record: @registered_attendee,
            metadata: { record_name: @registered_attendee.attendee_name, attendee_email: @registered_attendee.attendee_email }
          )
          respond_to do |format|
               format.html { redirect_to registered_attendees_path, notice: "Registered attendee was successfully destroyed.", status: :see_other }
               format.json { head :no_content }
          end
     end

  # GET /registered_attendees/teams_for_year.json
     def teams_for_year
          year_id = params[:year_id]
          if year_id.blank?
               render json: []
               return
          end

          teams = Team.where(ideathon_year_id: year_id).order(:unassigned, :team_name)
          team_list = teams.map do |team|
               member_count = team.registered_attendees.count
               {
                 id: team.id,
                 name: team.team_name,
                 member_count: member_count,
                 unassigned: team.unassigned
               }
          end
          render json: team_list
     end

  private

       def set_registered_attendee
            @registered_attendee = RegisteredAttendee.find(params[:id])
       end

       def active_year
            IdeathonYear.find_by(is_active: true) ||
              IdeathonYear.order(start_date: :desc, created_at: :desc).first ||
              IdeathonYear.create!(
                name: Time.zone.today.year.to_s,
                start_date: Time.zone.today,
                end_date: Time.zone.today + 1.day,
                is_active: true,
                description: "Auto-generated default year"
              )
       end

       def set_active_year
            @active_year = active_year
       end

  # Teams list for the active year (used by the form)
       def load_teams
            @teams = Team.where(ideathon_year: @active_year).order(:unassigned, :team_name)
       end

       def registered_attendee_params
            params.require(:registered_attendee).permit(
              :ideathon_year_id,
              :attendee_name,
              :attendee_phone,
              :attendee_email,
              :attendee_major,
              :attendee_class
              # IMPORTANT: we do NOT trust :team_id from the form anymore;
              # we set it ourselves in apply_team_selection!
            )
       end

  # Works with the radio form:
  # params[:team_choice] = "existing" | "unassigned" | "new"
  # params[:existing_team_id] = team id (string)
  # params[:new_team_name] = name (string)
       def apply_team_selection!(attendee, enforce_limit: false)
         # year must be selected first
            if attendee.ideathon_year_id.blank?
                 attendee.errors.add(:ideathon_year_id, "must be selected")
                 return
            end

            team_choice = params[:team_choice].to_s
            existing_team_id = params[:existing_team_id].to_s
            new_team_name = params[:new_team_name].to_s.strip

            case team_choice
            when "existing"
                 if existing_team_id.blank?
                      attendee.errors.add(:base, "Please select an existing team.")
                      return
                 end

                 team = Team.find_by(id: existing_team_id.to_i, ideathon_year_id: attendee.ideathon_year_id)
                 if team.nil?
                      attendee.errors.add(:base, "Selected team is invalid for this year.")
                      return
                 end

                 if enforce_limit && team.registered_attendees.count >= 4
                      attendee.errors.add(:base, "That team is already full (max 4 members).")
                      return
                 end

                 attendee.team_id = team.id

            when "new"
                 if new_team_name.blank?
                      attendee.errors.add(:base, "Please enter a new team name.")
                      return
                 end

                 team = Team.new(
                   ideathon_year_id: attendee.ideathon_year_id,
                   team_name: new_team_name,
                   unassigned: false
                 )

                 unless team.save
                      team.errors.full_messages.each do |msg|
                           # Make error messages more user-friendly
                           friendly_msg = msg.include?("already exists") ? "Team name \"#{new_team_name}\" already exists" : msg
                           attendee.errors.add(:base, friendly_msg)
                      end
                      return
                 end

                 attendee.team_id = team.id

            else
              # default to unassigned if not chosen / unassigned radio
                 begin
                      unassigned = Team.find_or_create_by!(ideathon_year_id: attendee.ideathon_year_id, unassigned: true) do |t|
                           t.team_name = "Unassigned"
                      end
                      attendee.team_id = unassigned.id
                 rescue => e
                      attendee.errors.add(:base, "Unable to create or find unassigned team. Please contact support.")
                      nil
                 end
            end
       end
end
