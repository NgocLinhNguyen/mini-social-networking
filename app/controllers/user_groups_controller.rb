class UserGroupsController < ApplicationController
  before_action :user_must_logged_in

  def create
    @group = Group.find params[:group_id]
    @user_group = UserGroup.new(user_id: current_user.id, group_id: @group.id, status: "active")
    if @user_group.save
      redirect_to group_path(@group)
    else
      flash[:danger] = "Something went wrong"
      redirect_to groups_path(type: "yours")
    end
  end

  def destroy
    @group = Group.find params[:group_id]
    @user_group = UserGroup.find_by(user_id: current_user.id, group_id: @group.id)
    if @user_group.present?
      @user_group.destroy
    else
      flash[:danger] = "Something went wrong"
    end
    redirect_to groups_path(type: "yours")
  end
end
