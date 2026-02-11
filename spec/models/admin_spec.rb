require "rails_helper"

RSpec.describe Admin, type: :model do
  describe ".from_google" do
    let(:email) { "test@example.com" }
    let(:full_name) { "Test User" }
    let(:uid) { "123456789" }
    let(:avatar_url) { "https://example.com/avatar.jpg" }

    context "when admin does not exist" do
      it "creates a new admin" do
        expect {
          Admin.from_google(email: email, full_name: full_name, uid: uid, avatar_url: avatar_url)
        }.to change(Admin, :count).by(1)
      end

      it "sets the correct attributes" do
        admin = Admin.from_google(email: email, full_name: full_name, uid: uid, avatar_url: avatar_url)
        expect(admin.email).to eq(email)
        expect(admin.full_name).to eq(full_name)
        expect(admin.uid).to eq(uid)
        expect(admin.avatar_url).to eq(avatar_url)
      end
    end

    context "when admin already exists" do
      let!(:existing_admin) do
        Admin.create!(email: email, full_name: "Old Name", uid: "old_uid", avatar_url: "old_url")
      end

      it "does not create a new admin" do
        expect {
          Admin.from_google(email: email, full_name: full_name, uid: uid, avatar_url: avatar_url)
        }.not_to change(Admin, :count)
      end

      it "updates the existing admin attributes" do
        admin = Admin.from_google(email: email, full_name: full_name, uid: uid, avatar_url: avatar_url)
        expect(admin.id).to eq(existing_admin.id)
        expect(admin.full_name).to eq(full_name)
        expect(admin.uid).to eq(uid)
      end
    end
  end
end
