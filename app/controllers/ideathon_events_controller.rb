class IdeathonEventsController < ApplicationController
  before_action :set_ideathon_event, only: %i[ show edit update destroy ]

  # GET /ideathon_events or /ideathon_events.json
  def index
    @ideathon_events = IdeathonEvent.all
  end

  # GET /ideathon_events/1 or /ideathon_events/1.json
  def show
  end

  # GET /ideathon_events/new
  def new
    @ideathon_event = IdeathonEvent.new
  end

  # GET /ideathon_events/1/edit
  def edit
  end

  # POST /ideathon_events or /ideathon_events.json
  def create
    @ideathon_event = IdeathonEvent.new(ideathon_event_params)

    respond_to do |format|
      if @ideathon_event.save
        format.html { redirect_to @ideathon_event, notice: "Ideathon event was successfully created." }
        format.json { render :show, status: :created, location: @ideathon_event }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @ideathon_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ideathon_events/1 or /ideathon_events/1.json
  def update
    respond_to do |format|
      if @ideathon_event.update(ideathon_event_params)
        format.html { redirect_to @ideathon_event, notice: "Ideathon event was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @ideathon_event }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @ideathon_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ideathon_events/1 or /ideathon_events/1.json
  def destroy
    @ideathon_event.destroy!

    respond_to do |format|
      format.html { redirect_to ideathon_events_path, notice: "Ideathon event was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ideathon_event
      @ideathon_event = IdeathonEvent.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def ideathon_event_params
      params.expect(ideathon_event: [ :ideathon_year_id, :event_name, :event_description, :event_date, :event_time ])
    end
end
