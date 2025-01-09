class Tag < ApplicationRecord
  belongs_to :user
  has_many :task_taggings, dependent: :destroy

  validates :name, presence: true
  validates :color, presence: true

  scope :default_order, -> { order(id: :desc) }
end
