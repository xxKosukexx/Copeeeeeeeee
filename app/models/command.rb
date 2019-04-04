class Command < ApplicationRecord
  # アソシエーションを付与する。
  belongs_to :category
  # commandモデルの検証機能を実装する。
  validates :name,
    presence: { message: VALIDATES_PRESENCE_MESSAGE}
  validates :contents,
    presence: { message: VALIDATES_PRESENCE_MESSAGE}

end
