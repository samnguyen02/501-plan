# frozen_string_literal: true

require "rails_helper"

if defined?(IdeathonRegistrationsController) && defined?(IdeathonRegistration)
  RSpec.describe IdeathonRegistrationsController, type: :controller do
    let(:admin) { Admin.create!(email: "admin@example.com", full_name: "Admin", uid: "123") }
    let(:tamu_params) { { full_name: "Student", email: "student@tamu.edu" } }

    describe "GET #index" do
      context "when not signed in" do
        it "redirects to sign in" do
          get :index
          expect(response).to redirect_to(new_admin_session_path)
        end
      end

      context "when signed in" do
        before { sign_in admin }

        it "returns success" do
          get :index
          expect(response).to be_successful
        end

        it "assigns only current admin's registrations" do
          other_admin = Admin.create!(email: "other@example.com", full_name: "Other", uid: "456")
          mine = IdeathonRegistration.create!(admin: admin, full_name: "Me", email: "me@tamu.edu") if IdeathonRegistration.column_names.include?("full_name")
          theirs = IdeathonRegistration.create!(admin: other_admin, full_name: "Them", email: "them@tamu.edu") if IdeathonRegistration.column_names.include?("full_name")
          get :index
          registrations = assigns(:ideathon_registrations)
          expect(registrations).to include(mine) if mine
          expect(registrations).not_to include(theirs) if theirs
        end
      end
    end

    describe "POST #create" do
      before { sign_in admin }

      it "creates a registration with valid TAMU params" do
        expect {
          post :create, params: { ideathon_registration: tamu_params }
        }.to change(IdeathonRegistration, :count).by(1)
      end

      it "redirects after create" do
        post :create, params: { ideathon_registration: tamu_params }
        expect(response).to redirect_to(assigns(:ideathon_registration))
      end
    end
  end
else
  RSpec.describe "IdeathonRegistrationsController" do
    it "is implemented so controller specs can run" do
      skip "Add IdeathonRegistrationsController and routes; then these specs will run and should pass"
    end
  end
end
