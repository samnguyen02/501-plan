# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
IdeathonYear.find_or_create_by!(name: "Ideathon 2026") do |y|
     y.description = "Spring ProductTAMU Ideathon"
     y.location = "Texas A&M University"
     y.start_date = Date.new(2026, 4, 11)
     y.end_date = Date.new(2026, 4, 12)
     y.is_active = true
end