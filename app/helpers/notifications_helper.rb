module NotificationsHelper

  def unread_notification
    return current_user.notifications.unread.order(created_at: :desc)
  end

  def get_message type
    case type
    when "comment_post"
      return " commented on a post you following."
    when "post_group"
      return " published a post in a group called "
    when "add_to_group"
      return " add you to a group called "
    when "comment_post_on_post"
      return "commented on your post."
    end
  end
end
