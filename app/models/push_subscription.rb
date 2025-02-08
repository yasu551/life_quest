class PushSubscription < ApplicationRecord
  belongs_to :user

  scope :latest, -> { order(updated_at: :desc, id: :desc) }
end
