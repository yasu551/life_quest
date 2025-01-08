class Challenge < ApplicationRecord
  belongs_to :source, polymorphic: true

  validates :name, presence: true

  scope :default_order, -> { order(id: :desc) }
end
