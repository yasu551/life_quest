class ActivitySummary < ApplicationRecord
  belongs_to :user
  has_many :activity_summary_items, dependent: :destroy
  has_many :activities, through: :activity_summary_items

  validates :start_on, presence: true, date: true
  validates :end_on, presence: true, date: { after_or_equal_to: :start_on }

  scope :default_order, -> { order(id: :desc) }

  class << self
    def build_from(user:, start_on:, end_on:)
      activities = user.activities.where(performed_at: start_on.beginning_of_day..end_on.end_of_day).default_order
      content = ""
      user.tasks.where(id: activities.select(:task_id)).default_order.each do |task|
        tag_names = task.tags.default_order.map { "[#{it.name}]" }.join(" ")
        content << "- #{tag_names} #{task.name}\n"
        activities.where(task:).default_order.each do |activity|
          content << "  - #{activity.name}\n"
        end
      end
      user.activity_summaries.build(start_on:, end_on:, content:, activities:)
    end
  end
end
