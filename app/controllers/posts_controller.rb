class PostsController < ApplicationController
  before_action :user_must_logged_in, only: [:index, :new, :create, :edit, :update, :destroy]
  before_action :post_must_belongs_to_current_user, only: [:edit, :update, :destroy]

  def index
    @posts = Post.filter_by_user(params[:user_id])
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
    @post = Post.new(
      content: params[:post][:content],
      status: "active",
      user_id: current_user.id
    )
    if @post.save
      flash[:success] = "Create new post successfully"
      redirect_to user_path(current_user)
    else
      render "new"
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
