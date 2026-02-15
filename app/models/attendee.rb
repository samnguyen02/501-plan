class Attendee < ApplicationRecord
  validates :name, :email, presence: true

  default_scope { order(name: :asc) }

  scope :search_by_name, ->(query) {
    where("name ILIKE ?", "%#{query}%") if query.present?
  }
end
