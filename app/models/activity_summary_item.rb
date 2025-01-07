class ActivitySummaryItem < ApplicationRecord
  belongs_to :activity_summary
  belongs_to :activity

  validates :activity_summary_id, uniqueness: { scope: :activity_id }
end
