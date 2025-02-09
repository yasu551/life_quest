class Notification < ApplicationRecord
  belongs_to :source, polymorphic: true

  scope :default_order, -> { order(updated_at: :desc, id: :desc) }
end
