class NotificationsController < ApplicationController

  def index
    @notifications = current_user.notifications
  end

  def update
    @notification = Notification.find params[:notification_id]
    @notification.update(status: "read")
    if @notification.post_id.present?
      redirect_to post_path(@notification.post_id)
    elsif @notification.group_id.present?
      redirect_to group_path(@notification.group_id)
    end
  end

  def destroy
    @notifications = current_user.notifications.unread
    @notifications.update_all(status: "read")
    redirect_to home_path
  end
end
