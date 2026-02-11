# frozen_string_literal: true

require "rails_helper"

if defined?(IdeathonRegistration)
  RSpec.describe IdeathonRegistration, type: :model do
    let(:admin) { Admin.create!(email: "admin@example.com", full_name: "Admin", uid: "123") }

    describe "associations" do
      it { is_expected.to belong_to(:admin) }
    end

    describe "validations" do
      it { is_expected.to validate_presence_of(:full_name) }
      it { is_expected.to validate_presence_of(:email) }
    end

    describe "TAMU-only email" do
      it "accepts @tamu.edu emails" do
        record = IdeathonRegistration.new(admin: admin, full_name: "Student", email: "student@tamu.edu")
        expect(record).to be_valid
      end

      it "rejects non-@tamu.edu emails" do
        record = IdeathonRegistration.new(admin: admin, full_name: "Other", email: "other@gmail.com")
        expect(record).not_to be_valid
        expect(record.errors[:email]).to be_any
      end
    end

    describe "status" do
      it "allows pending, approved, rejected" do
        %w[pending approved rejected].each do |status|
          record = IdeathonRegistration.new(admin: admin, full_name: "X", email: "x@tamu.edu", status: status)
          record.valid?
          expect(record.errors[:status]).to be_empty
        end
      end
    end

    describe "scopes" do
      it "responds to .pending" do
        expect(IdeathonRegistration).to respond_to(:pending)
      end
      it "responds to .approved" do
        expect(IdeathonRegistration).to respond_to(:approved)
      end
      it "responds to .rejected" do
        expect(IdeathonRegistration).to respond_to(:rejected)
      end
    end
  end
else
  RSpec.describe "IdeathonRegistration" do
    it "is implemented so model specs can run" do
      skip "Add IdeathonRegistration model and migration; then these specs will run and should pass"
    end
  end
end
