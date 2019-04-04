class Category < ApplicationRecord
  # アソシエーションを付与する。
  has_many :command, dependent: :delete_all
  belongs_to :user

  validates :name,
    presence: { message: VALIDATES_PRESENCE_MESSAGE},
    uniqueness: { message: VALIDATES_UNIQUNESS_MESSAGE}
end
