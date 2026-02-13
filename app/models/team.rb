class Team < ApplicationRecord
  belongs_to :ideathon_year
  has_many :registered_attendees
end
