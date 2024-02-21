class User < ApplicationRecord
  has_secure_password :password, validations: true

  has_one_attached :document

  validates :fname, presence: true
  validates :lname, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
end
