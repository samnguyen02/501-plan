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
               log_manager_action(
                 action: "event.created",
                 record: @ideathon_event,
                 metadata: {
                   record_name: @ideathon_event.event_name,
                   event_name: @ideathon_event.event_name,
                   event_date: @ideathon_event.event_date,
                   event_time: @ideathon_event.event_time
                 }
               )
               redirect_to manager_index_path(tab: "events"), notice: "Event created."
          else
               render :new, status: :unprocessable_entity
          end
     end

     def update
          if @ideathon_event.update(event_params)
               changes = @ideathon_event.saved_changes.slice("event_name", "event_description", "event_date", "event_time")
               log_manager_action(
                 action: "event.updated",
                 record: @ideathon_event,
                 metadata: {
                   record_name: @ideathon_event.event_name,
                   changes: changes
                 }
               )
               redirect_to manager_index_path(tab: "events"), notice: "Event updated."
          else
               render :edit, status: :unprocessable_entity
          end
     end

     def destroy
          @ideathon_event.destroy
          log_manager_action(
            action: "event.deleted",
            record: @ideathon_event,
            metadata: {
              record_name: @ideathon_event.event_name,
              event_name: @ideathon_event.event_name,
              event_date: @ideathon_event.event_date,
              event_time: @ideathon_event.event_time
            }
          )
          respond_to do |format|
               format.turbo_stream do
                    action_logs = ManagerActionLog.includes(:admin).recent_first.limit(200)
                    render turbo_stream: [
                      turbo_stream.remove("ideathon_event_#{@ideathon_event.id}"),
                      turbo_stream.replace("action_logs", partial: "manager/action_logs", locals: { action_logs: action_logs })
                    ]
               end
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
