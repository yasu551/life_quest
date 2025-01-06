require 'rails_helper'

RSpec.describe Achievement, type: :model do
  describe ".feasible" do
    let_it_be(:user) { create(:user) }
    let_it_be(:ideal_achievement) { create(:achievement, name: "理想の実績", user:) }
    let_it_be(:intermediate_achievement) { create(:achievement, name: "中間の実績", parent: ideal_achievement, user:) }
    let_it_be(:terminal_achievement) { create(:achievement, name: "末端の実績", parent: intermediate_achievement, user:) }
    let_it_be(:inactive_achievement) { create(:achievement, name: "無効な実績", active: false, parent: intermediate_achievement, user:) }
    let_it_be(:other_intermediate_achievement) { create(:achievement, name: "別の中間の実績", parent: ideal_achievement, user:) }
    let_it_be(:achieved_achievement) { create(:achievement, name: "達成済みの実績", achieved_on: Date.current, parent: other_intermediate_achievement, user:) }

    specify "実現可能な実績を取得できること" do
      expect(Achievement.feasible.pluck(:id)).to contain_exactly(terminal_achievement.id, inactive_achievement.id, other_intermediate_achievement.id)
    end
  end

  describe ".applied_scopes" do
    let_it_be(:user) { create(:user) }
    let_it_be(:active_ideal_achievement) { create(:achievement, name: "有効な理想の実績", user:) }
    let_it_be(:inactive_ideal_achievement) { create(:achievement, name: "無効な理想の実績", active: false, user:) }
    let_it_be(:active_achieved_achievement) { create(:achievement, name: "有効な達成済みの実績", achieved_on: Date.current, user:, parent: active_ideal_achievement) }
    let_it_be(:inactive_achieved_achievement) { create(:achievement, name: "無効な達成済みの実績", active: false, achieved_on: Date.current, user:, parent: active_ideal_achievement) }
    let_it_be(:active_ideal_achieved_achievement) { create(:achievement, name: "有効な理想の達成済みの実績", achieved_on: Date.current, user:) }

    specify "scopeを連続して適用できること" do
      expect(Achievement.applied_scopes("active.ideal").pluck(:id)).to contain_exactly(active_ideal_achievement.id, active_ideal_achieved_achievement.id)
      expect(Achievement.applied_scopes("inactive.ideal").pluck(:id)).to contain_exactly(inactive_ideal_achievement.id)
      expect(Achievement.applied_scopes("active.achieved").pluck(:id)).to contain_exactly(active_achieved_achievement.id, active_ideal_achieved_achievement.id)
      expect(Achievement.applied_scopes("inactive.achieved").pluck(:id)).to contain_exactly(inactive_achieved_achievement.id)
      expect(Achievement.applied_scopes("active.ideal.achieved").pluck(:id)).to contain_exactly(active_ideal_achieved_achievement.id)
    end

    specify "無効なscopeが指定された場合、エラーが発生すること" do
      expect { Achievement.applied_scopes("invalid_scope") }.to raise_error(ArgumentError, "invalid_scope is invalid")
    end
  end
end
