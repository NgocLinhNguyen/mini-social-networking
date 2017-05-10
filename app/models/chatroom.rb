class Chatroom < ApplicationRecord
  has_many :messages
  has_many :chatroom_users
  has_many :users, through: :chatroom_users

  accepts_nested_attributes_for :chatroom_users

  scope :active, -> { where(status: "active") }

  def partner(user_id)
    chatroom_users = self.chatroom_users
    chatroom_users.each do |chatroom_user|
      unless chatroom_user.user_id == user_id
        partner_user = User.find(chatroom_user.user_id)
        return partner_user
      end
    end
  end

  def last_message
    return self.messages.last
  end

  def load_more_message first_message_id
    self.messages.where("id < ?", first_message_id).order(created_at: :desc).limit(15)
  end

  def inbox_unread user_id
    self.messages.where(received_id: user_id, status: "unread").count
  end
end
