class Request < ApplicationRecord

  # related fields
  belongs_to :requester, class_name: 'User'
  has_many :volunteering_instances
  has_many :volunteers, through: :volunteering_instances, source: :user


  # validation
  validates :description, :request_type, :latitude, :longitude, presence: true
  validates :request_type, inclusion: { in: ['One time task', 'Material need'],
                                message: "%{value} is not a valid type" }

end
