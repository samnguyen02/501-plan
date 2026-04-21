class IdeathonYear < ApplicationRecord
     has_many :registered_attendees, dependent: :destroy
     has_many :teams, dependent: :destroy
     has_many :ideathon_events, dependent: :destroy
     has_many :sponsors_partners, dependent: :destroy
     has_many :mentors_judges, dependent: :destroy
     has_many :faqs, dependent: :destroy
     has_many :rules, dependent: :destroy

     before_validation :populate_year, if: -> { year.blank? }

     validates :year, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 2000, less_than_or_equal_to: 2100 }, uniqueness: true

  private

       def populate_year
            extracted_year = name.to_s[/\b(19|20)\d{2}\b/]
            self.year = extracted_year.to_i if extracted_year.present?
            self.year ||= start_date&.year
       end
end
