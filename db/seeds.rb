# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

Attendee.destroy_all

attendees = [
  { name: "Aiden Patel", email: "aiden.patel@tamu.edu", phone_number: "(979) 555-0101" },
  { name: "Brianna Chen", email: "brianna.chen@tamu.edu", phone_number: "(979) 555-0102" },
  { name: "Carlos Rivera", email: "carlos.rivera@tamu.edu", phone_number: "(979) 555-0103" },
  { name: "Diana Okafor", email: "diana.okafor@tamu.edu", phone_number: "(979) 555-0104" },
  { name: "Ethan Nguyen", email: "ethan.nguyen@tamu.edu", phone_number: "(979) 555-0105" },
  { name: "Fatima Al-Hassan", email: "fatima.alhassan@tamu.edu", phone_number: "(979) 555-0106" },
  { name: "Gabriel Santos", email: "gabriel.santos@tamu.edu", phone_number: "(979) 555-0107" },
  { name: "Hannah Kim", email: "hannah.kim@tamu.edu", phone_number: "(979) 555-0108" },
  { name: "Isaac Thompson", email: "isaac.thompson@tamu.edu", phone_number: "(979) 555-0109" },
  { name: "Jasmine Wright", email: "jasmine.wright@tamu.edu", phone_number: "(979) 555-0110" },
  { name: "Kevin Zhang", email: "kevin.zhang@tamu.edu", phone_number: "(979) 555-0111" },
  { name: "Lily Johnson", email: "lily.johnson@tamu.edu", phone_number: "(979) 555-0112" },
  { name: "Mason Garcia", email: "mason.garcia@tamu.edu", phone_number: "(979) 555-0113" },
  { name: "Nadia Petrova", email: "nadia.petrova@tamu.edu", phone_number: "(979) 555-0114" },
  { name: "Oliver Brown", email: "oliver.brown@tamu.edu", phone_number: "(979) 555-0115" },
  { name: "Priya Sharma", email: "priya.sharma@tamu.edu", phone_number: "(979) 555-0116" },
  { name: "Quinn Davis", email: "quinn.davis@tamu.edu", phone_number: "(979) 555-0117" },
  { name: "Rachel Martinez", email: "rachel.martinez@tamu.edu", phone_number: "(979) 555-0118" },
  { name: "Samuel Lee", email: "samuel.lee@tamu.edu", phone_number: "(979) 555-0119" },
  { name: "Taylor Anderson", email: "taylor.anderson@tamu.edu", phone_number: "(979) 555-0120" }
]

attendees.each do |attrs|
  Attendee.create!(attrs)
end

puts "Seeded #{Attendee.count} attendees."
