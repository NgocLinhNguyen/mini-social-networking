class Post < ApplicationRecord
  belongs_to :user
  belongs_to :group
  has_many :comments

  validates :content, presence: true
  validates :status, presence: true, inclusion: { in: ["active", "deleted"] }

  scope :filter_by_user, ->(user_id) { where(user_id: user_id) }
  default_scope { where(status: "active")}
end
