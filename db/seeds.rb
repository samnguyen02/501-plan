# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Ideathon 2026
year = IdeathonYear.find_or_create_by!(name: "Ideathon 2026") do |y|
     y.description = "Spring ProductTAMU Ideathon"
     y.location = "Texas A&M University"
     y.start_date = Date.new(2026, 4, 11)
     y.end_date = Date.new(2026, 4, 12)
     y.is_active = true
end

# Ensure an "Unassigned" team exists (required by registration form)
unassigned_team = Team.find_or_create_by!(ideathon_year: year, unassigned: true) do |t|
     t.team_name = "Unassigned"
end

# Create a few named teams
team_names = ["Alpha Builders", "Code Crusaders", "Pixel Pirates", "Data Dragons"]
teams = team_names.map do |name|
     Team.find_or_create_by!(ideathon_year: year, team_name: name) do |t|
          t.unassigned = false
     end
end

# Fake attendees for testing
attendees_data = [
     { name: "Alice Johnson",    email: "alice.johnson@tamu.edu",    phone: "979-555-0101", major: "Computer Science",      classification: "Junior" },
     { name: "Bob Martinez",     email: "bob.martinez@tamu.edu",     phone: "979-555-0102", major: "Electrical Engineering", classification: "Senior" },
     { name: "Charlie Kim",      email: "charlie.kim@tamu.edu",      phone: "979-555-0103", major: "Computer Engineering",   classification: "Sophomore" },
     { name: "Diana Patel",      email: "diana.patel@tamu.edu",      phone: "979-555-0104", major: "Data Science",           classification: "Junior" },
     { name: "Ethan Brown",      email: "ethan.brown@tamu.edu",      phone: "979-555-0105", major: "Computer Science",       classification: "Senior" },
     { name: "Fiona Chen",       email: "fiona.chen@tamu.edu",       phone: "979-555-0106", major: "Mathematics",            classification: "Freshman" },
     { name: "George Davis",     email: "george.davis@tamu.edu",     phone: "979-555-0107", major: "Mechanical Engineering", classification: "Junior" },
     { name: "Hannah Lee",       email: "hannah.lee@tamu.edu",       phone: "979-555-0108", major: "Computer Science",       classification: "Sophomore" },
     { name: "Isaac Wilson",     email: "isaac.wilson@tamu.edu",     phone: "979-555-0109", major: "Physics",                classification: "Senior" },
     { name: "Julia Nguyen",     email: "julia.nguyen@tamu.edu",     phone: "979-555-0110", major: "Computer Science",       classification: "Junior" },
     { name: "Kevin Thompson",   email: "kevin.thompson@tamu.edu",   phone: "979-555-0111", major: "Industrial Engineering", classification: "Sophomore" },
     { name: "Laura Garcia",     email: "laura.garcia@tamu.edu",     phone: "979-555-0112", major: "Biomedical Engineering", classification: "Senior" },
     { name: "Marcus Wright",    email: "marcus.wright@tamu.edu",    phone: "979-555-0113", major: "Computer Science",       classification: "Freshman" },
     { name: "Nadia Hassan",     email: "nadia.hassan@tamu.edu",     phone: "979-555-0114", major: "Aerospace Engineering",  classification: "Junior" },
     { name: "Oscar Rivera",     email: "oscar.rivera@tamu.edu",     phone: "979-555-0115", major: "Computer Science",       classification: "Senior" },
     { name: "Priya Sharma",     email: "priya.sharma@tamu.edu",     phone: "979-555-0116", major: "Statistics",             classification: "Sophomore" },
     { name: "Quinn O'Brien",    email: "quinn.obrien@tamu.edu",     phone: "979-555-0117", major: "Computer Science",       classification: "Junior" },
     { name: "Rachel Adams",     email: "rachel.adams@tamu.edu",     phone: "979-555-0118", major: "Chemical Engineering",   classification: "Senior" },
     { name: "Sam Taylor",       email: "sam.taylor@tamu.edu",       phone: "979-555-0119", major: "Computer Science",       classification: "Freshman" },
     { name: "Tina Zhao",        email: "tina.zhao@tamu.edu",        phone: "979-555-0120", major: "Information Technology",  classification: "Junior" }
]

attendees_data.each_with_index do |data, i|
     # Distribute across teams: first 16 get assigned to 4 teams (4 each), last 4 are unassigned
     team = i < 16 ? teams[i % 4] : unassigned_team

     RegisteredAttendee.find_or_create_by!(attendee_email: data[:email]) do |a|
          a.attendee_name  = data[:name]
          a.attendee_phone = data[:phone]
          a.attendee_major = data[:major]
          a.attendee_class = data[:classification]
          a.ideathon_year  = year
          a.team           = team
     end
end
