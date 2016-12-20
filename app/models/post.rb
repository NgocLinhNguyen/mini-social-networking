class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  validates :content, presence: true
  validates :status, presence: true, inclusion: { in: ["active", "deleted"] }

  scope :filter_by_user, ->(user_id) { where(user_id: user_id) }
  default_scope { where(status: "active") }

  def image
    Image.find_by(id: self.image_id)
  end
end
