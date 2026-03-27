# frozen_string_literal: true

require "rails_helper"

RSpec.describe "IdeathonEvents", type: :request do
  let(:admin) { Admin.create!(email: "admin@example.com", full_name: "Admin", uid: "123") }
  let!(:ideathon_year) do
    IdeathonYear.create!(name: "2026", start_date: 1.week.from_now, end_date: 2.weeks.from_now, is_active: true)
  end

  describe "POST /ideathon_events" do
    before { sign_in admin, scope: :admin }

    it "creates an event and writes a log entry" do
      expect do
        post ideathon_events_path, params: {
          ideathon_event: {
            event_name: "Check-in",
            event_description: "Doors open",
            event_date: Date.current,
            event_time: "09:00"
          }
        }
      end.to change(IdeathonEvent, :count).by(1)
         .and change(ManagerActionLog, :count).by(1)

      expect(response).to redirect_to(manager_index_path(tab: "events"))
      expect(ManagerActionLog.last.action).to eq("event.created")
    end

    it "accepts blank event_name and still redirects (current behavior)" do
      post ideathon_events_path, params: {
        ideathon_event: {
          event_name: "",
          event_description: "Desc",
          event_date: Date.current,
          event_time: "09:00"
        }
      }

      expect(response).to redirect_to(manager_index_path(tab: "events"))
      expect(ManagerActionLog.last.action).to eq("event.created")
    end
  end

  describe "PATCH /ideathon_events/:id" do
    before { sign_in admin, scope: :admin }

    let!(:event) do
      IdeathonEvent.create!(
        ideathon_year: ideathon_year,
        event_name: "Old Name",
        event_description: "Old Description",
        event_date: Date.current,
        event_time: "09:00"
      )
    end

    it "updates an event and writes an update log" do
      expect do
        patch ideathon_event_path(event), params: {
          ideathon_event: {
            event_name: "New Name",
            event_description: "New Description",
            event_date: Date.current + 1.day,
            event_time: "10:00"
          }
        }
      end.to change(ManagerActionLog, :count).by(1)

      expect(response).to redirect_to(manager_index_path(tab: "events"))
      expect(ManagerActionLog.last.action).to eq("event.updated")
    end

    it "accepts blank event_name on update and redirects (current behavior)" do
      patch ideathon_event_path(event), params: {
        ideathon_event: {
          event_name: "",
          event_description: "No title",
          event_date: Date.current,
          event_time: "09:00"
        }
      }

      expect(response).to redirect_to(manager_index_path(tab: "events"))
      expect(ManagerActionLog.last.action).to eq("event.updated")
    end
  end

  describe "DELETE /ideathon_events/:id" do
    before { sign_in admin, scope: :admin }

    let!(:event) do
      IdeathonEvent.create!(
        ideathon_year: ideathon_year,
        event_name: "To Delete",
        event_description: "bye",
        event_date: Date.current,
        event_time: "09:00"
      )
    end

    it "deletes an event and writes a delete log" do
      expect do
        delete ideathon_event_path(event)
      end.to change(IdeathonEvent, :count).by(-1)
         .and change(ManagerActionLog, :count).by(1)

      expect(response).to redirect_to(manager_index_path(tab: "events"))
      expect(ManagerActionLog.last.action).to eq("event.deleted")
    end
  end
end

