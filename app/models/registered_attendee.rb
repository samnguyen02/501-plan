class RegisteredAttendee < ApplicationRecord
     belongs_to :ideathon_year
     belongs_to :team, optional: true
     validates :ideathon_year_id, :attendee_name, :attendee_phone, :attendee_email, :attendee_major, :attendee_class, presence: true

     validate :phone_must_have_ten_digits

     default_scope { order(attendee_name: :asc) }

     scope :search_by_name, ->(query) {
          where("attendee_name ILIKE ?", "%#{query}%") if query.present?
     }

     scope :search_by_name_or_team, ->(query) {
          if query.present?
               left_joins(:team).where(
                    "attendee_name ILIKE :q OR teams.team_name ILIKE :q",
                    q: "%#{query}%"
               )
          end
     }

     scope :sorted_by_team, -> {
          reorder(nil).left_joins(:team).order("teams.team_name ASC NULLS LAST, attendee_name ASC")
     }

     private

          def phone_must_have_ten_digits
               if attendee_phone.present?
                    digit_count = attendee_phone.gsub(/\D/, "").length
                    if digit_count != 10
                         errors.add(:attendee_phone, "must contain exactly 10 digits")
                    end
               end
          end
end
