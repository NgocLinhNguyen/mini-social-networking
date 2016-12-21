class SearchController < ApplicationController
  before_action :user_must_logged_in

  def index
    if params[:search].present?
      if params[:type] == "friends" && params[:group_id].present?
        @group = Group.find params[:group_id]
        @users = Array.new
        @array = current_user.active_friends.search(params[:search])
        @array.each do |member|
          if !member.belong_to_group(@group)
            @users.push(member)
          end
        end
      else
        @users = User.search(params[:search])
        @groups = Group.search(params[:search])
      end
    end
    @message = "successfully"
    respond_to do |format|
      format.json
      format.html
    end
  end
end
