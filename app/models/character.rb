class Character < ApplicationRecord
  has_one_attached :character_img
  validates :name, presence: true, length: { maximum: 255 }
  validates :name_kana, presence: true, length: { maximum: 255 }
  validates :name_eng, presence: true, length: { maximum: 255 }

  enum element: { Pyro: 0, Hydro: 1, Cryo: 2, Electro: 3, Anemo: 4, Geo: 5, Dendro: 6 }
  enum version_half: { First: 0, Second: 1 }

  validate :image_type

  private

  def image_type
    if character_img.attached? && !character_img.content_type.in?(%w(image/jpeg image/png))
      errors.add(:image, "はJPEGまたはPNG形式である必要があります")
    end
  end

  def self.ransackable_attributes(auth_object = nil)
    ["element", "name", "name_eng", "name_kana", "star", "version", "version_half"]
  end

  # Ransackで検索可能な関連を定義
  def self.ransackable_associations(auth_object = nil)
    []
  end
end
