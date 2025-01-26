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

  describe "#submit!" do
    let_it_be(:user) { create(:user) }

    specify "開始日から終了日の間で、指定した時間の行動の配列を作成する" do
      travel_to "2025-01-01".to_date do
        form = ScheduledActivityForm.new(user_id: user.id, name: "朝会", memo: "昨日やった仕事と供する予定の仕事をする", schedule_type: "daily", start_on: "2025-01-01", end_on: "2025-01-10", time: "09:30")
        expect { form.send(:submit!) }.to change { user.activities.count }.by(10)
        ("2025-01-01".."2025-01-10").each do |date|
          activity = user.activities.find_by(perform_at: "#{date} 09:30".in_time_zone)
          expect(activity).to have_attributes(name: "朝会", memo: "昨日やった仕事と供する予定の仕事をする")
        end
      end
    end

    specify "開始日から終了日の間で、指定した曜日、日時の行動の配列を作成する" do
      travel_to "2025-01-01".to_date do
        form = ScheduledActivityForm.new(user_id: user.id, name: "週次レビュー", memo: "週次レビューを行う", schedule_type: "weekly", weekday: 3, start_on: "2025-01-01", end_on: "2025-01-31", time: "10:30")
        expect { form.send(:submit!) }.to change { user.activities.count }.by(5)
        %w[2025-01-01 2025-01-08 2025-01-15 2025-01-22 2025-01-29].each do |date|
          activity = user.activities.find_by(perform_at: "#{date} 10:30".in_time_zone)
          expect(activity).to have_attributes(name: "週次レビュー", memo: "週次レビューを行う")
        end
      end
    end

    specify "開始日から終了日の間で、指定した日、時間の行動の配列を作成する" do
      travel_to "2025-01-01".to_date do
        form = ScheduledActivityForm.new(user_id: user.id, name: "月次レビュー", memo: "月次レビューを行う", schedule_type: "monthly", day: 15, start_on: "2025-01-01", end_on: "2025-03-31", time: "14:30")
        expect { form.send(:submit!) }.to change { user.activities.count }.by(3)
        %w[2025-01-15 2025-02-15 2025-03-15].each do |date|
          activity = user.activities.find_by(perform_at: "#{date} 14:30".in_time_zone)
          expect(activity).to have_attributes(name: "月次レビュー", memo: "月次レビューを行う")
        end
      end
    end
  end
end
