class Request < ApplicationRecord
  after_save :check_fulfillment_count


  # related fields
  belongs_to :requester, class_name: 'User'
  has_many :volunteering_instances
  has_many :volunteers, through: :volunteering_instances, source: :user


  # validation
  validates :description, :request_type, :status, :latitude, :longitude, presence: true
  validates :request_type, inclusion: { in: ['One time task', 'Material need'],
                                message: "%{value} is not a valid type" }

  validates :status, inclusion: { in: ['unpublished', 'fulfilled', 'unfulfilled'],
                                message: "%{value} is not a valid status" }

  private
  def check_fulfillment_count
    if self.fulfillment_count == 5
      # using update_column, skips validation and avoids triggering this function again
      self.update_column(:status, 'unpublished')
    end
  end
end