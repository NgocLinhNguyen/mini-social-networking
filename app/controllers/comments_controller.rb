class CommentsController < ApplicationController
  before_action :user_must_logged_in, only: [:create, :update]
  before_action :user_must_be_current_user, only: [:edit, :update, :destroy]

  def index
    @post = Post.find_by(id: params[:post_id])
    if @post.present?
      @comment = @post.comments.paginate(page: params[:page],
        per_page: 10)
      respond_to do |format|
        format.json
      end
    end
  end

  def create
    @comment = Comment.new(
      content: params[:comment][:content],
      user_id: current_user.id,
      post_id: params[:post_id],
      status: "active"
    )
    if @comment.save
      if @comment.user.avatar.present?
        @avatar = @comment.user.avatar.picture.thumb.url
      end
      @time = @comment.created_at.strftime("%F, %H:%M")
      respond_to do |format|
        format.html {
          flash[:success] = "Create your comment successfully"
          redirect_to user_post_path(user_id: current_user.id, id: params[:post_id])
        }
        format.json
      end
    else
      respond_to do |format|
        format.html {
          flash[:success] = "Create your comment fail"
          redirect_to user_post_path(user_id: current_user.id, id: params[:post_id])
        }
        format.json { render json: ({ error: true }).to_json }
      end
    end
  end

  def update
    @comment = Comment.find_by(id: params[:id], post_id: params[:post_id], user_id: current_user.id)
    if @comment.present?
      if @comment.update(content: params[:content])
        flash[:success] = "Update your comment successfully"
      end
    else
      flash[:warning] = "Comment not exist"
    end
  end

  def destroy
    @comment = Comment.find_by(id: params[:id], post_id: params[:post_id], user_id: current_user.id)
    if @comment.present?
      if @comment.update(status: "deleted")
        flash[:success] = "Delete your comment successfully"
      end
    else
      flash[:warning] = "Comment not exist"
    end
  end
end
