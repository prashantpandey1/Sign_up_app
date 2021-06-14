class Micropost < ApplicationRecord
  belongs_to :user
  default_scope -> {order(created_at: :desc)}
  mount_uploader :picture, PictureUploader

  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: 140}

  private

  #validates the size of an uploaded picture
  def picture_size
    if picture_size > 1.megabyte
      errors.add(:picture, "should be less than 5MB")
    end
  end
end
