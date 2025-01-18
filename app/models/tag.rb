class Tag < ApplicationRecord
  belongs_to :user
  has_many :task_taggings, dependent: :destroy

  validates :name, presence: true
  validates :color, presence: true
  validates :user_id, uniqueness: { scope: :name }

  scope :default_order, -> { order(id: :desc) }
end
