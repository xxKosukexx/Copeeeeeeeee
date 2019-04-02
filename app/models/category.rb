class Category < ApplicationRecord
  has_many :command, dependent: :delete_all
  belongs_to :user
end
