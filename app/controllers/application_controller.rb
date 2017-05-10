class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  # before_action :set_user

  include SessionsHelper
  include UsersHelper
  include NotificationsHelper
  include FriendsHelper

  private

  # def set_user
  #   cookies[:current_user_id] = current_user.id || 0
  # end
end
