class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user

  validates :user_id, presence: true
  validates :post_id, presence: true
  validates :content, presence: true
  validates :status, presence: true, inclusion: { in: ["active", "deleted"] }

  scope :filter_by_post, ->(post_id) { where(post_id: post_id) }
  default_scope { where(status: "active")}
end
