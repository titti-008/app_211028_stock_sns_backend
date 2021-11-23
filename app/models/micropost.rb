class Micropost < ApplicationRecord
  belongs_to :user
  has_many_attached :images, dependent: :destroy
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 300 }
  validates :images,   content_type: { in: %w[image/jpeg image/gif image/png],
                                      message: "must be a valid image format" },
                      size:         { less_than: 1.megabytes,
                                      message: "should be less than 1MB" }

  
end
