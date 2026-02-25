# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Manager", type: :request do
  let(:ideathon_year) { IdeathonYear.create!(name: "2026", start_date: 1.week.from_now, end_date: 2.weeks.from_now, is_active: true) }
  let(:team) { Team.create!(ideathon_year: ideathon_year, team_name: "Team A", unassigned: false) }
  let(:admin) { Admin.create!(email: "admin@example.com", full_name: "Admin", uid: "123") }
  let!(:attendee) do
    RegisteredAttendee.create!(
      ideathon_year: ideathon_year,
      team: team,
      attendee_name: "Jane Doe",
      attendee_phone: "979-555-1234",
      attendee_email: "jane@example.com",
      attendee_major: "CS",
      attendee_class: "Senior"
    )
  end

  describe "GET /manager" do
    context "when not authenticated" do
      it "redirects to sign-in" do
        get manager_index_path
        expect(response).to redirect_to(new_admin_session_path)
      end
    end

    context "when signed in as admin" do
      before { sign_in admin }

      it "returns success" do
        get manager_index_path
        expect(response).to have_http_status(:ok)
      end

      it "sorts by name by default" do
        get manager_index_path
        expect(response).to have_http_status(:ok)
      end

      it "sorts by team when sort=team" do
        get manager_index_path, params: { sort: "team" }
        expect(response).to have_http_status(:ok)
      end

      it "filters by query when query present" do
        get manager_index_path, params: { query: "Jane" }
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "DELETE /manager/:id" do
    before { sign_in admin }

    it "removes attendee and redirects to manager index" do
      expect { delete manager_path(attendee) }.to change(RegisteredAttendee, :count).by(-1)
      expect(response).to redirect_to(manager_index_path)
      follow_redirect!
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /manager/export_participants" do
    before { sign_in admin }

    it "returns CSV for participants" do
      get export_participants_manager_index_path(format: :csv)
      expect(response).to have_http_status(:ok)
      expect(response.media_type).to include("text/csv")
      expect(response.body).to include("Name,Email,Phone,Major,Class,Team,Year")
      expect(response.body).to include("Jane Doe")
    end
  end

  describe "GET /manager/export_teams" do
    before { sign_in admin }

    it "returns CSV for teams" do
      get export_teams_manager_index_path(format: :csv)
      expect(response).to have_http_status(:ok)
      expect(response.media_type).to include("text/csv")
      expect(response.body).to include("Team,Year,Member Name,Email,Major,Class")
      expect(response.body).to include("Team A")
      expect(response.body).to include("Jane Doe")
    end
  end
end
