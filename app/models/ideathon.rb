# frozen_string_literal: true

class Ideathon < ApplicationRecord
     self.table_name = "ideathon_years"
     self.inheritance_column = nil

     include ActivityTrackable

     has_many :sponsors_partners, dependent: :destroy, foreign_key: :ideathon_year_id, inverse_of: :ideathon
     has_many :mentors_judges, dependent: :destroy, foreign_key: :ideathon_year_id, inverse_of: :ideathon
     has_many :faqs, dependent: :destroy, foreign_key: :ideathon_year_id, inverse_of: :ideathon
     has_many :rules, dependent: :destroy, foreign_key: :ideathon_year_id, inverse_of: :ideathon
     has_many :registered_attendees, dependent: :destroy, foreign_key: :ideathon_year_id, inverse_of: :ideathon_year
     has_many :teams, dependent: :destroy, foreign_key: :ideathon_year_id, inverse_of: :ideathon_year
     has_many :ideathon_events, dependent: :destroy, foreign_key: :ideathon_year_id, inverse_of: :ideathon_year

     validates :year, presence: true, uniqueness: true, numericality: { only_integer: true, greater_than_or_equal_to: 2000, less_than_or_equal_to: 2100 }

     before_validation :assign_default_name

     def to_param
          year.to_s
     end

  private

       def assign_default_name
            self.name = "Ideathon #{year}" if year.present? && name.blank?
       end
end
