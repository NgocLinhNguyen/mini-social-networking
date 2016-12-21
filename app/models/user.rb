class User < ApplicationRecord
  before_save { self.email = email.downcase }
  before_save :generate_password_digest

  attr_accessor :password

  validates :name, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
    format: { with: VALID_EMAIL_REGEX },
    uniqueness: { case_sensitive: false }
  validates :password, confirmation: true
  validates :status, inclusion: { in: ["active", "deleted"] }
  validates_length_of :password, in: 8..20, on: :create
  validates_length_of :password, in: 8..20, allow_nil: true, on: :update

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :user_groups, dependent: :destroy
  has_many :active_friends, class_name:  "Friend",
                            foreign_key: "follower_id",
                            dependent:   :destroy
  has_many :passive_friends, class_name:  "Friend",
                            foreign_key: "followed_id",
                            dependent:   :destroy
  has_many :following, through: :active_friends, source: :followed
  has_many :followers, through: :passive_friends
  has_many :notifications, dependent: :destroy

  default_scope { where(status: "active")}

  def generate_password_digest
    if password.present?
      self.password_digest = BCrypt::Password.create(self.password, cost: 10)
    end
  end

  def authenticate password
    bcrypt = BCrypt::Password.new self.password_digest
    BCrypt::Engine.hash_secret(password, bcrypt.salt) == self.password_digest
  end

  def avatar
    if self.avatar_id.present?
      return Image.find_by(id: self.avatar_id, status: "active")
    end
  end

  def cover
    if self.cover_id.present?
      return Image.find_by(id: self.cover_id, status: "active")
    end
  end

  def liked_post? post
    like = Like.find_by(user_id: self.id, post_id: post.id)
    return like.present?
  end

  def liked_comment? comment
    like = Like.find_by(user_id: self.id, comment_id: comment.id)
    return like.present?
  end

  def belong_to_group?(group)
    user_group = UserGroup.find_by(group_id: group.id, user_id: self.id)
    if user_group.present?
      return true
    end
    return false
  end

  # Follow a user
  def follow(other_user)
    self.active_friends.create(followed_id: other_user.id)
  end

  # Unfollows a user.
  def unfollow(other_user)
    self.active_friends.find_by(followed_id: other_user.id).destroy
  end

  # Returns true if the current user is following the other user.
  def following?(other_user)
    self.following.include?(other_user)
  end

  def common_friends(other_user)
    self_friends = self.get_friends
    other_user_friends = other_user.get_friends
    self_friends - (self_friends - other_user_friends)
  end

  def self.search(search)
    where("name LIKE ?", "%#{search}%")
  end

  def is_owner? post
    post.user == self
  end

  def friends_active
    id = self.id
    User.joins("INNER JOIN friends ON users.id = friends.followed_id").where(
      friends: { follower_id: id })
  end

  def friends_passive
    id = self.id
    User.joins("INNER JOIN friends ON users.id = friends.follower_id").where(
      friends: { followed_id: id })
  end

  def get_friends
    active = self.friends_active
    passive = self.friends_passive
    friends = active - (active - passive)
  end

  def get_groups
    Group.joins(:user_groups).where(user_groups: { user_id: id })
  end
end
