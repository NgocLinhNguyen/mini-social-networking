class LikesController < ApplicationController
  before_action :user_must_logged_in

  def create
    @user = User.find_by(id: params[:user_id])
    if @user.present?
      if params[:post_id].present?
        @post = Post.find_by(id: params[:post_id])
        if @post.present?
          Like.create(user_id: @user.id, post_id: @post.id)
          @number_likes = @post.likes.count
          @message = "Successfully"
        else
          @error = "Post does not exist"
        end
      else
        @comment = Comment.find_by(id: params[:comment_id])
        if @comment.present?
          Like.create(user_id: @user.id, comment_id: @comment.id)
          @number_likes = @comment.likes.count
          @message = "Successfully"
        else
          @error = "Comment does not exist"
        end
      end
    else
      @error = "Member does not exist"
    end
    respond_to do |format|
      format.json
    end
  end

  def destroy
    @user = User.find_by(id: params[:user_id])
    if @user.present?
      if params[:post_id].present?
        @post = Post.find_by(id: params[:post_id])
        if @post.present?
          like = Like.find_by(user_id: @user.id, post_id: @post.id)
          if like.present?
            like.destroy
            @number_likes = @post.likes.count
            @message = "Successfully"
          else
            @error = "Like does not exist"
          end
        else
          @error = "Post does not exist"
        end
      else
        @comment = Comment.find_by(id: params[:comment_id])
        if @comment.present?
          like = Like.find_by(user_id: @user.id, comment_id: @comment.id)
          if like.present?
            like.destroy
            @number_likes = @comment.likes.count
            @message = "Successfully"
          else
            @error = "Like does not exist"
          end
        else
          @error = "Comment does not exist"
        end
      end
    else
      @error = "Member does not exist"
    end
    respond_to do |format|
      format.json
    end
  end
end
