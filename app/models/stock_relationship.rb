class StockRelationship < ApplicationRecord
  belongs_to :user
  belongs_to :stock
  validates :user_id, presence: true
  validates :stock_id, presence: true
end
