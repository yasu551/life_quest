class ScheduledActivityForm < ApplicationForm
  SCHEDULE_TYPES = %w[daily weekly monthly].freeze
  WEEKDAYS = (0..6).to_a.freeze
  DAYS = (1..31).to_a.freeze

  attribute :user_id, :big_integer
  attribute :name, :string
  attribute :memo, :string
  attribute :schedule_type, :string
  attribute :weekday, :integer
  attribute :day, :integer
  attribute :start_on, :date
  attribute :end_on, :date
  attribute :time, :time

  validates :user_id, presence: true
  validates :name, presence: true
  validates :schedule_type, presence: true, inclusion: { in: SCHEDULE_TYPES }
  validates :weekday, presence: true, numericality: { only_integer: true, range: WEEKDAYS },
            if: -> { schedule_type == "weekly" }
  validates :day, presence: true, numericality: { only_integer: true, range: DAYS },
            if: -> { schedule_type == "monthly" }
  validates :start_on, presence: true, date: { after_or_equal_to: Proc.new { Date.today } }
  validates :end_on, presence: true, date: { after: :start_on }
  validates :time, presence: true

  class << self
    def schedule_type_collection
      SCHEDULE_TYPES.map { |type| [ I18n.t("activemodel.attribute_values.scheduled_activity_form.schedule_type.#{type}"), type ] }
    end

    def weekday_collection
      WEEKDAYS.map { |weekday| [ I18n.t("date.abbr_day_names")[weekday], weekday ] }
    end
  end

  private

  def submit!
    user = User.find(user_id)
    scheduled_dates.each do |date|
      perform_at = Time.zone.local(date.year, date.month, date.day, time.hour, time.min)
      activity = user.activities.build(name:, perform_at:, memo:)
      activity.build_activity_evaluation
      activity.save!
    end
  end

  def scheduled_dates
    case schedule_type
    when "daily"
      start_on..end_on
    when "weekly"
      next_weekday_count = (weekday - start_on.wday) % WEEKDAYS.length
      next_weekday = start_on + next_weekday_count
      next_weekday.step(end_on, WEEKDAYS.length)
    when "monthly"
      start_date = start_on
      dates = []
      while start_date <= end_on
        date =
          begin
            start_date.change(day:)
          rescue
            nil
          end
        dates << date if date.present?
        start_date = start_date.next_month
      end
      dates
    else
      raise "invalid schedule_type: #{schedule_type}"
    end
  end
end
