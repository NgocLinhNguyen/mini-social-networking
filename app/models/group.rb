class Group < ApplicationRecord
  has_many :user_groups
  has_many :posts

  validates :name, presence: true
  validates :owner_id, presence: true
  validates :kind, presence: true, inclusion: { in: ["public", "private", "protected"] }
  validates :status, presence: true, inclusion: { in: ["active", "deleted"] }

  scope :yours, -> (user) { where(owner_id: user.id) }
  default_scope { where(status: "active")}

  def cover
    if self.cover_id.present?
      return Image.find_by(id: self.cover_id, status: "active")
    end
  end

  def self.search(search)
    where("name LIKE ?", "%#{search}%")
  end
end
