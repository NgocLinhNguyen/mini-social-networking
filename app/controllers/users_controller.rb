class UsersController < ApplicationController
  before_action :user_must_logged_in, only: [:show, :edit, :update]
  before_action :user_not_logged_in, only: [:new, :create]
  before_action :user_must_be_current_user, only: [:edit, :update]

  def show
    @user = User.find params[:id]
    @posts = Post.filter_by_user(params[:id]).order(created_at: :desc).limit(5)
    @post = Post.new
    @comment = Comment.new
    @number_post = Post.filter_by_user(params[:id]).count
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.status = "active"
    if @user.save
      flash[:success] = "Create new account successfully"
      redirect_to login_path
    else
      render "new"
    end
  end

  def edit
    @user = User.find params[:id]
  end

  def update
    @user = User.find params[:id]
    if params[:user][:name].present?
      @user.update(name: params[:user][:name])
    end
    if params[:user][:phone_number].present?
      @user.update(phone_number: params[:user][:phone_number])
    end
    if params[:user][:birthday].present?
      @user.update(birthday: params[:user][:birthday])
    end
    if params[:user][:address].present?
      @user.update(address: params[:user][:address])
    end
    if params[:user][:avatar].present?
      if @user.avatar.present?
        @user.avatar.update(status: "deleted")
      end
      avatar = Image.create(
        picture: params[:user][:avatar],
        status: "active"
      )
      @user.update(avatar_id: avatar.id)
    end
    redirect_to @user
    flash[:success] = "Success"
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
