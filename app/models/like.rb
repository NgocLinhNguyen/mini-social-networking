class Like < ApplicationRecord
  belongs_to :user
  belongs_to :comment, optional: true
  belongs_to :post, optional: true
end
