# frozen_string_literal: true

require "rails_helper"

RSpec.describe "IdeathonEvents", type: :request do
     let(:ideathon_year) { IdeathonYear.create!(name: "2026", start_date: 1.week.from_now, end_date: 2.weeks.from_now, is_active: true) }
     let(:admin) { Admin.create!(email: "admin@example.com", full_name: "Admin", uid: "123") }
     let!(:event) do
          IdeathonEvent.create!(
            ideathon_year: ideathon_year,
            event_name: "Opening Ceremony",
            event_description: "Kickoff",
            event_date: Date.current,
            event_time: Time.current
          )
     end

     describe "GET /ideathon_events/new" do
          context "when signed in as admin" do
               before do
                    allow_any_instance_of(ApplicationController).to receive(:authenticate_admin!).and_return(true)
               end

               it "renders the new event form" do
                    get new_ideathon_event_path
                    expect(response).to have_http_status(:ok)
               end
          end
     end

     describe "POST /ideathon_events" do
          let(:valid_params) do
               {
                 ideathon_event: {
                   event_name: "Workshop",
                   event_description: "Technical workshop",
                   event_date: Date.current + 1.day,
                   event_time: Time.current.change(hour: 10, min: 0)
                 }
               }
          end

          let(:invalid_params) do
               {
                 ideathon_event: {
                   event_name: "",
                   event_description: "Missing name",
                   event_date: Date.current + 1.day,
                   event_time: Time.current.change(hour: 10, min: 0)
                 }
               }
          end

          before do
               allow_any_instance_of(ApplicationController).to receive(:authenticate_admin!).and_return(true)
          end

          it "creates an event tied to the active year and redirects to manager events tab" do
               expect { post ideathon_events_path, params: valid_params }.to change(IdeathonEvent, :count).by(1)
               created = IdeathonEvent.order(:created_at).last
               expect(created.ideathon_year).to eq(ideathon_year)
               expect(response).to redirect_to(manager_index_path(tab: "events"))
          end

          it "re-renders new on validation errors" do
               expect { post ideathon_events_path, params: invalid_params }.not_to change(IdeathonEvent, :count)
               expect(response).to have_http_status(422)
          end
     end

     describe "GET /ideathon_events/:id/edit" do
          before do
               allow_any_instance_of(ApplicationController).to receive(:authenticate_admin!).and_return(true)
          end

          it "renders the edit form" do
               get edit_ideathon_event_path(event)
               expect(response).to have_http_status(:ok)
          end
     end

     describe "PATCH /ideathon_events/:id" do
          before do
               allow_any_instance_of(ApplicationController).to receive(:authenticate_admin!).and_return(true)
          end

          it "updates the event and redirects back to manager events tab" do
               patch ideathon_event_path(event), params: {
                 ideathon_event: {
                   event_name: "Updated Name",
                   event_description: event.event_description,
                   event_date: event.event_date,
                   event_time: event.event_time
                 }
               }
               expect(response).to redirect_to(manager_index_path(tab: "events"))
               expect(event.reload.event_name).to eq("Updated Name")
          end

          it "re-renders edit on invalid update" do
               patch ideathon_event_path(event), params: {
                 ideathon_event: {
                   event_name: "",
                   event_description: event.event_description,
                   event_date: event.event_date,
                   event_time: event.event_time
                 }
               }
               expect(response).to have_http_status(422)
          end
     end

     describe "DELETE /ideathon_events/:id" do
          before do
               allow_any_instance_of(ApplicationController).to receive(:authenticate_admin!).and_return(true)
          end

          it "deletes the event and redirects to manager events tab (HTML)" do
               expect { delete ideathon_event_path(event) }.to change(IdeathonEvent, :count).by(-1)
               expect(response).to redirect_to(manager_index_path(tab: "events"))
          end
     end
end

