class Team < ApplicationRecord
     belongs_to :ideathon_year
     has_many :registered_attendees

     validates :team_name, presence: true
     validates :team_name, uniqueness: { scope: :ideathon_year_id, message: "already exists for this year" }, unless: :unassigned
end
