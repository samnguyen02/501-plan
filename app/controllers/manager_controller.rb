class ManagerController < ApplicationController
  layout "ideathon"

  def index
    @attendees = if params[:query].present?
                   Attendee.search_by_name(params[:query])
                 else
                   Attendee.all
                 end
  end

  def destroy
    @attendee = Attendee.find(params[:id])
    @attendee.destroy

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove("attendee_#{@attendee.id}") }
      format.html { redirect_to manager_index_path, notice: "Attendee removed." }
    end
  end
end
