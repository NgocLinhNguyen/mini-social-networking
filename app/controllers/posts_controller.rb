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
<<<<<<< 9f0504fcef555268aa72952a60d427048ac43fcf
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
      redirect_to user_path(current_user)
=======
    if params[:group_id].present?
      @group = Group.find params[:group_id]
      @post = Post.new(
        content: params[:post][:content],
        status: "active",
        user_id: current_user.id,
        group_id: @group.id
      )
      if @post.save
        flash[:success] = "Create new post successfully"
      else
        flash[:danger] = "error"
      end
      redirect_to group_path(@group)
>>>>>>> Complete show, update, create, destroy group
    else
      @post = Post.new(
        content: params[:post][:content],
        status: "active",
        user_id: current_user.id
      )
      if @post.save
        flash[:success] = "Create new post successfully"
        redirect_to user_path(current_user)
      else
        flash[:danger] = "error"
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
      if @post.update(content: params[:post][:content])
        flash[:success] = "Update your post successfully"
        redirect_to user_post_path(current_user, @post)
      end
    end
  end

  def destroy
    @post = Post.find params[:id]
    if @post.update(status: "deleted")
      flash[:success] = "Delete your post successfully"
      redirect_to user_path(current_user)
    end
  end

  private
    def post_must_belongs_to_current_user
      @user = User.find params[:user_id]
      @post = Post.find params[:id]
      unless @user.id == current_user.id || @post.user_id == current_user.id
        flash[:warning] = "Permission denied"
        redirect_to user_path(current_user)
      end
    end
end
