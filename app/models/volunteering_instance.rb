class VolunteeringInstance < ApplicationRecord
  belongs_to :user
  belongs_to :request
end
