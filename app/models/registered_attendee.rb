class RegisteredAttendee < ApplicationRecord
  belongs_to :ideathon_year
  belongs_to :team, optional: true
  validates :ideathon_year_id, :attendee_name, :attendee_phone, :attendee_email, :attendee_major, :attendee_class, presence: true
end
