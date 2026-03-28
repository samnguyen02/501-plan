##
# Controller for managing Ideathon events (admin only).
# Handles creation, editing, updating, and deletion of events for the active year.
class IdeathonEventsController < ApplicationController
     # Use the ideathon layout for all actions
     layout "ideathon"
     # Load the event for actions that require an existing record
     before_action :set_ideathon_event, only: %i[ edit update destroy ]

     # GET /ideathon_events/new
     # Show form to create a new event
     def new
          @ideathon_event = IdeathonEvent.new
     end

     # GET /ideathon_events/:id/edit
     # Show form to edit an existing event
     def edit; end

     # POST /ideathon_events
     # Create a new event for the active year
     def create
          @ideathon_event = IdeathonEvent.new(event_params)
          @ideathon_event.ideathon_year = IdeathonYear.find_by(is_active: true)
          if @ideathon_event.save
               redirect_to manager_index_path(tab: "events"), notice: "Event created."
          else
               render :new, status: :unprocessable_entity
          end
     end

     # PATCH/PUT /ideathon_events/:id
     # Update an existing event
     def update
          if @ideathon_event.update(event_params)
               redirect_to manager_index_path(tab: "events"), notice: "Event updated."
          else
               render :edit, status: :unprocessable_entity
          end
     end

     # DELETE /ideathon_events/:id
     # Delete an event (admin only)
     def destroy
          @ideathon_event.destroy
          respond_to do |format|
               format.turbo_stream { render turbo_stream: turbo_stream.remove("ideathon_event_#{@ideathon_event.id}") }
               format.html { redirect_to manager_index_path(tab: "events"), notice: "Event deleted." }
          end
     end

  private

       # Finds the event for actions that require an existing record
       def set_ideathon_event
            @ideathon_event = IdeathonEvent.find(params[:id])
       end

       # Strong parameters: only allow trusted fields from the form
       def event_params
            params.require(:ideathon_event).permit(:event_name, :event_description, :event_date, :event_time)
       end
end
