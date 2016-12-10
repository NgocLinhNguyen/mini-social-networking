class Group < ApplicationRecord
  has_many :user_groups
  has_many :posts

  validates :name, presence: true
  validates :owner_id, presence: true
  validates :kind, presence: true
  validates :status, presence: true, inclusion: { in: ["active", "deleted"] }
end
