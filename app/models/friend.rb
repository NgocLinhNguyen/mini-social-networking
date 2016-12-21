class Friend < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"

  validates :follower_id, presence: true
  validates :followed_id, presence: true

  def follower
    User.find_by(id: self.follower_id)
  end

  def followed
    User.find_by(id: self.followed_id)
  end
end
