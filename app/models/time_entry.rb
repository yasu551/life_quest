class TimeEntry < ApplicationRecord
  belongs_to :task

  validates :content, presence: true

  scope :default_order, -> { order(created_at: :desc, id: :desc) }
end
