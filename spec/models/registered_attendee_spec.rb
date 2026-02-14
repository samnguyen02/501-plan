# frozen_string_literal: true

require "rails_helper"

RSpec.describe RegisteredAttendee, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:ideathon_year) }
    it { is_expected.to belong_to(:team).optional }
  end

  describe "validations" do
    let(:ideathon_year) { IdeathonYear.create!(name: "2026", start_date: 1.week.from_now, end_date: 2.weeks.from_now) }
    let(:team) { Team.create!(ideathon_year: ideathon_year, team_name: "Team A", unassigned: false) }

    it "validates presence of ideathon_year_id, attendee_name, attendee_phone, attendee_email, attendee_major, attendee_class" do
      attendee = RegisteredAttendee.new(ideathon_year: ideathon_year, team: team)
      expect(attendee).not_to be_valid
      expect(attendee.errors[:attendee_name]).to include("can't be blank")
      expect(attendee.errors[:attendee_phone]).to include("can't be blank")
      expect(attendee.errors[:attendee_email]).to include("can't be blank")
      expect(attendee.errors[:attendee_major]).to include("can't be blank")
      expect(attendee.errors[:attendee_class]).to include("can't be blank")
    end

    it "is valid with all required attributes" do
      attendee = RegisteredAttendee.new(
        ideathon_year: ideathon_year,
        team: team,
        attendee_name: "Jane",
        attendee_phone: "979-555-1234",
        attendee_email: "jane@example.com",
        attendee_major: "CS",
        attendee_class: "Senior"
      )
      expect(attendee).to be_valid
    end
  end

  describe "email acceptance" do
    let(:ideathon_year) { IdeathonYear.create!(name: "2026", start_date: 1.week.from_now, end_date: 2.weeks.from_now) }
    let(:team) { Team.create!(ideathon_year: ideathon_year, team_name: "Team A", unassigned: false) }

    it "accepts any email (no TAMU restriction)" do
      attendee = RegisteredAttendee.new(
        ideathon_year: ideathon_year,
        team: team,
        attendee_name: "Jane",
        attendee_phone: "979-555-1234",
        attendee_email: "jane@gmail.com",
        attendee_major: "CS",
        attendee_class: "Senior"
      )
      expect(attendee).to be_valid
    end

    it "accepts TAMU emails" do
      attendee = RegisteredAttendee.new(
        ideathon_year: ideathon_year,
        team: team,
        attendee_name: "Bob",
        attendee_phone: "979-555-5678",
        attendee_email: "bob@tamu.edu",
        attendee_major: "EE",
        attendee_class: "Junior"
      )
      expect(attendee).to be_valid
    end
  end
end
