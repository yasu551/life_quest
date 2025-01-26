require 'rails_helper'

RSpec.describe ScheduledActivityForm, type: :model do
  describe "#scheduled_dates" do
    specify "開始日から終了日の間で、指定した曜日の日にちの配列を返す" do
      travel_to "2025-01-01".to_date do
        form = ScheduledActivityForm.new(schedule_type: "weekly", weekday: 0, start_on: "2025-01-03", end_on: "2025-01-31")
        expect(form.send(:scheduled_dates)).to contain_exactly("2025-01-05".to_date, "2025-01-12".to_date, "2025-01-19".to_date, "2025-01-26".to_date)

        form = ScheduledActivityForm.new(schedule_type: "weekly", weekday: 5, start_on: "2025-01-03", end_on: "2025-01-31")
        expect(form.send(:scheduled_dates)).to contain_exactly("2025-01-03".to_date, "2025-01-10".to_date, "2025-01-17".to_date, "2025-01-24".to_date, "2025-01-31".to_date)
      end
    end

    specify "開始日から終了日の間で、指定した日の配列を返す" do
      travel_to "2025-01-01".to_date do
        form = ScheduledActivityForm.new(schedule_type: "monthly", day: 15, start_on: "2025-01-01", end_on: "2025-03-31")
        expect(form.send(:scheduled_dates)).to contain_exactly("2025-01-15".to_date, "2025-02-15".to_date, "2025-03-15".to_date)

        form = ScheduledActivityForm.new(schedule_type: "monthly", day: 1, start_on: "2025-01-01", end_on: "2025-03-31")
        expect(form.send(:scheduled_dates)).to contain_exactly("2025-01-01".to_date, "2025-02-01".to_date, "2025-03-01".to_date)
      end
    end
  end
end
