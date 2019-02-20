class Category < ApplicationRecord
  has_many :command
  belongs_to :user
end
