class UsersController < ApplicationController
  before_action :user_must_logged_in, only: [:index, :show, :edit, :update]
  before_action :user_not_logged_in, only: [:new, :create]
  before_action :user_must_be_current_user, only: [:edit, :update]

  def index
  end

  def show
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
    if @user.avatar.present?
      @user.avatar.update(status: "deleted")
    end
    image = Image.create(
      picture: params[:user][:picture][0],
      status: "active"
    )
    @user.update(avatar_id: image.id)
    redirect_to @user
    flash[:success] = "Success"
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
