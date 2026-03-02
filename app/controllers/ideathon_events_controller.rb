class IdeathonEventsController < ApplicationController
     layout "ideathon"
     before_action :set_ideathon_event, only: %i[ edit update destroy ]

     def new
          @ideathon_event = IdeathonEvent.new
     end

     def edit; end

     def create
          @ideathon_event = IdeathonEvent.new(event_params)
          @ideathon_event.ideathon_year = IdeathonYear.find_by(is_active: true)
          if @ideathon_event.save
               redirect_to manager_index_path(tab: "events"), notice: "Event created."
          else
               render :new, status: :unprocessable_entity
          end
     end

     def update
          if @ideathon_event.update(event_params)
               redirect_to manager_index_path(tab: "events"), notice: "Event updated."
          else
               render :edit, status: :unprocessable_entity
          end
     end

     def destroy
          @ideathon_event.destroy
          respond_to do |format|
               format.turbo_stream { render turbo_stream: turbo_stream.remove("ideathon_event_#{@ideathon_event.id}") }
               format.html { redirect_to manager_index_path(tab: "events"), notice: "Event deleted." }
          end
     end

  private

       def set_ideathon_event
            @ideathon_event = IdeathonEvent.find(params[:id])
       end

       def event_params
            params.require(:ideathon_event).permit(:event_name, :event_description, :event_date, :event_time)
       end
end
