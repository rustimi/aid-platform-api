class User < ApplicationRecord
  # validation
  validates :fname, :lname, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  has_secure_password :password, validations: true

  # related fields
  has_one_attached :document
  has_many :requests, foreign_key: 'requester_id'
  # As a volunteer
  has_many :volunteering_instances
  has_many :volunteered_requests, through: :volunteering_instances, source: :request
end
