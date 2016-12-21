class HomeController < ApplicationController
  def index
    @posts = Array.new
    self_post = current_user.posts.where(group_id: nil)
    @posts = @posts + self_post
    friends_id = current_user.get_friends.pluck(:id)
    unless friends_id.empty?
      friends_post = Post.where(user_id: friends_id, group_id: nil)
      @posts = @posts + friends_post
    end
    groups_id = current_user.get_groups.pluck(:id)
    unless groups_id.empty?
      groups_post = Post.where(group_id: groups_id)
      @posts = @posts + groups_post
    end
    @number_post = @posts.count
    @posts = (@posts.sort_by{ |e| e[:created_at] }).reverse()
    @posts = @posts[0..4]
    @suggest = (User.where("id != ?", current_user.id) - current_user.friends_active -
      current_user.friends_passive).sample(5)
  end
end
