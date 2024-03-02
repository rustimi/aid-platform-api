# Clear existing data
User.destroy_all
Request.destroy_all
Conversation.destroy_all
Message.destroy_all
VolunteeringInstance.destroy_all

# Create Users
user1 = User.create!(fname: 'John', lname: 'Doe', email: 'john.doe@example.com', password: 'password')
user2 = User.create!(fname: 'Jane', lname: 'Smith', email: 'jane.smith@example.com', password: 'password')
user3 = User.create!(fname: 'Mike', lname: 'Brown', email: 'mike.brown@example.com', password: 'password')

# Create Requests
request1 = Request.create!(description: "Need groceries", request_type: "One time task", latitude: 40.7128, longitude: -74.0060, requester: user1)
request2 = Request.create!(description: "Need a ride", request_type: "One time task", latitude: 34.0522, longitude: -118.2437, requester: user2)

# Create Conversations
conversation1 = Conversation.create!(sender: user2, receiver: user1, request: request1)
conversation2 = Conversation.create!(sender: user3, receiver: user1, request: request1)

# Create Messages
Message.create!(body: "Can help with groceries", user: user2, conversation: conversation1)
Message.create!(body: "Thank you!", user: user1, conversation: conversation1)
Message.create!(body: "Can I join and help too?", user: user3, conversation: conversation2)

# Create Volunteering Instances
VolunteeringInstance.create!(user: user2, request: request1)
VolunteeringInstance.create!(user: user3, request: request1)
