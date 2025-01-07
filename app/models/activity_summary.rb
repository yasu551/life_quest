class ActivitySummary < ApplicationRecord
  belongs_to :user
  has_many :activity_summary_items, dependent: :destroy
  has_many :activities, through: :activity_summary_items

  validates :start_on, presence: true, date: true
  validates :end_on, presence: true, date: { after_or_equal_to: :start_on }

  scope :default_order, -> { order(id: :desc) }
end
