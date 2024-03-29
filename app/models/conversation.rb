class Conversation < ApplicationRecord
  belongs_to :sender, class_name: "User", foreign_key: "sender_id"
  belongs_to :receiver, class_name: "User", foreign_key: "receiver_id"
  belongs_to :request, optional: false
  has_many :messages, dependent: :destroy

  # A conversation should be unique per user and request
  validates :sender_id, uniqueness: { scope: [:receiver_id, :request_id] }

  # A conversation should have different sender and receiver
  validate :sender_receiver_different


  scope :between, -> (sender_id, receiver_id, request_id) do
    where("(conversations.sender_id = ? AND conversations.receiver_id = ? AND conversations.request_id = ?) OR (conversations.receiver_id = ? AND conversations.sender_id = ? AND conversations.request_id = ?)", sender_id, receiver_id, request_id, sender_id, receiver_id, request_id)
  end

  private
  def sender_receiver_different
    if sender_id == receiver_id
      errors.add(:receiver_id, "cannot be the same as sender")
    end
  end
end
