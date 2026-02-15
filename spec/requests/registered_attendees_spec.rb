# frozen_string_literal: true

require "rails_helper"

RSpec.describe "RegisteredAttendees", type: :request do
     let(:ideathon_year) { IdeathonYear.create!(name: "2026", start_date: 1.week.from_now, end_date: 2.weeks.from_now) }
     let(:unassigned_team) { Team.create!(ideathon_year: ideathon_year, team_name: "Unassigned", unassigned: true) }
     let(:admin) { Admin.create!(email: "admin@tamu.edu", full_name: "Admin", uid: "123") }

     before { unassigned_team }

     describe "GET /registered_attendees/new" do
          it "returns success (public page)" do
               get new_registered_attendee_path
               expect(response).to have_http_status(:ok)
          end
     end

     describe "GET /registered_attendees/success" do
          it "returns success (public page)" do
               get success_registered_attendees_path
               expect(response).to have_http_status(:ok)
               expect(response.body).to include("Registration successful")
          end
     end

     describe "GET /registered_attendees/teams_for_year" do
          it "returns empty array when year_id is blank" do
               get teams_for_year_registered_attendees_path, params: { year_id: "" }
               expect(response).to have_http_status(:ok)
               expect(JSON.parse(response.body)).to eq([])
          end

          it "returns teams for the given year" do
               get teams_for_year_registered_attendees_path, params: { year_id: ideathon_year.id }
               expect(response).to have_http_status(:ok)
               data = JSON.parse(response.body)
               expect(data).to be_an(Array)
               expect(data.size).to eq(1)
               expect(data.first["name"]).to eq("Unassigned")
               expect(data.first["id"]).to eq(unassigned_team.id)
          end
     end

     describe "POST /registered_attendees" do
          let(:valid_params) do
               {
                 registered_attendee: {
                   ideathon_year_id: ideathon_year.id,
                   attendee_name: "Jane Doe",
                   attendee_phone: "979-555-1234",
                   attendee_email: "jane@gmail.com",
                   attendee_major: "CS",
                   attendee_class: "Senior"
                 },
                 team_choice: "unassigned"
               }
          end

          it "creates an attendee and redirects to success page (any email allowed)" do
               expect {
                    post registered_attendees_path, params: valid_params
               }.to change(RegisteredAttendee, :count).by(1)
               expect(response).to redirect_to(success_registered_attendees_path)
               expect(RegisteredAttendee.last.attendee_email).to eq("jane@gmail.com")
          end

          it "accepts non-TAMU email" do
               post registered_attendees_path, params: valid_params
               expect(response).to redirect_to(success_registered_attendees_path)
               expect(RegisteredAttendee.last.attendee_email).to eq("jane@gmail.com")
          end

          context "with invalid params (missing year)" do
               let(:invalid_params) do
                    {
                      registered_attendee: {
                        ideathon_year_id: nil,
                        attendee_name: "Jane",
                        attendee_phone: "979-555-1234",
                        attendee_email: "jane@example.com",
                        attendee_major: "CS",
                        attendee_class: "Senior"
                      },
                      team_choice: "unassigned"
                    }
               end

               it "re-renders new and does not create" do
                    expect { post registered_attendees_path, params: invalid_params }.not_to change(RegisteredAttendee, :count)
                    expect(response).to have_http_status(:unprocessable_entity)
               end
          end
     end

     describe "GET /registered_attendees (index)" do
          it "redirects to sign-in when not authenticated" do
               get registered_attendees_path
               expect(response).to redirect_to(new_admin_session_path)
          end

          context "when signed in as admin" do
               before { sign_in admin }

               it "returns success" do
                    get registered_attendees_path
                    expect(response).to have_http_status(:ok)
               end
          end
     end

     describe "GET /registered_attendees/:id (show)" do
          let(:attendee) do
               RegisteredAttendee.create!(
                 ideathon_year: ideathon_year,
                 team: unassigned_team,
                 attendee_name: "Jane",
                 attendee_phone: "979-555-1234",
                 attendee_email: "jane@example.com",
                 attendee_major: "CS",
                 attendee_class: "Senior"
               )
          end

          it "returns success (public show)" do
               get registered_attendee_path(attendee)
               expect(response).to have_http_status(:ok)
          end
     end

     describe "edit, update, destroy (admin only)" do
          let(:attendee) do
               RegisteredAttendee.create!(
                 ideathon_year: ideathon_year,
                 team: unassigned_team,
                 attendee_name: "Jane",
                 attendee_phone: "979-555-1234",
                 attendee_email: "jane@example.com",
                 attendee_major: "CS",
                 attendee_class: "Senior"
               )
          end

          it "edit redirects to sign-in when not authenticated" do
               get edit_registered_attendee_path(attendee)
               expect(response).to redirect_to(new_admin_session_path)
          end

          it "update redirects to sign-in when not authenticated" do
               patch registered_attendee_path(attendee), params: { registered_attendee: { attendee_name: "Updated" } }
               expect(response).to redirect_to(new_admin_session_path)
          end

          it "destroy redirects to sign-in when not authenticated" do
               delete registered_attendee_path(attendee)
               expect(response).to redirect_to(new_admin_session_path)
          end

          context "when signed in as admin" do
               before { sign_in admin }

               it "update succeeds and redirects to show" do
                    patch registered_attendee_path(attendee), params: {
                      registered_attendee: {
                        ideathon_year_id: ideathon_year.id,
                        attendee_name: "Jane Updated",
                        attendee_phone: attendee.attendee_phone,
                        attendee_email: attendee.attendee_email,
                        attendee_major: attendee.attendee_major,
                        attendee_class: attendee.attendee_class
                      },
                      team_choice: "unassigned"
                    }
                    expect(response).to redirect_to(registered_attendee_path(attendee))
                    expect(attendee.reload.attendee_name).to eq("Jane Updated")
               end

               it "destroy deletes and redirects to index" do
                    delete registered_attendee_path(attendee)
                    expect(response).to redirect_to(registered_attendees_path)
                    expect(RegisteredAttendee.find_by(id: attendee.id)).to be_nil
               end
          end
     end
end
