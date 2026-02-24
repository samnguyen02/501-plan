# frozen_string_literal: true

require "rails_helper"

# IdeathonController serves the public landing page at root (GET /).
# No sign-in required; it shows the event info and links to Register (attendees) and Login (admins).
RSpec.describe "Ideathon (public landing)", type: :request do
     describe "GET /" do
          it "returns success without authentication" do
               get root_path
               expect(response).to have_http_status(:ok)
          end
     end
end
