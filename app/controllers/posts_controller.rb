class PostsController < ApplicationController
  before_action :user_must_logged_in, only: [:index, :new, :create, :edit, :update, :destroy]
  before_action :post_must_belongs_to_current_user, only: [:edit, :update, :destroy]

  def index
    @posts = Post.filter_by_user(params[:user_id]).order(created_at: :desc).paginate(page: params[:page], per_page: 5)
    @posts_info = Array.new
    @posts.each do |post|
      post_info = render_to_string(template: "shared/_post.html.haml", locals: { post: post }, layout: false)
      @posts_info.push post_info
    end
    respond_to do |format|
      format.json
    end
  end

  def show
    @post = Post.find params[:id]
    @user = @post.user
    @comments = Comment.filter_by_post(@post.id)
    @comment = Comment.new
  end

  def new
    @post = Post.new
  end

  def create
    if params[:post][:post_image].present?
      @image = Image.create(
        picture: params[:post][:post_image],
        status: "active"
      )
    end
    @post = Post.new(
      content: params[:post][:content],
      status: "active",
      user_id: current_user.id,
      image_id: @image.try(:id),
      group_id: params[:group_id]
    )
    if @post.save
      flash[:success] = "Create new post successfully"
      if params[:group_id].present?
        @group = Group.find params[:group_id]
        arr_user = @group.user_groups.uniq{ |x| x.user_id }
        arr_user.each do |user|
          unless user.id == current_user.id
            Notification.create(
              sender_id: current_user.id,
              post_id: @post.id,
              group_id: @group.id,
              message: current_user.name + get_message("post_group") + @group.name,
              user_id: user.id,
              status: "unread"
            )
          end
        end
        redirect_to group_path(@group)
      else
        redirect_to user_path(current_user)
      end
    else
      flash[:danger] = "error"
      if params[:group_id].present?
        @group = Group.find params[:group_id]
        redirect_to group_path(@group)
      else
        render "new"
      end
    end
  end

  def edit
    @post = Post.find params[:id]
  end

  def update
    @post = Post.find params[:id]
    if params[:post][:content].present?
      @post.update(content: params[:post][:content])
      @post_info = render_to_string(template: "shared/_post.html.haml", locals: { post: @post }, layout: false)
      @message = "successfully"
    else
      @message = "error"
    end
    respond_to :json
  end

  def destroy
    @post = Post.find params[:id]
    @post.destroy()
    respond_to :json
  end

  private
    def post_must_belongs_to_current_user
      if params[:post].present?
        @user = User.find params[:post][:user_id]
      else
        @user = User.find params[:user_id]
      end
      @post = Post.find params[:id]
      unless @user.id == current_user.id || @post.user_id == current_user.id
        flash[:warning] = "Permission denied"
        redirect_to user_path(current_user)
      end
    end
end
