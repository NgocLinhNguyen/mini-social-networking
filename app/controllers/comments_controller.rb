class CommentsController < ApplicationController
  before_action :user_must_logged_in, only: [:create, :update]
  before_action :user_must_be_current_user, only: [:edit, :update, :destroy]

  def create
    @comment = Comment.new(
      content: params[:comment][:content],
      user_id: current_user.id,
      post_id: params[:post_id],
      status: "active"
    )
    if @comment.save
      flash[:success] = "Create your comment successfully"
      redirect_to user_post_path(user_id: current_user.id, id: params[:post_id])
    else
      flash[:success] = "Create your comment fail"
      redirect_to user_post_path(user_id: current_user.id, id: params[:post_id])
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
