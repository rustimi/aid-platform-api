# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


# Clear existing data to prevent duplication if you run seeds multiple times
VolunteeringInstance.delete_all
Request.delete_all
User.delete_all

# Create seed users
User.create([
              { fname: "John", lname: "Doe", email: "john.doe@example.com", password_digest: BCrypt::Password.create('password123') },
              { fname: "Jane", lname: "Doe", email: "jane.doe@example.com", password_digest: BCrypt::Password.create('password123') },
              { fname: "Jim", lname: "Beam", email: "jim.beam@example.com", password_digest: BCrypt::Password.create('password123') }
            ])
puts "Users created: #{User.count}"

# Seed requests
Request.create([
                 { description: "Need help moving a sofa to the third floor.", request_type: "One time task", status: "unfulfilled", latitude: 40.7128, longitude: -74.0060, requester_id: 1, fulfillment_count: 0 },
                 { description: "Looking for a winter coat donation.", request_type: "Material need", status: "unfulfilled", latitude: 34.0522, longitude: -118.2437, requester_id: 2, fulfillment_count: 0 },
                 { description: "Urgent: baby supplies needed.", request_type: "Material need", status: "unfulfilled", latitude: 41.8781, longitude: -87.6298, requester_id: 1, fulfillment_count: 0 },
                 { description: "Volunteers needed for community clean-up.", request_type: "One time task", status: "unfulfilled", latitude: 37.7749, longitude: -122.4194, requester_id: 3, fulfillment_count: 0 }
               ])

puts "Requests created: #{Request.count}"


VolunteeringInstance.create([
                              { user_id: 2, request_id: 1},
                              { user_id: 3, request_id: 1},
                              { user_id: 1, request_id: 2},
                            ])
puts "Volunteer created: #{VolunteeringInstance.count}"