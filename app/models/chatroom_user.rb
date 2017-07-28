class ChatroomUser < ApplicationRecord
  belongs_to :user
  belongs_to :chatroom, optional: true

  scope :active, -> { where(status: "active") }

  validates_uniqueness_of :user_id, scope: :chatroom_id
end
