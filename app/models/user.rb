class User < ApplicationRecord
  has_secure_password :password, validations: true

  has_one_attached :document
end
