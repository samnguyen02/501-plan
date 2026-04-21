require "rails_helper"

RSpec.describe "Docs", type: :request do
     let(:admin) { Admin.create!(email: "admin@tamu.edu", full_name: "Admin", uid: "123") }

     before { sign_in admin, scope: :admin }

     describe "GET /UserDocumentation.pdf" do
          it "serves user documentation content" do
               get user_documentation_pdf_path

               expect(response).to have_http_status(:ok)
               expect(response.content_type).to include("text/markdown")
               expect(response.body).to include("TAMU Ideathon User Documentation")
          end
     end

     describe "GET /TechnicalDocumentation.pdf" do
          it "serves technical documentation content" do
               get technical_documentation_pdf_path

               expect(response).to have_http_status(:ok)
               expect(response.content_type).to include("text/markdown")
               expect(response.body).to include("TAMU Ideathon Technical Documentation")
          end
     end
end
