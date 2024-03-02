class User < ApplicationRecord
  # validation
  validates :fname, :lname, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }
  validate :password_complexity
  has_secure_password :password, validations: true


  # related fields
  has_one_attached :document, dependent: :destroy
  has_many :requests, foreign_key: 'requester_id', dependent: :destroy
    # As a volunteer
  has_many :volunteering_instances, dependent: :destroy
  has_many :volunteered_requests, through: :volunteering_instances, source: :request

  has_many :received_conversations, class_name: 'Conversation', foreign_key: 'receiver_id', dependent: :destroy
  has_many :sent_conversations, class_name: 'Conversation', foreign_key: 'sender_id', dependent: :destroy


  private
  def password_complexity
    if password.blank?
      return
    end

    regex = /\A
      (?=.*\d)           # Must contain a digit
      (?=.*[a-z])        # Must contain a lower case character
      (?=.*[A-Z])        # Must contain an upper case character
      (?=.*[[:^alnum:]]) # Must contain a symbol
      .{8,}              # Must be at least 8 characters long
    /x

    unless password.match?(regex)
      errors.add :password, 'Complexity requirement not met. Length should be 8-70 characters and include: 1 uppercase, 1 lowercase, 1 digit and 1 special character'
    end
  end
end
