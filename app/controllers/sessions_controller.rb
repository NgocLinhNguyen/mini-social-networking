class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      redirect_to root_path
    else
      flash[:danger] = "Your email or password is invalid"
      render "new"
    end
  end

  def destroy
    log_out
    redirect_to login_path
  end
end
