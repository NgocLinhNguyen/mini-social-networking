module FriendsHelper

  def friend_requests
    return current_user.friends_passive - current_user.friends_active
  end
end
