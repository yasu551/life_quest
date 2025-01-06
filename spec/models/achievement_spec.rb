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
      expect(Achievement.feasible.pluck(:id)).to contain_exactly(terminal_achievement.id, other_intermediate_achievement.id)
    end
  end
end
