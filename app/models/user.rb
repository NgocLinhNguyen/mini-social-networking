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

  has_many :posts
  has_many :comments
  has_many :user_groups
  has_many :active_friends, class_name:  "Friend",
                            foreign_key: "follower_id",
                            dependent:   :destroy
  has_many :passive_friends, class_name:  "Friend",
                            foreign_key: "followed_id",
                            dependent:   :destroy
  has_many :following, through: :active_friends, source: :followed
  has_many :followers, through: :passive_friends

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

  def common_friend(other_user)
    return (self.active_friends & other_user.active_friends).length
  end

end
