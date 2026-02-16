class IdeathonYearsController < ApplicationController
     before_action :set_ideathon_year, only: %i[ show edit update destroy ]

     # GET /ideathon_years or /ideathon_years.json
     def index
          @ideathon_years = IdeathonYear.all
     end

     # GET /ideathon_years/1 or /ideathon_years/1.json
     def show
     end

     # GET /ideathon_years/new
     def new
          @ideathon_year = IdeathonYear.new
     end

     # GET /ideathon_years/1/edit
     def edit
     end

     # POST /ideathon_years or /ideathon_years.json
     def create
          @ideathon_year = IdeathonYear.new(ideathon_year_params)

          respond_to do |format|
               if @ideathon_year.save
                    format.html { redirect_to @ideathon_year, notice: "Ideathon year was successfully created." }
                    format.json { render :show, status: :created, location: @ideathon_year }
               else
                    format.html { render :new, status: :unprocessable_entity }
                    format.json { render json: @ideathon_year.errors, status: :unprocessable_entity }
               end
          end
     end

     # PATCH/PUT /ideathon_years/1 or /ideathon_years/1.json
     def update
          respond_to do |format|
               if @ideathon_year.update(ideathon_year_params)
                    format.html { redirect_to @ideathon_year, notice: "Ideathon year was successfully updated.", status: :see_other }
                    format.json { render :show, status: :ok, location: @ideathon_year }
               else
                    format.html { render :edit, status: :unprocessable_entity }
                    format.json { render json: @ideathon_year.errors, status: :unprocessable_entity }
               end
          end
     end

     # DELETE /ideathon_years/1 or /ideathon_years/1.json
     def destroy
          @ideathon_year.destroy!

          respond_to do |format|
               format.html { redirect_to ideathon_years_path, notice: "Ideathon year was successfully destroyed.", status: :see_other }
               format.json { head :no_content }
          end
     end

  private
       # Use callbacks to share common setup or constraints between actions.
       def set_ideathon_year
            @ideathon_year = IdeathonYear.find(params.expect(:id))
       end

       # Only allow a list of trusted parameters through.
       def ideathon_year_params
            params.expect(ideathon_year: [ :name, :description, :location, :start_date, :end_date, :is_active ])
       end
end
