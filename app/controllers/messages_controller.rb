class MessagesController < ApplicationController
  def index
    chatroom = Chatroom.find(params[:chatroom_id])
    messages = chatroom.load_more_message params[:first_message_id]
    partner = chatroom.partner current_user.id

    messages_html = render_to_string(template: "messages/_messages.html.haml",
      locals: { messages: messages, partner: partner, load_more: true }, layout: false)
    render json: ({ number_messages: messages.length, messages_html: messages_html })
  end

  def create
    chatroom = Chatroom.find(params[:chatroom_id])
    partner = chatroom.partner current_user.id
    message = Message.new(
      content: params[:content],
      user_id: current_user.id,
      received_id: partner.id,
      chatroom_id: params[:chatroom_id],
      status: "unread"
    )
    if message.save
      avatar = "no_avatar"
      if current_user.avatar.present?
        avatar = current_user.avatar.picture.thumb.url
      end
      chatroom.update(last_message_at: Time.now)
      ActionCable.server.broadcast partner.id,
        message_id: message.id.to_s,
        content: message.content,
        avatar: avatar,
        created_at: message.created_at.to_s,
        received_name: current_user.name,
        chatroom_id: chatroom.id.to_s
      head :ok
    else
      render json: ({ error: "failed" })
    end
  end

  def update
    chatroom = Chatroom.find(params[:chatroom_id])
    chatroom.messages.where(received_id: current_user.id, status: "unread").update(status: "read")
    render json: ({ error: "success" })
  end
end
