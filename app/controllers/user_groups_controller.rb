class UserGroupsController < ApplicationController
  before_action :user_must_logged_in

  def index

  end

  def create
    @user = User.find params[:user_id]
    @group = Group.find params[:group_id]
    @user_group = UserGroup.new(user_id: @user.id, group_id: @group.id)
    if @user_group.save
      redirect_to groups_path
    else
      flash[:danger] = "Something went wrong"
      render "groups/index"
    end
  end
end
