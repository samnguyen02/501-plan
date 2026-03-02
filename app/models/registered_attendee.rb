class RegisteredAttendee < ApplicationRecord
     belongs_to :ideathon_year
     belongs_to :team, optional: true
     validates :ideathon_year_id, :attendee_name, :attendee_phone, :attendee_email, :attendee_major, :attendee_class, presence: true

     validate :name_must_contain_only_letters
     validate :phone_must_have_ten_digits
     validate :phone_must_contain_only_digits
     validate :email_must_be_valid_format
     validate :major_must_be_valid
     validate :class_must_be_valid

     before_validation :normalize_phone

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

          # Strip all non-digit characters before validation so 979-555-1234 becomes 9795551234
          def normalize_phone
               self.attendee_phone = attendee_phone.gsub(/\D/, "") if attendee_phone.present?
          end

          def name_must_contain_only_letters
               if attendee_name.present? && attendee_name !~ /\A[a-zA-Z\s\-'\.]+\z/
                    errors.add(:attendee_name, "may only contain letters, spaces, hyphens, apostrophes, and periods")
               end
          end

          def phone_must_have_ten_digits
               if attendee_phone.present? && attendee_phone.length != 10
                    errors.add(:attendee_phone, "must contain exactly 10 digits")
               end
          end

          def phone_must_contain_only_digits
               if attendee_phone.present? && attendee_phone !~ /\A\d+\z/
                    errors.add(:attendee_phone, "must contain only digits")
               end
          end

          def email_must_be_valid_format
               return unless attendee_email.present?
               unless attendee_email =~ /\A[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}\z/
                    errors.add(:attendee_email, "must be a valid email address (only letters, numbers, and . _ % + - @ are allowed)")
               end
          end

          def major_must_be_valid
               return unless attendee_major.present?
               unless attendee_major =~ /\A[a-zA-Z\s]+\z/
                    errors.add(:attendee_major, "may only contain letters")
               end
          end

          def class_must_be_valid
               return unless attendee_class.present?
               unless attendee_class =~ /\A[a-zA-Z\s\-]+\z/
                    errors.add(:attendee_class, "may only contain letters, spaces, and hyphens")
               end
          end
end
