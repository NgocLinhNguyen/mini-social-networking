class ChatroomsController < ApplicationController
  before_action :user_must_logged_in

  def index
    chatroom = current_user.chatrooms.active.order(last_message_at: :desc).first
    redirect_to chatroom_path chatroom
  end

  def show
    @chatroom = Chatroom.find_by(id: params[:id])
    @chatrooms = current_user.chatrooms.active.order(last_message_at: :desc)
    @chatroom.messages.where(received_id: current_user.id).update(status: "read")
    @messages = @chatroom.messages.order(created_at: :desc).limit(15)
    @message = Message.new
  end
end
