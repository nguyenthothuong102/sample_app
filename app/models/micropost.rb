class Micropost < ApplicationRecord
  MICROPOST_TYPE = %i(content picture).freeze
  belongs_to :user
  delegate :name, to: :user, :prefix => true
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: Settings.size.s_140 }
  validate :picture_size
  scope :recent_posts, ->{order created_at: :desc}
  scope :feed, ->(id){ where("user_id=?", id) }
  mount_uploader :picture, PictureUploader

  private

  def picture_size
    if picture.size > Settings.size.s_5.megabytes
      errors.add(:picture, I18n.t("micropost.should_be_less"))
    end
  end
end
