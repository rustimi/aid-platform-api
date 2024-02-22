class User < ApplicationRecord
  # validation
  validates :fname, presence: true
  validates :lname, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  has_secure_password :password, validations: true

  # related fields
  has_one_attached :document
end
