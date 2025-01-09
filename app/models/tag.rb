class Tag < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :color, presence: true

  scope :default_order, -> { order(id: :desc) }
end