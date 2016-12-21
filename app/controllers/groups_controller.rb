class GroupsController < ApplicationController
  before_action :user_must_logged_in
  before_action :owner_must_be_current_user, only: [:update, :destroy]

  def index
    if params[:type] == "yours"
      @groups = current_user.get_groups
    else
      @groups = Group.all
    end
    @group = Group.new
  end

  def show
    @group = Group.find params[:id]
    @owner = User.find @group.owner_id
    @posts = @group.posts.order(created_at: :desc).limit(5)
    @number_post = @group.posts.count
    @post = Post.new(group_id: @group.id)
    @comment = Comment.new
  end

  def create
    @group = Group.new(
      name: params[:group][:name],
      owner_id: current_user.id,
      description: params[:group][:description],
      kind: params[:group][:kind],
      status: "active"
    )
    if @group.save
      @user_group = UserGroup.create(user_id: current_user.id, group_id: @group.id)
      if params[:group][:cover].present?
        cover = Image.create(
          picture: params[:group][:cover],
          status: "active"
        )
        @group.update(cover_id: cover.id)
      end
      redirect_to group_path(@group)
      flash[:success] = "Create group successfully"
    else
      render "new"
    end
  end

  def update
    @group = Group.find params[:id]
    @group.update(
      name: params[:group][:name],
      description: params[:group][:description],
      kind: params[:group][:kind]
    )
    if params[:group][:cover].present?
      if @group.cover.present?
        @group.cover.update(status: "deleted")
      end
      cover = Image.create(
        picture: params[:group][:cover],
        status: "active"
      )
      @group.update(cover_id: cover.id)
    end
    redirect_to group_path(@group)
  end

  def destroy
    @group = Group.find params[:id]
    if @group.present?
      if @group.update(status: "deleted")
        flash[:success] = "Delete group successfully"
      else
        flash[:danger] = "Something went wrong"
      end
      redirect_to groups_path
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
