class ChallengeNotification < ApplicationRecord
  belongs_to :challenge

  scope :default_order, -> { order(updated_at: :desc, id: :desc) }
end
