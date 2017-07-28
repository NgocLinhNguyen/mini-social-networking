module MessagesHelper
  def number_message_unread
    Message.where(received_id: current_user.id, status: "unread").count(:id)
  end
end
