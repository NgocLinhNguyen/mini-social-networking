class FriendsController < ApplicationController
  before_action :user_must_logged_in, only: [:index, :create, :update, :destroy]

  def index
    @friends = current_user.get_friends
    @friends = @friends.paginate(page: params[:page], per_page: 8)
  end

  def show
    @user = User.find params[:user_id]
    if params[:type] == "DeleteRequest"
      @friend = Friend.find_by(followed_id: current_user.id, follower_id: @user.id)
      if @friend.present?
        @friend.destroy
      end
    else
      current_user.follow(@user)
    end
    redirect_to user_path(@user)
  end

  def create
    @user = User.find params[:user_id]
    current_user.follow(@user)
    redirect_to user_path(@user)
  end

  def update
    @user = User.find params[:user_id]
    current_user.follow(@user)
    chatroom = Chatroom.create(
      status: "active",
      last_message_at: Time.now,
      chatroom_users_attributes: [
        { user_id: current_user.id, status: "active" },
        { user_id: @user.id, status: "active" }
      ]
    )
    redirect_to user_path(@user)
  end

  def destroy
    @user = User.find params[:user_id]
    chatroom_user = ChatroomUser.find_by(user_id: @user.id, status: "active")
    if chatroom_user.present?
      chatroom_user.update(status: "deleted")
      chatroom_user = ChatroomUser.find_by(user_id: current_user.id, status: "active")
      chatroom_user.update(status: "deleted")
      chatroom_user.chatroom.update(status: "deleted")
    end
    if params[:type] == "Unfollow"
      @friend = Friend.find_by(follower_id: current_user.id, followed_id: @user.id)
      if @friend.present?
        @friend.destroy
      end
    elsif params[:type] == "Unfriend"
      current_user.unfollow(@user)
      @user.unfollow(current_user)
    elsif params[:type] == "DeleteRequest"
      @friend = Friend.find_by(followed_id: current_user.id, follower_id: @user.id)
      if @friend.present?
        @friend.destroy
      end
    end
    redirect_to user_path(@user)
  end
end
