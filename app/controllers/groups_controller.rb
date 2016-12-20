class GroupsController < ApplicationController
  before_action :user_must_logged_in
  before_action :owner_must_be_current_user, only: [:edit, :update, :destroy]

  def index
    @groups = Group.all
    @group = Group.new
  end

  def show
    @group = Group.find params[:id]
    @posts = @group.posts.order(created_at: :desc)
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(
      name: params[:group][:name],
      owner_id: current_user.id,
      kind: params[:group][:kind],
      status: "active"
    )
    if @group.save
      @user_group = UserGroup.create(user_id: current_user.id, group_id: @group.id)
      redirect_to group_path(@group)
      flash[:success] = "Create group successfully"
    else
      render "new"
    end
  end

  def edit
    @group = Group.find params[:id]
  end

  def update
    @group = Group.find params[:id]
    if params[:group][:name].present?
      @group.update(name: params[:group][:name])
    end
    if params[:group][:kind].present?
      @group.update(kind: params[:group][:kind])
    end
  end

  def destroy
    @group = Group.find params[:id]
    if @group.present?
      if @group.update(status: "deleted")
        flash[:success] = "Delete group successfully"
      else
        flash[:danger] = "Something went wrong"
      end
    end
  end
  private
    def owner_must_be_current_user
      @group = Group.find params[:id]
      if current_user.present?
        unless current_user.id == @group.owner_id
          redirect_to user_path(current_user)
          flash[:warning] = "Permission denied!"
        end
      end
    end
end
