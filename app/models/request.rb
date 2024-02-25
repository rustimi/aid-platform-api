class Request < ApplicationRecord
  belongs_to :requester, class_name: 'User'
  has_many :volunteering_instances
  has_many :volunteers, through: :volunteering_instances, source: :user


  validates :description, :type, :status, :latitude, :longitude, presence: true


end
