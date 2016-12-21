class Notification < ApplicationRecord
  belongs_to :user

  validates :message, presence: true
  validates :sender_id, presence: true
  validates :user_id, presence: true
  validates :status, presence: true, inclusion: { in: ["read", "unread"] }

  scope :unread, -> { where(status: "unread") }

  def get_sender
    return User.find self.sender_id
  end
end
