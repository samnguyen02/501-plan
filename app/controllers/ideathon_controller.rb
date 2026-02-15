class IdeathonController < ApplicationController
     skip_before_action :authenticate_admin!, only: :index

     def index
          render layout: "ideathon"
     end
end
