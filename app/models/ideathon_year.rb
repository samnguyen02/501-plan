class IdeathonYear < ApplicationRecord
     has_many :teams, dependent: :destroy
     has_many :registered_attendees, dependent: :restrict_with_error
end
