class Restaurant < ApplicationRecord
  has_many :daily_menus

  validates :name, presence: true
end
