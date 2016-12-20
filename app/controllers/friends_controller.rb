class FriendsController < ApplicationController
  before_action :user_must_logged_in, only: [:index, :create, :update, :destroy]

  def index
    @friends = Array.new
    array = current_user.active_friends
    array.each do |index|
      user = User.find index.followed_id
      @friends.push user
    end
    @friends
  end

  def create
    @user = User.find params[:user_id]
    current_user.follow(@user)
    redirect_to user_path(@user)
  end

  def update
    @user = User.find params[:user_id]
    current_user.follow(@user)
    redirect_to user_path(@user)
  end

  def destroy
    @user = User.find params[:user_id]
    if params[:type] == "Unfollow"
      @friend = Friend.find_by(follower_id: current_user.id, followed_id: @user.id)
      if @friend.present?
        @friend.destroy
      end
    elsif params[:type] == "Unfriend"
      current_user.unfollow(@user)
      @user.unfollow(current_user)
    end
    redirect_to user_path(@user)
  end
end
